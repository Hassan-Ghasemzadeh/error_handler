import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/coffee_demo/presentation/pages/home_landing_pages.dart';

// Generated file containing type-safe route helper extensions created by go_router_builder
part 'landing_route.g.dart';

/// Strongly-typed route definition for the application's root landing page.
@TypedGoRoute<LandingRoute>(
  path: '/',
)
class LandingRoute extends GoRouteData with $LandingRoute {
  const LandingRoute();

  /// Builds and returns the target [HomeLandingPage] when this route is navigated to.
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const HomeLandingPage();
}