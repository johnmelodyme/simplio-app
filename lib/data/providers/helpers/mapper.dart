import 'dart:isolate';
import 'package:simplio_app/data/providers/helpers/box_provider.dart';

abstract class Mapper<T, K extends Entity> {
  T mapFrom(K entity);
  K mapTo(T data);
}

// TODO - remove this. It's not used.
abstract class IsolateMapper {
  static Future<T> mapFrom<T, K extends Entity>(
    Mapper<T, K> mapper,
    K entity,
  ) async {
    final r = ReceivePort();
    Isolate.spawn(_mapFrom(mapper, entity), r.sendPort);
    return await r.first as T;
  }

  static Future<K> mapTo<T, K extends Entity>(
    Mapper<T, K> mapper,
    T data,
  ) async {
    final r = ReceivePort();
    Isolate.spawn(_mapTo(mapper, data), r.sendPort);
    return await r.first as K;
  }

  static Function(SendPort s) _mapFrom<T, K extends Entity>(
    Mapper<T, K> mapper,
    K entity,
  ) {
    return (SendPort s) => s.send(mapper.mapFrom(entity));
  }

  static Function(SendPort s) _mapTo<T, K extends Entity>(
    Mapper<T, K> mapper,
    T data,
  ) {
    return (SendPort s) => s.send(mapper.mapTo(data));
  }
}
