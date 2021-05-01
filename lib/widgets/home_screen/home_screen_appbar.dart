import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/main.dart';
import 'package:frederic/misc/ExtraIcons.dart';

class HomeScreenAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 0),
        child: Column(
          children: [
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: CachedNetworkImageProvider(
                      'https://static.toiimg.com/thumb/msid-74688213,imgsize-91052,width-800,height-600,resizemode-75/74688213.jpg'),
                ),
                Icon(
                  ExtraIcons.bell_1,
                  color: Colors.grey,
                )
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Good morning, Ana!',
                        style: TextStyle(
                            color: const Color(0xFF272727),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.6,
                            fontSize: 13)),
                    SizedBox(height: 8),
                    Text('Let\'s find you a workout',
                        style: TextStyle(
                            color: const Color(0xFF272727),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                            fontSize: 16))
                  ],
                ),
                Container(
                    height: 32,
                    width: 32,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: kMainColor),
                    child: Icon(
                      ExtraIcons.statistics,
                      color: Colors.white,
                      size: 18,
                    ))
              ],
            ),
            SizedBox(height: 8)
          ],
        ),
      ),
    );
  }
}
