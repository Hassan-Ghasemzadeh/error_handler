import 'package:hive/hive.dart';
import 'package:resultex_network/src/cache/provider/resultex_cache_provider.dart';

/// A Hive implementation of [ResultexCacheProvider].
/// Provides blazing-fast, local key-value storage for the offline-first mechanism.
class HiveCacheProvider<T> implements ResultexCacheProvider<T> {
  /// The name of the Hive box used for caching.
  final String boxName;

  Box<T>? _box;

  HiveCacheProvider({required this.boxName});

  /// Ensures the Hive box is open and ready before performing any operations.
  /// This prevents 'Box not found' exceptions during rapid read/writes.
  Future<Box<T>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      _box = await Hive.openBox<T>(boxName);
    }
    return _box!;
  }

  @override
  Future<T?> read(String key) async {
    try {
      final box = await _getBox();
      return box.get(key);
    } catch (e) {
      // NOTE: Here you can integrate resultex_logger to log cache read failures silently.
      // Returning null ensures the OfflineFirstHandler gracefully falls back to network fetch.
      return null;
    }
  }

  @override
  Future<void> write(String key, T data) async {
    try {
      final box = await _getBox();
      await box.put(key, data);
    } catch (e) {
      // Log cache write errors.
      // Ensure that if 'T' is a custom model, its HiveType and TypeAdapter are registered.
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      final box = await _getBox();
      await box.delete(key);
    } catch (e) {
      // Log deletion errors
    }
  }

  @override
  Future<void> clear() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      // Log clear errors
    }
  }
}
