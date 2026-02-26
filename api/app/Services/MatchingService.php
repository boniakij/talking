<?php

namespace App\Services;

use App\Models\UserMatch;
use App\Models\MatchingPreference;
use App\Models\User;
use App\Models\Conversation;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;

class MatchingService
{
    // Score weights (must total 100)
    private const WEIGHT_LANGUAGE = 40;
    private const WEIGHT_INTERESTS = 25;
    private const WEIGHT_ACTIVITY = 20;
    private const WEIGHT_LOCATION = 15;

    /**
     * Get or create matching preferences for a user.
     */
    public function getPreferences(User $user): MatchingPreference
    {
        return MatchingPreference::firstOrCreate(
            ['user_id' => $user->id],
            [
                'preferred_gender' => null,
                'age_min' => 18,
                'age_max' => 99,
                'preferred_languages' => [],
                'preferred_countries' => [],
                'preferred_interests' => [],
                'is_active' => true,
            ]
        );
    }

    /**
     * Update matching preferences.
     */
    public function updatePreferences(User $user, array $data): MatchingPreference
    {
        $preference = $this->getPreferences($user);
        $preference->update($data);
        return $preference->fresh();
    }

    /**
     * Calculate compatibility score between two users (0-100).
     */
    public function calculateScore(User $userA, User $userB): array
    {
        $languageScore = $this->calculateLanguageScore($userA, $userB);
        $interestScore = $this->calculateInterestScore($userA, $userB);
        $activityScore = $this->calculateActivityScore($userA, $userB);
        $locationScore = $this->calculateLocationScore($userA, $userB);

        $totalScore = round(
            ($languageScore * self::WEIGHT_LANGUAGE / 100) +
            ($interestScore * self::WEIGHT_INTERESTS / 100) +
            ($activityScore * self::WEIGHT_ACTIVITY / 100) +
            ($locationScore * self::WEIGHT_LOCATION / 100),
            2
        );

        return [
            'total' => $totalScore,
            'breakdown' => [
                'language' => round($languageScore * self::WEIGHT_LANGUAGE / 100, 2),
                'interests' => round($interestScore * self::WEIGHT_INTERESTS / 100, 2),
                'activity' => round($activityScore * self::WEIGHT_ACTIVITY / 100, 2),
                'location' => round($locationScore * self::WEIGHT_LOCATION / 100, 2),
            ],
        ];
    }

    /**
     * Language compatibility: overlap between native + learning languages.
     * High score if user A speaks what B is learning, and vice versa.
     */
    private function calculateLanguageScore(User $userA, User $userB): float
    {
        $aNative = $userA->nativeLanguages()->pluck('language_id')->toArray();
        $aLearning = $userA->learningLanguages()->pluck('language_id')->toArray();
        $bNative = $userB->nativeLanguages()->pluck('language_id')->toArray();
        $bLearning = $userB->learningLanguages()->pluck('language_id')->toArray();

        if (empty($aNative) && empty($aLearning) && empty($bNative) && empty($bLearning)) {
            return 50; // Neutral if no language data
        }

        $score = 0;
        $maxPoints = 0;

        // A speaks natively what B is learning => great match
        $teachAtoB = count(array_intersect($aNative, $bLearning));
        $teachBtoA = count(array_intersect($bNative, $aLearning));
        $maxTeach = max(count($bLearning), count($aLearning), 1);

        // Mutual teaching potential (weighted heavily)
        if ($teachAtoB > 0 && $teachBtoA > 0) {
            $score += 40; // Mutual language exchange = very high score
        } elseif ($teachAtoB > 0 || $teachBtoA > 0) {
            $score += 25; // One-way teaching
        }
        $maxPoints += 40;

        // Shared native languages (can communicate easily)
        $sharedNative = count(array_intersect($aNative, $bNative));
        if ($sharedNative > 0) {
            $score += 30;
        }
        $maxPoints += 30;

        // Shared learning goals (learning same languages)
        $sharedLearning = count(array_intersect($aLearning, $bLearning));
        if ($sharedLearning > 0) {
            $score += 30;
        }
        $maxPoints += 30;

        return $maxPoints > 0 ? min(100, ($score / $maxPoints) * 100) : 50;
    }

