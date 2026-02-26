<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class TranslateTextRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'text' => 'required|string|max:5000',
            'target_lang' => 'required|string|max:10|exists:languages,code',
            'source_lang' => 'nullable|string|max:10|exists:languages,code',
        ];
    }

    public function messages(): array
    {
        return [
            'text.required' => 'Text to translate is required.',
            'text.max' => 'Text cannot exceed 5000 characters.',
            'target_lang.required' => 'Target language code is required.',
            'target_lang.exists' => 'Target language is not supported.',
            'source_lang.exists' => 'Source language is not supported.',
        ];
    }
}
