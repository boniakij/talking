<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CoinWallet extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'balance',
        'total_earned',
        'total_spent',
    ];

    protected $casts = [
        'balance' => 'integer',
        'total_earned' => 'integer',
        'total_spent' => 'integer',
    ];

    // Relationships

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Methods

    /**
     * Check if wallet has enough coins.
     */
    public function hasSufficientBalance(int $amount): bool
    {
        return $this->balance >= $amount;
    }

    /**
     * Credit coins to wallet (topup, bonus, refund).
     */
    public function credit(int $amount): void
    {
        $this->increment('balance', $amount);
        $this->increment('total_earned', $amount);
    }

    /**
     * Debit coins from wallet (spending).
     */
    public function debit(int $amount): void
    {
        if (!$this->hasSufficientBalance($amount)) {
            throw new \RuntimeException('Insufficient coin balance.');
        }

        $this->decrement('balance', $amount);
        $this->increment('total_spent', $amount);
    }
}
