import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:frederic/main.dart';

class PictureIcon extends StatelessWidget {
  PictureIcon(
    this.url, {
    Color? mainColor,
    Color? accentColor,
    this.borderRadius = 10,
  }) : icon = null {
    this.mainColor = mainColor ?? theme.mainColor;
    this.accentColor = accentColor ?? theme.mainColorLight;
  }

  PictureIcon.icon(
    this.icon, {
    Color? mainColor,
    Color? accentColor,
    this.borderRadius = 10,
  }) : url = null {
    this.mainColor = mainColor ?? theme.mainColor;
    this.accentColor = accentColor ?? theme.mainColorLight;
  }

  final IconData? icon;
  final String? url;
  late final Color mainColor;
  final double borderRadius;
  late final Color accentColor;

  @override
  Widget build(BuildContext context) {
    if (url == null && icon == null)
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: theme.mainColorLight),
        ),
      );
    if (icon == null)
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: accentColor),
            child: CachedNetworkImage(
              imageUrl: url!,
              color: mainColor,
              progressIndicatorBuilder: (context, text, progress) {
                return CupertinoActivityIndicator(
                  color: mainColor,

                  //    animating: true,
                );
              },
            )),
      );
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: accentColor),
          child: Icon(
            icon,
            color: mainColor,
          )),
    );
  }
}
