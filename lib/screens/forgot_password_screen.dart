import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_scaffold.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailController = TextEditingController();

  String errorText = '';
  String successText = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return FredericScaffold(
        body: Column(
      children: [
        FredericBasicAppBar(
          title: 'Reset Password',
          icon: Icon(
            Icons.settings_backup_restore_outlined,
            color: theme.mainColor,
          ),
          subtitle: 'Enter your E-Mail to reset your password',
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              FredericTextField(
                'Enter your E-Mail address',
                icon: Icons.mail_outline_rounded,
                controller: emailController,
              ),
              SizedBox(height: 12),
              Align(
                alignment: Alignment.center,
                child: Text(errorText,
                    style: TextStyle(color: theme.negativeColor, fontSize: 14)),
              ),
              Align(
                alignment: Alignment.center,
                child: Text(successText,
                    style: TextStyle(color: theme.positiveColor, fontSize: 16)),
              ),
              SizedBox(height: 12),
              if (successText == '')
                FredericButton('Send reset link',
                    onPressed: buttonHandler, loading: loading),
              if (successText != '')
                FredericButton('Close',
                    onPressed: () => Navigator.of(context).pop())
            ],
          ),
        ),
      ],
    ));
  }

  void buttonHandler() async {
    String email = emailController.text;
    if (email.isEmpty) {
      setState(() {
        errorText = 'Provide an E-Mail address to send the link to.';
      });
      return;
    }
    setState(() {
      loading = true;
      errorText = '';
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        setState(() {
          errorText = 'Invalid E-Mail';
          loading = false;
        });
        return;
      } else if (e.code == 'user-not-found') {
        setState(() {
          errorText = 'There is no user with this E-Mail address.';
          loading = false;
        });
        return;
      }
    }

    setState(() {
      loading = false;
      successText = 'Reset link sent!';
    });
  }
}
