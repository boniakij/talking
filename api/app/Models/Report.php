<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Report extends Model
{
    use HasFactory;

    protected $fillable = [
        'reporter_id',
        'reportable_type',
        'reportable_id',
        'type',
        'description',
        'evidence',
        'status',
        'admin_notes',
        'resolved_by',
        'resolved_at',
    ];

    protected $casts = [
        'evidence' => 'array',
        'resolved_at' => 'datetime',
    ];

    // Report types
    public const TYPES = [
        'spam',
        'harassment',
        'hate_speech',
        'nudity',
        'scam',
        'impersonation',
        'inappropriate_content',
        'copyright',
        'other',
    ];

    // Reportable entity types
    public const REPORTABLE_TYPES = [
        'user' => 'App\\Models\\User',
        'post' => 'App\\Models\\Post',
        'message' => 'App\\Models\\Message',
        'comment' => 'App\\Models\\Comment',
    ];

    // Relationships

    public function reporter(): BelongsTo
    {
        return $this->belongsTo(User::class, 'reporter_id');
    }

    public function reportable(): MorphTo
    {
        return $this->morphTo();
    }

    public function resolvedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'resolved_by');
    }

    // Scopes

    public function scopePending(Builder $query): Builder
    {
        return $query->where('status', 'pending');
    }

    public function scopeReviewing(Builder $query): Builder
    {
        return $query->where('status', 'reviewing');
    }

    public function scopeResolved(Builder $query): Builder
    {
        return $query->where('status', 'resolved');
    }

    public function scopeOfType(Builder $query, string $type): Builder
    {
        return $query->where('type', $type);
    }

    // Methods

    public function isPending(): bool
    {
        return $this->status === 'pending';
    }

    public function isResolved(): bool
    {
        return $this->status === 'resolved';
    }

    /**
     * Resolve the reportable type key from a short alias.
     */
    public static function resolveReportableType(string $type): ?string
    {
        return self::REPORTABLE_TYPES[$type] ?? null;
    }
}
