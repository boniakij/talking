<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;

class RegisterRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'username' => ['required', 'string', 'min:3', 'max:50', 'unique:users', 'alpha_dash'],
            'email' => ['required', 'email', 'max:255', 'unique:users'],
            'password' => ['required', 'string', 'min:8', 'confirmed', Password::defaults()],
            'country_code' => ['nullable', 'string', 'size:2'],
            'native_language' => ['required', 'string', 'exists:languages,code'],
            'learning_language' => ['nullable', 'string', 'exists:languages,code'],
        ];
    }

    public function messages(): array
    {
        return [
            'username.alpha_dash' => 'Username can only contain letters, numbers, dashes and underscores.',
            'native_language.exists' => 'The selected native language is invalid.',
            'learning_language.exists' => 'The selected learning language is invalid.',
        ];
    }
}
