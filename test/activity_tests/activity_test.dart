import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';

import '../mock_database/test_activity_data_interface.dart';

void main() {
  group('Basic backend tests', () {
    TestActivityDataInterface activityDataInterface =
        TestActivityDataInterface();
    test('Mock DB Test', () async {
      activityDataInterface.initData();
      List<FredericActivity> activities = await activityDataInterface.get();
      expect(activities.length, 7);
      expect(activities.where((element) => element.name == 'Hubert').length, 1);

      var hubert =
          activities.where((element) => element.name == 'Hubert').first;
      activityDataInterface.delete(hubert);
      activities = await activityDataInterface.get();

      expect(activities.where((element) => element.name == 'Hubert').length, 0);
    });
  });
}