    /**
     * Interest compatibility: overlap in user interests/tags.
     */
    private function calculateInterestScore(User $userA, User $userB): float
    {
        $aInterests = $userA->profile?->interests ?? [];
        $bInterests = $userB->profile?->interests ?? [];

        if (empty($aInterests) || empty($bInterests)) {
            return 50; // Neutral if no data
        }

        // Normalize to lowercase arrays
        $aInterests = array_map('strtolower', (array) $aInterests);
        $bInterests = array_map('strtolower', (array) $bInterests);

        $overlap = count(array_intersect($aInterests, $bInterests));
        $total = count(array_unique(array_merge($aInterests, $bInterests)));

        if ($total === 0) {
            return 50;
        }

        // Jaccard similarity * 100
        return round(($overlap / $total) * 100, 2);
    }

    /**
     * Activity compatibility: users active around similar times.
     */
    private function calculateActivityScore(User $userA, User $userB): float
    {
        $aLastSeen = $userA->last_seen_at;
        $bLastSeen = $userB->last_seen_at;

        if (!$aLastSeen || !$bLastSeen) {
            return 50;
        }

        // Both active recently = higher score
        $aRecent = $aLastSeen->diffInDays(now());
        $bRecent = $bLastSeen->diffInDays(now());

        // Score based on how recently both were active
        $avgRecency = ($aRecent + $bRecent) / 2;

        if ($avgRecency <= 1) return 100;  // Both active today
        if ($avgRecency <= 3) return 80;   // Active in last 3 days
        if ($avgRecency <= 7) return 60;   // Active this week
        if ($avgRecency <= 14) return 40;  // Active in 2 weeks
        if ($avgRecency <= 30) return 20;  // Active this month

        return 10; // Inactive
    }

    /**
     * Location compatibility: same country or nearby.
     */
    private function calculateLocationScore(User $userA, User $userB): float
    {
        $aCountry = $userA->profile?->country;
        $bCountry = $userB->profile?->country;

        if (!$aCountry || !$bCountry) {
            return 50; // Neutral
        }

        if (strtolower($aCountry) === strtolower($bCountry)) {
            return 100; // Same country
        }

        // Different country = lower score but not zero (global platform)
        return 30;
    }

    /**
     * Generate match suggestions for a user.
     */
    public function generateSuggestions(User $user, int $limit = 5): array
    {
        $preferences = $this->getPreferences($user);

        if (!$preferences->is_active) {
            return [];
        }

        // Get candidate users (exclude blocked, already matched, self)
        $blockedIds = $user->blockedUsers()->pluck('blocked_user_id')->toArray();
        $blockedByIds = DB::table('blocked_users')
            ->where('blocked_user_id', $user->id)
            ->pluck('user_id')
            ->toArray();
        $existingMatchIds = UserMatch::forUser($user->id)
            ->whereIn('status', ['pending', 'accepted'])
            ->get()
            ->map(fn ($m) => $m->user_id === $user->id ? $m->matched_user_id : $m->user_id)
            ->toArray();

        $excludeIds = array_unique(array_merge([$user->id], $blockedIds, $blockedByIds, $existingMatchIds));

        $candidateQuery = User::where('status', 'active')
            ->whereNotIn('id', $excludeIds)
            ->with(['profile', 'languages']);

        // Apply gender preference
        if ($preferences->preferred_gender && $preferences->preferred_gender !== 'any') {
            $candidateQuery->whereHas('profile', function ($q) use ($preferences) {
                $q->where('gender', $preferences->preferred_gender);
            });
        }

        // Apply country preference
        if (!empty($preferences->preferred_countries)) {
            $candidateQuery->whereHas('profile', function ($q) use ($preferences) {
                $q->whereIn('country', $preferences->preferred_countries);
            });
        }

        // Fetch candidates (limit to reasonable pool)
        $candidates = $candidateQuery->limit(100)->get();

        // Score and rank
        $scoredCandidates = [];
        foreach ($candidates as $candidate) {
            $scoreResult = $this->calculateScore($user, $candidate);

            if ($scoreResult['total'] >= 15) { // Minimum threshold
                $scoredCandidates[] = [
                    'user' => $candidate,
                    'score' => $scoreResult['total'],
                    'breakdown' => $scoreResult['breakdown'],
                ];
            }
        }

        // Sort by score descending
        usort($scoredCandidates, fn ($a, $b) => $b['score'] <=> $a['score']);

        // Return top matches
        return array_slice($scoredCandidates, 0, $limit);
    }

