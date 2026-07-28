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
  /// [onEmit] is a callback to update the UI state (e.g., loading, success, error).
  Future<void> execute({
    required String key,
    required Future<T> Function() fetcher,
    required void Function(dynamic state)
        onEmit, // Replace 'dynamic' with your Result state class
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
    void Function(dynamic state) onEmit,
  ) async {
    // Emit loading state initially
    onEmit('LOADING_STATE'); // Replace with your Result.loading()

    bool hasCachedData = false;

    // Try to read from cache and emit immediately if available
    await executor.executeAsync(
      () async {
        final cachedData = await cacheProvider!.read(key);
        if (cachedData != null) {
          hasCachedData = true;
          // Emit cached data. You can flag it as 'isCached: true' in your Result class.
          onEmit('SUCCESS_STATE_CACHED: $cachedData');
        }
      },
    );

    // Fetch fresh data from the network
    await executor.executeAsync(
      () async {
        final freshData = await fetcher();

        // Update the cache with fresh data
        await cacheProvider!.write(key, freshData);

        // Emit the fresh network data
        onEmit('SUCCESS_STATE_NETWORK: $freshData');
      },
    ).catchError(
      (error) {
        if (!hasCachedData) {
          // If there was no cache, emit the error to the UI
          onEmit('ERROR_STATE: $error');
        } else {
          // If we already showed cached data, you might want to silently log the network error
          // or emit a specific state like Result.success(cachedData, networkError: error).
        }
        return FailureResult(
          Failure(
            message: error.toString(),
            // اگر exception یا stackTrace هم نیاز دارد اینجا پاس بده
          ),
        );
      },
    );
  }

  /// Implements Cache-First logic.
  /// Ideal for static data. It checks the cache first, and only hits the network
  /// if the cache is completely empty or expired.
  Future<void> _executeCacheFirst(
    String key,
    Future<T> Function() fetcher,
    void Function(dynamic state) onEmit,
  ) async {
    // Emit loading state
    onEmit('LOADING_STATE');
    await executor.executeAsync(
      () async {
        // Try to read from cache first
        final cachedData = await cacheProvider!.read(key);

        if (cachedData != null) {
          // Cache hit: Emit cached data and terminate early (No network call)
          onEmit('SUCCESS_STATE_CACHED: $cachedData');
          return;
        }
      },
    );

    // Cache miss: Fallback to network fetch
    await executor.executeAsync(
      () async {
        final freshData = await fetcher();

        // Save the newly fetched data to cache for next time
        await cacheProvider!.write(key, freshData);

        // Emit fresh network data
        onEmit('SUCCESS_STATE_NETWORK: $freshData');
      },
    ).catchError(
      (error) {
        onEmit('ERROR_STATE: $error');
        return FailureResult(
          Failure(
            message: error.toString(),
            // اگر exception یا stackTrace هم نیاز دارد اینجا پاس بده
          ),
        );
      },
    );
  }

  /// Implements Network-First logic.
  /// Always tries to fetch fresh data from the network. If the network call fails
  /// (e.g., no internet), it gracefully falls back to the last cached version.
  Future<void> _executeNetworkFirst(
    String key,
    Future<T> Function() fetcher,
    void Function(dynamic state) onEmit,
  ) async {
    // Emit loading state
    onEmit('LOADING_STATE');

    await executor.executeAsync(
      () async {
        // Attempt network fetch first
        final freshData = await fetcher();

        // Network success: Update the cache with the latest data
        await cacheProvider!.write(key, freshData);

        // Emit fresh network data
        onEmit('SUCCESS_STATE_NETWORK: $freshData');
      },
    ).catchError(
      (error) async {
        final cachedData = await cacheProvider!.read(key);

        if (cachedData != null) {
          // Cache hit after network failure (Offline mode)
          onEmit('SUCCESS_STATE_CACHED: $cachedData');
        } else {
          // Network failed AND cache is empty -> Emit the network error
          onEmit('ERROR_STATE: $error');
        }
        return FailureResult(
          Failure(
            message: error.toString(),
            // اگر exception یا stackTrace هم نیاز دارد اینجا پاس بده
          ),
        );
      },
    );
  }

  /// Standard network execution without cache.
  Future<void> _fetchNetworkOnly(
    Future<T> Function() fetcher,
    void Function(dynamic state) onEmit,
  ) async {
    await executor.executeAsync(
      () async {
        onEmit('LOADING_STATE');
        final data = await fetcher();
        onEmit('SUCCESS_STATE: $data');
      },
    ).catchError(
      (error) {
        onEmit('ERROR_STATE: $error');
        return FailureResult(
          Failure(
            message: error.toString(),
            // اگر exception یا stackTrace هم نیاز دارد اینجا پاس بده
          ),
        );
      },
    );
  }
}
