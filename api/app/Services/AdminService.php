<?php

namespace App\Services;

use App\Models\Gift;
use App\Models\PlatformSetting;
use App\Models\Report;
use App\Models\User;
use App\Models\UserWarning;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;

class AdminService
{
    public function __construct(
        private NotificationService $notificationService,
    ) {}

    // ─── User Management ────────────────────────────────────────────

    /**
     * List all users with filters.
     */
    public function listUsers(array $filters = [], int $perPage = 20)
    {
        $query = User::with('profile')
            ->orderByDesc('created_at');

        if (!empty($filters['search'])) {
            $search = $filters['search'];
            $query->where(function ($q) use ($search) {
                $q->where('username', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('name', 'like', "%{$search}%");
            });
        }

        if (!empty($filters['status'])) {
            $query->where('status', $filters['status']);
        }

        if (!empty($filters['role'])) {
            $query->where('role', $filters['role']);
        }

        return $query->paginate($perPage);
    }

    /**
     * Get user detail with stats.
     */
    public function getUserDetail(int $userId): array
    {
        $user = User::with(['profile', 'languages'])->findOrFail($userId);

        return [
            'user' => $user,
            'stats' => [
                'posts_count' => $user->posts()->count(),
                'followers_count' => $user->followers()->count(),
                'following_count' => $user->following()->count(),
                'warnings_count' => UserWarning::where('user_id', $userId)->count(),
                'reports_received' => Report::where('reportable_type', 'App\\Models\\User')
                    ->where('reportable_id', $userId)->count(),
                'reports_submitted' => Report::where('reporter_id', $userId)->count(),
                'joined_at' => $user->created_at->toISOString(),
                'last_seen' => $user->last_seen_at?->toISOString(),
            ],
            'warnings' => UserWarning::where('user_id', $userId)
                ->with('admin')
                ->orderByDesc('created_at')
                ->limit(10)
                ->get(),
        ];
    }

    /**
     * Ban a user (Super Admin only).
     */
    public function banUser(User $admin, int $userId, string $reason): User
    {
        $user = User::findOrFail($userId);

        $this->preventSelfAction($admin, $user);
        $this->preventActionOnSuperAdmin($user);

        $user->update(['status' => 'banned']);

        $this->notificationService->send($user, 'system', [
            'title' => 'Account Banned',
            'body' => "Your account has been banned. Reason: {$reason}",
        ]);

        Log::info('User banned', [
            'user_id' => $userId,
            'admin_id' => $admin->id,
            'reason' => $reason,
        ]);

        return $user->fresh();
    }

    /**
     * Suspend a user (Admin).
     */
    public function suspendUser(User $admin, int $userId, string $reason, ?int $days = null): User
    {
        $user = User::findOrFail($userId);

        $this->preventSelfAction($admin, $user);
        $this->preventActionOnSuperAdmin($user);

        $user->update(['status' => 'suspended']);

        $durationText = $days ? "for {$days} days" : 'indefinitely';
        $this->notificationService->send($user, 'system', [
            'title' => 'Account Suspended',
            'body' => "Your account has been suspended {$durationText}. Reason: {$reason}",
        ]);

        Log::info('User suspended', [
            'user_id' => $userId,
            'admin_id' => $admin->id,
            'reason' => $reason,
            'days' => $days,
        ]);

        return $user->fresh();
    }

    /**
     * Restore a user.
     */
    public function restoreUser(User $admin, int $userId): User
    {
        $user = User::findOrFail($userId);

        if ($user->status === 'active') {
            throw new \InvalidArgumentException('User is already active.');
        }

        $user->update(['status' => 'active']);

        $this->notificationService->send($user, 'system', [
            'title' => 'Account Restored',
            'body' => 'Your account has been restored. Welcome back!',
        ]);

        Log::info('User restored', [
            'user_id' => $userId,
            'admin_id' => $admin->id,
        ]);

        return $user->fresh();
    }

    /**
     * Issue a warning to a user.
     */
    public function warnUser(User $admin, int $userId, string $reason, ?string $details = null, ?int $reportId = null): UserWarning
    {
        $user = User::findOrFail($userId);

        $this->preventSelfAction($admin, $user);

        $warning = UserWarning::create([
            'user_id' => $userId,
            'warned_by' => $admin->id,
            'reason' => $reason,
            'details' => $details,
            'report_id' => $reportId,
        ]);

        $this->notificationService->send($user, 'system', [
            'title' => 'Warning Received',
            'body' => "You have received a warning: {$reason}",
        ]);

        return $warning;
    }

    // ─── Admin Management ───────────────────────────────────────────

    /**
     * List admin users.
     */
    public function listAdmins(int $perPage = 20)
    {
        return User::whereIn('role', ['admin', 'super_admin'])
            ->with('profile')
            ->orderByDesc('created_at')
            ->paginate($perPage);
    }

    /**
     * Create an admin account.
     */
    public function createAdmin(array $data): User
    {
        return User::create([
            'name' => $data['name'],
            'username' => $data['username'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'role' => $data['role'] ?? 'admin',
            'status' => 'active',
        ]);
    }

    /**
     * Update admin permissions/role.
     */
    public function updateAdmin(int $adminId, array $data): User
    {
        $admin = User::whereIn('role', ['admin', 'super_admin'])->findOrFail($adminId);

        $updateData = [];
        if (isset($data['role'])) {
            $updateData['role'] = $data['role'];
        }
        if (isset($data['name'])) {
            $updateData['name'] = $data['name'];
        }
        if (isset($data['email'])) {
            $updateData['email'] = $data['email'];
        }

        $admin->update($updateData);

        return $admin->fresh();
    }

    /**
     * Remove admin (demote to regular user).
     */
    public function removeAdmin(User $superAdmin, int $adminId): User
    {
        $admin = User::whereIn('role', ['admin', 'super_admin'])->findOrFail($adminId);

        $this->preventSelfAction($superAdmin, $admin);

        $admin->update(['role' => 'user']);

        Log::info('Admin removed', [
            'admin_id' => $adminId,
            'by' => $superAdmin->id,
        ]);

        return $admin->fresh();
    }

    // ─── Content Moderation ─────────────────────────────────────────

    /**
     * List all reports.
     */
    public function listReports(array $filters = [], int $perPage = 20)
    {
        $query = Report::with(['reporter', 'resolvedBy'])
            ->orderByDesc('created_at');

        if (!empty($filters['status'])) {
            $query->where('status', $filters['status']);
        }

        if (!empty($filters['type'])) {
            $query->where('type', $filters['type']);
        }

        return $query->paginate($perPage);
    }

    /**
     * Get report detail.
     */
    public function getReportDetail(int $reportId): Report
    {
        return Report::with(['reporter', 'resolvedBy'])->findOrFail($reportId);
    }

    /**
     * Resolve a report.
     */
    public function resolveReport(User $admin, int $reportId, string $status, ?string $adminNotes = null): Report
    {
        $report = Report::findOrFail($reportId);

        if (!in_array($status, ['resolved', 'dismissed'])) {
            throw new \InvalidArgumentException('Status must be resolved or dismissed.');
        }

        $report->update([
            'status' => $status,
            'admin_notes' => $adminNotes,
            'resolved_by' => $admin->id,
            'resolved_at' => now(),
        ]);

        // Notify the reporter
        $this->notificationService->send(
            User::find($report->reporter_id),
            'system',
            [
                'title' => 'Report Update',
                'body' => "Your report has been {$status}.",
                'report_id' => $report->id,
            ]
        );

        return $report->fresh(['reporter', 'resolvedBy']);
    }

    // ─── Platform Settings ──────────────────────────────────────────

    /**
     * Get all platform settings grouped.
     */
    public function getSettings(): array
    {
        $settings = PlatformSetting::all();

        $grouped = [];
        foreach ($settings as $setting) {
            $grouped[$setting->group][$setting->key] = [
                'value' => PlatformSetting::getValue($setting->key),
                'type' => $setting->type,
                'description' => $setting->description,
            ];
        }

        return $grouped;
    }

    /**
     * Update platform settings.
     */
    public function updateSettings(array $settings): array
    {
        foreach ($settings as $key => $data) {
            PlatformSetting::setValue(
                $key,
                $data['value'],
                $data['type'] ?? 'string',
                $data['group'] ?? 'general',
                $data['description'] ?? null,
            );
        }

        return $this->getSettings();
    }

    // ─── Gift Management ────────────────────────────────────────────

    /**
     * List all gifts for admin.
     */
    public function listGifts(int $perPage = 20)
    {
        return Gift::with('category')
            ->orderByDesc('created_at')
            ->paginate($perPage);
    }

    /**
     * Create a gift.
     */
    public function createGift(array $data): Gift
    {
        return Gift::create($data);
    }

    /**
     * Update a gift.
     */
    public function updateGift(int $giftId, array $data): Gift
    {
        $gift = Gift::findOrFail($giftId);
        $gift->update($data);
        return $gift->fresh();
    }

    /**
     * Delete a gift.
     */
    public function deleteGift(int $giftId): void
    {
        $gift = Gift::findOrFail($giftId);
        $gift->delete();
    }

    // ─── Helpers ────────────────────────────────────────────────────

    private function preventSelfAction(User $admin, User $target): void
    {
        if ($admin->id === $target->id) {
            throw new \InvalidArgumentException('You cannot perform this action on yourself.');
        }
    }

    private function preventActionOnSuperAdmin(User $target): void
    {
        if ($target->role === 'super_admin') {
            throw new \InvalidArgumentException('Cannot perform this action on a Super Admin.');
        }
    }
}
