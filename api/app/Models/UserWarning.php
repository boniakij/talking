<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class UserWarning extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'warned_by',
        'reason',
        'details',
        'report_id',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function admin(): BelongsTo
    {
        return $this->belongsTo(User::class, 'warned_by');
    }

    public function report(): BelongsTo
    {
        return $this->belongsTo(Report::class);
    }
}
