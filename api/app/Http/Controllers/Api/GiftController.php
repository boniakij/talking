<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\SendGiftRequest;
use App\Http\Requests\TopUpCoinsRequest;
use App\Http\Resources\CoinWalletResource;
use App\Http\Resources\GiftCategoryResource;
use App\Http\Resources\GiftResource;
use App\Http\Resources\GiftTransactionResource;
use App\Services\CoinService;
use App\Services\GiftService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GiftController extends BaseController
{
    public function __construct(
        private GiftService $giftService,
        private CoinService $coinService,
    ) {}

    /**
     * GET /gifts — List available gifts.
     */
    public function index(Request $request): JsonResponse
    {
        $gifts = $this->giftService->getGifts(
            categoryId: $request->input('category_id'),
            rarity: $request->input('rarity'),
            perPage: $request->input('per_page', 20),
        );

        return $this->paginatedResponse(
            $gifts->through(fn ($gift) => new GiftResource($gift)),
            'Gifts retrieved successfully.'
        );
    }

    /**
     * GET /gifts/categories — List gift categories with gifts.
     */
    public function categories(Request $request): JsonResponse
    {
        $categories = $this->giftService->getCategories(
            cultureTag: $request->input('culture')
        );

        return $this->successResponse(
            GiftCategoryResource::collection($categories),
            'Gift categories retrieved successfully.'
        );
    }

    /**
     * POST /gifts/send — Send a gift to another user.
     */
    public function send(SendGiftRequest $request): JsonResponse
    {
        try {
            $transaction = $this->giftService->sendGift(
                sender: $request->user(),
                receiverId: $request->input('receiver_id'),
                giftId: $request->input('gift_id'),
                message: $request->input('message'),
                isAnonymous: $request->boolean('is_anonymous', false),
            );

            return $this->successResponse(
                new GiftTransactionResource($transaction),
                'Gift sent successfully!',
                201
            );
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        } catch (\RuntimeException $e) {
            return $this->errorResponse($e->getMessage(), null, 400);
        }
    }

    /**
     * GET /gifts/history — Gift transaction history.
     */
    public function history(Request $request): JsonResponse
    {
        $request->validate([
            'type' => 'nullable|in:sent,received',
        ]);

        $history = $this->giftService->getHistory(
            user: $request->user(),
            type: $request->input('type', 'received'),
            perPage: $request->input('per_page', 20),
        );

        return $this->paginatedResponse(
            $history->through(fn ($tx) => new GiftTransactionResource($tx)),
            'Gift history retrieved successfully.'
        );
    }

    /**
     * GET /gifts/leaderboard — Top gift receivers.
     */
    public function leaderboard(Request $request): JsonResponse
    {
        $request->validate([
            'period' => 'nullable|in:week,month,all',
        ]);

        $leaderboard = $this->giftService->getLeaderboard(
            period: $request->input('period', 'all'),
            limit: $request->input('limit', 20),
        );

        return $this->successResponse($leaderboard, 'Gift leaderboard retrieved successfully.');
    }

    /**
     * GET /gifts/coins/balance — Get coin wallet balance.
     */
    public function balance(Request $request): JsonResponse
    {
        $wallet = $this->coinService->getOrCreateWallet($request->user());

        return $this->successResponse(
            new CoinWalletResource($wallet),
            'Coin balance retrieved successfully.'
        );
    }

    /**
     * POST /gifts/coins/topup — Purchase coins via Stripe.
     */
    public function topup(TopUpCoinsRequest $request): JsonResponse
    {
        try {
            // Create Stripe PaymentIntent
            $paymentData = $this->coinService->createStripePaymentIntent(
                $request->input('amount')
            );

            return $this->successResponse([
                'client_secret' => $paymentData['client_secret'],
                'payment_intent_id' => $paymentData['payment_intent_id'],
                'coin_amount' => $paymentData['coin_amount'],
                'charge_amount_cents' => $paymentData['amount_cents'],
            ], 'Payment intent created. Complete payment on client.');

        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        } catch (\RuntimeException $e) {
            return $this->errorResponse($e->getMessage(), null, 503);
        }
    }

    /**
     * POST /gifts/coins/confirm — Confirm payment and credit coins.
     */
    public function confirmTopup(Request $request): JsonResponse
    {
        $request->validate([
            'payment_intent_id' => 'required|string',
            'coin_amount' => 'required|integer|min:100',
        ]);

        try {
            $transaction = $this->coinService->processTopUp(
                $request->user(),
                $request->input('coin_amount'),
                $request->input('payment_intent_id')
            );

            $wallet = $this->coinService->getOrCreateWallet($request->user());

            return $this->successResponse([
                'transaction_id' => $transaction->id,
                'coins_added' => abs($transaction->amount),
                'new_balance' => $wallet->balance,
            ], 'Coins added to your wallet!');

        } catch (\RuntimeException $e) {
            return $this->errorResponse($e->getMessage(), null, 400);
        }
    }

    /**
     * GET /gifts/coins/transactions — Coin transaction history.
     */
    public function coinTransactions(Request $request): JsonResponse
    {
        $request->validate([
            'type' => 'nullable|in:topup,spent,refund,bonus',
        ]);

        $transactions = $this->coinService->getTransactionHistory(
            user: $request->user(),
            type: $request->input('type'),
            perPage: $request->input('per_page', 20),
        );

        return $this->paginatedResponse($transactions, 'Coin transactions retrieved successfully.');
    }
}
