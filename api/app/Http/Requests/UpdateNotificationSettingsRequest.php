<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateNotificationSettingsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'push_enabled' => 'nullable|boolean',
            'email_enabled' => 'nullable|boolean',
            'mute_all' => 'nullable|boolean',
            'quiet_hours_start' => 'nullable|date_format:H:i',
            'quiet_hours_end' => 'nullable|date_format:H:i|required_with:quiet_hours_start',
            'type_preferences' => 'nullable|array',
            'type_preferences.message' => 'nullable|boolean',
            'type_preferences.call' => 'nullable|boolean',
            'type_preferences.gift' => 'nullable|boolean',
            'type_preferences.match' => 'nullable|boolean',
            'type_preferences.follow' => 'nullable|boolean',
            'type_preferences.comment' => 'nullable|boolean',
            'type_preferences.system' => 'nullable|boolean',
        ];
    }

    public function messages(): array
    {
        return [
            'quiet_hours_end.required_with' => 'Quiet hours end is required when start is set.',
            'quiet_hours_start.date_format' => 'Quiet hours must be in HH:MM format.',
        ];
    }
}
