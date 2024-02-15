import 'package:flutter/cupertino.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

Future<void> showFredericBottomSheet(
    {required BuildContext context,
    bool enableDrag = false,
    bool isDismissible = true,
    required Widget Function(BuildContext) builder}) {
  // Use `CupertinoModalSheetRoute` to show an ios 15 style modal sheet.
  // For declarative navigation (Navigator 2.0), use `CupertinoModalSheetPage` instead.
  print("WERNER FINDENIG");
  final modalRoute = CupertinoModalSheetRoute(
      builder: (context) => DraggableSheet(
          child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: CupertinoColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(16),
                  ),
                ),
              ),
              child: SizedBox.expand(
                child: Builder(builder: builder),
              ))));

  return Navigator.push(context, modalRoute);
}

// Future<void> showFredericBottomSheetOld(
//     {required BuildContext context,
//     bool enableDrag = false,
//     bool isDismissible = true,
//     required Widget Function(BuildContext) builder}) {
//   HapticFeedback.lightImpact();
//
//   return showCupertinoModalSheet(
//     context: context,
//     builder: builder,
//     //barrierDismissible: isDismissible,
//   );
//
//   // return Navigator.of(context)
//   //     .push(CupertinoSheetRoute<void>(builder: builder));
//   // Navigator.of(context)
//   //     .push(SheetRoute<void>(builder: builder, draggable: enableDrag));
// }

// void showOldCupertinoFredericBottomSheet({required BuildContext context, required Widget Function(BuildContext) builder}) {
//   CupertinoScaffold.showCupertinoModalBottomSheet(
//       context: context,
//       builder: builder);
// }
