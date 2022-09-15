import 'dart:async';

import 'package:frederic/backend/backend.dart';

abstract class SetDataRepresentation {
  FutureOr<void> initialize({required bool clearCachedData});

  void addSet(FredericActivity activity, FredericSet set);

  void deleteSet(FredericActivity activity, FredericSet set);
}
