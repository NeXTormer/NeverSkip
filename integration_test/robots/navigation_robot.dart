import 'package:flutter_test/flutter_test.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';

class NavigationRobot {
  Future<void> gotoWorkoutScreen(WidgetTester tester) async {
    await tester.pumpAndSettle();
    await tester.tap(find.text('Workouts'));
    await tester.pumpAndSettle();
  }

  Future<void> enterTexts(WidgetTester tester, List<String> text,
      [int offset = 0]) async {
    final textFields = find.byType(FredericTextField);

    int index = offset;
    for (String s in text) {
      await tester.enterText(textFields.at(index), s);

      index++;
    }
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
  }
}
