<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('matches', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('matched_user_id')->constrained('users')->onDelete('cascade');
            $table->decimal('score', 5, 2)->default(0); // 0.00 - 100.00
            $table->enum('status', ['pending', 'accepted', 'declined', 'expired'])->default('pending');
            $table->json('score_breakdown')->nullable(); // {"language": 35, "interests": 20, ...}
            $table->foreignId('conversation_id')->nullable()->constrained()->onDelete('set null');
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'matched_user_id']);
            $table->index(['user_id', 'status']);
            $table->index(['matched_user_id', 'status']);
            $table->index('score');
            $table->index('expires_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('matches');
    }
};
