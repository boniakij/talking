import 'package:equatable/equatable.dart';
import '../models/gift.dart';
import '../models/wallet.dart';
import '../models/coin_package.dart';

abstract class GiftsState extends Equatable {
  const GiftsState();

  @override
  List<Object?> get props => [];
}

class GiftsInitial extends GiftsState {}

class GiftsLoading extends GiftsState {}

class GiftsLoaded extends GiftsState {
  final List<Gift> gifts;
  final Wallet wallet;

  const GiftsLoaded(this.gifts, this.wallet);

  @override
  List<Object?> get props => [gifts, wallet];
}

class CoinStoreLoaded extends GiftsState {
  final List<CoinPackage> packages;
  final Wallet wallet;

  const CoinStoreLoaded(this.packages, this.wallet);

  @override
  List<Object?> get props => [packages, wallet];
}

class PurchaseInProgress extends GiftsState {
  final String itemName;

  const PurchaseInProgress(this.itemName);

  @override
  List<Object?> get props => [itemName];
}

class PurchaseSuccess extends GiftsState {
  final String itemName;
  final int newBalance;

  const PurchaseSuccess(this.itemName, this.newBalance);

  @override
  List<Object?> get props => [itemName, newBalance];
}

class GiftSent extends GiftsState {
  final Gift gift;
  final String recipientName;

  const GiftSent(this.gift, this.recipientName);

  @override
  List<Object?> get props => [gift, recipientName];
}

class GiftsError extends GiftsState {
  final String message;

  const GiftsError(this.message);

  @override
  List<Object?> get props => [message];
}
