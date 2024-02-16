import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sheet/route.dart';

Future<void> showFredericBottomSheet(
    {required BuildContext context,
    bool enableDrag = false,
    bool isDismissible = true,
    required Widget Function(BuildContext) builder}) {
  HapticFeedback.lightImpact();
  return Navigator.of(context).push(CupertinoSheetRoute<void>(
    stops: isDismissible ? <double>[0, 1] : <double>[1],
    builder: builder,
  ));
}
