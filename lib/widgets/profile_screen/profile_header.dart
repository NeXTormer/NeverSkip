import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.user);
  final FredericUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          child: Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Colors.black,
                child: Image.network(
                  user.banner,
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
                          backgroundImage: NetworkImage(user.image),
                        ),
                        radius: 60,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Container(
                        width: 250,
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
