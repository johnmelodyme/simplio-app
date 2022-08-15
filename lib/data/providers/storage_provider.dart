abstract class StorageProvider<T> {
  Future<void> write(T data);
  T read();
}
