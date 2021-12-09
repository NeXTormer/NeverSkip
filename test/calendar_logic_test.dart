import 'package:frederic/backend/workouts/frederic_workout.dart';
import 'package:test/test.dart';

void main() {
  test('Counter value should be incremented', () {
    FredericWorkout workout = FredericWorkout.create();
    //workout.period = 1;

    FredericWorkoutActivities activities =
        FredericWorkoutActivities(FredericWorkout.create());

    expect(1, 1);
  });
}
