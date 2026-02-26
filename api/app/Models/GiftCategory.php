<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\HasMany;

class GiftCategory extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',
        'slug',
        'description',
        'icon_url',
        'culture_tag',
        'display_order',
        'is_active',
    ];

    protected $casts = [
        'is_active' => 'boolean',
        'display_order' => 'integer',
    ];

    // Relationships

    public function gifts(): HasMany
    {
        return $this->hasMany(Gift::class)->orderBy('display_order');
    }

    public function activeGifts(): HasMany
    {
        return $this->gifts()->where('is_active', true);
    }

    // Scopes

    public function scopeActive(Builder $query): Builder
    {
        return $query->where('is_active', true);
    }

    public function scopeByCulture(Builder $query, string $cultureTag): Builder
    {
        return $query->where('culture_tag', $cultureTag);
    }
}
