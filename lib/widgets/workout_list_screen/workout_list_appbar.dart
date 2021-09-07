import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/state/workout_search_term.dart';
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
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16, bottom: 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Find your perfect workout plan',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: theme.textColor,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.6,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'All workout plans',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: theme.textColor,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              StreakIcon(user: widget.user)
            ],
          ),
          SizedBox(height: 16),
          FredericTextField(
            'Search...',
            controller: textEditingController,
            icon: Icons.search,
            size: 20,
            suffixIcon: ExtraIcons.settings,
          ),
          SizedBox(height: 8),
        ],
      ),
    ));
  }
}
