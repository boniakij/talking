<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NotificationSettingResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'push_enabled' => $this->push_enabled,
            'email_enabled' => $this->email_enabled,
            'mute_all' => $this->mute_all,
            'quiet_hours_start' => $this->quiet_hours_start,
            'quiet_hours_end' => $this->quiet_hours_end,
            'type_preferences' => $this->type_preferences ?? \App\Models\NotificationSetting::DEFAULT_TYPE_PREFERENCES,
        ];
    }
}
