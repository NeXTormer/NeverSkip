import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/misc/ExtraIcons.dart';

import '../../main.dart';

class FredericTextField extends StatefulWidget {
  FredericTextField(this.placeholder,
      {this.controller,
      this.onSubmit,
      this.keyboardType = TextInputType.text,
      this.icon = Icons.person,
      this.size = 16,
      this.height = 44,
      this.maxLines = 1,
      this.suffixIcon,
      this.isPasswordField = false,
      this.verticalContentPadding = 0,
      this.text,
      this.brightContents = false,
      this.maxLength = 200});

  final String placeholder;
  final TextInputType keyboardType;
  final IconData? icon;
  final IconData? suffixIcon;
  final double size;
  final bool isPasswordField;
  final bool brightContents;
  final TextEditingController? controller;
  final double height;
  final int maxLines;
  final double verticalContentPadding;
  final int maxLength;
  final String? text;

  final void Function(String)? onSubmit;

  @override
  _FredericTextFieldState createState() => _FredericTextFieldState();
}

class _FredericTextFieldState extends State<FredericTextField> {
  final Color textColor = Colors.black87;
  final Color disabledBorderColor = Color(0xFFE2E2E2);

  bool showPassword = false;

  @override
  void initState() {
    widget.controller?.text = widget.text ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: TextField(
        onSubmitted: widget.onSubmit,
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        style: TextStyle(
          fontSize: 12,
          color: theme.greyTextColor,
          letterSpacing: 0.2,
        ),
        maxLines: widget.maxLines,
        inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
        obscureText: widget.isPasswordField && !showPassword,
        decoration: InputDecoration(
          hintStyle: TextStyle(color: theme.greyTextColor),
          prefixIcon: widget.icon == null
              ? null
              : Icon(
                  widget.icon,
                  size: widget.size,
                  color: widget.brightContents ? Colors.white : theme.mainColor,
                ),
          suffixIcon: widget.suffixIcon == null
              ? null
              : Icon(
                  widget.suffixIcon,
                  size: widget.size,
                  color: widget.brightContents ? Colors.white : theme.mainColor,
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
          contentPadding: EdgeInsets.symmetric(
              horizontal: widget.icon == null ? 16 : 8,
              vertical: widget.verticalContentPadding),
          hintText: widget.placeholder,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
                width: 0.6,
                color: widget.brightContents ? Colors.white : theme.mainColor),
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
