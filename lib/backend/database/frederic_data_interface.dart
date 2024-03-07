import 'package:frederic/backend/database/frederic_data_object.dart';

abstract class FredericDataInterface<T extends FredericDataObject> {
  ///
  /// Get cached data. If no data is cached, request data from the remote DB
  ///
  Future<List<T>> get();

  ///
  /// Reloads data from remote DB
  ///
  Future<List<T>> reload();

  Future<T> update(T object);

  Future<void> delete(T object);

  Future<T> create(T object);

  Future<T> createFromMap(Map<String, dynamic> data);

  Future<void> deleteFromDisk();
}
