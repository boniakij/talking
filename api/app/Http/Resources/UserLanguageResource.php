<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserLanguageResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'code' => $this->language->code,
            'name' => $this->language->name,
            'native_name' => $this->language->native_name,
            'flag_emoji' => $this->language->flag_emoji,
            'type' => $this->type,
            'proficiency' => $this->proficiency,
        ];
    }
}
