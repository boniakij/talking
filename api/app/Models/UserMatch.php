<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserMatch extends Model
{
    use HasFactory;

    protected $table = 'matches';

    protected $fillable = [
        'user_id',
        'matched_user_id',
        'score',
        'status',
        'score_breakdown',
        'conversation_id',
        'expires_at',
    ];

    protected $casts = [
        'score' => 'decimal:2',
        'score_breakdown' => 'array',
        'expires_at' => 'datetime',
    ];

    // Relationships

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function matchedUser(): BelongsTo
    {
        return $this->belongsTo(User::class, 'matched_user_id');
    }

    public function conversation(): BelongsTo
    {
        return $this->belongsTo(Conversation::class);
    }

    // Scopes

    public function scopePending(Builder $query): Builder
    {
        return $query->where('status', 'pending');
    }

    public function scopeAccepted(Builder $query): Builder
    {
        return $query->where('status', 'accepted');
    }

    public function scopeNotExpired(Builder $query): Builder
    {
        return $query->where(function ($q) {
            $q->whereNull('expires_at')
              ->orWhere('expires_at', '>', now());
        });
    }

    public function scopeForUser(Builder $query, int $userId): Builder
    {
        return $query->where(function ($q) use ($userId) {
            $q->where('user_id', $userId)
              ->orWhere('matched_user_id', $userId);
        });
    }

    // Methods

    public function isPending(): bool
    {
        return $this->status === 'pending';
    }

    public function isAccepted(): bool
    {
        return $this->status === 'accepted';
    }

    public function isExpired(): bool
    {
        return $this->expires_at && $this->expires_at->isPast();
    }
}
