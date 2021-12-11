import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/backend/database/frederic_data_interface.dart';

class FirestoreActivityDataInterface
    implements FredericDataInterface<FredericActivity> {
  @override
  Future<FredericActivity> create(FredericActivity object) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(FredericActivity object) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<FredericActivity>> get() {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<FredericActivity> update(FredericActivity object) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
