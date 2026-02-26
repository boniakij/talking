<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GiftCategoryResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'slug' => $this->slug,
            'description' => $this->description,
            'icon_url' => $this->icon_url,
            'culture_tag' => $this->culture_tag,
            'gifts_count' => $this->whenCounted('activeGifts'),
            'gifts' => GiftResource::collection($this->whenLoaded('activeGifts')),
        ];
    }
}
