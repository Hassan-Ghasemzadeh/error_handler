import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_strings.dart';
import '../di/get_it_config.dart';
import '../services/url_launcher_service.dart';
import '../theme/app_theme.dart';

/// Main application layout wrapper utilizing [StatefulNavigationShell]
/// to manage persistent, nested top-level route navigation.
class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundDark,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,

        // ---------------------------------------------------------------------
        // Application Branding & Logo Header
        // ---------------------------------------------------------------------
        title: Row(
          children: [
            Icon(
              Icons.code,
              color: AppTheme.accentBlue,
            ),
            const SizedBox(width: 8),
            const Text(
              'Resultex',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),

        // ---------------------------------------------------------------------
        // AppBar Action Controls
        // ---------------------------------------------------------------------
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextButton.icon(
              // Open external GitHub source code repository
              onPressed: () {
                getIt<UrlLauncherService>()
                    .openWeb(AppStrings.exampleGitHubUrl);
              },

              // Remote GitHub icon with fallback icon on loading failure
              icon: Image.network(
                AppStrings.gitLogoUrl,
                width: 20,
                height: 20,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.code,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              label: Text(
                AppStrings.sourceCode,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.surfaceCard.withValues(alpha: 0.5),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: AppTheme.borderDark,
                  ),
                ),
                foregroundColor: AppTheme.accentBlue,
              ),
            ),
          ),
        ],
      ),

      // Displays the current active shell branch view
      body: navigationShell,
    );
  }
}
