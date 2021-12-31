import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/workouts/frederic_workout_activity.dart';

void main() {
  group('Test FredericWorkoutActivities class', () {
    FredericWorkout workout = FredericWorkout.noSuchWorkout('werner');
    workout.updateData(newPeriod: 1, newRepeating: true);
    FredericWorkoutActivities activities = FredericWorkoutActivities(workout);

    test('Initialize and clear data', () {
      FredericActivity activity1 = FredericActivity.noSuchActivity('1');
      FredericActivity activity2 = FredericActivity.noSuchActivity('2');
      FredericActivity activity3 = FredericActivity.noSuchActivity('3');
      FredericActivity activity4 = FredericActivity.noSuchActivity('4');
      FredericActivity activity5 = FredericActivity.noSuchActivity('5');
      FredericActivity activity6 = FredericActivity.noSuchActivity('6');
      FredericActivity activity7 = FredericActivity.noSuchActivity('7');

      activities.activities[1]
          .add(FredericWorkoutActivity(activity: activity1, weekday: 1));
      activities.activities[2]
          .add(FredericWorkoutActivity(activity: activity2, weekday: 2));
      activities.activities[3]
          .add(FredericWorkoutActivity(activity: activity3, weekday: 3));
      activities.activities[4]
          .add(FredericWorkoutActivity(activity: activity4, weekday: 4));
      activities.activities[5]
          .add(FredericWorkoutActivity(activity: activity5, weekday: 5));
      activities.activities[6]
          .add(FredericWorkoutActivity(activity: activity6, weekday: 6));
      activities.activities[7]
          .add(FredericWorkoutActivity(activity: activity7, weekday: 7));

      expect(activities.totalNumberOfActivities, 7);
      activities.clear();
      expect(activities.totalNumberOfActivities, 0);

      activities.activities[1]
          .add(FredericWorkoutActivity(activity: activity1, weekday: 1));
      activities.activities[2]
          .add(FredericWorkoutActivity(activity: activity2, weekday: 2));
      activities.activities[3]
          .add(FredericWorkoutActivity(activity: activity3, weekday: 3));
      activities.activities[4]
          .add(FredericWorkoutActivity(activity: activity4, weekday: 4));
      activities.activities[5]
          .add(FredericWorkoutActivity(activity: activity5, weekday: 5));
      activities.activities[6]
          .add(FredericWorkoutActivity(activity: activity6, weekday: 6));
      activities.activities[7]
          .add(FredericWorkoutActivity(activity: activity7, weekday: 7));

      expect(activities.totalNumberOfActivities, 7);
    });

    test('Resize', () {
      workout.updateData(newPeriod: 3);
      activities.resizeForPeriod(3);

      FredericActivity activity = FredericActivity.noSuchActivity('x');

      activities.activities[21]
          .add(FredericWorkoutActivity(activity: activity, weekday: 21));
      activities.activities[14]
          .add(FredericWorkoutActivity(activity: activity, weekday: 14));

      expect(activities.totalNumberOfActivities, 9);

      workout.updateData(newPeriod: 1);
      activities.resizeForPeriod(1);
      activities.trimForPeriod(1);

      expect(activities.totalNumberOfActivities, 7);
    });

    test('Get activities on day', () {
      DateTime start = DateTime(2021, 1, 1);
      workout.updateData(newStartDate: start, newRepeating: true);

      void checkDay(int day, int week) {
        var list = activities.getDay(start.add(Duration(days: week * 7 + day)));

        expect(list.isNotEmpty, true);
        var activity = list.first;

        expect(activity.activity.id, (day + 1).toString());
      }

      for (int week = 0; week < 100; week++) {
        for (int day = 0; day < 7; day++) {
          checkDay(day, week);
        }
      }
    });

    test('Get activities on day (period 2)', () {
      DateTime start = DateTime(2021, 1, 1);
      workout.updateData(newStartDate: start, newRepeating: true, newPeriod: 2);
      activities.resizeForPeriod(2);

      void checkDay(int day, int week) {
        bool weekHasActivities = week % 2 == 0;
        var list = activities.getDay(start.add(Duration(days: week * 7 + day)));

        if (!weekHasActivities) {
          expect(list.isEmpty, true);
        } else {
          expect(list.isNotEmpty, true);
          var activity = list.first;
          expect(activity.activity.id, (day + 1).toString());
        }
      }

      for (int week = 0; week < 100; week++) {
        for (int day = 0; day < 7; day++) {
          checkDay(day, week);
        }
      }
    });
  });
}
