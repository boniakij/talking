<?php

namespace App\Listeners;

use App\Events\MessageSent;
use App\Jobs\TranslateMessage;
use App\Models\User;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Support\Facades\Log;

class AutoTranslateMessage implements ShouldQueue
{
    public string $queue = 'translations';

    public function handle(MessageSent $event): void
    {
        if (!config('services.google_translate.auto_translate_enabled', false)) {
            return;
        }

        $message = $event->message;
        $conversation = $message->conversation;

        // Get all other participants in the conversation
        $participants = $conversation->participants()
            ->where('users.id', '!=', $message->user_id)
            ->get();

        foreach ($participants as $participant) {
            // Only auto-translate for users who have opt-in
            if (!$participant->auto_translate_enabled) {
                continue;
            }

            $targetLang = $participant->preferred_language;

            if (empty($targetLang)) {
                continue;
            }

            // Dispatch a queued translation job
            TranslateMessage::dispatch($message, $targetLang, $participant);

            Log::info('Dispatched auto-translate job', [
                'message_id' => $message->id,
                'recipient' => $participant->id,
                'target_lang' => $targetLang,
            ]);
        }
    }

    /**
     * Determine if the listener should be queued.
     */
    public function shouldQueue(MessageSent $event): bool
    {
        return config('services.google_translate.auto_translate_enabled', false)
            && !empty($event->message->content);
    }
}
