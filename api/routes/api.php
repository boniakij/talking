<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProfileController;
use App\Http\Controllers\Api\UserController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Version 1
|--------------------------------------------------------------------------
*/

Route::prefix('v1')->group(function () {
    
    // Public routes
    Route::prefix('auth')->group(function () {
        Route::post('register', [AuthController::class, 'register']);
        Route::post('login', [AuthController::class, 'login']);
        Route::post('forgot-password', [AuthController::class, 'forgotPassword']);
        Route::post('reset-password', [AuthController::class, 'resetPassword']);
        Route::get('verify-email/{id}/{hash}', [AuthController::class, 'verifyEmail'])
            ->name('verification.verify');
    });

    // Protected routes
    Route::middleware('auth:sanctum')->group(function () {
        
        // Auth routes
        Route::prefix('auth')->group(function () {
            Route::post('logout', [AuthController::class, 'logout']);
            Route::post('refresh', [AuthController::class, 'refresh']);
            Route::post('resend-verification', [AuthController::class, 'resendVerification']);
        });

        // User routes
        Route::prefix('users')->group(function () {
            Route::get('me', [UserController::class, 'me']);
            Route::put('me', [UserController::class, 'update']);
            Route::get('search', [UserController::class, 'search']);
            Route::get('{id}', [UserController::class, 'show']);
        });

        // Profile routes
        Route::prefix('profiles')->group(function () {
            Route::get('me', [ProfileController::class, 'me']);
            Route::put('me', [ProfileController::class, 'update']);
            Route::post('me/photo', [ProfileController::class, 'uploadPhoto']);
            Route::put('me/languages', [ProfileController::class, 'updateLanguages']);
            Route::get('{id}', [ProfileController::class, 'show']);
        });
    });
});
