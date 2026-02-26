<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->uuid('uuid')->unique()->after('id');
            $table->string('username', 50)->unique()->after('uuid');
            $table->string('provider', 20)->default('email')->after('password');
            $table->string('provider_id')->nullable()->after('provider');
            $table->enum('role', ['user', 'admin', 'super_admin'])->default('user')->after('provider_id');
            $table->enum('status', ['active', 'suspended', 'banned'])->default('active')->after('role');
            $table->timestamp('last_seen_at')->nullable()->after('remember_token');
            
            $table->index('uuid');
            $table->index('username');
            $table->index(['provider', 'provider_id']);
            $table->index('role');
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex(['uuid']);
            $table->dropIndex(['username']);
            $table->dropIndex(['provider', 'provider_id']);
            $table->dropIndex(['role']);
            $table->dropIndex(['status']);
            
            $table->dropColumn([
                'uuid',
                'username',
                'provider',
                'provider_id',
                'role',
                'status',
                'last_seen_at'
            ]);
        });
    }
};
