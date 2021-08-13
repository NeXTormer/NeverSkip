import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';

class SettingsSegment extends StatefulWidget {
  const SettingsSegment({required this.title, required this.elements, Key? key})
      : super(key: key);

  final String title;
  final List<SettingsElement> elements;

  @override
  _SettingsSegmentState createState() => _SettingsSegmentState();
}

class _SettingsSegmentState extends State<SettingsSegment> {
  late List<bool> buttonStates;

  @override
  void initState() {
    buttonStates = List<bool>.filled(widget.elements.length, false);
    for (int i = 0; i < widget.elements.length; i++) {
      buttonStates[i] = widget.elements[i].defaultSwitchPosition;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: FredericHeading(widget.title),
            ),
            SizedBox(height: 8),
            FredericCard(
              child: Column(
                children: List.generate(
                    widget.elements.length + (widget.elements.length - 1),
                    (index) => index % 2 == 1
                        ? Container(
                            height: 1,
                            color: Colors.black12,
                          )
                        : buildSettingsElement(
                            context, widget.elements[index ~/ 2], index ~/ 2)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsElement(
      BuildContext context, SettingsElement element, int index) {
    bool isFirst = index == 0;
    bool isLast = index == widget.elements.length - 1;
    return InkWell(
      onTap: element.hasSwitch ? null : element.onTap,
      customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft:
                  isFirst ? const Radius.circular(8) : const Radius.circular(0),
              topRight:
                  isFirst ? const Radius.circular(8) : const Radius.circular(0),
              bottomRight:
                  isLast ? const Radius.circular(8) : const Radius.circular(0),
              bottomLeft: isLast
                  ? const Radius.circular(8)
                  : const Radius.circular(0))),
      child: Container(
          padding:
              EdgeInsets.only(left: element.icon != null ? 0 : 6, right: 8),
          height: 46,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (element.icon != null)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 6, left: 6, bottom: 6, right: 12),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: kMainColor),
                        child: Icon(
                          element.icon!,
                          color: Colors.white,
                        )),
                  ),
                ),
              Text(
                element.text,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: kTextColor),
              ),
              Expanded(child: Container()),
              if (element.subText != null) Text(element.subText!),
              SizedBox(width: 6),
              if (element.hasSwitch)
                CupertinoSwitch(
                    value: buttonStates[index],
                    onChanged: (state) {
                      setState(() {
                        buttonStates[index] = state;
                      });
                    },
                    activeColor: kMainColor),
              if (!element.hasSwitch)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: kGreyColor,
                )
            ],
          )),
    );
  }
}

class SettingsElement {
  SettingsElement(
      {required this.text,
      this.subText,
      this.icon,
      this.hasSwitch = false,
      this.onTap,
      this.onChanged,
      this.defaultSwitchPosition = false,
      this.iconBackgroundColor = kMainColor});

  final String text;
  final String? subText;
  final IconData? icon;
  final bool hasSwitch;
  final bool defaultSwitchPosition;
  final void Function()? onTap;
  final void Function(bool state)? onChanged;
  final Color iconBackgroundColor;
}
