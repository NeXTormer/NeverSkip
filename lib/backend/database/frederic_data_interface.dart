import 'package:frederic/backend/database/frederic_data_object.dart';

abstract class FredericDataInterface<T extends FredericDataObject> {
  Future<List<T>> get();
  Future<T> update(T object);
  Future<void> delete(T object);
  Future<T> create(T object);
  Future<T> createFromMap(Map<String, dynamic> data);
}
