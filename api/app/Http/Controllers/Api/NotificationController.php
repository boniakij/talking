<?php

namespace App\Http\Controllers\Api;

use App\Http\Requests\RegisterDeviceTokenRequest;
use App\Http\Requests\UpdateNotificationSettingsRequest;
use App\Http\Resources\NotificationResource;
use App\Http\Resources\NotificationSettingResource;
use App\Services\NotificationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends BaseController
{
    public function __construct(
        private NotificationService $notificationService,
    ) {}

    /**
     * GET /notifications — Get all notifications (paginated).
     */
    public function index(Request $request): JsonResponse
    {
        $notifications = $this->notificationService->getNotifications(
            $request->user(),
            $request->input('type'),
            $request->input('per_page', 20),
        );

        $unreadCount = $this->notificationService->getUnreadCount($request->user());

        return $this->successResponse([
            'unread_count' => $unreadCount,
            'notifications' => NotificationResource::collection($notifications)->response()->getData(true),
        ], 'Notifications retrieved successfully.');
    }

    /**
     * POST /notifications/{id}/read — Mark as read.
     */
    public function markAsRead(Request $request, int $id): JsonResponse
    {
        try {
            $notification = $this->notificationService->markAsRead($request->user(), $id);

            return $this->successResponse(
                new NotificationResource($notification),
                'Notification marked as read.'
            );
        } catch (\Illuminate\Database\Eloquent\ModelNotFoundException $e) {
            return $this->errorResponse('Notification not found.', null, 404);
        }
    }

    /**
     * POST /notifications/read-all — Mark all as read.
     */
    public function markAllAsRead(Request $request): JsonResponse
    {
        $count = $this->notificationService->markAllAsRead($request->user());

        return $this->successResponse([
            'marked_count' => $count,
        ], "{$count} notifications marked as read.");
    }

    /**
     * POST /notifications/device-token — Register device for push.
     */
    public function registerDeviceToken(RegisterDeviceTokenRequest $request): JsonResponse
    {
        $deviceToken = $this->notificationService->registerDeviceToken(
            $request->user(),
            $request->input('token'),
            $request->input('platform', 'android'),
            $request->input('device_name'),
        );

        return $this->successResponse([
            'id' => $deviceToken->id,
            'platform' => $deviceToken->platform,
            'device_name' => $deviceToken->device_name,
        ], 'Device token registered successfully.');
    }

    /**
     * DELETE /notifications/device-token — Remove device token.
     */
    public function removeDeviceToken(Request $request): JsonResponse
    {
        $request->validate([
            'token' => 'required|string',
        ]);

        $removed = $this->notificationService->removeDeviceToken(
            $request->user(),
            $request->input('token'),
        );

        if (!$removed) {
            return $this->errorResponse('Device token not found.', null, 404);
        }

        return $this->successResponse(null, 'Device token removed successfully.');
    }

    /**
     * GET /notifications/settings — Get notification settings.
     */
    public function getSettings(Request $request): JsonResponse
    {
        $settings = $this->notificationService->getOrCreateSettings($request->user());

        return $this->successResponse(
            new NotificationSettingResource($settings),
            'Notification settings retrieved successfully.'
        );
    }

    /**
     * PUT /notifications/settings — Update notification settings.
     */
    public function updateSettings(UpdateNotificationSettingsRequest $request): JsonResponse
    {
        $settings = $this->notificationService->updateSettings(
            $request->user(),
            $request->validated(),
        );

        return $this->successResponse(
            new NotificationSettingResource($settings),
            'Notification settings updated successfully.'
        );
    }
}
