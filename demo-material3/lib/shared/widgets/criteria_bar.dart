import 'package:flutter/material.dart';
import '../../app_theme.dart';

class CriteriaBar extends StatelessWidget {
  final String label;
  final double score;
  final double maxScore;

  const CriteriaBar({
    super.key,
    required this.label,
    required this.score,
    this.maxScore = 5.0,
  });

  Color _scoreColor(ColorScheme colorScheme) {
    if (score >= 4.5) return AppTheme.scoreHigh;
    if (score >= 3.5) return colorScheme.primary;
    return AppTheme.scoreMid;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = (score / maxScore).clamp(0.0, 1.0);
    final barColor = _scoreColor(colorScheme);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                score.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: barColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation(barColor),
            borderRadius: BorderRadius.circular(4),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}
