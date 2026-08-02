/// Enumeration representing available navigation route identifiers across the application.
enum AppRoute {
  coffeeDemo,
}

/// Extension on [AppRoute] providing strongly-typed helpers for path resolution and route names.
extension AppRouteExtension on AppRoute {
  /// Maps each enum route to its corresponding URL path string.
  String get path => switch (this) {
        AppRoute.coffeeDemo => '/',
      };

  /// Convenience getter returning the string representation of the route enum name.
  String get routeName => name;
}
