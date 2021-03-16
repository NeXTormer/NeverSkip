import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/screens/screens.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.user);
  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(height: kAppBarHeight),
        Container(
          height: 200,
          child: Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.black,
                child: Image(
                  image: CachedNetworkImageProvider(user.banner),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20.0,
                child: Container(
                  width: 400,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CircleAvatar(
                        child: CircleAvatar(
                          radius: 58,
                          backgroundImage:
                              CachedNetworkImageProvider(user.image),
                        ),
                        radius: 60,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              //width: 250,
                              child: Text(
                                user.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.only(right: 8),
                              icon: Icon(
                                Icons.settings,
                                size: 32,
                                color: Colors.black38,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SettingsScreen()));
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6),
        if (user.description != '')
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              user.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          )
      ],
    );
  }

  /// Outsource the Profile-Text section
  ///
  /// Currently build a static [profile name] and [subtext].
  Widget buildProfileText() {
    return Container(
      child: Row(
        children: [
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 6),
              Text(
                user.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              )
            ],
          ),
        ],
      ),
    );
  }
}
