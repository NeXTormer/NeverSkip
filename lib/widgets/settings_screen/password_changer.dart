import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_user.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
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
  bool loading = false;
  bool finished = false;
  String errorText = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FredericUserManager, FredericUser>(
      builder: (context, user) {
        print('rebuilt');
        return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                FredericHeading(tr('settings.user.change_password.current')),
                SizedBox(height: 6),
                FredericTextField(
                  tr('settings.user.change_password.current_field'),
                  isPasswordField: true,
                  brightContents: theme.isDark,
                  controller: oldPasswordController,
                  onSubmit: (value) {},
                  icon: null,
                ),
                SizedBox(height: 16),
                FredericHeading(tr('settings.user.change_password.new')),
                SizedBox(height: 6),
                FredericTextField(
                  tr('settings.user.change_password.new_field'),
                  brightContents: theme.isDark,
                  isPasswordField: true,
                  controller: newPasswordController,
                  onSubmit: (value) {},
                  icon: null,
                ),
                SizedBox(height: 16),
                FredericHeading(tr('settings.user.change_password.repeat')),
                SizedBox(height: 6),
                FredericTextField(
                  tr('settings.user.change_password.repeat_field'),
                  brightContents: theme.isDark,
                  isPasswordField: true,
                  controller: newPasswordRepeatController,
                  onSubmit: (value) {},
                  icon: null,
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Text(errorText,
                      style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                ),
                if (finished)
                  Align(
                    alignment: Alignment.center,
                    child: Text(tr('settings.user.change_password.success'),
                        style: TextStyle(
                            color: theme.positiveColor, fontSize: 16)),
                  ),
                SizedBox(height: 12),
                if (finished)
                  FredericButton(tr('close'),
                      onPressed: () => Navigator.of(context).pop()),
                if (finished) SizedBox(height: 16),
                if (!finished)
                  FredericButton(tr('settings.user.change_password.button'),
                      onPressed: () => buttonHandler(context), loading: loading)
              ],
            ));
      },
    );
  }

  void buttonHandler(BuildContext context) async {
    String oldPassword = oldPasswordController.text.trim();
    String password = newPasswordController.text.trim();
    String passwordConfirm = newPasswordRepeatController.text.trim();

    if (oldPassword.isEmpty || password.isEmpty || passwordConfirm.isEmpty) {
      setState(() {
        hasError = true;
        errorText = tr('settings.change_password.fill_all_fields');
      });
      return;
    }

    if (password != passwordConfirm) {
      setState(() {
        hasError = true;
        errorText = tr('settings.change_password.no_match');
      });
      return;
    }

    if (FirebaseAuth.instance.currentUser == null ||
        FirebaseAuth.instance.currentUser!.email == null) {
      setState(() {
        hasError = true;
        errorText = tr('settings.change_password.no_user');
      });
      return;
    }
    setState(() {
      loading = true;
    });

    final credential = EmailAuthProvider.credential(
        email: FirebaseAuth.instance.currentUser!.email!,
        password: oldPassword);

    try {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          hasError = true;
          errorText = tr('settings.change_password.wrong_password');
          loading = false;
        });
      }
      setState(() {
        hasError = true;
        errorText = tr('settings.change_password.other_error', args: [e.code]);
        loading = false;
      });
      return;
    }
    if (FirebaseAuth.instance.currentUser == null) return;

    try {
      FirebaseAuth.instance.currentUser!.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        setState(() {
          hasError = true;
          errorText = tr('settings.change_password.weak_password');
          loading = false;
        });
        return;
      }
    }
    setState(() {
      loading = false;
      hasError = false;
      finished = true;
    });
  }
}
