<?php

namespace App\Jobs;

use App\Models\AppNotification;
use App\Services\NotificationService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class SendPushNotification implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 3;
    public int $backoff = 10; // seconds between retries

    public function __construct(
        public AppNotification $notification,
    ) {}

    public function handle(NotificationService $notificationService): void
    {
        try {
            $sent = $notificationService->sendPushToUser($this->notification);
            Log::info("Push notification sent to {$sent} devices", [
                'notification_id' => $this->notification->id,
                'user_id' => $this->notification->user_id,
            ]);
        } catch (\Exception $e) {
            Log::error('SendPushNotification job failed', [
                'notification_id' => $this->notification->id,
                'error' => $e->getMessage(),
            ]);
            throw $e; // Re-throw for retry
        }
    }
}
