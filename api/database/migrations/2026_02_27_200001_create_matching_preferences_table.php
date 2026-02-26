<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('matching_preferences', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained()->onDelete('cascade');
            $table->string('preferred_gender', 20)->nullable(); // male, female, any
            $table->unsignedTinyInteger('age_min')->default(18);
            $table->unsignedTinyInteger('age_max')->default(99);
            $table->json('preferred_languages')->nullable(); // ["en", "es", "fr"]
            $table->json('preferred_countries')->nullable(); // ["US", "UK", "BD"]
            $table->json('preferred_interests')->nullable(); // ["music", "travel"]
            $table->unsignedInteger('max_distance_km')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('matching_preferences');
    }
};
