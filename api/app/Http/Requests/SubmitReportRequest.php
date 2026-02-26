<?php

namespace App\Http\Requests;

use App\Models\Report;
use Illuminate\Foundation\Http\FormRequest;

class SubmitReportRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'reportable_type' => 'required|string|in:' . implode(',', array_keys(Report::REPORTABLE_TYPES)),
            'reportable_id' => 'required|integer|min:1',
            'type' => 'required|string|in:' . implode(',', Report::TYPES),
            'description' => 'nullable|string|max:2000',
            'evidence' => 'nullable|array|max:5',
            'evidence.*' => 'string|url|max:500',
        ];
    }

    public function messages(): array
    {
        return [
            'reportable_type.in' => 'Invalid content type. Must be: ' . implode(', ', array_keys(Report::REPORTABLE_TYPES)),
            'type.in' => 'Invalid report type. Must be: ' . implode(', ', Report::TYPES),
            'evidence.max' => 'You can provide at most 5 evidence URLs.',
        ];
    }
}
