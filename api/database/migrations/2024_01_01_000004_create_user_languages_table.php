<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_languages', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->unsignedSmallInteger('language_id');
            $table->enum('type', ['native', 'learning']);
            $table->enum('proficiency', ['beginner', 'elementary', 'intermediate', 'advanced', 'fluent', 'native'])->nullable();
            $table->timestamps();
            
            $table->foreign('language_id')->references('id')->on('languages');
            $table->unique(['user_id', 'language_id', 'type']);
            $table->index(['user_id', 'type']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_languages');
    }
};
