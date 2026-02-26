<?php

namespace App\Services;

use App\Models\CoinTransaction;
use App\Models\CoinWallet;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class CoinService
{
    /**
     * Get or create a wallet for the user (lazy initialization).
     */
    public function getOrCreateWallet(User $user): CoinWallet
    {
        return CoinWallet::firstOrCreate(
            ['user_id' => $user->id],
            ['balance' => 0, 'total_earned' => 0, 'total_spent' => 0]
        );
    }

    /**
     * Get user's current coin balance.
     */
    public function getBalance(User $user): int
    {
        return $this->getOrCreateWallet($user)->balance;
    }

    /**
     * Credit coins to user's wallet (topup, bonus, refund).
     */
    public function credit(User $user, int $amount, string $type, string $description, ?string $stripePaymentId = null): CoinTransaction
    {
        return DB::transaction(function () use ($user, $amount, $type, $description, $stripePaymentId) {
            $wallet = $this->getOrCreateWallet($user);

            // Lock the wallet row for update
            $wallet = CoinWallet::lockForUpdate()->find($wallet->id);
            $wallet->credit($amount);

            $transaction = CoinTransaction::create([
                'user_id' => $user->id,
                'type' => $type,
                'amount' => $amount,
                'balance_after' => $wallet->balance,
                'description' => $description,
                'stripe_payment_id' => $stripePaymentId,
            ]);

            return $transaction;
        });
    }

    /**
     * Debit coins from user's wallet (spending).
     */
    public function debit(User $user, int $amount, string $description, ?string $referenceType = null, ?int $referenceId = null): CoinTransaction
    {
        return DB::transaction(function () use ($user, $amount, $description, $referenceType, $referenceId) {
            $wallet = $this->getOrCreateWallet($user);

            // Lock the wallet row for update
            $wallet = CoinWallet::lockForUpdate()->find($wallet->id);

            if (!$wallet->hasSufficientBalance($amount)) {
                throw new \RuntimeException('Insufficient coin balance. You need ' . $amount . ' coins but only have ' . $wallet->balance . '.');
            }

            $wallet->debit($amount);

            $transaction = CoinTransaction::create([
                'user_id' => $user->id,
                'type' => 'spent',
                'amount' => -$amount,
                'balance_after' => $wallet->balance,
                'description' => $description,
                'reference_type' => $referenceType,
                'reference_id' => $referenceId,
            ]);

            return $transaction;
        });
    }

    /**
     * Create a Stripe PaymentIntent for coin topup.
     */
    public function createStripePaymentIntent(int $coinAmount): array
    {
        $pricePerCoin = (float) config('services.stripe.price_per_coin', 0.01); // $0.01 per coin
        $amountCents = (int) round($coinAmount * $pricePerCoin * 100); // Convert to cents

        if ($amountCents < 50) {
            throw new \InvalidArgumentException('Minimum topup amount is 50 coins.');
        }

        $stripeKey = config('services.stripe.secret');

        if (empty($stripeKey)) {
            throw new \RuntimeException('Stripe is not configured. Please contact support.');
        }

        try {
            $response = Http::withHeaders([
                'Authorization' => 'Bearer ' . $stripeKey,
                'Content-Type' => 'application/x-www-form-urlencoded',
            ])->asForm()->post('https://api.stripe.com/v1/payment_intents', [
                'amount' => $amountCents,
                'currency' => config('services.stripe.currency', 'usd'),
                'metadata[coin_amount]' => $coinAmount,
                'metadata[product]' => 'coin_topup',
            ]);

            if ($response->successful()) {
                $data = $response->json();
                return [
                    'client_secret' => $data['client_secret'],
                    'payment_intent_id' => $data['id'],
                    'amount_cents' => $amountCents,
                    'coin_amount' => $coinAmount,
                ];
            }

            Log::error('Stripe PaymentIntent creation failed', [
                'status' => $response->status(),
                'body' => $response->body(),
            ]);

            throw new \RuntimeException('Payment service error. Please try again later.');

        } catch (\Illuminate\Http\Client\ConnectionException $e) {
            Log::error('Stripe connection failed', ['error' => $e->getMessage()]);
            throw new \RuntimeException('Payment service is currently unavailable.');
        }
    }

    /**
     * Process a successful Stripe payment and credit coins.
     */
    public function processTopUp(User $user, int $coinAmount, string $stripePaymentId): CoinTransaction
    {
        return $this->credit(
            $user,
            $coinAmount,
            'topup',
            "Purchased {$coinAmount} coins",
            $stripePaymentId
        );
    }

    /**
     * Get paginated transaction history for a user.
     */
    public function getTransactionHistory(User $user, ?string $type = null, int $perPage = 20)
    {
        $query = CoinTransaction::where('user_id', $user->id)
            ->orderByDesc('created_at');

        if ($type) {
            $query->where('type', $type);
        }

        return $query->paginate($perPage);
    }
}
