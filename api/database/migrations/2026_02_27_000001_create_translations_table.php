<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('translations', function (Blueprint $table) {
            $table->id();
            $table->enum('source_type', ['message', 'post', 'text']);
            $table->unsignedBigInteger('source_id')->nullable();
            $table->string('source_hash', 64)->nullable(); // SHA-256 hash for arbitrary text
            $table->string('source_language', 10);
            $table->string('target_language', 10);
            $table->text('source_text');
            $table->text('translated_text');
            $table->decimal('quality_score', 3, 2)->nullable(); // 0.00 - 5.00
            $table->unsignedInteger('rating_count')->default(0);
            $table->unsignedInteger('usage_count')->default(1);
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();

            // Cache lookup indexes
            $table->index(['source_type', 'source_id', 'target_language'], 'idx_translation_source_target');
            $table->index(['source_hash', 'target_language'], 'idx_translation_hash_target');
            $table->index('expires_at');
            $table->index('source_language');
            $table->index('target_language');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('translations');
    }
};