    /**
     * Store generated suggestions as Match records.
     */
    public function storeSuggestions(User $user, array $suggestions): int
    {
        $stored = 0;

        foreach ($suggestions as $suggestion) {
            try {
                UserMatch::updateOrCreate(
                    [
                        'user_id' => $user->id,
                        'matched_user_id' => $suggestion['user']->id,
                    ],
                    [
                        'score' => $suggestion['score'],
                        'score_breakdown' => $suggestion['breakdown'],
                        'status' => 'pending',
                        'expires_at' => now()->addDays(7),
                    ]
                );
                $stored++;
            } catch (\Exception $e) {
                Log::warning('Failed to store match suggestion', [
                    'user_id' => $user->id,
                    'matched_user_id' => $suggestion['user']->id,
                    'error' => $e->getMessage(),
                ]);
            }
        }

        return $stored;
    }

    /**
     * Get pending match suggestions for a user.
     */
    public function getSuggestions(User $user, int $perPage = 20)
    {
        return UserMatch::where('user_id', $user->id)
            ->pending()
            ->notExpired()
            ->with(['matchedUser.profile'])
            ->orderByDesc('score')
            ->paginate($perPage);
    }

    /**
     * Accept a match — updates status and auto-creates a conversation.
     */
    public function acceptMatch(User $user, int $matchedUserId): UserMatch
    {
        $match = $this->findMatch($user, $matchedUserId);

        if (!$match) {
            throw new \InvalidArgumentException('Match not found.');
        }

        if (!$match->isPending()) {
            throw new \InvalidArgumentException('This match has already been ' . $match->status . '.');
        }

        return DB::transaction(function () use ($match, $user, $matchedUserId) {
            // Create a conversation for the matched pair
            $conversation = Conversation::create([
                'type' => 'direct',
                'created_by' => $user->id,
            ]);

            // Add both users as participants
            $conversation->participants()->attach([
                $user->id => ['role' => 'member', 'joined_at' => now()],
                $matchedUserId => ['role' => 'member', 'joined_at' => now()],
            ]);

            // Update match status
            $match->update([
                'status' => 'accepted',
                'conversation_id' => $conversation->id,
            ]);

            // Also update the reverse match if it exists
            UserMatch::where('user_id', $matchedUserId)
                ->where('matched_user_id', $user->id)
                ->pending()
                ->update([
                    'status' => 'accepted',
                    'conversation_id' => $conversation->id,
                ]);

            return $match->fresh(['matchedUser.profile', 'conversation']);
        });
    }

    /**
     * Decline a match.
     */
    public function declineMatch(User $user, int $matchedUserId): UserMatch
    {
        $match = $this->findMatch($user, $matchedUserId);

        if (!$match) {
            throw new \InvalidArgumentException('Match not found.');
        }

        if (!$match->isPending()) {
            throw new \InvalidArgumentException('This match has already been ' . $match->status . '.');
        }

        $match->update(['status' => 'declined']);

        return $match;
    }

    /**
     * Get active (accepted) matches with conversations.
     */
    public function getActiveMatches(User $user, int $perPage = 20)
    {
        return UserMatch::forUser($user->id)
            ->accepted()
            ->with(['user.profile', 'matchedUser.profile', 'conversation'])
            ->orderByDesc('updated_at')
            ->paginate($perPage);
    }

    /**
     * Expire old pending matches.
     */
    public function expireOldMatches(): int
    {
        return UserMatch::pending()
            ->where('expires_at', '<=', now())
            ->update(['status' => 'expired']);
    }

    /**
     * Find a match between two users (either direction).
     */
    private function findMatch(User $user, int $otherUserId): ?UserMatch
    {
        return UserMatch::where(function ($q) use ($user, $otherUserId) {
            $q->where('user_id', $user->id)->where('matched_user_id', $otherUserId);
        })->orWhere(function ($q) use ($user, $otherUserId) {
            $q->where('user_id', $otherUserId)->where('matched_user_id', $user->id);
        })->first();
    }
}
