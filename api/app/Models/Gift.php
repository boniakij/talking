<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Gift extends Model
{
    use HasFactory;

    protected $fillable = [
        'gift_category_id',
        'name',
        'slug',
        'description',
        'price_coins',
        'icon_url',
        'animation_url',
        'rarity',
        'display_order',
        'is_active',
    ];

    protected $casts = [
        'price_coins' => 'integer',
        'is_active' => 'boolean',
        'display_order' => 'integer',
    ];

    // Relationships

    public function category(): BelongsTo
    {
        return $this->belongsTo(GiftCategory::class, 'gift_category_id');
    }

    public function transactions(): HasMany
    {
        return $this->hasMany(GiftTransaction::class);
    }

    // Scopes

    public function scopeActive(Builder $query): Builder
    {
        return $query->where('is_active', true);
    }

    public function scopeByRarity(Builder $query, string $rarity): Builder
    {
        return $query->where('rarity', $rarity);
    }

    public function scopeByCategory(Builder $query, int $categoryId): Builder
    {
        return $query->where('gift_category_id', $categoryId);
    }

    public function scopeAffordable(Builder $query, int $coins): Builder
    {
        return $query->where('price_coins', '<=', $coins);
    }
}
