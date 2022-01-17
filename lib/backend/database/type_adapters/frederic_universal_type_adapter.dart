import 'package:frederic/backend/database/frederic_data_object.dart';
import 'package:hive/hive.dart';

class FredericUniversalTypeAdapter<T extends FredericDataObject>
    extends TypeAdapter<T> {
  FredericUniversalTypeAdapter(this.typeId, {required this.create});

  final T Function(String id, Map<String, dynamic> map) create;

  @override
  T read(BinaryReader reader) {
    final id = reader.readString();
    final map = reader.readMap();
    return create(id, Map.from(map));
  }

  @override
  final int typeId;

  @override
  void write(BinaryWriter writer, T obj) {
    writer.writeString(obj.id);
    writer.writeMap(obj.toMap());
  }
}
