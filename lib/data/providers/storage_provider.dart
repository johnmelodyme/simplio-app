abstract class StorageProvider<T> {
  Future<void> save(T data);
  T get();
}
