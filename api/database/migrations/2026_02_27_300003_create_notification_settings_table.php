<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('notification_settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->unique()->constrained()->onDelete('cascade');
            $table->boolean('push_enabled')->default(true);
            $table->boolean('email_enabled')->default(true);
            $table->json('type_preferences')->nullable(); // {"message": true, "call": true, "gift": true, ...}
            $table->boolean('mute_all')->default(false);
            $table->time('quiet_hours_start')->nullable(); // e.g. 22:00
            $table->time('quiet_hours_end')->nullable(); // e.g. 07:00
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('notification_settings');
    }
};
