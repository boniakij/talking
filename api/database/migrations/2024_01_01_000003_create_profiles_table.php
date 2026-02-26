<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained()->onDelete('cascade');
            $table->string('display_name', 100)->nullable();
            $table->string('avatar', 500)->nullable();
            $table->text('bio')->nullable();
            $table->string('country_code', 5)->nullable();
            $table->date('date_of_birth')->nullable();
            $table->enum('gender', ['male', 'female', 'other', 'prefer_not_to_say'])->nullable();
            $table->boolean('is_public')->default(true);
            $table->unsignedInteger('coin_balance')->default(0);
            $table->json('cultural_interests')->nullable();
            $table->enum('learning_goal', ['casual', 'study', 'cultural_exchange', 'friendship'])->default('casual');
            $table->timestamps();
            
            $table->index('country_code');
            $table->index('is_public');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('profiles');
    }
};
