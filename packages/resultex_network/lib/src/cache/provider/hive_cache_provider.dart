import 'package:hive/hive.dart';
import 'package:resultex_network/src/cache/provider/resultex_cache_provider.dart';

import '../../../resultex_network.dart';

/// A Hive implementation of [ResultexCacheProvider].
/// Provides blazing-fast, local key-value storage for the offline-first mechanism.
class HiveCacheProvider<T> implements ResultexCacheProvider<T> {
  /// The name of the Hive box used for caching.
  final String boxName;

  final ResultExecutor executor;

  Box<T>? _box;

  HiveCacheProvider({
    required this.boxName,
    ResultExecutor? executor,
  }) : executor = executor ?? Resultex.executor;

  /// Ensures the Hive box is open and ready before performing any operations.
  /// This prevents 'Box not found' exceptions during rapid read/writes.
  Future<Box<T>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<T>(boxName);
    }
    return _box!;
  }

  @override
  Future<Result<T?>> read(String key) async {
    return executor.executeAsync<T>(
      () async {
        final box = await _getBox();
        return box.get(key);
      },
    );
  }

  @override
  Future<void> write(String key, T data) async {
    await executor.executeAsync(
      () async {
        final box = await _getBox();
        await box.put(key, data);
      },
    );
  }

  @override
  Future<void> delete(String key) async {
    await executor.executeAsync(
      () async {
        final box = await _getBox();
        await box.delete(key);
      },
    );
  }

  @override
  Future<void> clear() async {
    await executor.executeAsync(
      () async {
        final box = await _getBox();
        await box.clear();
      },
    );
  }
}
