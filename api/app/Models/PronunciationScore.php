<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PronunciationScore extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'tongue_twister_id',
        'overall_score',
        'phoneme_scores',
        'feedback',
        'recording_path',
        'analyzed_at',
    ];

    protected $casts = [
        'overall_score' => 'decimal:2',
        'phoneme_scores' => 'array',
        'feedback' => 'array',
        'analyzed_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function tongueTwister(): BelongsTo
    {
        return $this->belongsTo(TongueTwister::class);
    }

    public function getScoreGradeAttribute(): string
    {
        return match(true) {
            $this->overall_score >= 90 => 'Excellent',
            $this->overall_score >= 80 => 'Good',
            $this->overall_score >= 70 => 'Fair',
            $this->overall_score >= 60 => 'Needs Work',
            default => 'Keep Practicing',
        };
    }

    public function getScoreColorAttribute(): string
    {
        return match(true) {
            $this->overall_score >= 90 => '#4CAF50',
            $this->overall_score >= 80 => '#8BC34A',
            $this->overall_score >= 70 => '#FFC107',
            $this->overall_score >= 60 => '#FF9800',
            default => '#F44336',
        };
    }
}
