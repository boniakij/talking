<?php

use App\Models\User;
use App\Models\Post;
use App\Models\Message;
use App\Models\Conversation;
use App\Models\Language;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

require __DIR__.'/../../vendor/autoload.php';
$app = require_once __DIR__.'/../../bootstrap/app.php';

$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$users = [
    'qa@example.com' => 'qa',
    'qa2@example.com' => 'qa2',
];

echo "Setting up test users and tokens for Phase 10...\n";

foreach ($users as $email => $name) {
    $user = User::where('email', $email)->first();
    if (!$user) {
        $user = User::create([
            'name' => $name,
            'email' => $email,
            'username' => $name . 'user',
            'password' => Hash::make('password'),
        ]);
    } else {
        $user->update(['password' => Hash::make('password')]);
    }

    $token = $user->createToken('test-token')->plainTextToken;
    echo "TOKEN_$name=$token\n";
}

// Ensure languages are active
Language::whereIn('code', ['en', 'es', 'fr', 'bn'])->update(['is_active' => true]);

echo "Creating initial data for translation testing...\n";
$qaUser = User::where('email', 'qa@example.com')->first();
$qa2User = User::where('email', 'qa2@example.com')->first();

// Create Post
$post = Post::create([
    'user_id' => $qa2User->id,
    'content' => 'This is a test post about AI and translation.',
    'likes_count' => 0,
    'comments_count' => 0,
]);
echo "ID_POST={$post->id}\n";

// Create Conversation and Message
$conversation = Conversation::create(['type' => 'direct']);
$conversation->participants()->attach([$qaUser->id, $qa2User->id]);

$message = Message::create([
    'conversation_id' => $conversation->id,
    'user_id' => $qa2User->id,
    'content' => 'Hello QA! How are you today?',
    'type' => 'text',
]);
echo "ID_MESSAGE={$message->id}\n";

echo "Phase 10 environment prepared.\n";
