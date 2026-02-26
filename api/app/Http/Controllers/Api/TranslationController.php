<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\TranslateTextRequest;
use App\Http\Resources\LanguageResource;
use App\Http\Resources\TranslationResource;
use App\Models\Message;
use App\Models\Post;
use App\Models\Translation;
use App\Services\TranslationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TranslationController extends BaseController
{
    public function __construct(
        private TranslationService $translationService
    ) {}

    /**
     * GET /translations/message/{id}?target_lang=xx
     *
     * Translate a message to the target language.
     */
    public function translateMessage(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'target_lang' => 'required|string|max:10|exists:languages,code',
        ]);

        $message = Message::find($id);

        if (!$message) {
            return $this->errorResponse('Message not found.', null, 404);
        }

        // Verify user is a participant of the conversation
        $user = $request->user();
        if (!$message->conversation->isParticipant($user)) {
            return $this->errorResponse('You do not have access to this message.', null, 403);
        }

        try {
            $translation = $this->translationService->translateMessage(
                $message,
                $request->input('target_lang'),
                $user
            );

            return $this->successResponse(
                new TranslationResource($translation),
                'Message translated successfully.'
            );
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        } catch (\RuntimeException $e) {
            return $this->errorResponse($e->getMessage(), null, 503);
        }
    }

    /**
     * GET /translations/post/{id}?target_lang=xx
     *
     * Translate a post to the target language.
     */
    public function translatePost(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'target_lang' => 'required|string|max:10|exists:languages,code',
        ]);

        $post = Post::find($id);

        if (!$post) {
            return $this->errorResponse('Post not found.', null, 404);
        }

        try {
            $translation = $this->translationService->translatePost(
                $post,
                $request->input('target_lang'),
                $request->user()
            );

            return $this->successResponse(
                new TranslationResource($translation),
                'Post translated successfully.'
            );
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        } catch (\RuntimeException $e) {
            return $this->errorResponse($e->getMessage(), null, 503);
        }
    }

    /**
     * POST /translations/text
     *
     * Translate arbitrary text.
     */
    public function translateText(TranslateTextRequest $request): JsonResponse
    {
        try {
            $translation = $this->translationService->translateText(
                $request->input('text'),
                $request->input('target_lang'),
                $request->input('source_lang'),
                $request->user()
            );

            return $this->successResponse(
                new TranslationResource($translation),
                'Text translated successfully.'
            );
        } catch (\RuntimeException $e) {
            return $this->errorResponse($e->getMessage(), null, 503);
        }
    }

    /**
     * GET /translations/languages
     *
     * List all supported languages.
     */
    public function languages(): JsonResponse
    {
        $languages = $this->translationService->getSupportedLanguages();

        return $this->successResponse(
            LanguageResource::collection($languages),
            'Supported languages retrieved successfully.'
        );
    }

    /**
     * POST /translations/{id}/score
     *
     * Rate a translation's quality.
     */
    public function score(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'rating' => 'required|integer|min:1|max:5',
            'feedback' => 'nullable|string|max:500',
        ]);

        $translation = Translation::find($id);

        if (!$translation) {
            return $this->errorResponse('Translation not found.', null, 404);
        }

        $log = $this->translationService->scoreTranslation(
            $translation,
            $request->user(),
            $request->input('rating'),
            $request->input('feedback')
        );

        return $this->successResponse([
            'translation_id' => $translation->id,
            'new_quality_score' => (float) $translation->fresh()->quality_score,
            'your_rating' => $log->rating,
        ], 'Translation rated successfully.');
    }

    /**
     * GET /translations/detect
     *
     * Detect the language of given text.
     */
    public function detect(Request $request): JsonResponse
    {
        $request->validate([
            'text' => 'required|string|max:5000',
        ]);

        $language = $this->translationService->detectLanguage(
            $request->input('text')
        );

        return $this->successResponse([
            'detected_language' => $language,
        ], 'Language detected successfully.');
    }
}
