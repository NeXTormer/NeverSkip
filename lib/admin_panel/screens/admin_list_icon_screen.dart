import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/models/admin_icon_model.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class AdminListIconScreen extends StatefulWidget {
  const AdminListIconScreen({Key? key}) : super(key: key);

  @override
  _AdminListIconScreenState createState() => _AdminListIconScreenState();
}

class _AdminListIconScreenState extends State<AdminListIconScreen> {
  bool expanded = false;
  AdminIconModel? selectedIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 500,
      //color: Colors.yellow,
      child: FutureBuilder<List<AdminIconModel>>(
          future: getAllIcons('defaultimages'),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: GridView.builder(
                        scrollDirection: Axis.vertical,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 120,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: snapshot.data?.length ?? 0,
                        itemBuilder: (context, index) {
                          AdminIconModel? icon = snapshot.data?[index];
                          if (icon == null) return Container();
                          bool selected = false;
                          if (selectedIcon != null) {
                            selected = selectedIcon!.url == icon.url;
                          }
                          return FredericCard(
                            onTap: () => setState(() {
                              if (selectedIcon == null) {
                                selectedIcon = icon;
                                expanded = true;
                                return;
                              }
                              if (selectedIcon == icon) {
                                selectedIcon = null;
                                expanded = false;
                                return;
                              } else {
                                selectedIcon = icon;
                                expanded = true;
                                return;
                              }
                            }),
                            child: PictureIcon(
                              icon.url,
                              mainColor: selected ? kGreenColor : kMainColor,
                              accentColor:
                                  selected ? kGreenColorLight : kMainColorLight,
                            ),
                          );
                        }),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: expanded ? 350 : 0,
                  )
                ],
              ),
            );
          }),
    );
  }

  Future<List<AdminIconModel>> getAllIcons(String folder) async {
    List<AdminIconModel> icons = <AdminIconModel>[];
    ListResult result = await FirebaseStorage.instance.ref(folder).listAll();
    for (var ref in result.items) {
      icons.add(AdminIconModel(
          ref.name, await ref.getDownloadURL(), <String>[], ref));
    }

    return icons;
  }
}
