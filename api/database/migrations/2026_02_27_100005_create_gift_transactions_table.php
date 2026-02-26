<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('gift_transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('sender_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('receiver_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('gift_id')->constrained('gifts')->onDelete('cascade');
            $table->foreignId('coin_transaction_id')->constrained('coin_transactions')->onDelete('cascade');
            $table->string('message', 255)->nullable();
            $table->boolean('is_anonymous')->default(false);
            $table->timestamps();

            $table->index(['sender_id', 'created_at']);
            $table->index(['receiver_id', 'created_at']);
            $table->index('gift_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('gift_transactions');
    }
};
