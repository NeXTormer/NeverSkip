import 'package:flutter/material.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
import 'package:frederic/widgets/standard_elements/streak_icon.dart';

import '../../state/activity_filter_controller.dart';
import '../standard_elements/frederic_text_field.dart';

class ActivityHeader extends StatefulWidget {
  ActivityHeader(this.title, this.subtitle,
      {required this.user, required this.filterController});

  final String title;
  final String subtitle;
  final FredericUser user;
  final ActivityFilterController filterController;

  @override
  _ActivityHeaderState createState() => _ActivityHeaderState();
}

class _ActivityHeaderState extends State<ActivityHeader> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.addListener(() {
      widget.filterController.searchText = textController.text;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FredericSliverAppBar(
      title: widget.title,
      subtitle: widget.subtitle,
      height: 140,
      icon: StreakIcon(user: widget.user),
      trailing: Container(
        color: theme.isColorful ? theme.mainColor : theme.backgroundColor,
        child: Column(
          children: [
            FredericTextField(
              'Search...',
              onSuffixIconTap: () {
                setState(() {
                  textController.text = '';
                });
              },
              controller: textController,
              brightContents: true,
              icon: Icons.search,
              size: 20,
              suffixIcon: Icons.highlight_remove_outlined,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
