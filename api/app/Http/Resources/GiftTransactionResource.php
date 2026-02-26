<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GiftTransactionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $data = [
            'id' => $this->id,
            'gift' => new GiftResource($this->whenLoaded('gift')),
            'message' => $this->message,
            'is_anonymous' => $this->is_anonymous,
            'created_at' => $this->created_at?->toISOString(),
        ];

        // Hide sender identity for anonymous gifts (unless the viewer is the sender)
        if ($this->is_anonymous && $request->user()?->id !== $this->sender_id) {
            $data['sender'] = null;
        } else {
            $data['sender'] = $this->whenLoaded('sender', function () {
                return [
                    'id' => $this->sender->id,
                    'username' => $this->sender->username,
                ];
            });
        }

        $data['receiver'] = $this->whenLoaded('receiver', function () {
            return [
                'id' => $this->receiver->id,
                'username' => $this->receiver->username,
            ];
        });

        return $data;
    }
}
