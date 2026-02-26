<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class TopUpCoinsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'amount' => 'required|integer|min:100|max:100000',
            'payment_method_id' => 'required|string',
        ];
    }

    public function messages(): array
    {
        return [
            'amount.required' => 'Coin amount is required.',
            'amount.min' => 'Minimum topup is 100 coins.',
            'amount.max' => 'Maximum topup is 100,000 coins.',
            'payment_method_id.required' => 'Payment method is required.',
        ];
    }
}
