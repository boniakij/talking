<?php

use App\Models\User;
use Illuminate\Support\Facades\Hash;

require __DIR__.'/../../vendor/autoload.php';
$app = require_once __DIR__.'/../../bootstrap/app.php';

$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$users = [
    'qa@example.com' => 'qa',
    'qa2@example.com' => 'qa2',
    'qa3@example.com' => 'qa3',
];

echo "Setting up test users and tokens for Phase 8...\n";

foreach ($users as $email => $name) {
    $user = User::where('email', $email)->first();
    if (!$user) {
        $user = User::create([
            'name' => $name,
            'email' => $email,
            'username' => $name . 'user',
            'password' => Hash::make('password'),
        ]);
        echo "Created user: $email\n";
    } else {
        $user->update(['password' => Hash::make('password')]);
        echo "Reset password for: $email\n";
    }

    $token = $user->createToken('test-token')->plainTextToken;
    echo "TOKEN_$name=$token\n";
    echo "ID_$name={$user->id}\n";
}
