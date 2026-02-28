import 'package:equatable/equatable.dart';

class Gift extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final int coinCost;
  final bool isPremium;
  final String? animationAsset;
  final String? category;

  const Gift({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.coinCost,
    this.isPremium = false,
    this.animationAsset,
    this.category,
  });

  factory Gift.fromJson(Map<String, dynamic> json) {
    return Gift(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      iconAsset: json['icon_asset'],
      coinCost: json['coin_cost'],
      isPremium: json['is_premium'] ?? false,
      animationAsset: json['animation_asset'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon_asset': iconAsset,
      'coin_cost': coinCost,
      'is_premium': isPremium,
      'animation_asset': animationAsset,
      'category': category,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconAsset,
        coinCost,
        isPremium,
        animationAsset,
        category,
      ];
}

class GiftCategory {
  static const String popular = 'Popular';
  static const String cultural = 'Cultural';
  static const String romantic = 'Romantic';
  static const String fun = 'Fun';
  static const String premium = 'Premium';
}
