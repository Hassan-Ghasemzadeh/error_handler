/// Defines how resultex should handle network and cache interactions.
enum CachePolicy {
  /// Cache-First: Returns cache if available. Only fetches network if cache is empty.
  cacheFirst,

  /// Network-First: Tries network first. Falls back to cache only if network fails.
  networkFirst,

  /// Stale-While-Revalidate (Offline-First): Immediately emits cached data (if any),
  /// then fetches fresh data from the network in the background and updates the UI.
  swr,
}
