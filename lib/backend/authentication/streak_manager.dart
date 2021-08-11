import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/util/event_bus/frederic_system_events.dart';
import 'package:frederic/extensions.dart';

class StreakManager {
  StreakManager(this.userManager, FredericBackend backend) {
    backend.eventBus.subscribe((event) {
      if (event.type == FredericSystemEventType.CalendarDayCompleted) {
        handleCompleteDay();
      }
    });
  }
  final FredericUserManager userManager;

  void update() {
    if (_checkIfStreakNeedsUpdating()) {
      _updateStreak();
    }
  }

  void handleCompleteDay() {
    if (userManager.state.hasStreak) {
      if (userManager.state.streakLatestDate?.isNotSameDay(DateTime.now()) ??
          true) {
        userManager.state.streakLatestDate = DateTime.now();
      }
    }
  }

  void _updateStreak() async {
    bool streakBroken = await _calculateIsStreakBroken();

    if (streakBroken) {
      userManager.state.streakStartDate = null;
      userManager.state.streakLatestDate = null;
    } else {
      if (userManager.state.streakLatestDateWasNotTodayOrYesterday()) {
        userManager.state.streakLatestDate = DateTime.now();
      }
    }
  }

  Future<bool> _calculateIsStreakBroken() async {
    var lastCompletion = userManager.state.streakLatestDate;
    var now = DateTime.now();
    bool streakBroken = false;

    int iterationCount = 0;
    for (int i = 1;
        now
            .subtract(Duration(days: i))
            .isNotSameDay(lastCompletion ?? userManager.state.streakStartDate);
        i++) {
      iterationCount++;
      if (iterationCount > 100) {
        streakBroken = true;
        break;
      }
      bool calendarDayIsNotEmpty = await userManager.state
          .hasActivitiesOnDay(now.subtract(Duration(days: i)));
      if (calendarDayIsNotEmpty) {
        streakBroken = true;
        break;
      }
    }
    return streakBroken;
  }

  bool _checkIfStreakNeedsUpdating() {
    if (userManager.state.streakStartDate == null) return false;
    if (userManager.state.streakLatestDate != null) {
      if (userManager.state.streakLatestDate!.isSameDay(DateTime.now())) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }
}
