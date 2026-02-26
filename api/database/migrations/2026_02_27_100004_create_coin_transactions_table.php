<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('coin_transactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->enum('type', ['topup', 'spent', 'refund', 'bonus']);
            $table->integer('amount'); // positive for credit, negative for debit
            $table->unsignedBigInteger('balance_after');
            $table->string('description')->nullable();
            $table->string('reference_type', 50)->nullable(); // gift, system, etc.
            $table->unsignedBigInteger('reference_id')->nullable();
            $table->string('stripe_payment_id')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'created_at']);
            $table->index('type');
            $table->index('stripe_payment_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('coin_transactions');
    }
};
