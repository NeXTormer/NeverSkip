import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

class PickBannerImage extends StatefulWidget {
  PickBannerImage(this.user);
  final FredericUser user;
  @override
  _PickBannerImageState createState() => _PickBannerImageState();
}

class _PickBannerImageState extends State<PickBannerImage> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  child: Image.network(
                    widget.user.banner,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        // TODO
                        // Open image picker
                        print('Open Image picker');
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(50),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            width: 5,
                            color: Colors.black.withAlpha(80),
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildDialogButton('Cancel', Colors.redAccent, () {
                    Navigator.of(context).pop();
                  }),
                  SizedBox(width: 10),
                  _buildDialogButton('Save', Colors.lightBlue, () {
                    // TODO
                    // Save banner image
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildDialogButton(String text, Color color, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
