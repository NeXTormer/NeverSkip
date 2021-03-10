import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField(
      {Key key,
      @required this.validator,
      @required this.controller,
      @required this.titleText,
      @required this.hintText,
      @required this.iconData,
      this.obscureText = false})
      : super(key: key);

  final Function validator;
  final TextEditingController controller;
  final String titleText;
  final String hintText;
  final bool obscureText;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titleText,
              style: GoogleFonts.varelaRound(
                  textStyle: TextStyle(color: Colors.white, fontSize: 18))),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    offset: Offset(0, 3),
                    color: Colors.black12,
                  )
                ]),
            child: TextFormField(
              style: TextStyle(color: kTextColor),
              validator: validator,
              obscureText: obscureText,
              controller: controller,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(iconData, color: Colors.blue),
                  hintText: hintText,
                  hintStyle: GoogleFonts.varelaRound(
                      textStyle:
                          TextStyle(color: Colors.blue[200], fontSize: 18))),
            ),
          ),
        ],
      ),
    );
  }
}
