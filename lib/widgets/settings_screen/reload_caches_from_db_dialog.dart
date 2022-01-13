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
  String btnText = 'Reload';

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
                      'Reload cached data from the Database?',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                        'Reload if you think the cached data might be corrupted.',
                        textAlign: TextAlign.center),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            padding:
                                EdgeInsets.only(left: 12, bottom: 12, top: 8),
                            child: FredericButton('Cancel',
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
                                if (btnText != 'Reload') {
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
                                  btnText = 'Done!';
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
