import 'package:frederic/backend/sets/frederic_set_manager.dart';

class TrainingVolumeChartData {
  TrainingVolumeChartData(this.setListData);

  final FredericSetListData setListData;

  List<int> getVolumeArray() {
    return <int>[];
  }
}
