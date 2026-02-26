<?php

namespace App\Http\Controllers\Api;

use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class UserController extends BaseController
{
    /**
     * Get authenticated user
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user()->load(['profile', 'languages.language']);
        
        // Update last seen
        $user->update(['last_seen_at' => now()]);

        return $this->successResponse(new UserResource($user));
    }

    /**
     * Update authenticated user
     */
    public function update(Request $request): JsonResponse
    {
        $user = $request->user();

        $validated = $request->validate([
            'username' => ['sometimes', 'string', 'min:3', 'max:50', 'alpha_dash', Rule::unique('users')->ignore($user->id)],
            'email' => ['sometimes', 'email', 'max:255', Rule::unique('users')->ignore($user->id)],
        ]);

        // If email changed, mark as unverified
        if (isset($validated['email']) && $validated['email'] !== $user->email) {
            $validated['email_verified_at'] = null;
            $user->sendEmailVerificationNotification();
        }

        $user->update($validated);
        $user->load(['profile', 'languages.language']);

        return $this->successResponse(
            new UserResource($user),
            'User updated successfully'
        );
    }

    /**
     * Get user by ID
     */
    public function show(Request $request, $id): JsonResponse
    {
        $user = User::with(['profile', 'languages.language'])->findOrFail($id);

        // Check if blocked
        // TODO: Implement block check when block system is ready

        return $this->successResponse(new UserResource($user));
    }

    /**
     * Search users
     */
    public function search(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'q' => ['required', 'string', 'min:2'],
            'per_page' => ['sometimes', 'integer', 'min:1', 'max:50'],
        ]);

        $query = User::with(['profile', 'languages.language'])
            ->where('status', 'active')
            ->where('id', '!=', $request->user()->id)
            ->where(function ($q) use ($validated) {
                $q->where('username', 'like', "%{$validated['q']}%")
                  ->orWhereHas('profile', function ($q) use ($validated) {
                      $q->where('display_name', 'like', "%{$validated['q']}%");
                  });
            });

        $users = $query->paginate($validated['per_page'] ?? 20);

        return $this->paginatedResponse($users);
    }
}
