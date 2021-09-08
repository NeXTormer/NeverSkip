import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/misc/ExtraIcons.dart';
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
      title: 'All Workout Plans',
      subtitle: 'Find your perfect Workout Plan',
      icon: StreakIcon(user: widget.user),
      trailing: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FredericTextField(
          'Search...',
          brightContents: true,
          controller: textEditingController,
          icon: Icons.search,
          size: 20,
          suffixIcon: ExtraIcons.settings,
        ),
      ),
    );
  }
}
