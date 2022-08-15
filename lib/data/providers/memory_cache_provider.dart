abstract class Cache<T> {
  bool get isValid;
  T? read();
  void write(T data);
  void clear();
}

class MemoryCacheProvider<T> implements Cache {
  final int _lifetime;
  DateTime _updatedAt;
  T _initialData;
  T _data;

  MemoryCacheProvider._(
    this._updatedAt,
    this._lifetime,
    this._initialData,
    this._data,
  );

  MemoryCacheProvider.builder({
    required int lifetimeInSeconds,
    required T initialData,
  }) : this._(
          DateTime.now(),
          lifetimeInSeconds,
          initialData,
          initialData,
        );

  @override
  bool get isValid {
    final expiresAt = _updatedAt.microsecondsSinceEpoch + (_lifetime * 1000);
    return DateTime.now().microsecondsSinceEpoch <= expiresAt;
  }

  @override
  T read() => _data;

  @override
  void write(data) {
    _updatedAt = DateTime.now();
    _data = data;
  }

  @override
  void clear() => _data = _initialData;
}
