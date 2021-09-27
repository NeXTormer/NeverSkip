import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/models/admin_user_model.dart';
import 'package:frederic/admin_panel/widgets/admin_data_table.dart';
import 'package:frederic/main.dart';

class AdminListUserScreen extends StatefulWidget {
  const AdminListUserScreen({Key? key}) : super(key: key);

  @override
  _AdminListUserScreenState createState() => _AdminListUserScreenState();
}

class _AdminListUserScreenState extends State<AdminListUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance.collection('users').get(),
              builder: (context, data) {
                if (!data.hasData) return Container();
                List<AdminUserModel> users = <AdminUserModel>[];
                for (var doc in data.data?.docs ??
                    <QueryDocumentSnapshot<Map<String, dynamic>>>[]) {
                  users.add(AdminUserModel.fromDocumentSnapshot(doc));
                }
                if (users.isEmpty) return Container();
                return AdminDataTable<AdminUserModel>(
                  elements: users,
                  onSelectElement: (user) => print(user.name),
                );
              }),
        ),
      ),
    );
  }
}
