import 'package:example/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Section widget displaying installation instructions and terminal command snippet.
class InstallationSection extends StatelessWidget {
  const InstallationSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          AppStrings.installTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          AppStrings.installDescription,
          style: TextStyle(
            color: AppTheme.textMuted,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.borderDark),
          ),
          child: Row(
            children: [
              const Text(
                '\$ ',
                style: TextStyle(
                  color: AppTheme.successGreen,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppStrings.font,
                  fontSize: 14,
                ),
              ),
              Text(
                AppStrings.installCommand,
                style: TextStyle(
                  color: AppTheme.successGreen.withValues(alpha: 0.8),
                  fontFamily: AppStrings.font,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
