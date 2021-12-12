import 'package:flutter/material.dart';
import 'package:frederic/backend/activities/frederic_activity.dart';
import 'package:frederic/state/activity_filter_controller.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/frederic_sliver_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import 'activity_filter_segment.dart';
import 'activity_list_segment.dart';

class ActivitySearcher extends StatefulWidget {
  const ActivitySearcher({this.isSelector = false, this.onSelect, Key? key})
      : super(key: key);

  final bool isSelector;
  final void Function(FredericActivity)? onSelect;

  @override
  _ActivitySearcherState createState() => _ActivitySearcherState();
}

class _ActivitySearcherState extends State<ActivitySearcher> {
  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
      body: ChangeNotifierProvider<ActivityFilterController>(
        create: (context) => ActivityFilterController(),
        child: Consumer<ActivityFilterController>(
          builder: (context, filter, child) => CustomScrollView(
            slivers: [
              FredericSliverAppBar(
                height: 130,
                title: 'Search for an Exercise',
                subtitle: 'Find what you are looking for',
                trailing: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: FredericTextField(
                    'Search...',
                    // onSuffixIconTap: () {
                    //   setState(() {
                    //     textController.text = '';
                    //   });
                    // },
                    onColorfulBackground: theme.isColorful,
                    //controller: textController,
                    brightContents: theme.isColorful,
                    icon: Icons.search,
                    size: 20,
                    suffixIcon: Icons.highlight_remove_outlined,
                  ),
                ),
              ),
              ActivityFilterSegment(filterController: filter),
              ActivityListSegment(
                filterController: filter,
                onTap: widget.onSelect,
                isSelector: widget.isSelector,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
