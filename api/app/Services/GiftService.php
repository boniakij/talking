<?php

namespace App\Services;

use App\Events\GiftReceived;
use App\Models\Gift;
use App\Models\GiftCategory;
use App\Models\GiftTransaction;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;

class GiftService
{
    public function __construct(
        private CoinService $coinService
    ) {}

    /**
     * Get all active gift categories with their gifts.
     */
    public function getCategories(?string $cultureTag = null)
    {
        $cacheKey = 'gift_categories:' . ($cultureTag ?? 'all');

        return Cache::remember($cacheKey, now()->addHours(6), function () use ($cultureTag) {
            $query = GiftCategory::active()
                ->with(['activeGifts'])
                ->orderBy('display_order');

            if ($cultureTag) {
                $query->byCulture($cultureTag);
            }

            return $query->get();
        });
    }

    /**
     * Get filtered gift catalog.
     */
    public function getGifts(?int $categoryId = null, ?string $rarity = null, int $perPage = 20)
    {
        $query = Gift::active()
            ->with('category')
            ->orderBy('display_order');

        if ($categoryId) {
            $query->byCategory($categoryId);
        }

        if ($rarity) {
            $query->byRarity($rarity);
        }

        return $query->paginate($perPage);
    }

    /**
     * Send a gift from one user to another.
     * Atomic: debit coins → create transaction → fire event.
     */
    public function sendGift(
        User $sender,
        int $receiverId,
        int $giftId,
        ?string $message = null,
        bool $isAnonymous = false
    ): GiftTransaction {
        $receiver = User::find($receiverId);

        if (!$receiver) {
            throw new \InvalidArgumentException('Recipient user not found.');
        }

        if ($sender->id === $receiver->id) {
            throw new \InvalidArgumentException('You cannot send a gift to yourself.');
        }

        if ($sender->hasBlockedOrIsBlockedBy($receiver)) {
            throw new \InvalidArgumentException('Unable to send gift to this user.');
        }

        $gift = Gift::active()->find($giftId);

        if (!$gift) {
            throw new \InvalidArgumentException('Gift not found or unavailable.');
        }

        return DB::transaction(function () use ($sender, $receiver, $gift, $message, $isAnonymous) {
            // Debit coins from sender
            $coinTransaction = $this->coinService->debit(
                $sender,
                $gift->price_coins,
                "Sent gift: {$gift->name} to {$receiver->username}",
                'gift',
                null // will update after creating gift transaction
            );

            // Create gift transaction
            $giftTransaction = GiftTransaction::create([
                'sender_id' => $sender->id,
                'receiver_id' => $receiver->id,
                'gift_id' => $gift->id,
                'coin_transaction_id' => $coinTransaction->id,
                'message' => $message,
                'is_anonymous' => $isAnonymous,
            ]);

            // Update coin transaction reference
            $coinTransaction->update([
                'reference_id' => $giftTransaction->id,
            ]);

            // Load relationships
            $giftTransaction->load(['sender', 'receiver', 'gift.category']);

            // Fire event for real-time notification
            broadcast(new GiftReceived($giftTransaction))->toOthers();

            return $giftTransaction;
        });
    }

    /**
     * Get gift transaction history for a user.
     */
    public function getHistory(User $user, string $type = 'received', int $perPage = 20)
    {
        $query = GiftTransaction::with(['sender', 'receiver', 'gift.category']);

        if ($type === 'sent') {
            $query->where('sender_id', $user->id);
        } else {
            $query->where('receiver_id', $user->id);
        }

        return $query->orderByDesc('created_at')->paginate($perPage);
    }

    /**
     * Get gift leaderboard — top gift receivers.
     */
    public function getLeaderboard(string $period = 'all', int $limit = 20): array
    {
        $query = GiftTransaction::select('receiver_id')
            ->selectRaw('COUNT(*) as gifts_received')
            ->selectRaw('SUM(gifts.price_coins) as total_coins_received')
            ->join('gifts', 'gift_transactions.gift_id', '=', 'gifts.id')
            ->groupBy('receiver_id')
            ->orderByDesc('total_coins_received');

        // Apply time period filter
        if ($period === 'week') {
            $query->where('gift_transactions.created_at', '>=', now()->subWeek());
        } elseif ($period === 'month') {
            $query->where('gift_transactions.created_at', '>=', now()->subMonth());
        }

        $results = $query->limit($limit)->get();

        // Load user data
        $userIds = $results->pluck('receiver_id');
        $users = User::with('profile')->whereIn('id', $userIds)->get()->keyBy('id');

        return $results->map(function ($row, $index) use ($users) {
            $user = $users->get($row->receiver_id);
            return [
                'rank' => $index + 1,
                'user' => $user ? [
                    'id' => $user->id,
                    'username' => $user->username,
                    'avatar' => $user->profile?->avatar_url,
                ] : null,
                'gifts_received' => (int) $row->gifts_received,
                'total_coins_received' => (int) $row->total_coins_received,
            ];
        })->toArray();
    }
}
