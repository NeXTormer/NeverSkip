import 'dart:async';

class WaitForX {
  List<Completer<void>> _completers = <Completer<void>>[];
  bool _complete = false;

  bool get isComplete => _complete;

  Future<void> waitForX() async {
    if (_complete) return;
    Completer<void> completer = Completer<void>();
    _completers.add(completer);
    return completer.future;
  }

  void complete() {
    if (_complete) return;
    _complete = true;
    for (var completer in _completers) completer.complete();
  }
}
