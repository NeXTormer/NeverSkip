import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatefulWidget {
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File _image;
  String _imgUrl =
      'https://soziotypen.de/wp-content/uploads/2020/01/Sascha-Huber.jpg';

  Future getImage() async {
    final image = await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(image.path);
    });
  }

  void onEditTap() {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      context: context,
      builder: (_) => Container(
        height: 400,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Change Profile Picture'),
              onTap: getImage,
            ),
            Divider(),
            Text('Edit Profile Text'),
            TextField(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Stack(
        children: [
          _image != null
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(_image),
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.grey[200],
                  ),
                  width: 120,
                  height: 120,
                  child: Icon(Icons.camera_alt),
                ),
          Positioned(
            right: 0.0,
            bottom: 0.0,
            child: GestureDetector(
              onTap: () => onEditTap(),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.blue,
                child: CircleAvatar(
                  radius: 18.5,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.edit,
                    size: 25.0,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
