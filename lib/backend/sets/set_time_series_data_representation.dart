import 'dart:async';

import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/sets/set_data_representation.dart';

class SetTimeSeriesDataRepresentation implements SetDataRepresentation {
  SetTimeSeriesDataRepresentation(this.activityManager, this.setManager);

  final FredericSetManager setManager;
  final FredericActivityManager activityManager;

  FutureOr<void> initialize({required bool clearCachedData}) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  void addSet(FredericActivity activity, FredericSet set) {
    // TODO: implement addSet
  }

  void deleteSet(FredericActivity activity, FredericSet set) {
    // TODO: implement deleteSet
  }
}
