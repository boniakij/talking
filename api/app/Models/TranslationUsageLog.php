<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class TranslationUsageLog extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'translation_id',
        'source_type',
        'rating',
        'feedback',
    ];

    protected $casts = [
        'rating' => 'integer',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function translation(): BelongsTo
    {
        return $this->belongsTo(Translation::class);
    }
}
