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
  bool _populated;

  MemoryCacheProvider._(
    this._updatedAt,
    this._lifetime,
    this._initialData,
    this._data,
    this._populated,
  );

  MemoryCacheProvider.builder({
    required int lifetimeInSeconds,
    required T initialData,
  }) : this._(
          DateTime.now(),
          lifetimeInSeconds,
          initialData,
          initialData,
          false,
        );

  @override
  bool get isValid {
    final expiresAt = _updatedAt.millisecondsSinceEpoch + (_lifetime * 1000);
    return _populated && DateTime.now().millisecondsSinceEpoch <= expiresAt;
  }

  @override
  T read() => _data;

  @override
  void write(data) {
    _updatedAt = DateTime.now();
    _data = data;
    _populated = true;
  }

  @override
  void clear() {
    _populated = false;
    _data = _initialData;
  }
}
