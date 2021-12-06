import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/widgets/add_progress_screen/reps_weight_smart_suggestions.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'enter_reps_counter_widget.dart';
import 'enter_weight_widget.dart';

class AddProgressCard extends StatelessWidget {
  const AddProgressCard(
      {required this.controller,
      required this.activity,
      required this.onSave,
      this.suggestions,
      Key? key})
      : super(key: key);

  final AddProgressController controller;
  final FredericActivity activity;
  final List<RepsWeightSuggestion>? suggestions;
  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    bool hasSuggestions = suggestions?.isNotEmpty ?? false;

      return ChangeNotifierProvider<AddProgressController>.value(
        value: controller,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: theme.cardBackgroundColor,
              border: Border.all(color: theme.cardBorderColor)),
          child: Column(
            children: [
              buildSubHeading('Repetitions', Icons.repeat_outlined),
              SizedBox(height: 12),
              EnterRepsCounterWidget(),
              if (activity.type == FredericActivityType.Weighted) ...[
                SizedBox(height: 12),
                buildSubHeading('Weight', ExtraIcons.dumbbell),
                SizedBox(height: 12),
                EnterWeightWidget(),
              ],
              if (hasSuggestions) SizedBox(height: 8),
              if (hasSuggestions)
                buildSubHeading(
                    'Smart Suggestions', Icons.smart_button_outlined),
              if (hasSuggestions) SizedBox(height: 8),
              if (hasSuggestions) RepsWeightSmartSuggestions(suggestions!),
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 16),
                child: FredericButton('Save', onPressed: onSave),
              )
            ],
          ),
        ),
      );
  }

  Widget buildSubHeading(String title, IconData icon) {
    return Row(
      children: [
        SizedBox(height: 24, width: 24, child: Icon(icon)),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: theme.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class AddProgressController extends ChangeNotifier {
  AddProgressController(int reps, double weight)
      : //_sets = sets,
        _reps = reps,
        _weight = weight;

  set reps(int value) {
    _reps = value;
    notifyListeners();
  }

  set weight(double value) {
    _weight = value;
    notifyListeners();
  }

  int get reps => _reps;
  double get weight => _weight;

  void setRepsAndWeight(RepsWeightSuggestion suggestion) {
    _reps = suggestion.reps;
    _weight = suggestion.weight ?? 0;
    notifyListeners();
  }

  //int _sets;
  int _reps;
  double _weight;
}
