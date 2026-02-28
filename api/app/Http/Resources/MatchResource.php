<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MatchResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $currentUserId = $request->user()?->id;

        // Show the OTHER user in the match (not the requesting user)
        $otherUser = $this->user_id === $currentUserId
            ? $this->whenLoaded('matchedUser')
            : $this->whenLoaded('user');

        return [
            'id' => $this->id,
            'user' => ($otherUser && !($otherUser instanceof \Illuminate\Http\Resources\MissingValue)) ? [
                'id' => $otherUser->id,
                'username' => $otherUser->username,
                'avatar' => $otherUser->profile?->avatar_url,
                'country' => $otherUser->profile?->country,
                'bio' => $otherUser->profile?->bio,
            ] : null,
            'score' => (float) $this->score,
            'score_breakdown' => $this->score_breakdown,
            'status' => $this->status,
            'conversation_id' => $this->conversation_id,
            'expires_at' => $this->expires_at?->toISOString(),
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}
