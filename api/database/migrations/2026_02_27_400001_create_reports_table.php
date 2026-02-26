<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('reporter_id')->constrained('users')->onDelete('cascade');
            $table->string('reportable_type'); // App\Models\User, App\Models\Post, App\Models\Message, etc.
            $table->unsignedBigInteger('reportable_id');
            $table->string('type', 50); // spam, harassment, hate_speech, nudity, scam, impersonation, other
            $table->text('description')->nullable();
            $table->json('evidence')->nullable(); // screenshot URLs, message IDs, etc.
            $table->string('status', 20)->default('pending'); // pending, reviewing, resolved, dismissed
            $table->text('admin_notes')->nullable();
            $table->foreignId('resolved_by')->nullable()->constrained('users')->onDelete('set null');
            $table->timestamp('resolved_at')->nullable();
            $table->timestamps();

            $table->index(['reportable_type', 'reportable_id']);
            $table->index(['reporter_id', 'created_at']);
            $table->index('status');
            $table->index('type');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reports');
    }
};
