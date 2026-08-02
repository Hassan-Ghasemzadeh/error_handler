import 'package:flutter/material.dart';
import 'package:resultex/resultex.dart';
import 'core/constants/app_strings.dart';
import 'core/di/get_it_config.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

/// Application entry point.
/// Initializes Flutter bindings, dependency injection, and core utilities before running the app.
void main() async {
  // Ensure framework bindings are initialized before executing async tasks
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetIt dependency injection modules
  setupLocator();

  // Initialize Resultex core services and configuration
  await Resultex.init();

  // Launch the root application widget
  runApp(const ResultxDemoApp());
}

/// Root application widget that sets up routing, global theme, and localized strings.
class ResultxDemoApp extends StatelessWidget {
  const ResultxDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      routerConfig: AppRouter.router,
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
