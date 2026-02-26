<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateMatchingPreferencesRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'preferred_gender' => 'nullable|string|in:male,female,any',
            'age_min' => 'nullable|integer|min:18|max:99',
            'age_max' => 'nullable|integer|min:18|max:99|gte:age_min',
            'preferred_languages' => 'nullable|array|max:10',
            'preferred_languages.*' => 'string|max:10',
            'preferred_countries' => 'nullable|array|max:20',
            'preferred_countries.*' => 'string|max:5',
            'preferred_interests' => 'nullable|array|max:20',
            'preferred_interests.*' => 'string|max:50',
            'max_distance_km' => 'nullable|integer|min:10|max:50000',
            'is_active' => 'nullable|boolean',
        ];
    }

    public function messages(): array
    {
        return [
            'preferred_gender.in' => 'Gender must be male, female, or any.',
            'age_max.gte' => 'Maximum age must be greater than or equal to minimum age.',
            'preferred_languages.max' => 'You can specify at most 10 preferred languages.',
            'preferred_countries.max' => 'You can specify at most 20 preferred countries.',
        ];
    }
}
