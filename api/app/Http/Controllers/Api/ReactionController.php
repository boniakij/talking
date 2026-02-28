<?php

namespace App\Http\Controllers\Api;

use App\Models\Message;
use App\Services\MessageService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;

class ReactionController extends BaseController
{
    public function __construct(
        private MessageService $messageService
    ) {}

    /**
     * Add a reaction to a message
     */
    public function store(Request $request, int $messageId): JsonResponse
    {
        $request->validate([
            'emoji' => 'required|string|max:10',
        ]);

        $message = Message::with('conversation')->findOrFail($messageId);

        try {
            $reaction = $this->messageService->addReaction(
                $message,
                $request->user(),
                $request->emoji
            );

            return $this->successResponse(
                $reaction,
                'Reaction added successfully',
                201
            );
        } catch (ValidationException $e) {
            return $this->errorResponse('Validation error', $e->errors(), 422);
        }
    }

    /**
     * Remove a reaction from a message
     */
    public function destroy(Request $request, int $messageId, string $emoji): JsonResponse
    {
        $message = Message::with('conversation')->findOrFail($messageId);

        $removed = $this->messageService->removeReaction(
            $message,
            $request->user(),
            $emoji
        );

        if ($removed) {
            return $this->successResponse(
                null,
                'Reaction removed successfully'
            );
        }

        return $this->errorResponse('Reaction not found', null, 404);
    }
}
