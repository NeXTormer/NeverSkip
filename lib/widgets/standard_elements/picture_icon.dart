import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class PictureIcon extends StatelessWidget {
  PictureIcon(this.url,
      {this.mainColor = kMainColor, this.accentColor = kAccentColor});

  final String? url;
  final Color mainColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (url == null)
      return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: Colors.black54),
      );
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: kMainColorLight),
        child: CachedNetworkImage(imageUrl: url!, color: kMainColor));
  }
}
