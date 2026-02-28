<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('pronunciation_scores', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('tongue_twister_id')->constrained()->onDelete('cascade');
            $table->decimal('overall_score', 5, 2);
            $table->json('phoneme_scores')->nullable();
            $table->json('feedback')->nullable();
            $table->string('recording_path')->nullable();
            $table->timestamp('analyzed_at');
            $table->timestamps();
            
            $table->index(['user_id', 'tongue_twister_id']);
            $table->index('overall_score');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pronunciation_scores');
    }
};
