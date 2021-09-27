import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class PictureIcon extends StatelessWidget {
  PictureIcon(
    this.url, {
    Color? mainColor,
    Color? accentColor,
  }) {
    this.mainColor = mainColor ?? theme.mainColor;
    this.accentColor = accentColor ?? theme.mainColorLight;
  }

  final String? url;
  late final Color mainColor;
  late final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (url == null)
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: Colors.black54),
        ),
      );
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), color: accentColor),
          child: CachedNetworkImage(imageUrl: url!, color: mainColor)),
    );
  }
}
