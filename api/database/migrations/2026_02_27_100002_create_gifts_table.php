<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('gifts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('gift_category_id')->constrained('gift_categories')->onDelete('cascade');
            $table->string('name', 100);
            $table->string('slug', 100)->unique();
            $table->text('description')->nullable();
            $table->unsignedInteger('price_coins');
            $table->string('icon_url')->nullable();
            $table->string('animation_url')->nullable();
            $table->enum('rarity', ['common', 'rare', 'epic', 'legendary'])->default('common');
            $table->unsignedSmallInteger('display_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index('gift_category_id');
            $table->index('rarity');
            $table->index('is_active');
            $table->index('price_coins');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('gifts');
    }
};
