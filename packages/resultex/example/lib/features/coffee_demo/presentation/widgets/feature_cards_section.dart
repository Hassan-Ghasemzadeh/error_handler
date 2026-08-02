import 'package:example/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

/// A section widget displaying feature cards in a responsive layout.
///
/// Renders cards horizontally in a row on desktop layouts (> 850px) and stacks
/// them vertically in a column on smaller screens.
class FeatureCardsSection extends StatelessWidget {
  const FeatureCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 850;

        final cards = [
          _buildCard(
            title: AppStrings.featureOneTitle,
            description: AppStrings.featureOneDescription,
          ),
          _buildCard(
            title: AppStrings.featureTwoTitle,
            description: AppStrings.featureTwoDescription,
          ),
          _buildCard(
            title: AppStrings.featureThreeTitle,
            description: AppStrings.featureThreeDescription,
          ),
        ];

        if (isDesktop) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: cards
                .map((card) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: card,
                      ),
                    ))
                .toList(),
          );
        } else {
          return Column(
            children: cards
                .map((card) => Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: card,
                    ))
                .toList(),
          );
        }
      },
    );
  }

  Widget _buildCard({required String title, required String description}) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 110,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              color: AppTheme.textMuted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
