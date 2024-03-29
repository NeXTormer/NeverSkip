import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_button.dart';
import 'package:image_picker/image_picker.dart';

class ImageAttributeChanger extends StatefulWidget {
  const ImageAttributeChanger({
    required this.currentValue,
    required this.updateValue,
    Key? key,
  }) : super(key: key);

  final String? Function() currentValue;
  final Future<bool> Function(XFile) updateValue;

  @override
  _ImageAttributeChangerState createState() => _ImageAttributeChangerState();
}

class _ImageAttributeChangerState extends State<ImageAttributeChanger> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    String? currentImage = widget.currentValue();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          if (currentImage != null)
            CircleAvatar(
              radius: 80,
              backgroundColor: theme.mainColorLight,
              backgroundImage:
                  loading ? null : CachedNetworkImageProvider(currentImage),
              child: loading
                  ? CupertinoActivityIndicator(
                      radius: 16,
                    )
                  : null,
            ),
          if (currentImage == null)
            CircleAvatar(
              radius: 80,
              backgroundColor: theme.mainColor,
              child: Center(
                child: Text('No Image'),
              ),
            ),
          SizedBox(height: 32),
          Text(tr('settings.user.picture.description')),
          SizedBox(height: 24),
          FredericButton(tr('settings.user.picture.button'), inverted: true,
              onPressed: () async {
            ImagePicker picker = ImagePicker();
            XFile? file = await picker.pickImage(source: ImageSource.gallery);
            if (file != null) {
              setState(() {
                loading = true;
              });
              if (currentImage != null) {
                await CachedNetworkImage.evictFromCache(currentImage);
              }
              await widget.updateValue(file);
              setState(() {
                loading = false;
              });
            }
          }),
        ],
      ),
    );
  }
}
