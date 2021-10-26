import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_basic_app_bar.dart';
import 'package:frederic/widgets/standard_elements/sliver_divider.dart';

class ChangeSingleAttributeScreen extends StatefulWidget {
  const ChangeSingleAttributeScreen(
      {required this.title,
      this.changeAttributeWidget,
      this.changeAttributeSliver,
      this.subtitle,
      this.infoText,
      Key? key})
      : super(key: key);

  final Widget? changeAttributeWidget;
  final Widget? changeAttributeSliver;
  final String title;
  final String? subtitle;
  final String? infoText;

  @override
  _ChangeSingleAttributeScreenState createState() =>
      _ChangeSingleAttributeScreenState();
}

class _ChangeSingleAttributeScreenState
    extends State<ChangeSingleAttributeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: theme.backgroundColor,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: FredericBasicAppBar(
                    title: widget.title, subtitle: widget.subtitle)),
            if (theme.isMonotone) SliverDivider(),
            SliverPadding(padding: const EdgeInsets.only(bottom: 12)),
            if (widget.infoText != null)
              SliverPadding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                sliver: SliverToBoxAdapter(
                    child: Text(
                  widget.infoText!,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    color: theme.textColor,
                  ),
                )),
              ),
            if (widget.changeAttributeSliver != null)
              widget.changeAttributeSliver!,
            if (widget.changeAttributeWidget != null)
              SliverToBoxAdapter(
                child: widget.changeAttributeWidget,
              )
          ],
        ));
  }
}

class AttributePicker {
  AttributePicker({required this.picker});

  final Widget picker;
}
