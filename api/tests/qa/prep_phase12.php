<?php

use App\Models\User;
use App\Models\Profile;
use App\Models\Language;
use App\Models\MatchingPreference;
use App\Services\MatchingService;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\DB;

require __DIR__.'/../../vendor/autoload.php';
$app = require_once __DIR__.'/../../bootstrap/app.php';

$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

$matchingService = $app->make(MatchingService::class);

$users = [
    'qa@example.com' => ['name' => 'qa', 'country' => 'USA', 'native' => 'en', 'learning' => 'es', 'interests' => ['Tech', 'Travel']],
    'qa2@example.com' => ['name' => 'qa2', 'country' => 'Spain', 'native' => 'es', 'learning' => 'en', 'interests' => ['Tech', 'Cooking']],
];

echo "Setting up test users and profiles for Phase 12...\n";

$userIds = [];
foreach ($users as $email => $data) {
    $user = User::where('email', $email)->first();
    if (!$user) {
        $user = User::create([
            'name' => $data['name'],
            'email' => $email,
            'username' => $data['name'] . 'user',
            'password' => Hash::make('password'),
            'status' => 'active',
        ]);
    }

    $token = $user->createToken('test-token')->plainTextToken;
    echo "TOKEN_{$data['name']}=$token\n";
    echo "ID_{$data['name']}={$user->id}\n";
    $userIds[$data['name']] = $user->id;

    // Profile
    Profile::updateOrCreate(['user_id' => $user->id], [
        'country' => $data['country'],
        'interests' => $data['interests'],
        'bio' => 'QA profile for phase 12',
    ]);

    // Languages
    $nativeLang = Language::where('code', $data['native'])->first();
    $learningLang = Language::where('code', $data['learning'])->first();

    App\Models\UserLanguage::updateOrCreate(
        ['user_id' => $user->id, 'type' => 'native'],
        ['language_id' => $nativeLang->id, 'proficiency' => 5]
    );

    App\Models\UserLanguage::updateOrCreate(
        ['user_id' => $user->id, 'type' => 'learning'],
        ['language_id' => $learningLang->id, 'proficiency' => 1]
    );

    // Preferences
    MatchingPreference::updateOrCreate(['user_id' => $user->id], [
        'is_active' => true,
        'age_min' => 18,
        'age_max' => 99,
    ]);
}

// Generate suggestions for QA user
$userA = User::find($userIds['qa']);
$suggestions = $matchingService->generateSuggestions($userA);
$stored = $matchingService->storeSuggestions($userA, $suggestions);

echo "Stored $stored suggestions for qauser.\n";
echo "Phase 12 environment prepared.\n";
