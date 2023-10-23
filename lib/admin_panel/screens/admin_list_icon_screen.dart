import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frederic/admin_panel/backend/admin_icon_manager.dart';
import 'package:frederic/admin_panel/models/admin_icon_model.dart';
import 'package:frederic/admin_panel/widgets/admin_edit_icon_view.dart';
import 'package:frederic/admin_panel/widgets/admin_select_filter_type.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class AdminListIconScreen extends StatefulWidget {
  const AdminListIconScreen({this.onSelect, Key? key}) : super(key: key);

  final void Function(AdminIconModel)? onSelect;

  @override
  _AdminListIconScreenState createState() => _AdminListIconScreenState();
}

class _AdminListIconScreenState extends State<AdminListIconScreen> {
  bool expanded = false;
  AdminIconModel? selectedIcon;

  TextEditingController searchController = TextEditingController();

  // matchAll = false: matchAny
  bool matchAll = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 16, bottom: 0),
              child: Row(
                children: [
                  Expanded(
                      child: FredericTextField(
                          'Search for tags, separated by commas.',
                          controller: searchController,
                          onSubmit: (text) => setState(() {}),
                          icon: Icons.image_search)),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        searchController.text = '';
                      });
                    },
                    child: Icon(
                      Icons.highlight_remove_outlined,
                      color: theme.mainColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  AdminSelectFilterType(
                      matchAny: !matchAll,
                      onChange: (matchAny) {
                        setState(() {
                          matchAll = !matchAny;
                        });
                      }),
                  SizedBox(width: 16),
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: theme.mainColor,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: BlocBuilder<AdminIconManager, AdminIconListData>(
                builder: (context, iconListData) {
              List<AdminIconModel> icons =
                  iconListData.filtered(searchController.text, matchAll);
              return Padding(
                padding: const EdgeInsets.only(left: 16, top: 12, bottom: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 120,
                            childAspectRatio: 1,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemCount: icons.length,
                          itemBuilder: (context, index) {
                            AdminIconModel icon = icons[index];
                            bool selected = false;
                            if (selectedIcon != null) {
                              selected = selectedIcon!.url == icon.url;
                            }
                            return FredericCard(
                              onTap: () {
                                if (widget.onSelect != null) {
                                  widget.onSelect!(icon);
                                  return;
                                }
                                setState(() {
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
                                });
                              },
                              child: PictureIcon(
                                icon.url,
                                mainColor: selected
                                    ? theme.positiveColor
                                    : theme.mainColor,
                                accentColor: selected
                                    ? theme.positiveColorLight
                                    : theme.mainColorLight,
                              ),
                            );
                          }),
                    ),
                    AnimatedContainer(
                      margin: const EdgeInsets.only(left: 16),
                      duration: const Duration(milliseconds: 200),
                      width: expanded ? 400 : 0,
                      child: expanded
                          ? AdminEditIconView(
                              selectedIcon!,
                              key: ValueKey(selectedIcon!.url),
                            )
                          : null,
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
