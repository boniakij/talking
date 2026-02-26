<?php

namespace App\Services;

use App\Models\AppNotification;
use App\Models\Report;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class ReportService
{
    // Max reports a user can submit per day
    private const DAILY_REPORT_LIMIT = 10;

    public function __construct(
        private NotificationService $notificationService,
    ) {}

    /**
     * Submit a report.
     */
    public function submitReport(User $reporter, array $data): Report
    {
        // Rate limiting
        $this->checkRateLimit($reporter);

        // Resolve the reportable type from short alias
        $reportableType = Report::resolveReportableType($data['reportable_type']);
        if (!$reportableType) {
            throw new \InvalidArgumentException(
                'Invalid reportable type. Must be one of: ' . implode(', ', array_keys(Report::REPORTABLE_TYPES))
            );
        }

        // Verify the reportable entity exists
        $reportable = $reportableType::find($data['reportable_id']);
        if (!$reportable) {
            throw new \InvalidArgumentException('The reported content does not exist.');
        }

        // Prevent self-reporting (for user type)
        if ($reportableType === 'App\\Models\\User' && $data['reportable_id'] == $reporter->id) {
            throw new \InvalidArgumentException('You cannot report yourself.');
        }

        // Check for duplicate report
        $existingReport = Report::where('reporter_id', $reporter->id)
            ->where('reportable_type', $reportableType)
            ->where('reportable_id', $data['reportable_id'])
            ->whereIn('status', ['pending', 'reviewing'])
            ->first();

        if ($existingReport) {
            throw new \InvalidArgumentException('You have already reported this content.');
        }

        // Create the report
        $report = Report::create([
            'reporter_id' => $reporter->id,
            'reportable_type' => $reportableType,
            'reportable_id' => $data['reportable_id'],
            'type' => $data['type'],
            'description' => $data['description'] ?? null,
            'evidence' => $data['evidence'] ?? null,
            'status' => 'pending',
        ]);

        // Notify admins
        $this->notifyAdmins($report, $reporter);

        Log::info('Report submitted', [
            'report_id' => $report->id,
            'reporter_id' => $reporter->id,
            'type' => $data['type'],
            'reportable' => $reportableType . '#' . $data['reportable_id'],
        ]);

        return $report;
    }

    /**
     * Get reports submitted by a user.
     */
    public function getMyReports(User $user, ?string $status = null, int $perPage = 20)
    {
        $query = Report::where('reporter_id', $user->id)
            ->orderByDesc('created_at');

        if ($status) {
            $query->where('status', $status);
        }

        return $query->paginate($perPage);
    }

    /**
     * Enforce rate limiting: max N reports per day per user.
     */
    private function checkRateLimit(User $user): void
    {
        $todayCount = Report::where('reporter_id', $user->id)
            ->whereDate('created_at', today())
            ->count();

        if ($todayCount >= self::DAILY_REPORT_LIMIT) {
            throw new \InvalidArgumentException(
                "You have reached the daily report limit ({$todayCount}/" . self::DAILY_REPORT_LIMIT . '). Please try again tomorrow.'
            );
        }
    }

    /**
     * Notify admin users about a new report.
     */
    private function notifyAdmins(Report $report, User $reporter): void
    {
        try {
            $admins = User::where('role', 'admin')->pluck('id')->toArray();

            if (empty($admins)) {
                Log::warning('No admin users found to notify about report', [
                    'report_id' => $report->id,
                ]);
                return;
            }

            $this->notificationService->sendToMany(
                $admins,
                'system',
                [
                    'title' => 'New Report Submitted',
                    'body' => "{$reporter->username} reported {$report->type} on " . class_basename($report->reportable_type) . " #{$report->reportable_id}",
                    'report_id' => $report->id,
                    'report_type' => $report->type,
                ],
                "/admin/reports/{$report->id}"
            );
        } catch (\Exception $e) {
            Log::error('Failed to notify admins about report', [
                'report_id' => $report->id,
                'error' => $e->getMessage(),
            ]);
        }
    }
}
