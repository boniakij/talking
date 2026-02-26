<?php

namespace App\Services;

use App\Models\AppNotification;
use App\Models\DeviceToken;
use App\Models\NotificationSetting;
use App\Models\User;
use App\Jobs\SendPushNotification;
use Illuminate\Support\Facades\Log;

class NotificationService
{
    // Notification templates
    private const TEMPLATES = [
        'message' => [
            'title' => '{sender} sent you a message',
            'body' => '{preview}',
        ],
        'call' => [
            'title' => 'Incoming call from {caller}',
            'body' => '{type} call',
        ],
        'gift' => [
            'title' => 'You received a gift! 🎁',
            'body' => '{sender} sent you {gift_name}',
        ],
        'match' => [
            'title' => 'New match suggestion! 🎯',
            'body' => 'You have a new match with {score}% compatibility',
        ],
        'follow' => [
            'title' => 'New follower! 👋',
            'body' => '{follower} started following you',
        ],
        'comment' => [
            'title' => '{commenter} commented on your post',
            'body' => '{preview}',
        ],
        'system' => [
            'title' => '{title}',
            'body' => '{body}',
        ],
    ];

    /**
     * Send a notification (in-app + push).
     */
    public function send(
        User $user,
        string $type,
        array $data = [],
        ?string $actionUrl = null,
    ): ?AppNotification {
        // Validate type
        if (!in_array($type, AppNotification::TYPES)) {
            Log::warning("Invalid notification type: {$type}");
            return null;
        }

        // Check user preferences
        $settings = $this->getOrCreateSettings($user);
        if (!$settings->isTypeEnabled($type)) {
            return null; // User has disabled this type
        }

        // Render template
        $rendered = $this->renderTemplate($type, $data);

        // Create in-app notification
        $notification = AppNotification::create([
            'user_id' => $user->id,
            'type' => $type,
            'title' => $rendered['title'],
            'body' => $rendered['body'],
            'data' => $data,
            'action_url' => $actionUrl,
        ]);

        // Dispatch push notification if enabled
        if ($settings->isPushAllowedNow()) {
            SendPushNotification::dispatch($notification);
        }

        return $notification;
    }

    /**
     * Send notification to multiple users.
     */
    public function sendToMany(array $userIds, string $type, array $data = [], ?string $actionUrl = null): int
    {
        $sent = 0;

        foreach ($userIds as $userId) {
            $user = User::find($userId);
            if ($user) {
                $result = $this->send($user, $type, $data, $actionUrl);
                if ($result) {
                    $sent++;
                }
            }
        }

        return $sent;
    }

    /**
     * Get notifications for a user.
     */
    public function getNotifications(User $user, ?string $type = null, int $perPage = 20)
    {
        $query = AppNotification::where('user_id', $user->id)
            ->orderByDesc('created_at');

        if ($type) {
            $query->ofType($type);
        }

        return $query->paginate($perPage);
    }

    /**
     * Get unread count.
     */
    public function getUnreadCount(User $user): int
    {
        return AppNotification::where('user_id', $user->id)->unread()->count();
    }

    /**
     * Mark a notification as read.
     */
    public function markAsRead(User $user, int $notificationId): AppNotification
    {
        $notification = AppNotification::where('user_id', $user->id)
            ->findOrFail($notificationId);

        $notification->markAsRead();

        return $notification;
    }

    /**
     * Mark all notifications as read.
     */
    public function markAllAsRead(User $user): int
    {
        return AppNotification::where('user_id', $user->id)
            ->unread()
            ->update([
                'is_read' => true,
                'read_at' => now(),
            ]);
    }

    /**
     * Register a device token for push notifications.
     */
    public function registerDeviceToken(User $user, string $token, string $platform = 'android', ?string $deviceName = null): DeviceToken
    {
        return DeviceToken::updateOrCreate(
            ['token' => $token],
            [
                'user_id' => $user->id,
                'platform' => $platform,
                'device_name' => $deviceName,
                'is_active' => true,
                'last_used_at' => now(),
            ]
        );
    }

