import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final int balance;
  final int lifetimeEarnings;
  final int lifetimeSpent;
  final DateTime? lastPurchaseAt;

  const Wallet({
    required this.balance,
    this.lifetimeEarnings = 0,
    this.lifetimeSpent = 0,
    this.lastPurchaseAt,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      balance: json['balance'] ?? 0,
      lifetimeEarnings: json['lifetime_earnings'] ?? 0,
      lifetimeSpent: json['lifetime_spent'] ?? 0,
      lastPurchaseAt: json['last_purchase_at'] != null
          ? DateTime.parse(json['last_purchase_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'balance': balance,
      'lifetime_earnings': lifetimeEarnings,
      'lifetime_spent': lifetimeSpent,
      'last_purchase_at': lastPurchaseAt?.toIso8601String(),
    };
  }

  String get formattedBalance => balance.toString().replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (match) => ',',
      );

  @override
  List<Object?> get props => [balance, lifetimeEarnings, lifetimeSpent, lastPurchaseAt];
}
