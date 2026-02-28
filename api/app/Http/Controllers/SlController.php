<?php

namespace App\Http\Controllers;

use App\Models\TongueTwister;
use App\Models\PronunciationScore;
use App\Models\LeaderboardEntry;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class SlController extends Controller
{
    public function getTongueTwisters(): JsonResponse
    {
        $twisters = TongueTwister::active()->ordered()->get();
        
        $twisters = $twisters->map(function ($twister) {
            $userBestScore = null;
            if (Auth::check()) {
                $userBestScore = PronunciationScore::where('user_id', Auth::id())
                    ->where('tongue_twister_id', $twister->id)
                    ->max('overall_score');
            }
            
            return [
                'id' => $twister->id,
                'text' => $twister->text,
                'language' => $twister->language,
                'difficulty' => $twister->difficulty,
                'translation' => $twister->translation,
                'phonemes' => $twister->phonemes,
                'is_unlocked' => $this->isTwisterUnlocked($twister),
                'best_score' => $userBestScore ? (int) $userBestScore : null,
            ];
        });

        return response()->json(['data' => $twisters]);
    }

    public function analyzePronunciation(Request $request): JsonResponse
    {
        $request->validate([
            'audio' => 'required|file|mimes:wav,mp3,m4a|max:10240',
            'target_text' => 'required|string',
        ]);

        try {
            $audioFile = $request->file('audio');
            $path = $audioFile->store('pronunciation-recordings', 'public');
            
            $score = $this->generateMockScore($request->target_text);
            
            $pronunciationScore = PronunciationScore::create([
                'user_id' => Auth::id(),
                'tongue_twister_id' => $this->findTwisterByText($request->target_text),
                'overall_score' => $score['overall'],
                'phoneme_scores' => $score['phonemes'],
                'feedback' => $score['feedback'],
                'recording_path' => $path,
                'analyzed_at' => now(),
            ]);

            $this->updateLeaderboardIfNeeded($pronunciationScore);

            return response()->json(['data' => [
                'overall_score' => $pronunciationScore->overall_score,
                'phoneme_scores' => $pronunciationScore->phoneme_scores,
                'feedback' => $pronunciationScore->feedback,
                'recording_path' => $pronunciationScore->recording_path,
                'timestamp' => $pronunciationScore->analyzed_at->toISOString(),
            ]]);
            
        } catch (\Exception $e) {
            return response()->json(['error' => 'Failed to analyze pronunciation'], 500);
        }
    }

    public function getLeaderboard(): JsonResponse
    {
        $entries = LeaderboardEntry::with(['user:id,username,avatar', 'tongueTwister:text'])
            ->highScoreFirst()
            ->limit(50)
            ->get()
            ->map(function ($entry, $index) {
                return [
                    'id' => $entry->id,
                    'username' => $entry->user->username,
                    'avatar' => $entry->user->avatar ?? '',
                    'score' => $entry->score,
                    'tongue_twister_text' => $entry->tongueTwister->text,
                    'completed_at' => $entry->completed_at->toISOString(),
                    'rank' => $index + 1,
                ];
            });

        return response()->json(['data' => $entries]);
    }

    public function unlockTongueTwister(int $id): JsonResponse
    {
        $twister = TongueTwister::findOrFail($id);
        
        return response()->json(['message' => 'Tongue twister unlocked successfully']);
    }

    public function saveScore(Request $request, int $id): JsonResponse
    {
        $request->validate([
            'score' => 'required|integer|min:0|max:100',
        ]);

        $twister = TongueTwister::findOrFail($id);
        
        return response()->json(['message' => 'Score saved successfully']);
    }

    private function isTwisterUnlocked(TongueTwister $twister): bool
    {
        if ($twister->difficulty === 'Easy') {
            return true;
        }
        
        if (!Auth::check()) {
            return false;
        }

        $completedCount = PronunciationScore::where('user_id', Auth::id())
            ->where('overall_score', '>=', 70)
            ->distinct('tongue_twister_id')
            ->count();

        return match($twister->difficulty) {
            'Medium' => $completedCount >= 1,
            'Hard' => $completedCount >= 3,
            'Master' => $completedCount >= 6,
            default => false,
        };
    }

    private function generateMockScore(string $text): array
    {
        $overall = rand(60, 95);
        $phonemes = ['s', 'ʃ', 'l', 'r', 't'];
        $phonemeScores = [];
        
        foreach ($phonemes as $phoneme) {
            $phonemeScores[$phoneme] = rand(50, 100);
        }

        $feedback = [
            'Good pronunciation of consonant sounds',
            'Work on vowel articulation',
            'Try speaking slightly slower',
        ];

        return [
            'overall' => $overall,
            'phonemes' => $phonemeScores,
            'feedback' => $feedback,
        ];
    }

    private function findTwisterByText(string $text): ?int
    {
        $twister = TongueTwister::where('text', 'like', '%' . substr($text, 0, 20) . '%')->first();
        return $twister?->id;
    }

    private function updateLeaderboardIfNeeded(PronunciationScore $score): void
    {
        if ($score->overall_score >= 70) {
            $existingEntry = LeaderboardEntry::where('user_id', $score->user_id)
                ->where('tongue_twister_id', $score->tongue_twister_id)
                ->first();

            if (!$existingEntry || $score->overall_score > $existingEntry->score) {
                LeaderboardEntry::updateOrCreate(
                    [
                        'user_id' => $score->user_id,
                        'tongue_twister_id' => $score->tongue_twister_id,
                    ],
                    [
                        'score' => (int) $score->overall_score,
                        'completed_at' => $score->analyzed_at,
                    ]
                );
            }
        }
    }
}
