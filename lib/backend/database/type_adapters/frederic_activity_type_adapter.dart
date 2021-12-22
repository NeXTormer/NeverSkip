import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:hive/hive.dart';

@deprecated
class FredericActivityTypeAdapter extends TypeAdapter<FredericActivity> {
  @override
  FredericActivity read(BinaryReader reader) {
    final id = reader.readString();
    final map = reader.readMap();
    return FredericActivity.fromMap(id, Map.from(map));
  }

  @override
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, FredericActivity activity) {
    writer.writeString(activity.id);
    writer.writeMap(activity.toMap());
  }
}
