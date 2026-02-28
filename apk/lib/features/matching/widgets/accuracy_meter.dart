import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class AccuracyMeter extends StatelessWidget {
  final double compatibilityScore;
  final List<String> sharedInterests;
  final List<String> allInterests;

  const AccuracyMeter({
    super.key,
    required this.compatibilityScore,
    required this.sharedInterests,
    required this.allInterests,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (compatibilityScore * 100).toInt();
    final color = _getColorForScore(compatibilityScore);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Compatibility',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$percentage% Match',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
              CircularPercentIndicator(
                radius: 40,
                lineWidth: 8,
                percent: compatibilityScore,
                center: Icon(
                  _getIconForScore(compatibilityScore),
                  color: color,
                  size: 28,
                ),
                progressColor: color,
                backgroundColor: Colors.grey[200]!,
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (sharedInterests.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Shared Interests',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sharedInterests.map((interest) {
                return Chip(
                  avatar: const Icon(Icons.check, size: 16, color: Colors.white),
                  label: Text(interest),
                  backgroundColor: Theme.of(context).primaryColor,
                  labelStyle: const TextStyle(color: Colors.white),
                );
              }).toList(),
            ),
          ],
          if (allInterests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'All Interests',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allInterests.map((interest) {
                final isShared = sharedInterests.contains(interest);
                return Chip(
                  label: Text(interest),
                  backgroundColor: isShared 
                      ? Theme.of(context).primaryColor.withOpacity(0.2)
                      : Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isShared 
                        ? Theme.of(context).primaryColor
                        : Colors.grey[700],
                    fontWeight: isShared ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Color _getColorForScore(double score) {
    if (score >= 0.8) return Colors.green;
    if (score >= 0.6) return Colors.orange;
    return Colors.red;
  }

  IconData _getIconForScore(double score) {
    if (score >= 0.8) return Icons.favorite;
    if (score >= 0.6) return Icons.thumb_up;
    return Icons.person;
  }
}
