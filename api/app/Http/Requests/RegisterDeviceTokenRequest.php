<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class RegisterDeviceTokenRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'token' => 'required|string|max:500',
            'platform' => 'required|string|in:android,ios,web',
            'device_name' => 'nullable|string|max:100',
        ];
    }
}
