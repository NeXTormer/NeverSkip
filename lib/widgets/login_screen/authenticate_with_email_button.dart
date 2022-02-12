import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/backend/authentication/frederic_auth_event.dart';
import 'package:frederic/backend/authentication/frederic_user_manager.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';
import 'package:frederic/screens/forgot_password_screen.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthenticateWithEmailButton extends StatefulWidget {
  AuthenticateWithEmailButton(
      {this.login = true,
      this.expanded = false,
      this.hasError = false,
      required this.onError,
      Key? key})
      : super(key: key);

  final bool login;
  final bool expanded;
  final bool hasError;

  final void Function(String? error) onError;

  final RegExp emailValidator = RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$");

  final String termsAndContidionsURL =
      'https://hawkford.io/frederic-privacy-policy.html';

  @override
  _AuthenticateWithEmailButtonState createState() =>
      _AuthenticateWithEmailButtonState();
}

class _AuthenticateWithEmailButtonState
    extends State<AuthenticateWithEmailButton> {
  bool expanded = false;
  bool acceptedTermsAndConditions = false;
  String buttonText = '';
  bool loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    expanded = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buttonText = expanded
        ? (widget.login ? tr('login.log_in') : tr('login.sign_up'))
        : (widget.login ? tr('login.log_in_email') : tr('login.sign_up_email'));
    if (loading) {
      if (widget.hasError) {
        loading = false;
      }
    }
    return BlocBuilder<FredericUserManager, FredericUser>(
      builder: (context, user) {
        return Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: expanded ? (widget.login ? 144 : 254) : 0,
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Column(children: [
                  if (!widget.login)
                    FredericTextField(
                      'Name',
                      icon: ExtraIcons.person,
                      controller: nameController,
                    ),
                  if (!widget.login) SizedBox(height: 10),
                  FredericTextField('E-Mail',
                      icon: ExtraIcons.mail, controller: emailController),
                  SizedBox(height: 10),
                  FredericTextField(
                    tr('login.password'),
                    icon: ExtraIcons.lock,
                    isPasswordField: true,
                    controller: passwordController,
                  ),
                  if (!widget.login) SizedBox(height: 10),
                  if (!widget.login)
                    FredericTextField(tr('login.confirm_password'),
                        isPasswordField: true,
                        icon: ExtraIcons.lock,
                        controller: passwordConfirmationController),
                  SizedBox(height: 16),
                  if (widget.login)
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ForgotPasswordScreen();
                          }));
                        },
                        child: Text(
                          tr('login.forgot_password'),
                          style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: theme.textColor),
                        ),
                      ),
                    ),
                  if (!widget.login)
                    GestureDetector(
                      onTap: () => setState(() => acceptedTermsAndConditions =
                          !acceptedTermsAndConditions),
                      onLongPress: () => print('Show Terms and Conditions'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          buildCheckBox(),
                          SizedBox(width: 6),
                          Text('login.agree_tc_1',
                                  style: TextStyle(
                                      fontSize: 11, color: theme.textColor))
                              .tr(),
                          GestureDetector(
                            onTap: () {
                              launch(widget.termsAndContidionsURL);
                            },
                            child: Text('login.agree_tc_2',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        color: theme.textColor))
                                .tr(),
                          ),
                          Text('login.agree_tc_3',
                                  style: TextStyle(
                                      fontSize: 11, color: theme.textColor))
                              .tr()
                        ],
                      ),
                    ),
                  SizedBox(height: 12),
                ]),
              ),
            ),
            FredericButton(
              buttonText,
              loading: loading,
              onPressed: () {
                if (!expanded) {
                  setState(() {
                    expanded = true;
                  });
                } else {
                  buttonHandler();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildCheckBox() {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: const Color(0xFFB8B8B8)),
          color: Colors.white),
      child: acceptedTermsAndConditions
          ? Icon(
              Icons.check,
              size: 12,
              color: const Color(0xFF5C5C5C),
            )
          : null,
    );
  }

  void buttonHandler() {
    String email = emailController.text.trim();
    String name = nameController.text.trim();
    String password = passwordController.text.trim();
    String passwordConfirm = passwordConfirmationController.text.trim();

    if (widget.login) {
      if (email.isEmpty || password.isEmpty) {
        widget.onError(tr('settings.user.change_password.fill_all_fields'));
        return;
      }
      widget.onError(null);
      setState(() {
        loading = true;
      });
      FredericBackend.instance.userManager
          .add(FredericEmailLoginEvent(email, password));
    } else {
      if (email.isEmpty ||
          password.isEmpty ||
          passwordConfirm.isEmpty ||
          name.isEmpty) {
        widget.onError(tr('settings.user.change_password.fill_all_fields'));

        return;
      }

      if (!widget.emailValidator.hasMatch(email)) {
        widget.onError(tr('settings.user.change_password.invalid_email'));

        return;
      }

      if (password != passwordConfirm) {
        widget.onError(tr('settings.user.change_password.no_match'));

        return;
      }

      if (!acceptedTermsAndConditions) {
        widget.onError(tr('login.need_to_accept_tc'));

        return;
      }

      setState(() {
        loading = true;
      });

      FredericBackend.instance.userManager.add(FredericEmailSignupEvent(
          nameController.text.trim(),
          emailController.text.trim(),
          passwordController.text.trim()));
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    passwordConfirmationController.dispose();
  }
}
