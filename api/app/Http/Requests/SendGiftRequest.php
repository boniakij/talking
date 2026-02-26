<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SendGiftRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'receiver_id' => 'required|integer|exists:users,id',
            'gift_id' => 'required|integer|exists:gifts,id',
            'message' => 'nullable|string|max:255',
            'is_anonymous' => 'nullable|boolean',
        ];
    }

    public function messages(): array
    {
        return [
            'receiver_id.required' => 'Recipient is required.',
            'receiver_id.exists' => 'Recipient user not found.',
            'gift_id.required' => 'Please select a gift.',
            'gift_id.exists' => 'Selected gift is not available.',
            'message.max' => 'Gift message cannot exceed 255 characters.',
        ];
    }
}
