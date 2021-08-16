import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/data_table.dart';
import 'package:frederic/admin_panel/data_table_element.dart';

class AdminUserModel implements DataTableElement<AdminUserModel> {
  AdminUserModel({required this.id, required this.name, this.image});

  AdminUserModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id {
    image = snapshot.data()?['image'];
    name = snapshot.data()?['name'];
    username = snapshot.data()?['username'];
  }

  String id;
  String? image;
  String? name;
  String? username;

  @override
  List<DataColumn> toDataColumn() {
    return <DataColumn>[
      DataColumn(
        label: Text(
          'Picture',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'User ID',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ),
      DataColumn(
        label: Text(
          'Name',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      ),
      DataColumn(
        label: Text(
          'Username',
          style: TextStyle(fontStyle: FontStyle.normal),
        ),
      )
    ];
  }

  @override
  DataRow toDataRow(void Function(AdminUserModel)? onSelectElement) {
    return DataRow(
        onSelectChanged: (t) {
          onSelectElement?.call(this);
        },
        cells: [
          DataCell(Container(
            width: 50,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                  image ?? 'https://via.placeholder.com/300x300?text=profile'),
            ),
          )),
          DataCell(Text(id)),
          DataCell(Text(name ?? '<No Name>')),
          DataCell(Text(username ?? '<No Username>')),
        ]);
  }
}
