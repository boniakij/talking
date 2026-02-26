<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'key' => env('POSTMARK_API_KEY'),
    ],

    'resend' => [
        'key' => env('RESEND_API_KEY'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    'google_translate' => [
        'api_key' => env('GOOGLE_TRANSLATE_API_KEY', ''),
        'base_url' => env('GOOGLE_TRANSLATE_BASE_URL', 'https://translation.googleapis.com/language/translate/v2'),
        'cache_ttl_hours' => env('TRANSLATION_CACHE_TTL_HOURS', 168), // 7 days
        'auto_translate_enabled' => env('AUTO_TRANSLATE_ENABLED', false),
    ],

    'stripe' => [
        'secret' => env('STRIPE_SECRET_KEY', ''),
        'webhook_secret' => env('STRIPE_WEBHOOK_SECRET', ''),
        'currency' => env('STRIPE_CURRENCY', 'usd'),
        'price_per_coin' => env('STRIPE_PRICE_PER_COIN', 0.01), // $0.01 per coin
    ],

];
