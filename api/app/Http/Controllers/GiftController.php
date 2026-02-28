<?php

namespace App\Http\Controllers;

use App\Models\Gift;
use App\Models\CoinWallet;
use App\Models\CoinTransaction;
use App\Models\GiftTransaction;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class GiftController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Gift::where('is_active', true);
        
        if ($request->has('category')) {
            $query->whereHas('category', function ($q) use ($request) {
                $q->where('name', $request->category);
            });
        }
        
        $gifts = $query->orderBy('display_order')->get()->map(function ($gift) {
            return [
                'id' => $gift->slug,
                'name' => $gift->name,
                'description' => $gift->description,
                'icon_asset' => $gift->icon_url ?? $this->getDefaultIcon($gift->slug),
                'coin_cost' => $gift->price_coins,
                'is_premium' => in_array($gift->rarity, ['epic', 'legendary']),
                'category' => $gift->category?->name ?? 'General',
            ];
        });

        return response()->json(['data' => $gifts]);
    }

    public function show(string $id): JsonResponse
    {
        $gift = Gift::where('slug', $id)->firstOrFail();
        
        return response()->json(['data' => [
            'id' => $gift->slug,
            'name' => $gift->name,
            'description' => $gift->description,
            'icon_asset' => $gift->icon_url ?? $this->getDefaultIcon($gift->slug),
            'coin_cost' => $gift->price_coins,
            'is_premium' => in_array($gift->rarity, ['epic', 'legendary']),
            'category' => $gift->category?->name ?? 'General',
        ]]);
    }

    public function getWallet(): JsonResponse
    {
        $wallet = CoinWallet::firstOrCreate(
            ['user_id' => Auth::id()],
            ['balance' => 0, 'total_earned' => 0, 'total_spent' => 0]
        );

        return response()->json(['data' => [
            'balance' => $wallet->balance,
            'lifetime_earnings' => $wallet->total_earned,
            'lifetime_spent' => $wallet->total_spent,
            'last_purchase_at' => $wallet->updated_at,
        ]]);
    }

    public function getCoinPackages(): JsonResponse
    {
        $packages = [
            [
                'id' => 'coins_100',
                'name' => 'Handful',
                'coin_amount' => 100,
                'price' => 0.99,
                'currency' => 'USD',
                'store_product_id' => 'com.banitalk.coins.100',
            ],
            [
                'id' => 'coins_500',
                'name' => 'Pouch',
                'coin_amount' => 500,
                'price' => 4.99,
                'currency' => 'USD',
                'bonus_description' => '50 bonus coins!',
                'store_product_id' => 'com.banitalk.coins.500',
            ],
            [
                'id' => 'coins_1200',
                'name' => 'Bag',
                'coin_amount' => 1200,
                'price' => 9.99,
                'currency' => 'USD',
                'is_popular' => true,
                'bonus_description' => '200 bonus coins!',
                'store_product_id' => 'com.banitalk.coins.1200',
            ],
            [
                'id' => 'coins_2500',
                'name' => 'Chest',
                'coin_amount' => 2500,
                'price' => 19.99,
                'currency' => 'USD',
                'bonus_description' => '500 bonus coins!',
                'store_product_id' => 'com.banitalk.coins.2500',
            ],
            [
                'id' => 'coins_6500',
                'name' => 'Treasure',
                'coin_amount' => 6500,
                'price' => 49.99,
                'currency' => 'USD',
                'bonus_description' => '1500 bonus coins!',
                'store_product_id' => 'com.banitalk.coins.6500',
            ],
        ];

        return response()->json(['data' => $packages]);
    }

    public function purchaseCoins(Request $request): JsonResponse
    {
        $request->validate(['package_id' => 'required|string']);
        
        $packages = [
            'coins_100' => ['amount' => 100, 'bonus' => 0],
            'coins_500' => ['amount' => 500, 'bonus' => 50],
            'coins_1200' => ['amount' => 1200, 'bonus' => 200],
            'coins_2500' => ['amount' => 2500, 'bonus' => 500],
            'coins_6500' => ['amount' => 6500, 'bonus' => 1500],
        ];

        if (!isset($packages[$request->package_id])) {
            return response()->json(['error' => 'Invalid package'], 400);
        }

        $package = $packages[$request->package_id];
        $totalCoins = $package['amount'] + $package['bonus'];

        DB::transaction(function () use ($totalCoins, $request) {
            $wallet = CoinWallet::firstOrCreate(
                ['user_id' => Auth::id()],
                ['balance' => 0, 'total_earned' => 0, 'total_spent' => 0]
            );

            $oldBalance = $wallet->balance;
            $wallet->balance += $totalCoins;
            $wallet->total_earned += $totalCoins;
            $wallet->save();

            CoinTransaction::create([
                'user_id' => Auth::id(),
                'type' => 'topup',
                'amount' => $totalCoins,
                'balance_after' => $wallet->balance,
                'description' => 'Purchased coin package: ' . $request->package_id,
                'reference_type' => 'coin_purchase',
            ]);
        });

        return response()->json(['message' => 'Purchase successful']);
    }

    public function sendGift(Request $request): JsonResponse
    {
        $request->validate([
            'gift_id' => 'required|string|exists:gifts,slug',
            'recipient_id' => 'required|exists:users,id',
            'message' => 'nullable|string|max:500',
        ]);

        $gift = Gift::where('slug', $request->gift_id)->firstOrFail();
        $wallet = CoinWallet::where('user_id', Auth::id())->first();

        if (!$wallet || $wallet->balance < $gift->price_coins) {
            return response()->json(['error' => 'Insufficient coins'], 400);
        }

        DB::transaction(function () use ($gift, $request, $wallet) {
            // Deduct coins from sender
            $wallet->balance -= $gift->price_coins;
            $wallet->total_spent += $gift->price_coins;
            $wallet->save();

            // Record transaction
            CoinTransaction::create([
                'user_id' => Auth::id(),
                'type' => 'spent',
                'amount' => -$gift->price_coins,
                'balance_after' => $wallet->balance,
                'description' => 'Sent gift: ' . $gift->name,
                'reference_type' => 'gift_sent',
                'reference_id' => $gift->id,
            ]);

            // Record gift transaction
            GiftTransaction::create([
                'sender_id' => Auth::id(),
                'recipient_id' => $request->recipient_id,
                'gift_id' => $gift->id,
                'message' => $request->message,
                'coin_value' => $gift->price_coins,
            ]);

            // TODO: Send push notification to recipient
        });

        return response()->json(['message' => 'Gift sent successfully']);
    }

    public function getTransactions(): JsonResponse
    {
        $transactions = CoinTransaction::where('user_id', Auth::id())
            ->orderBy('created_at', 'desc')
            ->limit(50)
            ->get()
            ->map(function ($tx) {
                return [
                    'id' => $tx->id,
                    'type' => $tx->type,
                    'amount' => $tx->amount,
                    'description' => $tx->description,
                    'created_at' => $tx->created_at->toISOString(),
                ];
            });

        return response()->json(['data' => $transactions]);
    }

    private function getDefaultIcon(string $slug): string
    {
        return match($slug) {
            'sakura' => '🌸',
            'dragon' => '🐉',
            'coffee' => '☕',
            'rose' => '🌹',
            'pizza' => '🍕',
            'crown' => '👑',
            'lantern' => '🏮',
            'heart' => '❤️',
            default => '🎁',
        };
    }
}
