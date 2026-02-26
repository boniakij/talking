<?php

namespace App\Jobs;

use App\Models\User;
use App\Services\MatchingService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log;

class GenerateMatchSuggestions implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 1;
    public int $timeout = 300; // 5 minutes max

    public function handle(MatchingService $matchingService): void
    {
        Log::info('Starting daily match suggestion generation...');

        // Expire old pending matches first
        $expired = $matchingService->expireOldMatches();
        Log::info("Expired {$expired} old matches.");

        // Get all active users with matching enabled
        $users = User::where('status', 'active')
            ->whereHas('matchingPreference', function ($q) {
                $q->where('is_active', true);
            })
            ->with(['profile', 'languages', 'matchingPreference'])
            ->get();

        $totalSuggestions = 0;

        foreach ($users as $user) {
            try {
                $suggestions = $matchingService->generateSuggestions($user, 5);
                $stored = $matchingService->storeSuggestions($user, $suggestions);
                $totalSuggestions += $stored;
            } catch (\Exception $e) {
                Log::error("Match generation failed for user {$user->id}", [
                    'error' => $e->getMessage(),
                ]);
            }
        }

        Log::info("Match generation complete: {$totalSuggestions} suggestions for {$users->count()} users.");
    }
}
