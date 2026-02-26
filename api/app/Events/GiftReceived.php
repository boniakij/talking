<?php

namespace App\Events;

use App\Models\GiftTransaction;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Broadcasting\PrivateChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcast;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class GiftReceived implements ShouldBroadcast
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public GiftTransaction $giftTransaction
    ) {}

    public function broadcastOn(): array
    {
        return [
            new PrivateChannel('user.' . $this->giftTransaction->receiver_id),
        ];
    }

    public function broadcastAs(): string
    {
        return 'gift.received';
    }

    public function broadcastWith(): array
    {
        $data = [
            'gift_transaction_id' => $this->giftTransaction->id,
            'gift' => [
                'name' => $this->giftTransaction->gift->name,
                'icon_url' => $this->giftTransaction->gift->icon_url,
                'animation_url' => $this->giftTransaction->gift->animation_url,
                'rarity' => $this->giftTransaction->gift->rarity,
            ],
            'message' => $this->giftTransaction->message,
            'is_anonymous' => $this->giftTransaction->is_anonymous,
            'created_at' => $this->giftTransaction->created_at->toISOString(),
        ];

        if (!$this->giftTransaction->is_anonymous) {
            $data['sender'] = [
                'id' => $this->giftTransaction->sender->id,
                'username' => $this->giftTransaction->sender->username,
            ];
        }

        return $data;
    }
}
