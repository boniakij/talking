<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class TranslationResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'source_type' => $this->source_type,
            'source_id' => $this->source_id,
            'source_language' => $this->source_language,
            'target_language' => $this->target_language,
            'source_text' => $this->source_text,
            'translated_text' => $this->translated_text,
            'quality_score' => $this->quality_score ? (float) $this->quality_score : null,
            'rating_count' => $this->rating_count,
            'usage_count' => $this->usage_count,
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}
