///
/// A Goal and a achievement are the same object. Achieved goals are
/// automatically achievements. Additionally not completed goals can also be
/// added to the achievements
///
class FredericGoal {
  String _title;
  String _image;

  num _start;
  num _end;
  num _current;
  DateTime _startDate;
  DateTime _endDate;
  bool _isAchievement;
  bool _isDeleted;

  String get title => _title ?? 'Goal';
  String get image => _image ?? 'https://via.placeholder.com/500x400?text=Goal';
  num get startState => _start ?? 0;
  num get endState => _end ?? 0;
  num get currentState => _current ?? 0;
  DateTime get startDate => _startDate ?? DateTime.now();
  DateTime get endDate => _endDate ?? DateTime.now();
  bool get isAchievement => _isAchievement ?? false;
  bool get isDeleted => _isDeleted ?? false;
  bool get isLoss => startState > endState;

  num get progressPercentage {
    num diff = endState - startState;
    num change = currentState - startState;
    num percentage = change / diff;
    if (percentage < 0) percentage = 0;
    if (percentage > 1) percentage = 1;
    return percentage * 100;
  }

  //setter
  //getter
  //load
  //
}
