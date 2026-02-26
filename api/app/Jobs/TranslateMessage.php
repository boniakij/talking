<?php

namespace App\Jobs;

use App\Models\Message;
use App\Models\User;
use App\Services\TranslationService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class TranslateMessage implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Number of times the job may be attempted.
     */
    public int $tries = 3;

    /**
     * Seconds to wait before retrying.
     */
    public array $backoff = [10, 30, 60];

    public function __construct(
        public Message $message,
        public string $targetLanguage,
        public User $recipientUser,
    ) {
        $this->onQueue('translations');
    }

    public function handle(TranslationService $translationService): void
    {
        try {
            $translationService->translateMessage(
                $this->message,
                $this->targetLanguage,
                $this->recipientUser
            );

            Log::info('Auto-translated message', [
                'message_id' => $this->message->id,
                'target_lang' => $this->targetLanguage,
                'recipient' => $this->recipientUser->id,
            ]);
        } catch (\Exception $e) {
            Log::error('Auto-translation failed', [
                'message_id' => $this->message->id,
                'target_lang' => $this->targetLanguage,
                'error' => $e->getMessage(),
            ]);

            throw $e; // Re-throw so Laravel retries
        }
    }

    /**
     * Handle a job failure.
     */
    public function failed(\Throwable $exception): void
    {
        Log::error('TranslateMessage job permanently failed', [
            'message_id' => $this->message->id,
            'target_lang' => $this->targetLanguage,
            'error' => $exception->getMessage(),
        ]);
    }
}
