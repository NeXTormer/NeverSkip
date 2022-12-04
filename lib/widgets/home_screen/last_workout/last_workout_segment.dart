import 'dart:io';
import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/home_screen/last_workout/last_workout_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:social_share/social_share.dart';

class LastWorkoutSegment extends StatefulWidget {
  const LastWorkoutSegment({Key? key}) : super(key: key);

  @override
  State<LastWorkoutSegment> createState() => _LastWorkoutSegmentState();
}

class _LastWorkoutSegmentState extends State<LastWorkoutSegment> {
  bool screenshot = false;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            children: [
              if (screenshot)
                FredericCard(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text(
                          tr('app_name'),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: theme.mainColor,
                              letterSpacing: 0.6),
                        ),
                        Text(
                          tr('progress.my_last_workout'),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: theme.textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (!screenshot)
                FredericHeading(
                  tr('progress.my_last_workout'),
                  icon: screenshot
                      ? null
                      : (Platform.isAndroid
                      ? Icons.share_outlined
                      : Icons.ios_share),
                  onPressed: () => handleShare(context),
                ),
              const SizedBox(height: 8),
              FredericCard(
                child: LastWorkoutCard(
                  screenshot: screenshot,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void handleShare(BuildContext context) async {
    setState(() {
      screenshot = true;
    });

    await Future.delayed(const Duration(milliseconds: 1));

    Uint8List? image = await screenshotController.capture(
        pixelRatio: MediaQuery
            .of(context)
            .devicePixelRatio);

    setState(() {
      screenshot = false;
    });

    if (image == null) return;

    final directory = await getApplicationDocumentsDirectory();
    final file = await File('${directory.path}/temp.png').create();
    await file.writeAsBytes(image);

    FredericActionDialog.show(
        context: context,
        dialog: FredericActionDialog(
          onConfirm: () {},
          infoOnly: true,
          title: tr('sharing.share_to'),
          noOkayButton: true,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                FredericButton(tr('sharing.share_to_instagram_stories'),
                    onPressed: () async {
                      final result = await SocialShare.shareInstagramStory(
                          imagePath:
                          file.path,
                          backgroundTopColor:
                          '#${theme.mainColor.value.toRadixString(16)}',
                          backgroundBottomColor:
                          '#${theme.accentColor.value.toRadixString(16)}',
                          attributionURL: 'https://neverskipfitness.com',
                          appId: '');
                      print(result);
                      Navigator.of(context).pop();
                    }),
                const SizedBox(height: 8),
                FredericButton(tr('sharing.share_to_other'), onPressed: () {
                  final result = SocialShare.shareOptions(
                      tr('progress.my_last_workout'),
                      imagePath: file.path);
                  print(result);
                  Navigator.of(context).pop();
                }),
                const SizedBox(height: 12),
                FredericButton(
                  tr('cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  inverted: true,
                )
              ],
            ),
          ),
        ));
  }
}
