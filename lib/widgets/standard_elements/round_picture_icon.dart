import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class RoundPictureIcon extends StatelessWidget {
  const RoundPictureIcon(this.url,
      {this.borderThickness = 2, this.radius = 18, Key? key})
      : super(key: key);

  final String url;
  final double radius;
  final double borderThickness;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: theme.accentColor,
      radius: radius,
      child: CircleAvatar(
        backgroundColor: theme.backgroundColor,
        radius: radius - borderThickness,
        child: CachedNetworkImage(
            color: theme.mainColorInText,
            imageUrl: url,
            height: (radius * 1.2) - borderThickness),
      ),
    );
  }
}
