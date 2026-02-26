<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('gift_categories', function (Blueprint $table) {
            $table->id();
            $table->string('name', 100);
            $table->string('slug', 100)->unique();
            $table->text('description')->nullable();
            $table->string('icon_url')->nullable();
            $table->string('culture_tag', 50)->default('universal'); // universal, asian, western, etc.
            $table->unsignedSmallInteger('display_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index('culture_tag');
            $table->index('is_active');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('gift_categories');
    }
};
