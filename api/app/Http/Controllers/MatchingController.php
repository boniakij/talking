<?php

namespace App\Http\Controllers;

use App\Models\Swipe;
use App\Models\Match as UserMatch;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class MatchingController extends Controller
{
    public function discover(Request $request): JsonResponse
    {
        $user = Auth::user();
        
        $swipedUserIds = Swipe::where('user_id', $user->id)->pluck('swiped_user_id')->toArray();
        $matchedUserIds = UserMatch::where('user_id', $user->id)
            ->orWhere('matched_user_id', $user->id)
            ->get()
            ->map(fn($m) => $m->user_id === $user->id ? $m->matched_user_id : $m->user_id)
            ->toArray();
        
        $excludeIds = array_merge([$user->id], $swipedUserIds, $matchedUserIds);
        
        $query = User::whereNotIn('id', $excludeIds);
        
        if ($request->has('language')) {
            $query->whereHas('profile', fn($q) => $q->where('native_language', $request->language)
                ->orWhere('learning_language', $request->language));
        }
        
        if ($request->has('interests')) {
            $interests = explode(',', $request->interests);
            $query->whereHas('interests', fn($q) => $q->whereIn('name', $interests));
        }
        
        $potentialMatches = $query->limit(20)->get();
        
        $matches = $potentialMatches->map(function ($potential) use ($user) {
            $score = $this->calculateCompatibilityScore($user, $potential);
            return [
                'id' => $potential->id,
                'username' => $potential->username,
                'avatar' => $potential->avatar,
                'bio' => $potential->profile?->bio,
                'interests' => $potential->interests->pluck('name')->toArray(),
                'native_language' => $potential->profile?->native_language,
                'learning_language' => $potential->profile?->learning_language,
                'age' => $potential->profile?->date_of_birth ? now()->diffInYears($potential->profile->date_of_birth) : null,
                'location' => $potential->profile?->location,
                'compatibility_score' => $score['overall'],
                'shared_interests' => $score['shared_interests'],
            ];
        })->sortByDesc('compatibility_score')->values();
        
        return response()->json(['data' => $matches]);
    }
    
    public function likeUser(Request $request): JsonResponse
    {
        $request->validate(['user_id' => 'required|exists:users,id']);
        
        $user = Auth::user();
        $likedUserId = $request->user_id;
        
        if ($user->id == $likedUserId) {
            return response()->json(['error' => 'Cannot like yourself'], 400);
        }
        
        Swipe::updateOrCreate(
            ['user_id' => $user->id, 'swiped_user_id' => $likedUserId],
            ['direction' => 'like']
        );
        
        $isMatch = Swipe::where('user_id', $likedUserId)
            ->where('swiped_user_id', $user->id)
            ->where('direction', 'like')
            ->exists();
        
        if ($isMatch && !UserMatch::where(fn($q) => $q->where('user_id', $user->id)->where('matched_user_id', $likedUserId))
            ->orWhere(fn($q) => $q->where('user_id', $likedUserId)->where('matched_user_id', $user->id))
            ->exists()) {
            $score = $this->calculateCompatibilityScore(User::find($user->id), User::find($likedUserId));
            UserMatch::create([
                'user_id' => min($user->id, $likedUserId),
                'matched_user_id' => max($user->id, $likedUserId),
                'score' => $score['overall'] * 100,
                'status' => 'accepted',
            ]);
        }
        
        return response()->json(['is_match' => $isMatch, 'message' => $isMatch ? "It's a match!" : 'Like recorded']);
    }
    
    public function passUser(Request $request): JsonResponse
    {
        $request->validate(['user_id' => 'required|exists:users,id']);
        Swipe::updateOrCreate(
            ['user_id' => Auth::id(), 'swiped_user_id' => $request->user_id],
            ['direction' => 'pass']
        );
        return response()->json(['message' => 'User passed']);
    }
    
    public function superLikeUser(Request $request): JsonResponse
    {
        $request->validate(['user_id' => 'required|exists:users,id']);
        
        $user = Auth::user();
        $likedUserId = $request->user_id;
        
        if ($user->id == $likedUserId) {
            return response()->json(['error' => 'Cannot super like yourself'], 400);
        }
        
        Swipe::updateOrCreate(
            ['user_id' => $user->id, 'swiped_user_id' => $likedUserId],
            ['direction' => 'super_like']
        );
        
        if (!UserMatch::where(fn($q) => $q->where('user_id', $user->id)->where('matched_user_id', $likedUserId))
            ->orWhere(fn($q) => $q->where('user_id', $likedUserId)->where('matched_user_id', $user->id))
            ->exists()) {
            $score = $this->calculateCompatibilityScore(User::find($user->id), User::find($likedUserId));
            UserMatch::create([
                'user_id' => min($user->id, $likedUserId),
                'matched_user_id' => max($user->id, $likedUserId),
                'score' => $score['overall'] * 100,
                'status' => 'accepted',
            ]);
        }
        
        return response()->json(['is_match' => true, 'message' => 'Super like sent! You\'ve matched!']);
    }
    
    public function undoSwipe(Request $request): JsonResponse
    {
        $request->validate(['user_id' => 'required|exists:users,id']);
        $user = Auth::user();
        
        Swipe::where('user_id', $user->id)->where('swiped_user_id', $request->user_id)->delete();
        UserMatch::where(fn($q) => $q->where('user_id', $user->id)->where('matched_user_id', $request->user_id))
            ->orWhere(fn($q) => $q->where('user_id', $request->user_id)->where('matched_user_id', $user->id))
            ->delete();
        
        return response()->json(['message' => 'Swipe undone']);
    }
    
    public function getMatches(): JsonResponse
    {
        $user = Auth::user();
        
        $matches = UserMatch::with(['user', 'matchedUser'])
            ->where(fn($q) => $q->where('user_id', $user->id)->orWhere('matched_user_id', $user->id))
            ->where('status', 'accepted')
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(fn($match) => [
                'id' => $match->id,
                'user_id' => $match->user_id === $user->id ? $match->matched_user_id : $match->user_id,
                'username' => ($match->user_id === $user->id ? $match->matchedUser : $match->user)->username,
                'avatar' => ($match->user_id === $user->id ? $match->matchedUser : $match->user)->avatar,
                'score' => $match->score,
                'matched_at' => $match->created_at->toISOString(),
            ]);
        
        return response()->json(['data' => $matches]);
    }
    
    public function getLeaderboard(): JsonResponse
    {
        $topMatches = UserMatch::where('status', 'accepted')
            ->orderBy('score', 'desc')
            ->limit(50)
            ->get()
            ->map(fn($match, $index) => [
                'id' => $match->id,
                'username' => $match->user->username . ' & ' . $match->matchedUser->username,
                'avatar' => $match->user->avatar,
                'score' => $match->score,
                'completed_at' => $match->created_at->toISOString(),
                'rank' => $index + 1,
            ]);
        
        return response()->json(['data' => $topMatches]);
    }
    
    private function calculateCompatibilityScore(User $user1, User $user2): array
    {
        $score = 0;
        $maxScore = 0;
        
        $u1Native = $user1->profile?->native_language;
        $u1Learning = $user1->profile?->learning_language;
        $u2Native = $user2->profile?->native_language;
        $u2Learning = $user2->profile?->learning_language;
        
        $maxScore += 40;
        if ($u1Native && $u2Learning && $u1Native === $u2Learning) $score += 20;
        if ($u2Native && $u1Learning && $u2Native === $u1Learning) $score += 20;
        
        $u1Interests = $user1->interests->pluck('name')->toArray();
        $u2Interests = $user2->interests->pluck('name')->toArray();
        $sharedInterests = array_intersect($u1Interests, $u2Interests);
        
        $maxScore += 35;
        if (!empty($u1Interests) && !empty($u2Interests)) {
            $score += round((count($sharedInterests) / count(array_unique(array_merge($u1Interests, $u2Interests)))) * 35);
        }
        
        $maxScore += 15;
        if ($user1->profile?->location && $user2->profile?->location 
            && $user1->profile->location === $user2->profile->location) {
            $score += 15;
        }
        
        $maxScore += 10;
        $score += 5;
        
        return [
            'overall' => round($maxScore > 0 ? $score / $maxScore : 0, 2),
            'shared_interests' => array_values($sharedInterests),
        ];
    }
}
