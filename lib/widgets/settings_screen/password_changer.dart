import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';

class PasswordChanger extends StatefulWidget {
  const PasswordChanger({Key? key}) : super(key: key);

  @override
  _PasswordChangerState createState() => _PasswordChangerState();
}

class _PasswordChangerState extends State<PasswordChanger> {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordRepeatController = TextEditingController();

  bool hasError = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            FredericHeading('Current Password'),
            SizedBox(height: 6),
            FredericTextField(
              'Enter your current password',
              brightContents: theme.isDark,
              controller: oldPasswordController,
              onSubmit: (value) {},
              icon: null,
            ),
            SizedBox(height: 16),
            FredericHeading('New Password'),
            SizedBox(height: 6),
            FredericTextField(
              'Enter your new password',
              brightContents: theme.isDark,
              controller: newPasswordController,
              onSubmit: (value) {},
              icon: null,
            ),
            SizedBox(height: 16),
            FredericHeading('Repeat new password'),
            SizedBox(height: 6),
            FredericTextField(
              'Repeat your new password',
              brightContents: theme.isDark,
              controller: newPasswordRepeatController,
              onSubmit: (value) {},
              icon: null,
            ),
            SizedBox(height: 12),
            Align(
              alignment: Alignment.center,
              child: Text(errorText,
                  style: TextStyle(color: Colors.redAccent, fontSize: 14)),
            ),
            SizedBox(height: 12),
            FredericButton('Change Password', onPressed: () {})
          ],
        ));
  }
}
