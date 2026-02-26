<?php

namespace Database\Seeders;

use App\Models\Language;
use Illuminate\Database\Seeder;

class LanguageSeeder extends Seeder
{
    public function run(): void
    {
        $languages = [
            ['code' => 'en', 'name' => 'English', 'native_name' => 'English', 'flag_emoji' => '🇬🇧'],
            ['code' => 'es', 'name' => 'Spanish', 'native_name' => 'Español', 'flag_emoji' => '🇪🇸'],
            ['code' => 'fr', 'name' => 'French', 'native_name' => 'Français', 'flag_emoji' => '🇫🇷'],
            ['code' => 'de', 'name' => 'German', 'native_name' => 'Deutsch', 'flag_emoji' => '🇩🇪'],
            ['code' => 'it', 'name' => 'Italian', 'native_name' => 'Italiano', 'flag_emoji' => '🇮🇹'],
            ['code' => 'pt', 'name' => 'Portuguese', 'native_name' => 'Português', 'flag_emoji' => '🇵🇹'],
            ['code' => 'ru', 'name' => 'Russian', 'native_name' => 'Русский', 'flag_emoji' => '🇷🇺'],
            ['code' => 'ja', 'name' => 'Japanese', 'native_name' => '日本語', 'flag_emoji' => '🇯🇵'],
            ['code' => 'ko', 'name' => 'Korean', 'native_name' => '한국어', 'flag_emoji' => '🇰🇷'],
            ['code' => 'zh', 'name' => 'Chinese', 'native_name' => '中文', 'flag_emoji' => '🇨🇳'],
            ['code' => 'ar', 'name' => 'Arabic', 'native_name' => 'العربية', 'flag_emoji' => '🇸🇦'],
            ['code' => 'hi', 'name' => 'Hindi', 'native_name' => 'हिन्दी', 'flag_emoji' => '🇮🇳'],
            ['code' => 'bn', 'name' => 'Bengali', 'native_name' => 'বাংলা', 'flag_emoji' => '🇧🇩'],
            ['code' => 'tr', 'name' => 'Turkish', 'native_name' => 'Türkçe', 'flag_emoji' => '🇹🇷'],
            ['code' => 'vi', 'name' => 'Vietnamese', 'native_name' => 'Tiếng Việt', 'flag_emoji' => '🇻🇳'],
            ['code' => 'th', 'name' => 'Thai', 'native_name' => 'ไทย', 'flag_emoji' => '🇹🇭'],
            ['code' => 'pl', 'name' => 'Polish', 'native_name' => 'Polski', 'flag_emoji' => '🇵🇱'],
            ['code' => 'nl', 'name' => 'Dutch', 'native_name' => 'Nederlands', 'flag_emoji' => '🇳🇱'],
            ['code' => 'sv', 'name' => 'Swedish', 'native_name' => 'Svenska', 'flag_emoji' => '🇸🇪'],
            ['code' => 'no', 'name' => 'Norwegian', 'native_name' => 'Norsk', 'flag_emoji' => '🇳🇴'],
            ['code' => 'da', 'name' => 'Danish', 'native_name' => 'Dansk', 'flag_emoji' => '🇩🇰'],
            ['code' => 'fi', 'name' => 'Finnish', 'native_name' => 'Suomi', 'flag_emoji' => '🇫🇮'],
            ['code' => 'el', 'name' => 'Greek', 'native_name' => 'Ελληνικά', 'flag_emoji' => '🇬🇷'],
            ['code' => 'cs', 'name' => 'Czech', 'native_name' => 'Čeština', 'flag_emoji' => '🇨🇿'],
            ['code' => 'hu', 'name' => 'Hungarian', 'native_name' => 'Magyar', 'flag_emoji' => '🇭🇺'],
            ['code' => 'ro', 'name' => 'Romanian', 'native_name' => 'Română', 'flag_emoji' => '🇷🇴'],
            ['code' => 'uk', 'name' => 'Ukrainian', 'native_name' => 'Українська', 'flag_emoji' => '🇺🇦'],
            ['code' => 'id', 'name' => 'Indonesian', 'native_name' => 'Bahasa Indonesia', 'flag_emoji' => '🇮🇩'],
            ['code' => 'ms', 'name' => 'Malay', 'native_name' => 'Bahasa Melayu', 'flag_emoji' => '🇲🇾'],
            ['code' => 'he', 'name' => 'Hebrew', 'native_name' => 'עברית', 'flag_emoji' => '🇮🇱'],
        ];

        foreach ($languages as $language) {
            Language::updateOrCreate(
                ['code' => $language['code']],
                $language
            );
        }

        $this->command->info('Languages seeded successfully!');
    }
}
