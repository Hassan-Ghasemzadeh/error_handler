import 'package:example/core/router/router_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../layout/main_layout.dart';
import 'landing_route.dart';

/// Central router configuration utilizing [GoRouter] and [StatefulShellRoute]
/// to support stateful, multi-branch navigation.
class AppRouter {
  // Global keys for managing top-level and branch-specific navigator states
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _landingNavigatorKey = GlobalKey<NavigatorState>();

  /// Main [GoRouter] instance managing application routing and stateful shell branches.
  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoute.coffeeDemo.path,
    routes: [
      // -----------------------------------------------------------------------
      // Stateful Navigation Shell (Preserves State Across Tabs/Branches)
      // -----------------------------------------------------------------------
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayout(navigationShell: navigationShell);
        },
        branches: [
          // Landing/Home Navigation Branch
          StatefulShellBranch(
            navigatorKey: _landingNavigatorKey,
            routes: [$landingRoute],
          ),
        ],
      ),
    ],
  );
}
