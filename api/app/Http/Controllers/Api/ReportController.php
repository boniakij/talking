<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\SubmitReportRequest;
use App\Http\Resources\ReportResource;
use App\Services\ReportService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReportController extends BaseController
{
    public function __construct(
        private ReportService $reportService,
    ) {}

    /**
     * POST /reports — Submit a report.
     */
    public function store(SubmitReportRequest $request): JsonResponse
    {
        try {
            $report = $this->reportService->submitReport(
                $request->user(),
                $request->validated(),
            );

            return $this->successResponse(
                new ReportResource($report),
                'Report submitted successfully. Our team will review it shortly.',
                201,
            );
        } catch (\InvalidArgumentException $e) {
            return $this->errorResponse($e->getMessage(), null, 422);
        }
    }

    /**
     * GET /reports/my — Get user's submitted reports.
     */
    public function myReports(Request $request): JsonResponse
    {
        $reports = $this->reportService->getMyReports(
            $request->user(),
            $request->input('status'),
            $request->input('per_page', 20),
        );

        return $this->paginatedResponse(
            $reports->through(fn ($r) => new ReportResource($r)),
            'Reports retrieved successfully.'
        );
    }
}