    /**
     * Remove a device token.
     */
    public function removeDeviceToken(User $user, string $token): bool
    {
        return DeviceToken::where('user_id', $user->id)
            ->where('token', $token)
            ->delete() > 0;
    }

    /**
     * Get or create notification settings for a user.
     */
    public function getOrCreateSettings(User $user): NotificationSetting
    {
        return NotificationSetting::firstOrCreate(
            ['user_id' => $user->id],
            [
                'push_enabled' => true,
                'email_enabled' => true,
                'type_preferences' => NotificationSetting::DEFAULT_TYPE_PREFERENCES,
                'mute_all' => false,
            ]
        );
    }

    /**
     * Update notification settings.
     */
    public function updateSettings(User $user, array $data): NotificationSetting
    {
        $settings = $this->getOrCreateSettings($user);
        $settings->update($data);
        return $settings->fresh();
    }

    /**
     * Send push notification via FCM.
     */
    public function sendPushToUser(AppNotification $notification): int
    {
        $tokens = DeviceToken::where('user_id', $notification->user_id)
            ->active()
            ->pluck('token')
            ->toArray();

        if (empty($tokens)) {
            return 0;
        }

        $sent = 0;

        foreach ($tokens as $token) {
            try {
                $this->sendFcmMessage($token, $notification);
                $sent++;
            } catch (\Exception $e) {
                Log::warning("FCM push failed for token: {$token}", [
                    'error' => $e->getMessage(),
                    'notification_id' => $notification->id,
                ]);

                // Deactivate invalid tokens
                if ($this->isInvalidTokenError($e)) {
                    DeviceToken::where('token', $token)->update(['is_active' => false]);
                }
            }
        }

        return $sent;
    }

    /**
     * Send FCM message via HTTP v1 API.
     */
    private function sendFcmMessage(string $token, AppNotification $notification): void
    {
        $serverKey = config('services.fcm.server_key');

        if (!$serverKey) {
            Log::warning('FCM server key not configured.');
            return;
        }

        $payload = [
            'to' => $token,
            'notification' => [
                'title' => $notification->title,
                'body' => $notification->body,
                'sound' => 'default',
            ],
            'data' => array_merge($notification->data ?? [], [
                'notification_id' => (string) $notification->id,
                'type' => $notification->type,
                'action_url' => $notification->action_url ?? '',
            ]),
            'priority' => 'high',
        ];

        $response = \Illuminate\Support\Facades\Http::withHeaders([
            'Authorization' => "key={$serverKey}",
            'Content-Type' => 'application/json',
        ])->post('https://fcm.googleapis.com/fcm/send', $payload);

        if ($response->failed()) {
            throw new \RuntimeException('FCM request failed: ' . $response->body());
        }

        $result = $response->json();

        if (isset($result['failure']) && $result['failure'] > 0) {
            $errors = $result['results'][0]['error'] ?? 'unknown';
            throw new \RuntimeException("FCM delivery failed: {$errors}");
        }
    }

    /**
     * Render a notification template with data.
     */
    private function renderTemplate(string $type, array $data): array
    {
        $template = self::TEMPLATES[$type] ?? self::TEMPLATES['system'];

        $title = $template['title'];
        $body = $template['body'];

        // Replace placeholders {key} with data values
        foreach ($data as $key => $value) {
            if (is_string($value) || is_numeric($value)) {
                $title = str_replace("{{$key}}", (string) $value, $title);
                $body = str_replace("{{$key}}", (string) $value, $body);
            }
        }

        return ['title' => $title, 'body' => $body];
    }

    /**
     * Check if the FCM error indicates an invalid token.
     */
    private function isInvalidTokenError(\Exception $e): bool
    {
        $invalidMessages = ['NotRegistered', 'InvalidRegistration', 'MismatchSenderId'];
        foreach ($invalidMessages as $msg) {
            if (str_contains($e->getMessage(), $msg)) {
                return true;
            }
        }
        return false;
    }
}
