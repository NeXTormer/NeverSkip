import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../misc/ExtraIcons.dart';
import '../standard_elements/FredericTextField.dart';
import 'activity_filter_controller.dart';

class ActivityHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
        child: Consumer<ActivityFilterController>(
          builder: (context, filter, child) {
            return ActivityHeaderContent(filterController: filter);
          },
        ),
      ),
    );
  }
}

class ActivityHeaderContent extends StatefulWidget {
  ActivityHeaderContent({required this.filterController});

  final ActivityFilterController filterController;

  @override
  _ActivityHeaderContentState createState() => _ActivityHeaderContentState();
}

class _ActivityHeaderContentState extends State<ActivityHeaderContent> {
  final textController = TextEditingController();

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
                      'Search for an exercise',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF272727),
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.6,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      'Exercise List',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF272727),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.1,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              ExtraIcons.bell_1,
              color: Colors.grey,
            )
          ],
        ),
        SizedBox(height: 16),
        FredericTextField(
          'Search exercise',
          controller: textController,
          icon: Icons.search,
          size: 20,
          suffixIcon:
              ExtraIcons.settings, // TODO? Simulare style as in homescreen
        ),
        SizedBox(height: 8),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    textController.addListener(() {
      widget.filterController.searchText = textController.text;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
