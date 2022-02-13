import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';
import 'package:frederic/state/workout_search_term.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';

class WorkoutListAppbar extends StatefulWidget {
  WorkoutListAppbar(this.searchTerm, {Key? key, required this.user})
      : super(key: key);

  final WorkoutSearchTerm searchTerm;
  final FredericUser user;

  @override
  _WorkoutListAppbarState createState() => _WorkoutListAppbarState();
}

class _WorkoutListAppbarState extends State<WorkoutListAppbar> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    textEditingController.addListener(() {
      widget.searchTerm.searchTerm = textEditingController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FredericSliverAppBar(
      height: 140,
      title: tr('workouts.title'),
      subtitle: tr('workouts.subtitle'),
      icon:
          StreakIcon(user: widget.user, onColorfulBackground: theme.isColorful),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FredericTextField(
          tr('search_field'),
          onColorfulBackground: theme.isColorful,
          brightContents: theme.isColorful,
          onSuffixIconTap: () {
            setState(() {
              textEditingController.text = '';
            });
          },
          controller: textEditingController,
          icon: Icons.search,
          size: 20,
          suffixIcon: Icons.highlight_remove_outlined,
        ),
      ),
    );
  }
}
