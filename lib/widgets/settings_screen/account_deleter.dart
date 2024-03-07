import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/backend/feedback/frederic_feedback_sender.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_multiple_choice.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDeleter extends StatefulWidget {
  const AccountDeleter({Key? key}) : super(key: key);

  @override
  _AccountDeleterState createState() => _AccountDeleterState();
}

class _AccountDeleterState extends State<AccountDeleter> {
  bool confirmed = false;
  bool loading = false;

  TextEditingController feedbackController = TextEditingController();
  FredericMultipleChoiceController mcController =
      FredericMultipleChoiceController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericUserManager, FredericUser>(
      builder: (context, user) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr('settings.user.delete_account.enter_pw_title')),
            SizedBox(height: 16),
            FredericTextField(
              tr('settings.user.delete_account.enter_pw_field'),
              icon: Icons.vpn_key_outlined,
              isPasswordField: true,
              onSubmit: (value) async {
                bool success = false;
                setState(() {
                  loading = true;
                });
                try {
                  success = await FredericBackend
                      .instance.userManager.authInterface
                      .reAuthenticate(user, value);
                } on FirebaseAuthException catch (e) {
                  print(e);
                  setState(() {
                    loading = false;
                    confirmed = false;
                  });
                }

                if (success) {
                  setState(() {
                    loading = false;
                    confirmed = true;
                  });
                } else {
                  setState(() {
                    loading = false;
                    confirmed = false;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Text(tr('settings.user.delete_account.reason.title')),
            SizedBox(height: 16),
            FredericMultipleChoice(<FredericMultipleChoiceElement>[
              FredericMultipleChoiceElement(
                  0,
                  tr('settings.user.delete_account.reason.complicated'),
                  Icons.graphic_eq_outlined,
                  info: 'too-complicated'),
              FredericMultipleChoiceElement(
                  1,
                  tr('settings.user.delete_account.reason.no_need'),
                  Icons.remove_circle_outline,
                  info: 'no-need'),
              FredericMultipleChoiceElement(
                  2,
                  tr('settings.user.delete_account.reason.not_enough_features'),
                  Icons.featured_play_list_outlined,
                  info: 'not-everything-i-need'),
              FredericMultipleChoiceElement(
                  3,
                  tr('settings.user.delete_account.reason.not_working_as_expected'),
                  Icons.leak_remove_outlined,
                  info: 'not-as-expected'),
              FredericMultipleChoiceElement(
                  4,
                  tr('settings.user.delete_account.reason.performance_issues'),
                  Icons.speed_outlined,
                  info: 'bad-performance'),
              FredericMultipleChoiceElement(
                  5,
                  tr('settings.user.delete_account.reason.bugs'),
                  Icons.bug_report_outlined,
                  info: 'bugs')
            ], controller: mcController),
            SizedBox(height: 16),
            FredericTextField(
              tr('settings.user.delete_account.optional_feedback'),
              controller: feedbackController,
              icon: Icons.message_outlined,
            ),
            SizedBox(height: 12),
            Text('settings.user.delete_account.contact').tr(),
            SizedBox(height: 32),
            FredericButton(
              tr('settings.user.delete_account.button'),
              loading: loading,
              onPressed: () async {
                if (!confirmed) return;
                setState(() {
                  loading = true;
                });
                await FredericFeedbackSender.sendDeleteFeedback(
                    feedbackController.text,
                    List<String?>.generate(mcController.selectedElements.length,
                        (index) => mcController.selectedElements[index].info),
                    user);
                await FredericBackend.instance.userManager.authInterface
                    .deleteAccount(user);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                await FredericBackend.instance.deleteEverythingFromDisk();
                FredericBase.forceFullRestart(context);
              },
              mainColor: confirmed ? theme.negativeColor : theme.greyColor,
            ),
            SizedBox(height: 16)
          ],
        ),
      ),
    );
  }
}
