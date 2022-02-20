import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DeleteLocalDocumentsScreen extends StatefulWidget {
  const DeleteLocalDocumentsScreen({Key? key}) : super(key: key);

  @override
  State<DeleteLocalDocumentsScreen> createState() =>
      _DeleteLocalDocumentsScreenState();
}

class _DeleteLocalDocumentsScreenState
    extends State<DeleteLocalDocumentsScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Text('settings.reset_settings.description').tr(),
          const SizedBox(height: 24),
          FredericButton(
            tr('settings.reset_settings.button'),
            onPressed: () async {
              if (loading) return;
              setState(() {
                loading = true;
              });
              await deleteDocuments();
              setState(() {
                loading = false;
              });
              FredericBase.forceFullRestart(context);
            },
            loading: loading,
          )
        ],
      ),
    );
  }

  Future<void> deleteDocuments() async {
    await FirebaseAuth.instance.signOut();
    await Hive.deleteFromDisk();
    await (await SharedPreferences.getInstance()).clear();
  }
}
