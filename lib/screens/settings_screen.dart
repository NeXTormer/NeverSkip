import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/widgets/profile_screen/settings_screen/keep_signed_in.dart';
import 'package:frederic/widgets/profile_screen/settings_screen/pick_banner_image.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen(this.user);
  final FredericUser user;

  final double generalTextsize = 17;
  final double titleTextSize = 20;
  final double generalPadding = 20;

  final bool male = true;
  final bool female = false;
  final bool other = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: FooterView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'User Information',
                  style: TextStyle(
                    fontSize: titleTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildUserInformation(context),
                Divider(),
                Text(
                  'General',
                  style: TextStyle(
                    fontSize: titleTextSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildGeneralInformation(),
                SizedBox(height: generalPadding),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildAccountButton(
                      'Delete Account',
                      () {},
                      Colors.red[200],
                    ),
                    _buildAccountButton(
                      'Logout',
                      () {
                        FirebaseAuth.instance.signOut();
                      },
                      Colors.lightBlue,
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [],
                )
              ],
            ),
          ),
        ],
        footer: Footer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'Copyright ©2021, All Rights Reserved.\nPowered by Hawkford',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  _buildGeneralInformation() {
    return Row(
      children: [
        SizedBox(width: 50),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KeepSignedIn('Allow Notifications', () {
              // TODO
              // Turn off/on Notifications
            }),
            SizedBox(height: generalPadding),
            KeepSignedIn('Keep Signed In', () {
              // TODO
              // Keep user signed in
            }),
            _buildArrowGoToButton(
              'Terms & Conditions',
              () {
                // TODO
                // Go to terms & conditions
              },
            ),
            _buildArrowGoToButton('Support & Feedback', () {
              // TODO
              // Support & Feedback
            }),
          ],
        ),
      ],
    );
  }

  _buildUserInformation(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 50),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: generalPadding),
              _buildProfileImageAndText(),
              SizedBox(height: generalPadding),
              _buildBannerPickerButton(context),
              SizedBox(height: generalPadding),
              _buildInfoTextStack('kollegah.derboss@gmail.com', 'Email'),
              SizedBox(height: generalPadding),
              Row(
                children: [
                  Text(
                    'Gender:',
                    style: TextStyle(fontSize: generalTextsize),
                  ),
                  _buildGenderBox('Male', male),
                  _buildGenderBox('Female', female),
                  _buildGenderBox('other', other),
                ],
              ),
              SizedBox(height: generalPadding),
              Row(
                children: [
                  _buildInfoTextStack(user.age.toString(), 'Age'),
                  _buildInfoTextStack('187 cm', 'Height'),
                  _buildInfoTextStack('87 kg', 'Weight'),
                  _buildInfoTextStack('bmi', 'BMI'),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }

  _buildAccountButton(String text, Function action, Color color) {
    return InkWell(
      onTap: action,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: generalTextsize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  _buildArrowGoToButton(String text, Function navigation) {
    return InkWell(
      onTap: navigation,
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(2),
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: generalTextsize,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  _buildInfoTextStack(String data, String description) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          // width: 80,
          height: 45,
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Text(
                  data,
                  style: TextStyle(fontSize: generalTextsize),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: -2,
          left: 0,
          child: Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  _buildGenderBox(String gender, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 2,
      ),
      margin: const EdgeInsets.only(left: 5),
      decoration: isActive
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.lightBlue,
            )
          : BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(width: 0.5, color: Colors.black54),
            ),
      child: Text(
        gender,
        style: TextStyle(
          fontSize: generalTextsize,
          color: isActive ? Colors.white : Colors.black54,
        ),
      ),
    );
  }

  _buildProfileImageAndText() {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(user.image),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    user.name,
                    style: TextStyle(fontSize: titleTextSize),
                  ),
                  SizedBox(width: 10),
                  Icon(
                    Icons.person,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  _buildBannerPickerButton(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return PickBannerImage(user);
            });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 50,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12,
        ),
        child: Text(
          'Banner Image',
          style: TextStyle(fontSize: generalTextsize),
        ),
      ),
    );
  }
}
