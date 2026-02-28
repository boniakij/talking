<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LeaderboardEntry extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'tongue_twister_id',
        'score',
        'completed_at',
    ];

    protected $casts = [
        'completed_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function tongueTwister(): BelongsTo
    {
        return $this->belongsTo(TongueTwister::class);
    }

    public function getRankBadgeAttribute(): string
    {
        return match($this->rank) {
            1 => '🥇',
            2 => '🥈',
            3 => '🥉',
            default => (string) $this->rank,
        };
    }

    public function scopeForTwister($query, $twisterId)
    {
        return $query->where('tongue_twister_id', $twisterId);
    }

    public function scopeHighScoreFirst($query)
    {
        return $query->orderBy('score', 'desc')->orderBy('completed_at', 'asc');
    }
}
