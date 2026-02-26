<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\UpdateMatchingPreferencesRequest;
use App\Http\Resources\MatchingPreferenceResource;
use App\Http\Resources\MatchResource;
use App\Services\MatchingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MatchingController extends BaseController
{
    public function __construct(
        private MatchingService $matchingService,
    ) {}

    /**
     * GET /matching/preferences — Get matching preferences.
     */
    public function getPreferences(Request $request): JsonResponse
    {
        $preferences = $this->matchingService->getPreferences($request->user());

        return $this->successResponse(
            new MatchingPreferenceResource($preferences),
            'Matching preferences retrieved successfully.'
        );
    }

    /**
     * PUT /matching/preferences — Update matching preferences.
     */
    public function updatePreferences(UpdateMatchingPreferencesRequest $request): JsonResponse
    {
        $preferences = $this->matchingService->updatePreferences(
            $request->user(),
            $request->validated()
        );

        return $this->successResponse(
            new MatchingPreferenceResource($preferences),
            'Matching preferences updated successfully.'
        );
    }

    /**
     * GET /matching/suggestions — Get match suggestions.
     */
    public function suggestions(Request $request): JsonResponse
    {
        $suggestions = $this->matchingService->getSuggestions(
            $request->user(),
            $request->input('per_page', 20),
        );

        return $this->paginatedResponse(
            $suggestions->through(fn ($match) => new MatchResource($match)),
            'Match suggestions retrieved successfully.'
        );
    }

    /**
     * POST /matching/accept/{userId} — Accept a match.
     */
    public function accept(Request $request, int $userId): JsonResponse
    {
        try {
            $match = $this->matchingService->acceptMatch($request->user(), $userId);

            return $this->successResponse(
                new MatchResource($match),
                'Match accepted! A conversation has been created.'
            );
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        }
    }

    /**
     * POST /matching/decline/{userId} — Decline a match.
     */
    public function decline(Request $request, int $userId): JsonResponse
    {
        try {
            $match = $this->matchingService->declineMatch($request->user(), $userId);

            return $this->successResponse(
                new MatchResource($match),
                'Match declined.'
            );
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        }
    }

    /**
     * GET /matching/matches — List active (accepted) matches.
     */
    public function matches(Request $request): JsonResponse
    {
        $matches = $this->matchingService->getActiveMatches(
            $request->user(),
            $request->input('per_page', 20),
        );

        return $this->paginatedResponse(
            $matches->through(fn ($match) => new MatchResource($match)),
            'Active matches retrieved successfully.'
        );
    }
}
