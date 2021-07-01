import 'package:flutter/material.dart';
import 'package:frederic/misc/ExtraIcons.dart';

import '../../main.dart';

class FredericTextField extends StatefulWidget {
  FredericTextField(
    this.placeholder, {
    this.controller,
    this.onSubmit,
    this.keyboardType = TextInputType.text,
    this.icon = Icons.person,
    this.size = 16,
    this.suffixIcon,
    this.isPasswordField = false,
  });

  final String placeholder;
  final TextInputType keyboardType;
  final IconData icon;
  final IconData? suffixIcon;
  final double size;
  final bool isPasswordField;
  final TextEditingController? controller;

  final Function? onSubmit;

  @override
  _FredericTextFieldState createState() => _FredericTextFieldState();
}

class _FredericTextFieldState extends State<FredericTextField> {
  final Color textColor = Colors.black87;
  final Color disabledBorderColor = Color(0xFFE2E2E2);
  final double height = 44;

  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          fontSize: 12,
          letterSpacing: 0.2,
        ),
        maxLines: 1,
        obscureText: widget.isPasswordField && !showPassword,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: const Color(0xFFA5A5A5)),
          prefixIcon: Icon(
            widget.icon,
            size: widget.size,
            color: const Color(0xFF3E4FD8),
          ),
          suffixIcon: widget.suffixIcon == null
              ? null
              : Icon(
                  widget.suffixIcon,
                  size: widget.size,
                  color: kMainColor,
                ),
          suffix: widget.isPasswordField
              ? Padding(
                  padding: const EdgeInsets.only(right: 8, left: 2),
                  child: GestureDetector(
                    onTap: () => setState(() => showPassword = !showPassword),
                    child: Icon(
                      ExtraIcons.eye,
                      color: showPassword
                          ? Colors.black87
                          : const Color(0xFFC9C9C9),
                      size: 16,
                    ),
                  ),
                )
              : Container(
                  height: 16,
                  width: 0,
                ),
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          hintText: widget.placeholder,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0.6, color: Color(0xFF3E4FD8)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0.6, color: disabledBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(width: 0.6, color: disabledBorderColor),
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 0.6)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 0.6, color: disabledBorderColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(width: 0.6, color: disabledBorderColor)),
        ),
      ),
    );
  }
}
