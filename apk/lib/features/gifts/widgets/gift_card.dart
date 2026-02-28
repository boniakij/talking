import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/gift.dart';

class GiftCard extends StatelessWidget {
  final Gift gift;
  final bool canAfford;
  final VoidCallback onTap;

  const GiftCard({
    super.key,
    required this.gift,
    required this.canAfford,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canAfford ? onTap : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gift.isPremium
                ? [Colors.amber.shade100, Colors.amber.shade50]
                : [Colors.white, Colors.grey.shade50],
          ),
          borderRadius: BorderRadius.circular(16),
          border: gift.isPremium
              ? Border.all(color: Colors.amber, width: 2)
              : Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gift Icon with 3D effect
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  gift.iconAsset,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Gift Name
            Text(
              gift.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: canAfford ? Colors.black87 : Colors.grey,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            
            // Price
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.monetization_on,
                  size: 16,
                  color: canAfford ? Colors.amber : Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${gift.coinCost}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: canAfford ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
            
            if (gift.isPremium) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'PREMIUM',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class GiftAnimationOverlay extends StatelessWidget {
  final Gift gift;
  final String recipientName;
  final VoidCallback onComplete;

  const GiftAnimationOverlay({
    super.key,
    required this.gift,
    required this.recipientName,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie animation placeholder - in real app, use actual Lottie file
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  gift.iconAsset,
                  style: const TextStyle(fontSize: 120),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Sent ${gift.name} to',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recipientName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: const Text('Awesome!'),
            ),
          ],
        ),
      ),
    );
  }
}
