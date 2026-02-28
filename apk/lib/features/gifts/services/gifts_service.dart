import 'package:dio/dio.dart';
import '../models/gift.dart';
import '../models/wallet.dart';
import '../models/coin_package.dart';

class GiftsService {
  final Dio _dio;

  GiftsService(this._dio);

  Future<List<Gift>> getGifts({String? category}) async {
    try {
      final response = await _dio.get('/api/v1/gifts', queryParameters: {
        if (category != null) 'category': category,
      });
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Gift.fromJson(json)).toList();
    } catch (e) {
      // Return mock data for development
      return _getMockGifts();
    }
  }

  Future<Gift> getGiftById(String id) async {
    try {
      final response = await _dio.get('/api/v1/gifts/$id');
      return Gift.fromJson(response.data['data']);
    } catch (e) {
      return _getMockGifts().firstWhere((g) => g.id == id);
    }
  }

  Future<Wallet> getWallet() async {
    try {
      final response = await _dio.get('/api/v1/gifts/wallet');
      return Wallet.fromJson(response.data['data']);
    } catch (e) {
      // Return mock wallet for development
      return const Wallet(balance: 1250, lifetimeEarnings: 5000, lifetimeSpent: 3750);
    }
  }

  Future<List<CoinPackage>> getCoinPackages() async {
    try {
      final response = await _dio.get('/api/v1/gifts/coins/packages');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => CoinPackage.fromJson(json)).toList();
    } catch (e) {
      // Return mock packages for development
      return _getMockCoinPackages();
    }
  }

  Future<void> purchaseCoins(String packageId) async {
    try {
      await _dio.post('/api/v1/gifts/coins/purchase', data: {
        'package_id': packageId,
      });
    } catch (e) {
      // Mock success for development
      print('Mock: Purchased coin package $packageId');
    }
  }

  Future<void> sendGift(
    String giftId,
    int recipientId, {
    String? message,
  }) async {
    try {
      await _dio.post('/api/v1/gifts/send', data: {
        'gift_id': giftId,
        'recipient_id': recipientId,
        'message': message,
      });
    } catch (e) {
      // Mock success for development
      print('Mock: Sent gift $giftId to user $recipientId');
    }
  }

  Future<Map<String, dynamic>> getUserById(int id) async {
    try {
      final response = await _dio.get('/api/v1/users/$id');
      return response.data['data'];
    } catch (e) {
      return {'id': id, 'username': 'User $id'};
    }
  }

  List<Gift> _getMockGifts() {
    return [
      const Gift(
        id: 'sakura',
        name: 'Sakura',
        description: 'Beautiful cherry blossoms from Japan',
        iconAsset: '🌸',
        coinCost: 50,
        category: GiftCategory.cultural,
      ),
      const Gift(
        id: 'dragon',
        name: 'Dragon',
        description: 'Majestic dragon symbolizing strength',
        iconAsset: '🐉',
        coinCost: 200,
        isPremium: true,
        category: GiftCategory.cultural,
      ),
      const Gift(
        id: 'coffee',
        name: 'Coffee',
        description: 'Warm cup of coffee to brighten their day',
        iconAsset: '☕',
        coinCost: 25,
        category: GiftCategory.popular,
      ),
      const Gift(
        id: 'rose',
        name: 'Rose',
        description: 'Classic red rose for someone special',
        iconAsset: '🌹',
        coinCost: 100,
        category: GiftCategory.romantic,
      ),
      const Gift(
        id: 'pizza',
        name: 'Pizza',
        description: 'Share a virtual slice!',
        iconAsset: '🍕',
        coinCost: 30,
        category: GiftCategory.fun,
      ),
      const Gift(
        id: 'crown',
        name: 'Royal Crown',
        description: 'Premium crown for VIPs only',
        iconAsset: '👑',
        coinCost: 500,
        isPremium: true,
        category: GiftCategory.premium,
      ),
      const Gift(
        id: 'lantern',
        name: 'Chinese Lantern',
        description: 'Traditional red lantern',
        iconAsset: '🏮',
        coinCost: 75,
        category: GiftCategory.cultural,
      ),
      const Gift(
        id: 'heart',
        name: 'Heart',
        description: 'Show your love',
        iconAsset: '❤️',
        coinCost: 40,
        category: GiftCategory.romantic,
      ),
    ];
  }

  List<CoinPackage> _getMockCoinPackages() {
    return [
      const CoinPackage(
        id: 'coins_100',
        name: 'Handful',
        coinAmount: 100,
        price: 0.99,
        storeProductId: 'com.banitalk.coins.100',
      ),
      const CoinPackage(
        id: 'coins_500',
        name: 'Pouch',
        coinAmount: 500,
        price: 4.99,
        bonusDescription: '50 bonus coins!',
        storeProductId: 'com.banitalk.coins.500',
      ),
      const CoinPackage(
        id: 'coins_1200',
        name: 'Bag',
        coinAmount: 1200,
        price: 9.99,
        isPopular: true,
        bonusDescription: '200 bonus coins!',
        storeProductId: 'com.banitalk.coins.1200',
      ),
      const CoinPackage(
        id: 'coins_2500',
        name: 'Chest',
        coinAmount: 2500,
        price: 19.99,
        bonusDescription: '500 bonus coins!',
        storeProductId: 'com.banitalk.coins.2500',
      ),
      const CoinPackage(
        id: 'coins_6500',
        name: 'Treasure',
        coinAmount: 6500,
        price: 49.99,
        bonusDescription: '1500 bonus coins!',
        storeProductId: 'com.banitalk.coins.6500',
      ),
    ];
  }
}
