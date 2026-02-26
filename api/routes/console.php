<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// Phase 9: Generate match suggestions daily at 3am
Schedule::job(new \App\Jobs\GenerateMatchSuggestions)->daily()->at('03:00');
