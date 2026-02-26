<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ReportResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'reportable_type' => class_basename($this->reportable_type),
            'reportable_id' => $this->reportable_id,
            'type' => $this->type,
            'description' => $this->description,
            'evidence' => $this->evidence,
            'status' => $this->status,
            'admin_notes' => $this->when($this->status === 'resolved' || $this->status === 'dismissed', $this->admin_notes),
            'resolved_at' => $this->resolved_at?->toISOString(),
            'created_at' => $this->created_at?->toISOString(),
        ];
    }
}
