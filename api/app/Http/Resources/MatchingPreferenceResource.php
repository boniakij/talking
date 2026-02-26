<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MatchingPreferenceResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'preferred_gender' => $this->preferred_gender,
            'age_min' => $this->age_min,
            'age_max' => $this->age_max,
            'preferred_languages' => $this->preferred_languages ?? [],
            'preferred_countries' => $this->preferred_countries ?? [],
            'preferred_interests' => $this->preferred_interests ?? [],
            'max_distance_km' => $this->max_distance_km,
            'is_active' => $this->is_active,
        ];
    }
}
