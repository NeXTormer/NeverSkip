import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:provider/provider.dart';

import 'add_progress_card.dart';

class RepsWeightSmartSuggestions extends StatelessWidget {
  const RepsWeightSmartSuggestions(this.suggestions, {Key? key})
      : super(key: key);

  final List<RepsWeightSuggestion> suggestions;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddProgressController>(
        builder: (context, controller, child) {
      return Container(
          width: double.infinity,
          child: Wrap(
            runSpacing: 14,
            crossAxisAlignment: WrapCrossAlignment.center,
            alignment: WrapAlignment.spaceBetween,
            children: List.generate(
                suggestions.length,
                (index) => _RepsWeightSmartSuggestionCard(
                      suggestions[index],
                      onTap: () {
                        controller.setRepsAndWeight(suggestions[index]);
                      },
                      selected: suggestions[index].reps == controller.reps &&
                          (suggestions[index].weight == controller.weight ||
                              suggestions[index].weight == null),
                    )),
          ));
    });
  }
}

class RepsWeightSuggestion implements Comparable {
  RepsWeightSuggestion(this.reps, this.weight);
  final int reps;
  final double? weight;

  @override
  int compareTo(other) {
    if (other is RepsWeightSuggestion) {
      if (other.weight == this.weight && other.reps == this.reps) return 0;
    }
    return 1;
  }
}

class _RepsWeightSmartSuggestionCard extends StatelessWidget {
  const _RepsWeightSmartSuggestionCard(this.data,
      {this.selected = false, this.onTap, Key? key})
      : super(key: key);

  final bool selected;

  final void Function()? onTap;

  final RepsWeightSuggestion data;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      onTap: onTap,
      width: 110,
      color: selected
          ? theme.mainColor.withOpacity(0.1)
          : theme.cardBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 8),
      child: Center(
        child: Text(
          data.weight == null
              ? '${data.reps} Reps'
              : '${data.reps} x ${data.weight!.floor() == data.weight!.toInt() ? data.weight!.toInt() : data.weight!} kg',
          style: TextStyle(
            fontSize: 16,
            color: selected ? theme.mainColorInText : theme.textColor,
            fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
            letterSpacing: 0.1,
          ),
          maxLines: 1,
        ),
      ),
    );
  }
}
