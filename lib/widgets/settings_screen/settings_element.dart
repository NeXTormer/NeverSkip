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
      this.clickable = true,
      this.changerTitle,
      this.changerSubtitle,
      this.onTap,
      this.infoText,
      this.changeAttributeWidget,
      this.changeAttributeSliver,
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
  final bool clickable;
  final bool hasSwitch;
  final bool? defaultSwitchPosition;
  bool isFirstItem;
  bool isLastItem;
  final void Function()? onTap;
  final Future<bool> Function(bool state)? onChanged;
  late final Color iconBackgroundColor;
  final Widget? changeAttributeWidget;
  final Widget? changeAttributeSliver;

  @override
  _SettingsElementState createState() => _SettingsElementState();
}

class _SettingsElementState extends State<SettingsElement> {
  bool switchState = false;

  @override
  void initState() {
    super.initState();
    switchState = widget.defaultSwitchPosition ?? false;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle mainTextStyle = TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: theme.textColor);

    TextStyle subTextStyle = TextStyle();

    BorderRadius borderRadius = BorderRadius.only(
        topLeft: widget.isFirstItem
            ? const Radius.circular(9)
            : const Radius.circular(0),
        topRight: widget.isFirstItem
            ? const Radius.circular(9)
            : const Radius.circular(0),
        bottomRight: widget.isLastItem
            ? const Radius.circular(9)
            : const Radius.circular(0),
        bottomLeft: widget.isLastItem
            ? const Radius.circular(9)
            : const Radius.circular(0));
    ShapeBorder customBorder =
        RoundedRectangleBorder(borderRadius: borderRadius);
    Widget container = Container(
        padding: EdgeInsets.only(left: widget.icon != null ? 0 : 6, right: 8),
        //height: ,
        decoration: BoxDecoration(
            //color:
            //  true ? Colors.white.withOpacity(1) : theme.cardBackgroundColor,
            borderRadius: borderRadius,
            border: Border.all(color: Colors.transparent)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (widget.icon != null)
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(height: 44),
                child: Padding(
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
              ),
            Expanded(
              child: Container(
                //color: Colors.red,
                child: LayoutBuilder(builder: (context, constraints) {
                  Size mainTextSize = _textSize(widget.text, mainTextStyle);
                  Size subTextSize = widget.subText == null
                      ? Size.square(0)
                      : _textSize(widget.subText!, subTextStyle);
                  const double padding = 30;
                  double totalLength =
                      mainTextSize.width + subTextSize.width + padding;
                  int lines = totalLength ~/ constraints.maxWidth;
                  lines++;
                  bool mainTextTooLong = (mainTextSize.width + padding + 10) >
                      constraints.maxWidth;
                  return ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(height: lines * 12 + 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                widget.text,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: mainTextStyle,
                              ),
                            ),
                            if (widget.subText != null && lines == 1)
                              Text(
                                widget.subText!,
                                maxLines: 1,
                                textAlign: TextAlign.right,
                                style: subTextStyle,
                              ),
                            if (widget.subText != null && lines == 1)
                              SizedBox(width: 6),
                            if (widget.hasSwitch &&
                                widget.defaultSwitchPosition == null)
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: theme.mainColor,
                                ),
                              ),
                            if (widget.hasSwitch &&
                                widget.defaultSwitchPosition != null)
                              CupertinoSwitch(
                                  value: switchState,
                                  onChanged: (state) async {
                                    if (widget.onChanged == null ||
                                        await widget.onChanged!(state)) {
                                      setState(() {
                                        switchState = state;
                                      });
                                    }
                                  },
                                  activeColor: theme.mainColor),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            if (widget.subText != null && lines == 2)
                              Expanded(
                                child: Text(
                                  widget.subText!,
                                  maxLines: 1,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  style: subTextStyle,
                                ),
                              ),
                            if (widget.subText != null && lines == 2)
                              SizedBox(width: 18),
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ),
            ),
            if (!widget.hasSwitch && widget.clickable)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.greyColor,
              ),
          ],
        ));
    if (widget.hasSwitch || !widget.clickable)
      return Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: container,
      );
    if (widget.onTap != null)
      return Material(
        borderRadius: borderRadius,
        color: theme.cardBackgroundColor,
        child: InkWell(
            child: container,
            onTap: widget.onTap,
            customBorder: RoundedRectangleBorder(borderRadius: borderRadius)),
      );

    return FredericContainerTransition(
      closedBorderRadius: 0,
      customBorder: customBorder,
      expandedChild: ChangeSingleAttributeScreen(
          changeAttributeWidget: widget.changeAttributeWidget == null &&
                  widget.changeAttributeSliver == null
              ? Container()
              : widget.changeAttributeWidget,
          changeAttributeSliver: widget.changeAttributeSliver,
          infoText: widget.infoText,
          subtitle: widget.changerSubtitle,
          title: widget.changerTitle ?? 'Change Attribute'),
      childBuilder: (context, openContainer) => Material(
        color: theme.cardBackgroundColor,
        child: InkWell(
          onTap: openContainer,
          child: container,
          customBorder: customBorder,
        ),
      ),
    );
  }

  Size _textSize(String text, TextStyle? style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }
}
