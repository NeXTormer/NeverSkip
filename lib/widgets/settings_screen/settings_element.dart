import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/settings_screen/change_single_attribute_screen.dart';
import 'package:frederic/widgets/transitions/frederic_container_transition.dart';

class SettingsElement extends StatefulWidget {
  SettingsElement(
      {required this.text,
      this.subText,
      this.icon,
      this.hasSwitch = false,
      this.isFirstItem = false,
      this.isLastItem = false,
      this.changerTitle,
      this.changerSubtitle,
      this.onTap,
      this.infoText,
      this.changeAttributeWidget,
      this.onChanged,
      this.defaultSwitchPosition = false,
      Color? iconBackgroundColor,
      Key? key})
      : super(key: key) {
    this.iconBackgroundColor = iconBackgroundColor ?? theme.mainColor;
  }

  final String text;
  final String? subText;
  final String? changerTitle;
  final String? changerSubtitle;
  final String? infoText;
  final IconData? icon;
  final bool hasSwitch;
  final bool defaultSwitchPosition;
  bool isFirstItem;
  bool isLastItem;
  final void Function()? onTap;
  final void Function(bool state)? onChanged;
  late final Color iconBackgroundColor;
  final Widget? changeAttributeWidget;

  @override
  _SettingsElementState createState() => _SettingsElementState();
}

class _SettingsElementState extends State<SettingsElement> {
  bool switchState = false;

  @override
  void initState() {
    switchState = widget.defaultSwitchPosition;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget container = Container(
        color: theme.cardBackgroundColor,
        padding: EdgeInsets.only(left: widget.icon != null ? 0 : 6, right: 8),
        height: 46,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.icon != null)
              Padding(
                padding: const EdgeInsets.only(
                    top: 6, left: 6, bottom: 6, right: 12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: theme.mainColor),
                      child: Icon(
                        widget.icon!,
                        color: Colors.white,
                      )),
                ),
              ),
            Text(
              widget.text,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: theme.textColor),
            ),
            Expanded(child: Container()),
            if (widget.subText != null) Text(widget.subText!),
            SizedBox(width: 6),
            if (widget.hasSwitch)
              CupertinoSwitch(
                  value: switchState,
                  onChanged: (state) {
                    setState(() {
                      switchState = state;
                    });
                  },
                  activeColor: theme.mainColor),
            if (!widget.hasSwitch)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.greyColor,
              )
          ],
        ));
    ShapeBorder customBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: widget.isFirstItem
                ? const Radius.circular(8)
                : const Radius.circular(0),
            topRight: widget.isFirstItem
                ? const Radius.circular(8)
                : const Radius.circular(0),
            bottomRight: widget.isLastItem
                ? const Radius.circular(8)
                : const Radius.circular(0),
            bottomLeft: widget.isLastItem
                ? const Radius.circular(8)
                : const Radius.circular(0)));
    if (widget.hasSwitch) return container;
    if (widget.onTap != null)
      return InkWell(
          child: container,
          onTap: widget.onTap,
          customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: widget.isFirstItem
                      ? const Radius.circular(8)
                      : const Radius.circular(0),
                  topRight: widget.isFirstItem
                      ? const Radius.circular(8)
                      : const Radius.circular(0),
                  bottomRight: widget.isLastItem
                      ? const Radius.circular(8)
                      : const Radius.circular(0),
                  bottomLeft: widget.isLastItem
                      ? const Radius.circular(8)
                      : const Radius.circular(0))));

    return FredericContainerTransition(
      closedBorderRadius: 0,
      customBorder: customBorder,
      expandedChild: ChangeSingleAttributeScreen(
          widget.changeAttributeWidget ?? Container(),
          infoText: widget.infoText,
          subtitle: widget.changerSubtitle,
          title: widget.changerTitle ?? 'Change Attribute'),
      childBuilder: (context, openContainer) => InkWell(
        onTap: openContainer,
        child: container,
        customBorder: customBorder,
      ),
    );
  }
}
