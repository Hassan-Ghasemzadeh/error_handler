import 'package:example/core/constants/app_strings.dart';
import 'package:example/core/di/get_it_config.dart';
import 'package:example/core/services/url_launcher_service.dart';
import 'package:example/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/coffee_bloc/coffee_bloc.dart';
import '../widgets/hero_section.dart';
import '../widgets/live_demo_section.dart';

/// Main landing page widget displaying the hero section, external links,
/// and the interactive live demo section.
class HomeLandingPage extends StatelessWidget {
  const HomeLandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final urlLauncher = GetIt.I<UrlLauncherService>();

    return BlocProvider(
      create: (_) => getIt<CoffeeBloc>(),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              HeroSection(
                onPubDevTap: () => urlLauncher.openWeb(
                  AppStrings.pubDevUrl,
                ),
                onGithubTap: () => urlLauncher.openWeb(
                  AppStrings.resultexGitHubUrl,
                ),
              ),
              const SizedBox(height: 80),
              const LiveDemoSection(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}
