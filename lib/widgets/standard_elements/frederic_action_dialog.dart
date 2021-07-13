import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';

class FredericActionDialog extends StatelessWidget {
  const FredericActionDialog(
      {this.child,
      this.title,
      this.actionText = 'Confirm',
      required this.onConfirm,
      this.destructiveAction = false,
      this.infoOnly = false,
      Key? key})
      : super(key: key);

  final Widget? child;
  final String? title;
  final String actionText;
  final bool destructiveAction;
  final bool infoOnly;
  final void Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: Container(
              child: Column(
                children: [
                  if (title != null)
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        title!,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  if (child != null) child!,
                  if (infoOnly)
                    Container(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, bottom: 12, top: 8),
                      child: FredericButton(
                        'Okay',
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  if (!infoOnly)
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding:
                                  EdgeInsets.only(left: 12, bottom: 12, top: 8),
                              child: FredericButton('Cancel',
                                  onPressed: () => Navigator.of(context).pop(),
                                  inverted: true)),
                        ),
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.only(
                                  right: 12, bottom: 12, left: 12, top: 8),
                              child: FredericButton(
                                'Delete',
                                onPressed: onConfirm,
                                mainColor:
                                    destructiveAction ? Colors.red : kMainColor,
                              )),
                        ),
                      ],
                    )
                ],
              ),
              //padding: EdgeInsets.all(16),
            ),
          ),
        ],
      ),
    );
  }
}
