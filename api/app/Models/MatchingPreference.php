<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MatchingPreference extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'preferred_gender',
        'age_min',
        'age_max',
        'preferred_languages',
        'preferred_countries',
        'preferred_interests',
        'max_distance_km',
        'is_active',
    ];

    protected $casts = [
        'preferred_languages' => 'array',
        'preferred_countries' => 'array',
        'preferred_interests' => 'array',
        'age_min' => 'integer',
        'age_max' => 'integer',
        'max_distance_km' => 'integer',
        'is_active' => 'boolean',
    ];

    // Relationships

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // Scopes

    public function scopeActive(Builder $query): Builder
    {
        return $query->where('is_active', true);
    }
}
