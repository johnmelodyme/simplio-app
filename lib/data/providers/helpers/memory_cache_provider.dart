class MemoryCacheProvider<T> {
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

  bool get isValid {
    final expiresAt = _updatedAt.millisecondsSinceEpoch + (_lifetime * 1000);
    return _populated && DateTime.now().millisecondsSinceEpoch <= expiresAt;
  }

  T read() => _data;

  void write(T data) {
    _updatedAt = DateTime.now();
    _data = data;
    _populated = true;
  }

  void clear() {
    _populated = false;
    _data = _initialData;
  }
}
