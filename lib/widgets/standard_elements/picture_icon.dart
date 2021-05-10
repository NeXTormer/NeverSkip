import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class PictureIcon extends StatelessWidget {
  PictureIcon(this.url);

  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8), color: kMainColorLight),
        child: CachedNetworkImage(imageUrl: url, color: kMainColor));
  }
}
