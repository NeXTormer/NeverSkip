import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({@required this.imageUrl});

  final String imageUrl;

  Future getImage() async {
    print('TODO: implement file uploading [profile_avatar.dart]');
    final image = await ImagePicker().getImage(source: ImageSource.gallery);
  }

  void handleEditTap(BuildContext context) {
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
          imageUrl != null
              ? CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imageUrl),
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
              onTap: () => handleEditTap(context),
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
