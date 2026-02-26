<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class NotificationSetting extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'push_enabled',
        'email_enabled',
        'type_preferences',
        'mute_all',
        'quiet_hours_start',
        'quiet_hours_end',
    ];

    protected $casts = [
        'push_enabled' => 'boolean',
        'email_enabled' => 'boolean',
        'type_preferences' => 'array',
        'mute_all' => 'boolean',
    ];

    // Default type preferences
    public const DEFAULT_TYPE_PREFERENCES = [
        'message' => true,
        'call' => true,
        'gift' => true,
        'match' => true,
        'follow' => true,
        'comment' => true,
        'system' => true,
    ];

    // Relationships

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Methods

    /**
     * Check if a notification type is enabled.
     */
    public function isTypeEnabled(string $type): bool
    {
        if ($this->mute_all) {
            return false;
        }

        $prefs = $this->type_preferences ?? self::DEFAULT_TYPE_PREFERENCES;
        return $prefs[$type] ?? true;
    }

    /**
     * Check if push is allowed right now (quiet hours).
     */
    public function isPushAllowedNow(): bool
    {
        if (!$this->push_enabled || $this->mute_all) {
            return false;
        }

        if (!$this->quiet_hours_start || !$this->quiet_hours_end) {
            return true;
        }

        $now = now()->format('H:i');
        $start = $this->quiet_hours_start;
        $end = $this->quiet_hours_end;

        // Handle overnight quiet hours (e.g., 22:00 - 07:00)
        if ($start > $end) {
            return !($now >= $start || $now <= $end);
        }

        return !($now >= $start && $now <= $end);
    }
}
