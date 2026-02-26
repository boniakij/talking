<?php

namespace Database\Seeders;

use App\Models\Gift;
use App\Models\GiftCategory;
use Illuminate\Database\Seeder;

class GiftSeeder extends Seeder
{
    public function run(): void
    {
        $categories = [
            [
                'name' => 'Universal',
                'slug' => 'universal',
                'description' => 'Gifts loved by everyone around the world',
                'icon_url' => '/assets/gifts/categories/universal.png',
                'culture_tag' => 'universal',
                'display_order' => 1,
                'gifts' => [
                    ['name' => 'Heart', 'slug' => 'heart', 'price_coins' => 50, 'rarity' => 'common', 'icon_url' => '/assets/gifts/heart.png', 'animation_url' => '/assets/gifts/animations/heart.json', 'description' => 'A simple heart to show you care'],
                    ['name' => 'Star', 'slug' => 'star', 'price_coins' => 80, 'rarity' => 'common', 'icon_url' => '/assets/gifts/star.png', 'animation_url' => '/assets/gifts/animations/star.json', 'description' => 'You are a shining star!'],
                    ['name' => 'Fire', 'slug' => 'fire', 'price_coins' => 100, 'rarity' => 'common', 'icon_url' => '/assets/gifts/fire.png', 'animation_url' => '/assets/gifts/animations/fire.json', 'description' => 'Hot hot hot!'],
                    ['name' => 'Diamond', 'slug' => 'diamond', 'price_coins' => 500, 'rarity' => 'epic', 'icon_url' => '/assets/gifts/diamond.png', 'animation_url' => '/assets/gifts/animations/diamond.json', 'description' => 'A rare and precious diamond'],
                    ['name' => 'Crown', 'slug' => 'crown', 'price_coins' => 1000, 'rarity' => 'legendary', 'icon_url' => '/assets/gifts/crown.png', 'animation_url' => '/assets/gifts/animations/crown.json', 'description' => 'You deserve the crown!'],
                    ['name' => 'Rainbow', 'slug' => 'rainbow', 'price_coins' => 200, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/rainbow.png', 'animation_url' => '/assets/gifts/animations/rainbow.json', 'description' => 'A burst of colors for you'],
                ],
            ],
            [
                'name' => 'Asian',
                'slug' => 'asian',
                'description' => 'Beautiful gifts inspired by Asian cultures',
                'icon_url' => '/assets/gifts/categories/asian.png',
                'culture_tag' => 'asian',
                'display_order' => 2,
                'gifts' => [
                    ['name' => 'Sakura', 'slug' => 'sakura', 'price_coins' => 150, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/sakura.png', 'animation_url' => '/assets/gifts/animations/sakura.json', 'description' => 'Beautiful cherry blossoms'],
                    ['name' => 'Lucky Cat', 'slug' => 'lucky-cat', 'price_coins' => 200, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/lucky-cat.png', 'animation_url' => '/assets/gifts/animations/lucky-cat.json', 'description' => 'Maneki-neko brings good fortune!'],
                    ['name' => 'Dragon', 'slug' => 'dragon', 'price_coins' => 800, 'rarity' => 'epic', 'icon_url' => '/assets/gifts/dragon.png', 'animation_url' => '/assets/gifts/animations/dragon.json', 'description' => 'A mighty golden dragon'],
                    ['name' => 'Red Envelope', 'slug' => 'red-envelope', 'price_coins' => 300, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/red-envelope.png', 'animation_url' => '/assets/gifts/animations/red-envelope.json', 'description' => 'Prosperity and good luck!'],
                    ['name' => 'Lantern', 'slug' => 'lantern', 'price_coins' => 120, 'rarity' => 'common', 'icon_url' => '/assets/gifts/lantern.png', 'animation_url' => '/assets/gifts/animations/lantern.json', 'description' => 'A glowing lantern of hope'],
                ],
            ],
            [
                'name' => 'Middle Eastern',
                'slug' => 'middle-eastern',
                'description' => 'Magical gifts from the Middle East',
                'icon_url' => '/assets/gifts/categories/middle-eastern.png',
                'culture_tag' => 'middle_eastern',
                'display_order' => 3,
                'gifts' => [
                    ['name' => 'Crescent Moon', 'slug' => 'crescent-moon', 'price_coins' => 180, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/crescent-moon.png', 'animation_url' => '/assets/gifts/animations/crescent-moon.json', 'description' => 'A beautiful crescent moon'],
                    ['name' => 'Magic Lamp', 'slug' => 'magic-lamp', 'price_coins' => 600, 'rarity' => 'epic', 'icon_url' => '/assets/gifts/magic-lamp.png', 'animation_url' => '/assets/gifts/animations/magic-lamp.json', 'description' => 'Your wish is my command!'],
                    ['name' => 'Flying Carpet', 'slug' => 'flying-carpet', 'price_coins' => 900, 'rarity' => 'legendary', 'icon_url' => '/assets/gifts/flying-carpet.png', 'animation_url' => '/assets/gifts/animations/flying-carpet.json', 'description' => 'A whole new world!'],
                    ['name' => 'Palm Tree', 'slug' => 'palm-tree', 'price_coins' => 100, 'rarity' => 'common', 'icon_url' => '/assets/gifts/palm-tree.png', 'animation_url' => '/assets/gifts/animations/palm-tree.json', 'description' => 'An oasis of calm'],
                    ['name' => 'Arabian Coffee', 'slug' => 'arabian-coffee', 'price_coins' => 80, 'rarity' => 'common', 'icon_url' => '/assets/gifts/arabian-coffee.png', 'animation_url' => '/assets/gifts/animations/arabian-coffee.json', 'description' => 'Traditional hospitality'],
                ],
            ],
            [
                'name' => 'Western',
                'slug' => 'western',
                'description' => 'Classic Western-inspired gifts',
                'icon_url' => '/assets/gifts/categories/western.png',
                'culture_tag' => 'western',
                'display_order' => 4,
                'gifts' => [
                    ['name' => 'Trophy', 'slug' => 'trophy', 'price_coins' => 250, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/trophy.png', 'animation_url' => '/assets/gifts/animations/trophy.json', 'description' => 'You are a champion!'],
                    ['name' => 'Champagne', 'slug' => 'champagne', 'price_coins' => 400, 'rarity' => 'epic', 'icon_url' => '/assets/gifts/champagne.png', 'animation_url' => '/assets/gifts/animations/champagne.json', 'description' => 'Time to celebrate!'],
                    ['name' => 'Rose', 'slug' => 'rose', 'price_coins' => 100, 'rarity' => 'common', 'icon_url' => '/assets/gifts/rose.png', 'animation_url' => '/assets/gifts/animations/rose.json', 'description' => 'A classic red rose'],
                    ['name' => 'Castle', 'slug' => 'castle', 'price_coins' => 1500, 'rarity' => 'legendary', 'icon_url' => '/assets/gifts/castle.png', 'animation_url' => '/assets/gifts/animations/castle.json', 'description' => 'A grand royal castle'],
                    ['name' => 'Sports Car', 'slug' => 'sports-car', 'price_coins' => 2000, 'rarity' => 'legendary', 'icon_url' => '/assets/gifts/sports-car.png', 'animation_url' => '/assets/gifts/animations/sports-car.json', 'description' => 'Vroom vroom!'],
                ],
            ],
            [
                'name' => 'African',
                'slug' => 'african',
                'description' => 'Vibrant gifts celebrating African culture',
                'icon_url' => '/assets/gifts/categories/african.png',
                'culture_tag' => 'african',
                'display_order' => 5,
                'gifts' => [
                    ['name' => 'Baobab Tree', 'slug' => 'baobab-tree', 'price_coins' => 200, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/baobab-tree.png', 'animation_url' => '/assets/gifts/animations/baobab-tree.json', 'description' => 'The tree of life!'],
                    ['name' => 'Drum', 'slug' => 'drum', 'price_coins' => 150, 'rarity' => 'common', 'icon_url' => '/assets/gifts/drum.png', 'animation_url' => '/assets/gifts/animations/drum.json', 'description' => 'Feel the rhythm!'],
                    ['name' => 'Tribal Mask', 'slug' => 'tribal-mask', 'price_coins' => 350, 'rarity' => 'epic', 'icon_url' => '/assets/gifts/tribal-mask.png', 'animation_url' => '/assets/gifts/animations/tribal-mask.json', 'description' => 'Ancient wisdom and power'],
                    ['name' => 'Sunset', 'slug' => 'sunset', 'price_coins' => 120, 'rarity' => 'common', 'icon_url' => '/assets/gifts/sunset.png', 'animation_url' => '/assets/gifts/animations/sunset.json', 'description' => 'A beautiful African sunset'],
                ],
            ],
            [
                'name' => 'Latin',
                'slug' => 'latin',
                'description' => 'Festive gifts from Latin America',
                'icon_url' => '/assets/gifts/categories/latin.png',
                'culture_tag' => 'latin',
                'display_order' => 6,
                'gifts' => [
                    ['name' => 'Piñata', 'slug' => 'pinata', 'price_coins' => 180, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/pinata.png', 'animation_url' => '/assets/gifts/animations/pinata.json', 'description' => 'Fiesta time!'],
                    ['name' => 'Cactus', 'slug' => 'cactus', 'price_coins' => 80, 'rarity' => 'common', 'icon_url' => '/assets/gifts/cactus.png', 'animation_url' => '/assets/gifts/animations/cactus.json', 'description' => 'A tough little survivor'],
                    ['name' => 'Fiesta Guitar', 'slug' => 'fiesta-guitar', 'price_coins' => 250, 'rarity' => 'rare', 'icon_url' => '/assets/gifts/fiesta-guitar.png', 'animation_url' => '/assets/gifts/animations/fiesta-guitar.json', 'description' => 'Play me a song!'],
                    ['name' => 'Taco', 'slug' => 'taco', 'price_coins' => 60, 'rarity' => 'common', 'icon_url' => '/assets/gifts/taco.png', 'animation_url' => '/assets/gifts/animations/taco.json', 'description' => 'Delicioso!'],
                    ['name' => 'Sombrero', 'slug' => 'sombrero', 'price_coins' => 300, 'rarity' => 'epic', 'icon_url' => '/assets/gifts/sombrero.png', 'animation_url' => '/assets/gifts/animations/sombrero.json', 'description' => 'The ultimate party hat'],
                ],
            ],
        ];

        foreach ($categories as $categoryData) {
            $gifts = $categoryData['gifts'];
            unset($categoryData['gifts']);

            $category = GiftCategory::create($categoryData);

            foreach ($gifts as $index => $giftData) {
                $giftData['gift_category_id'] = $category->id;
                $giftData['display_order'] = $index + 1;
                Gift::create($giftData);
            }
        }

        $this->command->info('Seeded ' . Gift::count() . ' gifts across ' . GiftCategory::count() . ' categories.');
    }
}
