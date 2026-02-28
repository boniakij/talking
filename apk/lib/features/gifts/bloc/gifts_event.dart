import 'package:equatable/equatable.dart';

abstract class GiftsEvent extends Equatable {
  const GiftsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGifts extends GiftsEvent {}

class LoadCoinStore extends GiftsEvent {}

class LoadWallet extends GiftsEvent {}

class PurchaseCoins extends GiftsEvent {
  final String packageId;

  const PurchaseCoins(this.packageId);

  @override
  List<Object?> get props => [packageId];
}

class SendGift extends GiftsEvent {
  final String giftId;
  final int recipientId;
  final String? message;

  const SendGift(this.giftId, this.recipientId, {this.message});

  @override
  List<Object?> get props => [giftId, recipientId, message];
}

class SelectGift extends GiftsEvent {
  final String giftId;

  const SelectGift(this.giftId);

  @override
  List<Object?> get props => [giftId];
}

class FilterGiftsByCategory extends GiftsEvent {
  final String category;

  const FilterGiftsByCategory(this.category);

  @override
  List<Object?> get props => [category];
}
