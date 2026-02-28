import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/gifts_bloc.dart';
import '../bloc/gifts_event.dart';
import '../bloc/gifts_state.dart';
import '../models/gift.dart';
import '../widgets/gift_card.dart';
import '../widgets/wallet_display.dart';
import 'coin_store_view.dart';

class GiftShopView extends StatefulWidget {
  final int? recipientId;
  final String? recipientName;

  const GiftShopView({
    super.key,
    this.recipientId,
    this.recipientName,
  });

  @override
  State<GiftShopView> createState() => _GiftShopViewState();
}

class _GiftShopViewState extends State<GiftShopView> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    GiftCategory.popular,
    GiftCategory.cultural,
    GiftCategory.romantic,
    GiftCategory.fun,
    GiftCategory.premium,
  ];

  @override
  void initState() {
    super.initState();
    context.read<GiftsBloc>().add(LoadGifts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.recipientName != null
            ? Text('Send Gift to ${widget.recipientName}')
            : const Text('Gift Shop'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Show transaction history
            },
          ),
        ],
      ),
      body: BlocConsumer<GiftsBloc, GiftsState>(
        listener: (context, state) {
          if (state is GiftSent) {
            _showGiftAnimation(state.gift, state.recipientName);
          } else if (state is GiftsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is GiftsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GiftsLoaded) {
            return _buildGiftShopContent(state);
          }

          if (state is PurchaseSuccess) {
            // Reload gifts after purchase
            context.read<GiftsBloc>().add(LoadGifts());
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildGiftShopContent(GiftsLoaded state) {
    final filteredGifts = _selectedCategory == 'All'
        ? state.gifts
        : state.gifts.where((g) => g.category == _selectedCategory).toList();

    return Column(
      children: [
        // Wallet Section
        Padding(
          padding: const EdgeInsets.all(16),
          child: WalletDisplay(
            wallet: state.wallet,
            onAddCoins: () => _openCoinStore(),
          ),
        ),

        // Category Filter
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == _selectedCategory;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory = selected ? category : 'All';
                    });
                    if (selected && category != 'All') {
                      context.read<GiftsBloc>().add(FilterGiftsByCategory(category));
                    }
                  },
                  selectedColor: Theme.of(context).primaryColor,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 8),

        // Gift Grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: filteredGifts.length,
            itemBuilder: (context, index) {
              final gift = filteredGifts[index];
              final canAfford = state.wallet.balance >= gift.coinCost;

              return GiftCard(
                gift: gift,
                canAfford: canAfford,
                onTap: () => _showGiftConfirmation(gift),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showGiftConfirmation(Gift gift) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              gift.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              gift.description,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  gift.iconAsset,
                  style: const TextStyle(fontSize: 72),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '${gift.coinCost} Coins',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (widget.recipientId != null) {
                        context.read<GiftsBloc>().add(
                          SendGift(gift.id, widget.recipientId!),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Send Gift'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showGiftAnimation(Gift gift, String recipientName) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => GiftAnimationOverlay(
        gift: gift,
        recipientName: recipientName,
        onComplete: () {
          Navigator.pop(context);
          if (widget.recipientId != null) {
            Navigator.pop(context); // Close gift shop if opened for specific user
          }
        },
      ),
    );
  }

  void _openCoinStore() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CoinStoreView(),
      ),
    );
  }
}
