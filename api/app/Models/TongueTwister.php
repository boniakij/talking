<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class TongueTwister extends Model
{
    use HasFactory;

    protected $fillable = [
        'text',
        'language',
        'difficulty',
        'translation',
        'phonemes',
        'sort_order',
        'is_active',
    ];

    protected $casts = [
        'phonemes' => 'array',
        'is_active' => 'boolean',
    ];

    public function pronunciationScores(): HasMany
    {
        return $this->hasMany(PronunciationScore::class);
    }

    public function leaderboardEntries(): HasMany
    {
        return $this->hasMany(LeaderboardEntry::class);
    }

    public function getDifficultyEmojiAttribute(): string
    {
        return match($this->difficulty) {
            'Easy' => '🟢',
            'Medium' => '🟡',
            'Hard' => '🟠',
            'Master' => '🔴',
            default => '⚪',
        };
    }

    public function scopeByDifficulty($query, $difficulty)
    {
        return $query->where('difficulty', $difficulty);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeOrdered($query)
    {
        return $query->orderBy('sort_order')->orderBy('id');
    }
}
