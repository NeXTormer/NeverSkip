import 'package:frederic/backend/sets/frederic_set_document.dart';
import 'package:frederic/backend/sets/frederic_set_manager.dart';
import 'package:frederic/backend/util/frederic_profiler.dart';

class WeeklyTrainingVolumeChartData {
  WeeklyTrainingVolumeChartData(this.setListData) {}

  final FredericSetListData setListData;
  final int calisthenicsWeight = 50;

  List<int> getVolumeArray() {
    var profiler = FredericProfiler.track('Calculate workout volume for Chart');
    DateTime now = DateTime.now();
    DateTime startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    bool needsPreviousMonth = now.month != startOfWeek.month;
    int currentMonth = FredericSetDocument.calculateMonth(now);
    int minimumMonth = needsPreviousMonth ? currentMonth - 1 : currentMonth;

    List<int> weekVolume = List<int>.filled(7, 0);

    for (var setList in setListData.sets.values) {
      for (var setDocument in setList.setDocuments) {
        if (setDocument.month < minimumMonth) continue;
        for (var set in setDocument.sets) {
          if (set.timestamp.isAfter(startOfWeek)) {
            int weight = set.weight;
            if (weight == 0) weight = calisthenicsWeight;
            int volume = weight * set.reps;
            weekVolume[set.timestamp.weekday - 1] += volume;
          }
        }
      }
    }
    profiler.stop();
    return weekVolume;
  }
}
