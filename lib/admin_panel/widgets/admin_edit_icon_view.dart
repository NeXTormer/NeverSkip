import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/models/admin_icon_model.dart';
import 'package:frederic/admin_panel/widgets/admin_tag_list.dart';
import 'package:frederic/widgets/standard_elements/frederic_action_dialog.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';
import 'package:frederic/widgets/standard_elements/frederic_heading.dart';
import 'package:frederic/widgets/standard_elements/frederic_text_field.dart';
import 'package:frederic/widgets/standard_elements/picture_icon.dart';

class AdminEditIconView extends StatefulWidget {
  const AdminEditIconView(this.icon, {Key? key}) : super(key: key);

  final AdminIconModel icon;

  @override
  _AdminEditIconViewState createState() => _AdminEditIconViewState();
}

class _AdminEditIconViewState extends State<AdminEditIconView> {
  TextEditingController tagController = TextEditingController();
  List<String> tags = <String>[];

  @override
  void initState() {
    tags = widget.icon.tags;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FredericHeading('Icon'),
              const SizedBox(height: 8),
              Center(
                child: FractionallySizedBox(
                    widthFactor: 0.5,
                    child: FredericCard(child: PictureIcon(widget.icon.url))),
              ),
              const SizedBox(height: 16),
              FredericButton('Upload new Icon',
                  onPressed: changeIcon, inverted: true),
              const SizedBox(height: 16),
              FredericHeading('File Name'),
              const SizedBox(height: 8),
              Text(widget.icon.name),
              const SizedBox(height: 16),
              FredericHeading('Tags'),
              const SizedBox(height: 8),
              Text(
                'Set file tags to make the icon easier to find.\nEach tag contains only one word with no special characters!',
                textAlign: TextAlign.start,
              ),
              AdminTagList(
                tags,
                onDeleteElement: (index) {
                  setState(() {
                    tags.removeAt(index);
                  });
                },
              ),
              const SizedBox(height: 8),
              FredericHeading('Add Tag'),
              const SizedBox(height: 8),
              FredericTextField(
                'Add a new tag',
                icon: null,
                controller: tagController,
                onSubmit: (newTag) => setState(() {
                  if (newTag.trim().isNotEmpty && !tags.contains(newTag)) {
                    tags.add(newTag);
                  }
                  tagController.text = '';
                }),
              ),
              const SizedBox(height: 16),
              FredericHeading('Save or Delete'),
              const SizedBox(height: 8),
              FredericButton('Save', onPressed: save),
              const SizedBox(height: 16),
              FredericButton(
                'Delete',
                onPressed: delete,
                inverted: true,
                mainColor: Colors.red,
              ),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }

  void save() async {
    Reference ref = widget.icon.reference;
    String tagsString = '';
    for (String tag in tags) tagsString += (tag + ',');
    //remove last comma
    if (tagsString.endsWith(',')) {
      tagsString = tagsString.substring(0, tagsString.length - 1);
    }
    SettableMetadata metadata =
        SettableMetadata(customMetadata: <String, String>{'tags': tagsString});
    await ref.updateMetadata(metadata);
    FredericActionDialog.show(
        context: context,
        dialog: FredericActionDialog(
            onConfirm: () {},
            infoOnly: true,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Saved Icon'),
            )));
  }

  void delete() {
    FredericActionDialog.show(
        context: context,
        dialog: FredericActionDialog(
          destructiveAction: true,
          title: 'Delete this Icon?',
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
                'Do you really want to delete this icon? This action cannot be undone!'),
          ),
          onConfirm: () {
            widget.icon.reference.delete();
            Navigator.of(context).pop();
          },
        ));
  }

  void changeIcon() {}
}
