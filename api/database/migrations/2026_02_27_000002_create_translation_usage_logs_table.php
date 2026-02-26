<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('translation_usage_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('translation_id')->constrained()->onDelete('cascade');
            $table->enum('source_type', ['message', 'post', 'text']);
            $table->unsignedTinyInteger('rating')->nullable(); // 1-5
            $table->text('feedback')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'created_at']);
            $table->index(['translation_id', 'rating']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('translation_usage_logs');
    }
};
