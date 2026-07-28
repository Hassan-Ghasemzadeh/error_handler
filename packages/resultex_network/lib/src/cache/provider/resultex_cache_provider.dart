/// Core interface for caching mechanisms in resultex.
/// Developers can implement this interface using Hive, SharedPreferences, or SQLite.
abstract interface class ResultexCacheProvider<T> {
  /// Reads data from the cache using a unique [key].
  /// Returns null if the data does not exist or has expired.
  Future<T?> read(String key);

  /// Writes [data] to the cache assigned to the [key].
  Future<void> write(String key, T data);

  /// Deletes the cached data associated with the [key].
  Future<void> delete(String key);

  /// Clears all cached data managed by this provider.
  Future<void> clear();
}
