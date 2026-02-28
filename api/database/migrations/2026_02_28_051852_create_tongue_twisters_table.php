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
        Schema::create('tongue_twisters', function (Blueprint $table) {
            $table->id();
            $table->string('text');
            $table->string('language');
            $table->enum('difficulty', ['Easy', 'Medium', 'Hard', 'Master']);
            $table->text('translation')->nullable();
            $table->json('phonemes')->nullable();
            $table->integer('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('tongue_twisters');
    }
};
