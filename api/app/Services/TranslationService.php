<?php

namespace App\Services;

use App\Models\Language;
use App\Models\Message;
use App\Models\Post;
use App\Models\Translation;
use App\Models\TranslationUsageLog;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class TranslationService
{
    private string $apiKey;
    private string $baseUrl;
    private int $cacheTtlHours;

    public function __construct()
    {
        $this->apiKey = config('services.google_translate.api_key', '');
        $this->baseUrl = config('services.google_translate.base_url', 'https://translation.googleapis.com/language/translate/v2');
        $this->cacheTtlHours = (int) config('services.google_translate.cache_ttl_hours', 168); // 7 days
    }

    // ── Public API ───────────────────────────────────────────

    /**
     * Translate a message to the target language.
     */
    public function translateMessage(Message $message, string $targetLang, ?User $user = null): Translation
    {
        if (empty($message->content)) {
            throw new \InvalidArgumentException('Message has no text content to translate.');
        }

        // Check cache first
        $cached = Translation::forMessage($message->id, $targetLang)->notExpired()->first();

        if ($cached) {
            $cached->recordUsage();
            $this->logUsage($user, $cached, 'message');
            return $cached;
        }

        // Detect source language if needed
        $sourceLang = $this->detectLanguage($message->content);

        // Skip if already in target language
        if ($sourceLang === $targetLang) {
            return $this->createIdentityTranslation($message->content, $sourceLang, 'message', $message->id);
        }

        // Call API
        $translatedText = $this->callTranslateApi($message->content, $targetLang, $sourceLang);

        // Cache and return
        $translation = $this->cacheTranslation(
            sourceType: 'message',
            sourceId: $message->id,
            sourceText: $message->content,
            translatedText: $translatedText,
            sourceLang: $sourceLang,
            targetLang: $targetLang,
        );

        $this->logUsage($user, $translation, 'message');
        return $translation;
    }

    /**
     * Translate a post to the target language.
     */
    public function translatePost(Post $post, string $targetLang, ?User $user = null): Translation
    {
        if (empty($post->content)) {
            throw new \InvalidArgumentException('Post has no text content to translate.');
        }

        // Check cache first
        $cached = Translation::forPost($post->id, $targetLang)->notExpired()->first();

        if ($cached) {
            $cached->recordUsage();
            $this->logUsage($user, $cached, 'post');
            return $cached;
        }

        $sourceLang = $this->detectLanguage($post->content);

        if ($sourceLang === $targetLang) {
            return $this->createIdentityTranslation($post->content, $sourceLang, 'post', $post->id);
        }

        $translatedText = $this->callTranslateApi($post->content, $targetLang, $sourceLang);

        $translation = $this->cacheTranslation(
            sourceType: 'post',
            sourceId: $post->id,
            sourceText: $post->content,
            translatedText: $translatedText,
            sourceLang: $sourceLang,
            targetLang: $targetLang,
        );

        $this->logUsage($user, $translation, 'post');
        return $translation;
    }

    /**
     * Translate arbitrary text.
     */
    public function translateText(string $text, string $targetLang, ?string $sourceLang = null, ?User $user = null): Translation
    {
        $hash = hash('sha256', $text);

        // Check cache first
        $cached = Translation::forText($hash, $targetLang)->notExpired()->first();

        if ($cached) {
            $cached->recordUsage();
            $this->logUsage($user, $cached, 'text');
            return $cached;
        }

        // Detect language if not provided
        $sourceLang = $sourceLang ?: $this->detectLanguage($text);

        if ($sourceLang === $targetLang) {
            return $this->createIdentityTranslation($text, $sourceLang, 'text');
        }

        $translatedText = $this->callTranslateApi($text, $targetLang, $sourceLang);

        $translation = $this->cacheTranslation(
            sourceType: 'text',
            sourceId: null,
            sourceText: $text,
            translatedText: $translatedText,
            sourceLang: $sourceLang,
            targetLang: $targetLang,
            sourceHash: $hash,
        );

        $this->logUsage($user, $translation, 'text');
        return $translation;
    }

    /**
     * Detect the language of a given text.
     */
    public function detectLanguage(string $text): string
    {
        // Use a short sample (first 200 chars) for detection
        $sample = mb_substr($text, 0, 200);

        $cacheKey = 'lang_detect:' . md5($sample);
        $cached = Cache::get($cacheKey);

        if ($cached) {
            return $cached;
        }

        try {
            $response = Http::get($this->baseUrl . '/detect', [
                'key' => $this->apiKey,
                'q' => $sample,
            ]);

            if ($response->successful()) {
                $detections = $response->json('data.detections.0.0');
                $language = $detections['language'] ?? 'en';

                // Cache detection for 1 hour
                Cache::put($cacheKey, $language, now()->addHour());

                return $language;
            }
        } catch (\Exception $e) {
            Log::warning('Language detection failed, defaulting to en', [
                'error' => $e->getMessage(),
            ]);
        }

        return 'en';
    }

    /**
     * Get all supported (active) languages.
     */
    public function getSupportedLanguages(): \Illuminate\Database\Eloquent\Collection
    {
        return Cache::remember('supported_languages', now()->addDay(), function () {
            return Language::where('is_active', true)
                          ->orderBy('name')
                          ->get();
        });
    }

    /**
     * Rate a translation's quality.
     */
    public function scoreTranslation(Translation $translation, User $user, int $rating, ?string $feedback = null): TranslationUsageLog
    {
        // Update the translation's running average score
        $translation->updateQualityScore($rating);

        // Find existing usage log or create one
        $log = TranslationUsageLog::updateOrCreate(
            [
                'user_id' => $user->id,
                'translation_id' => $translation->id,
            ],
            [
                'source_type' => $translation->source_type,
                'rating' => $rating,
                'feedback' => $feedback,
            ]
        );

        return $log;
    }

    // ── Private Helpers ──────────────────────────────────────

    /**
     * Call Google Translate API v2.
     */
    private function callTranslateApi(string $text, string $targetLang, ?string $sourceLang = null): string
    {
        $params = [
            'key' => $this->apiKey,
            'q' => $text,
            'target' => $targetLang,
            'format' => 'text',
        ];

        if ($sourceLang) {
            $params['source'] = $sourceLang;
        }

        try {
            $response = Http::timeout(10)->get($this->baseUrl, $params);

            if ($response->successful()) {
                $translations = $response->json('data.translations');

                if (!empty($translations[0]['translatedText'])) {
                    return $translations[0]['translatedText'];
                }
            }

            Log::error('Translation API error', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            throw new \RuntimeException('Translation API returned an error: ' . $response->status());

        } catch (\Illuminate\Http\Client\ConnectionException $e) {
            Log::error('Translation API connection failed', ['error' => $e->getMessage()]);
            throw new \RuntimeException('Translation service is currently unavailable. Please try again later.');
        }
    }

    /**
     * Store a translation in the database cache.
     */
    private function cacheTranslation(
        string $sourceType,
        ?int $sourceId,
        string $sourceText,
        string $translatedText,
        string $sourceLang,
        string $targetLang,
        ?string $sourceHash = null,
    ): Translation {
        return Translation::create([
            'source_type' => $sourceType,
            'source_id' => $sourceId,
            'source_hash' => $sourceHash,
            'source_language' => $sourceLang,
            'target_language' => $targetLang,
            'source_text' => $sourceText,
            'translated_text' => $translatedText,
            'usage_count' => 1,
            'expires_at' => now()->addHours($this->cacheTtlHours),
        ]);
    }

    /**
     * Create a translation record when source and target language are the same.
     */
    private function createIdentityTranslation(string $text, string $lang, string $type, ?int $sourceId = null): Translation
    {
        $hash = $type === 'text' ? hash('sha256', $text) : null;

        return Translation::firstOrCreate(
            array_filter([
                'source_type' => $type,
                'source_id' => $sourceId,
                'source_hash' => $hash,
                'target_language' => $lang,
            ]),
            [
                'source_language' => $lang,
                'source_text' => $text,
                'translated_text' => $text,
                'quality_score' => 5.00,
                'usage_count' => 1,
            ]
        );
    }

    /**
     * Log a translation usage event.
     */
    private function logUsage(?User $user, Translation $translation, string $sourceType): void
    {
        if (!$user) {
            return;
        }

        TranslationUsageLog::create([
            'user_id' => $user->id,
            'translation_id' => $translation->id,
            'source_type' => $sourceType,
        ]);
    }
}
