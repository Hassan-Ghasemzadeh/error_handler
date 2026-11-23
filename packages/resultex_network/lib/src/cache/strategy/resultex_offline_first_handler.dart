import 'package:resultex/resultex.dart';

import '../policy/cache_policy.dart';
import '../provider/resultex_cache_provider.dart';

/// A clean execution handler for network requests with caching support.
class ResultexOfflineFirstHandler<T> {
  final ResultexCacheProvider<T>? cacheProvider;
  final CachePolicy policy;
  final ResultExecutor executor;

  ResultexOfflineFirstHandler({
    this.cacheProvider,
    this.policy = CachePolicy.swr,
    ResultExecutor? executor,
  }) : executor = executor ?? Resultex.executor;

  /// Executes the request based on the provided caching strategy.
  ///
  /// [key] is the unique identifier for the cache entry.
  /// [fetcher] is the actual network call returning `Future<T>`.
  /// [onEmit] is a callback to update the UI state with strongly-typed [Result<T>].
  Future<void> execute({
    required String key,
    required Future<T> Function() fetcher,
    required void Function(Result<T> state) onEmit,
  }) async {
    // Safety check: If no cache provider is injected, fallback to standard network call.
    if (cacheProvider == null) {
      await _fetchNetworkOnly(fetcher, onEmit);
      return;
    }

    switch (policy) {
      case CachePolicy.swr:
        await _executeSwr(key, fetcher, onEmit);
        break;
      case CachePolicy.cacheFirst:
        await _executeCacheFirst(key, fetcher, onEmit);
        break;
      case CachePolicy.networkFirst:
        await _executeNetworkFirst(key, fetcher, onEmit);
        break;
    }
  }

  /// Implements Stale-While-Revalidate (Offline-First) logic.
  Future<void> _executeSwr(
    String key,
    Future<T> Function() fetcher,
    void Function(Result<T> state) onEmit,
  ) async {
    // Emit loading state initially
    onEmit(Result<T>.loading());

    bool hasCachedData = false;

    // Try to read from cache and emit immediately if available
    await executor.executeAsync(
      () async {
        final cacheResult = await cacheProvider?.read(key);
        final cachedValue = cacheResult?.valueOrNull;
        if (cachedValue != null) {
          hasCachedData = true;
          onEmit(Result<T>.success(cachedValue));
        }
      },
    );

    // Fetch fresh data from the network
    final networkResult = await executor.executeAsync<T>(
      () async {
        final freshData = await fetcher();

        // Update the cache with fresh data
        await cacheProvider!.write(key, freshData);

        // Emit the fresh network data
        onEmit(Result<T>.success(freshData));
        return freshData;
      },
    );

    if (networkResult is FailureResult<T>) {
      if (!hasCachedData) {
        onEmit(networkResult);
      }
    }
  }

  /// Implements Cache-First logic.
  /// Ideal for static data. It checks the cache first, and only hits the network
  /// if the cache is completely empty or expired.
  Future<void> _executeCacheFirst(
    String key,
    Future<T> Function() fetcher,
    void Function(Result<T> state) onEmit,
  ) async {
    // Emit loading state
    onEmit(Result<T>.loading());
    bool hasCachedData = false;

    await executor.executeAsync(
      () async {
        final cacheResult = await cacheProvider?.read(key);
        final cachedValue = cacheResult?.valueOrNull;

        if (cachedValue != null) {
          hasCachedData = true;
          onEmit(Result<T>.success(cachedValue));
        }
      },
    );

    if (hasCachedData) return;

    // Cache miss: Fallback to network fetch
    final networkResult = await executor.executeAsync<T>(
      () async {
        final freshData = await fetcher();

        // Save the newly fetched data to cache for next time
        await cacheProvider!.write(key, freshData);

        // Emit fresh network data
        onEmit(Result<T>.success(freshData));
        return freshData;
      },
    );

    if (networkResult is FailureResult<T>) {
      onEmit(networkResult);
    }
  }

  /// Implements Network-First logic.
  /// Always tries to fetch fresh data from the network. If the network call fails
  /// (e.g., no internet), it gracefully falls back to the last cached version.
  Future<void> _executeNetworkFirst(
    String key,
    Future<T> Function() fetcher,
    void Function(Result<T> state) onEmit,
  ) async {
    // Emit loading state
    onEmit(Result<T>.loading());

    final networkResult = await executor.executeAsync<T>(
      () async {
        // Attempt network fetch first
        final freshData = await fetcher();

        // Network success: Update the cache with the latest data
        await cacheProvider!.write(key, freshData);

        // Emit fresh network data
        onEmit(Result<T>.success(freshData));
        return freshData;
      },
    );

    if (networkResult is FailureResult<T>) {
      final cacheResult = await cacheProvider?.read(key);
      final cachedValue = cacheResult?.valueOrNull;

      if (cachedValue != null) {
        // Cache hit after network failure (Offline mode)
        onEmit(Result<T>.success(cachedValue));
      } else {
        // Network failed AND cache is empty -> Emit the network error
        onEmit(networkResult);
      }
    }
  }

  /// Standard network execution without cache.
  Future<void> _fetchNetworkOnly(
    Future<T> Function() fetcher,
    void Function(Result<T> state) onEmit,
  ) async {
    onEmit(Result<T>.loading());
    final networkResult = await executor.executeAsync<T>(
      () async {
        final data = await fetcher();
        onEmit(Result<T>.success(data));
        return data;
      },
    );

    if (networkResult is FailureResult<T>) {
      onEmit(networkResult);
    }
  }
}
