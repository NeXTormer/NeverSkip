import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheet/route.dart';
import 'package:sheet/sheet.dart';

Future<void> showFredericBottomSheet(
    {required BuildContext context,
    bool enableDrag = false,
    bool isDismissible = false,
    required Widget Function(BuildContext) builder}) {
  HapticFeedback.lightImpact();
  return Navigator.of(context)
      .push(CupertinoSheetRoute<void>(builder: builder));
  // Navigator.of(context)
  //     .push(SheetRoute<void>(builder: builder, draggable: enableDrag));
}

// void showOldCupertinoFredericBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder}) {
//   CupertinoScaffold.showCupertinoModalBottomSheet(
//       context: context,
//       builder: builder);
// }
