import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/feedback/frederic_feedback_sender.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';

import '../../backend/authentication/frederic_user.dart';

class FeedbackSenderWidget extends StatefulWidget {
  const FeedbackSenderWidget(this.user, {Key? key}) : super(key: key);

  final FredericUser user;

  @override
  State<FeedbackSenderWidget> createState() => _FeedbackSenderWidgetState();
}

class _FeedbackSenderWidgetState extends State<FeedbackSenderWidget> {
  FredericFeedbackRating? rating;
  bool loading = false;
  bool buttonEnabled = false;
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          FredericHeading.translate('settings.feedback.heading_happiness'),
          const SizedBox(height: 8),
          FredericCard(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = FredericFeedbackRating.Happy;
                        buttonEnabled = true;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox.expand(
                        child: Icon(
                          Icons.sentiment_satisfied_outlined,
                          size: 48,
                          color: rating != null &&
                                  rating == FredericFeedbackRating.Happy
                              ? theme.mainColor
                              : theme.greyTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(thickness: 1),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = FredericFeedbackRating.Neutral;
                        buttonEnabled = true;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox.expand(
                        child: Icon(
                          Icons.sentiment_neutral_outlined,
                          size: 48,
                          color: rating != null &&
                                  rating == FredericFeedbackRating.Neutral
                              ? theme.mainColor
                              : theme.greyTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(thickness: 1),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        rating = FredericFeedbackRating.Unhappy;
                        buttonEnabled = true;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: SizedBox.expand(
                        child: Icon(
                          Icons.sentiment_dissatisfied_outlined,
                          size: 48,
                          color: rating != null &&
                                  rating == FredericFeedbackRating.Unhappy
                              ? theme.mainColor
                              : theme.greyTextColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FredericHeading.translate('settings.feedback.heading_text_feedback'),
          const SizedBox(height: 8),
          FredericTextField(
            '',
            icon: null,
            height: 100,
            controller: textController,
            maxLines: 6,
          ),
          const SizedBox(height: 48),
          FredericButton(
            tr('submit'),
            onPressed: () async {
              if (!buttonEnabled) return;
              if (loading) return;
              setState(() {
                loading = true;
              });
              await FredericFeedbackSender.sendInAppFeedback(
                  widget.user,
                  rating ?? FredericFeedbackRating.Neutral,
                  textController.text);
              setState(() {
                loading = false;
              });

              FredericActionDialog.show(
                  context: context,
                  dialog: FredericActionDialog(
                    title: tr('settings.feedback.thanks'),
                    infoOnly: true,
                    onConfirm: () {
                      Navigator.of(context).pop();
                    },
                  ));
            },
            loading: loading,
            mainColor: buttonEnabled ? theme.mainColor : theme.greyColor,
          )
        ],
      ),
    );
  }
}
