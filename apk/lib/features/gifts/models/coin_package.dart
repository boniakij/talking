import 'package:equatable/equatable.dart';

class CoinPackage extends Equatable {
  final String id;
  final String name;
  final int coinAmount;
  final double price;
  final String currency;
  final String? bonusDescription;
  final bool isPopular;
  final String storeProductId;

  const CoinPackage({
    required this.id,
    required this.name,
    required this.coinAmount,
    required this.price,
    this.currency = 'USD',
    this.bonusDescription,
    this.isPopular = false,
    required this.storeProductId,
  });

  factory CoinPackage.fromJson(Map<String, dynamic> json) {
    return CoinPackage(
      id: json['id'],
      name: json['name'],
      coinAmount: json['coin_amount'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] ?? 'USD',
      bonusDescription: json['bonus_description'],
      isPopular: json['is_popular'] ?? false,
      storeProductId: json['store_product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'coin_amount': coinAmount,
      'price': price,
      'currency': currency,
      'bonus_description': bonusDescription,
      'is_popular': isPopular,
      'store_product_id': storeProductId,
    };
  }

  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  @override
  List<Object?> get props => [
        id,
        name,
        coinAmount,
        price,
        currency,
        bonusDescription,
        isPopular,
        storeProductId,
      ];
}
