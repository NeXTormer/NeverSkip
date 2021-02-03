import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          height: 150,
          width: double.infinity,
          color: Colors.black,
          child: Image.network(
            'https://wallpaperaccess.com/full/1093845.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -70.0,
          left: 20.0,
          child: CircleAvatar(
            child: CircleAvatar(
              radius: 58,
              backgroundImage: NetworkImage(
                  'https://soziotypen.de/wp-content/uploads/2020/01/Sascha-Huber.jpg'),
            ),
            radius: 60,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
