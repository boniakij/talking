import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/gifts_bloc.dart';
import '../bloc/gifts_event.dart';
import '../bloc/gifts_state.dart';
import '../widgets/wallet_display.dart';

class CoinStoreView extends StatelessWidget {
  const CoinStoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Coins'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocConsumer<GiftsBloc, GiftsState>(
        listener: (context, state) {
          if (state is PurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Successfully purchased ${state.itemName}!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is GiftsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is GiftsLoading || state is PurchaseInProgress) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CoinStoreLoaded) {
            return _buildCoinStoreContent(context, state);
          }

          if (state is GiftsLoaded) {
            // Reload coin store
            context.read<GiftsBloc>().add(LoadCoinStore());
            return const Center(child: CircularProgressIndicator());
          }

          // Initial load
          context.read<GiftsBloc>().add(LoadCoinStore());
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCoinStoreContent(BuildContext context, CoinStoreLoaded state) {
    return Column(
      children: [
        // Wallet Section
        Padding(
          padding: const EdgeInsets.all(16),
          child: WalletDisplay(
            wallet: state.wallet,
            onAddCoins: () {},
          ),
        ),

        // Info Banner
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.amber.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.amber.shade200),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.amber.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Coins can be used to send gifts to other users. Larger packages offer bonus coins!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.amber.shade900,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Packages List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.packages.length,
            itemBuilder: (context, index) {
              final package = state.packages[index];
              return CoinPackageCard(
                package: package,
                onPurchase: () {
                  _showPurchaseConfirmation(context, package);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _showPurchaseConfirmation(BuildContext context, dynamic package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Purchase'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Purchase ${package.name} for ${package.formattedPrice}?',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    '${package.coinAmount} Coins',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            if (package.bonusDescription != null) ...[
              const SizedBox(height: 12),
              Text(
                package.bonusDescription!,
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<GiftsBloc>().add(PurchaseCoins(package.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Purchase'),
          ),
        ],
      ),
    );
  }
}
