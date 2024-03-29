import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';

class ReloadCachesFromDBDialog extends StatefulWidget {
  const ReloadCachesFromDBDialog({Key? key}) : super(key: key);

  @override
  _ReloadCachesFromDBDialogState createState() =>
      _ReloadCachesFromDBDialogState();

  static Future<dynamic> show(
      {required BuildContext context,
      required ReloadCachesFromDBDialog dialog}) {
    return showDialog(context: context, builder: (context) => dialog);
  }
}

class _ReloadCachesFromDBDialogState extends State<ReloadCachesFromDBDialog> {
  bool loading = false;
  String btnText = tr('settings.reload_caches.reload');

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
                borderRadius: BorderRadius.circular(12),
                color: theme.cardBackgroundColor),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      tr('settings.reload_caches.popup_title'),
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(tr('settings.reload_caches.popup_description'),
                        textAlign: TextAlign.center),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding:
                                EdgeInsets.only(left: 12, bottom: 12, top: 8),
                            child: FredericButton(tr('cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                inverted: true)),
                      ),
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(
                                right: 12, bottom: 12, left: 12, top: 8),
                            child: FredericButton(
                              btnText,
                              loading: loading,
                              onPressed: () async {
                                if (btnText !=
                                    tr('settings.reload_caches.reload')) {
                                  Navigator.of(context).pop();
                                  return;
                                }
                                setState(() {
                                  loading = true;
                                });
                                await FredericBackend.instance
                                    .reloadCachesFromDatabase();
                                setState(() {
                                  loading = false;
                                  btnText = tr('settings.reload_caches.done');
                                });
                                await Future.delayed(
                                    const Duration(milliseconds: 300));
                                Navigator.of(context).pop();
                              },
                              mainColor: theme.mainColor,
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
