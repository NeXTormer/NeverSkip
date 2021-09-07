import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';
import 'package:provider/provider.dart';

import '../../misc/ExtraIcons.dart';
import '../../state/activity_filter_controller.dart';
import '../standard_elements/frederic_text_field.dart';

class ActivityHeader extends StatelessWidget {
  ActivityHeader(this.title, this.subtitle, {required this.user});

  final String title;
  final String subtitle;
  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Consumer<ActivityFilterController>(
          builder: (context, filter, child) {
            return ActivityHeaderContent(title, subtitle,
                filterController: filter, user: user);
          },
        ),
      ),
    );
  }
}

class ActivityHeaderContent extends StatefulWidget {
  ActivityHeaderContent(this.title, this.subtitle,
      {required this.filterController, required this.user});

  final ActivityFilterController filterController;
  final FredericUser user;
  final String title;
  final String subtitle;

  @override
  _ActivityHeaderContentState createState() => _ActivityHeaderContentState();
}

class _ActivityHeaderContentState extends State<ActivityHeaderContent> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      widget.filterController.searchText = textController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                      widget.subtitle,
                      style: TextStyle(
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
                      widget.title,
                      style: TextStyle(
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
          controller: textController,
          icon: Icons.search,
          size: 20,
          suffixIcon:
              ExtraIcons.settings, // TODO? similar style as in homescreen
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
