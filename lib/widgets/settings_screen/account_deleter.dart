import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
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
            Text('Enter your password below to make sure its you.'),
            SizedBox(height: 16),
            FredericTextField(
              'Enter your password',
              icon: Icons.vpn_key_outlined,
              isPasswordField: true,
              onSubmit: (value) async {
                AuthCredential cred = EmailAuthProvider.credential(
                    email: user.email, password: value);
                bool success = false;
                setState(() {
                  loading = true;
                });
                try {
                  await FirebaseAuth.instance.currentUser
                      ?.reauthenticateWithCredential(cred);
                  success = true;
                } on FirebaseAuthException catch (e) {
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
            Text('Please tell us why you want to delete your account.'),
            SizedBox(height: 16),
            FredericMultipleChoice(<FredericMultipleChoiceElement>[
              FredericMultipleChoiceElement(
                  0, 'It\'s too complicated', Icons.graphic_eq_outlined,
                  info: 'too-complicated'),
              FredericMultipleChoiceElement(
                  1, 'I don\'t need it', Icons.remove_circle_outline,
                  info: 'no-need'),
              FredericMultipleChoiceElement(
                  2,
                  'It doensn\'t do everything I need',
                  Icons.featured_play_list_outlined,
                  info: 'not-everything-i-need'),
              FredericMultipleChoiceElement(
                  3, 'It didn\'t work as expected', Icons.leak_remove_outlined,
                  info: 'not-as-expected'),
              FredericMultipleChoiceElement(
                  4, 'Performance issues or lag', Icons.speed_outlined,
                  info: 'bad-performance'),
              FredericMultipleChoiceElement(
                  5, 'Too many errors/bugs', Icons.bug_report_outlined,
                  info: 'bugs')
            ], controller: mcController),
            SizedBox(height: 16),
            FredericTextField(
              'Optional Feedback',
              controller: feedbackController,
              icon: Icons.message_outlined,
            ),
            SizedBox(height: 12),
            Text(
                'If you have any issues or suggestions you can also contact us per E-Mail at office@hawkford.io.'),
            SizedBox(height: 32),
            FredericButton(
              'Delete account forever',
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
                await FredericBackend.instance.userManager
                    .deleteUser(confirmed);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                FredericBase.forceFullRestart(context);
              },
              mainColor: confirmed ? theme.negativeColor : theme.greyColor,
            )
          ],
        ),
      ),
    );
  }
}
