import 'package:flutter/material.dart';

class KeepSignedIn extends StatefulWidget {
  KeepSignedIn(this.text, this.executeOnTrue);
  final String text;
  final Function executeOnTrue;

  @override
  _KeepSignedInState createState() => _KeepSignedInState();
}

class _KeepSignedInState extends State<KeepSignedIn> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        SizedBox(width: 10),
        InkWell(
          onTap: () {
            setState(() {
              _value = !_value;
              if (_value) {
                widget.executeOnTrue();
              }
            });
          },
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: _value ? Colors.lightBlue : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: _value
                  ? null
                  : Border.all(
                      width: 3,
                      color: Colors.black45,
                    ),
            ),
            child: _value
                ? Center(
                    child: Icon(
                      Icons.done,
                      color: Colors.white,
                      size: 19,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
