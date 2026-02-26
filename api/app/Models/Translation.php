<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Translation extends Model
{
    use HasFactory;

    protected $fillable = [
        'source_type',
        'source_id',
        'source_hash',
        'source_language',
        'target_language',
        'source_text',
        'translated_text',
        'quality_score',
        'rating_count',
        'usage_count',
        'expires_at',
    ];

    protected $casts = [
        'quality_score' => 'decimal:2',
        'rating_count' => 'integer',
        'usage_count' => 'integer',
        'expires_at' => 'datetime',
    ];

    // ── Relationships ────────────────────────────────────────

    public function usageLogs(): HasMany
    {
        return $this->hasMany(TranslationUsageLog::class);
    }

    // ── Scopes ───────────────────────────────────────────────

    public function scopeForMessage(Builder $query, int $messageId, string $targetLang): Builder
    {
        return $query->where('source_type', 'message')
                     ->where('source_id', $messageId)
                     ->where('target_language', $targetLang);
    }

    public function scopeForPost(Builder $query, int $postId, string $targetLang): Builder
    {
        return $query->where('source_type', 'post')
                     ->where('source_id', $postId)
                     ->where('target_language', $targetLang);
    }

    public function scopeForText(Builder $query, string $hash, string $targetLang): Builder
    {
        return $query->where('source_type', 'text')
                     ->where('source_hash', $hash)
                     ->where('target_language', $targetLang);
    }

    public function scopeNotExpired(Builder $query): Builder
    {
        return $query->where(function ($q) {
            $q->whereNull('expires_at')
              ->orWhere('expires_at', '>', now());
        });
    }

    // ── Methods ──────────────────────────────────────────────

    /**
     * Increment usage count when a cached translation is served.
     */
    public function recordUsage(): void
    {
        $this->increment('usage_count');
    }

    /**
     * Update the quality score using a running average.
     */
    public function updateQualityScore(int $newRating): void
    {
        $currentTotal = ($this->quality_score ?? 0) * $this->rating_count;
        $this->rating_count++;
        $this->quality_score = ($currentTotal + $newRating) / $this->rating_count;
        $this->save();
    }

    /**
     * Check if this translation has expired.
     */
    public function isExpired(): bool
    {
        return $this->expires_at && $this->expires_at->isPast();
    }
}
