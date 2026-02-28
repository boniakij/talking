import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'gifts_event.dart';
import 'gifts_state.dart';
import '../services/gifts_service.dart';
import '../models/gift.dart';

class GiftsBloc extends Bloc<GiftsEvent, GiftsState> {
  final GiftsService _giftsService;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  GiftsBloc(this._giftsService) : super(GiftsInitial()) {
    on<LoadGifts>(_onLoadGifts);
    on<LoadCoinStore>(_onLoadCoinStore);
    on<LoadWallet>(_onLoadWallet);
    on<PurchaseCoins>(_onPurchaseCoins);
    on<SendGift>(_onSendGift);
    on<SelectGift>(_onSelectGift);
    on<FilterGiftsByCategory>(_onFilterGiftsByCategory);

    _initInAppPurchase();
  }

  void _initInAppPurchase() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    purchaseUpdated.listen(_handlePurchaseUpdates);
  }

  Future<void> _onLoadGifts(
    LoadGifts event,
    Emitter<GiftsState> emit,
  ) async {
    emit(GiftsLoading());
    try {
      final gifts = await _giftsService.getGifts();
      final wallet = await _giftsService.getWallet();
      emit(GiftsLoaded(gifts, wallet));
    } catch (e) {
      emit(GiftsError('Failed to load gifts: ${e.toString()}'));
    }
  }

  Future<void> _onLoadCoinStore(
    LoadCoinStore event,
    Emitter<GiftsState> emit,
  ) async {
    emit(GiftsLoading());
    try {
      final packages = await _giftsService.getCoinPackages();
      final wallet = await _giftsService.getWallet();
      emit(CoinStoreLoaded(packages, wallet));
    } catch (e) {
      emit(GiftsError('Failed to load coin store: ${e.toString()}'));
    }
  }

  Future<void> _onLoadWallet(
    LoadWallet event,
    Emitter<GiftsState> emit,
  ) async {
    try {
      final wallet = await _giftsService.getWallet();
      if (state is GiftsLoaded) {
        final currentState = state as GiftsLoaded;
        emit(GiftsLoaded(currentState.gifts, wallet));
      }
    } catch (e) {
      emit(GiftsError('Failed to load wallet: ${e.toString()}'));
    }
  }

  Future<void> _onPurchaseCoins(
    PurchaseCoins event,
    Emitter<GiftsState> emit,
  ) async {
    emit(PurchaseInProgress('Coin Package'));
    try {
      final packages = await _giftsService.getCoinPackages();
      final package = packages.firstWhere((p) => p.id == event.packageId);

      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        emit(GiftsError('Store not available'));
        return;
      }

      // Initiate purchase through store
      // This is a simplified version - real implementation would handle
      // purchase flow with store
      await _giftsService.purchaseCoins(event.packageId);

      final wallet = await _giftsService.getWallet();
      emit(PurchaseSuccess(package.name, wallet.balance));
    } catch (e) {
      emit(GiftsError('Purchase failed: ${e.toString()}'));
    }
  }

  Future<void> _onSendGift(
    SendGift event,
    Emitter<GiftsState> emit,
  ) async {
    emit(GiftsLoading());
    try {
      await _giftsService.sendGift(
        event.giftId,
        event.recipientId,
        message: event.message,
      );

      final gift = await _giftsService.getGiftById(event.giftId);
      final recipient = await _giftsService.getUserById(event.recipientId);

      emit(GiftSent(gift, recipient.username));
    } catch (e) {
      emit(GiftsError('Failed to send gift: ${e.toString()}'));
    }
  }

  void _onSelectGift(
    SelectGift event,
    Emitter<GiftsState> emit,
  ) {
    // Handle gift selection for UI updates
  }

  Future<void> _onFilterGiftsByCategory(
    FilterGiftsByCategory event,
    Emitter<GiftsState> emit,
  ) async {
    try {
      final gifts = await _giftsService.getGifts(category: event.category);
      final wallet = await _giftsService.getWallet();
      emit(GiftsLoaded(gifts, wallet));
    } catch (e) {
      emit(GiftsError('Failed to filter gifts: ${e.toString()}'));
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchases) {
    // Handle purchase updates from store
  }
}
