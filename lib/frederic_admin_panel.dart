import 'package:flutter/material.dart';
import 'package:frederic/admin_panel/admin_navigation_bar.dart';
import 'package:frederic/admin_panel/screens/admin_list_activity_screen.dart';
import 'package:frederic/admin_panel/screens/admin_list_icon_screen.dart';
import 'package:frederic/admin_panel/screens/admin_list_user_screen.dart';
import 'package:frederic/frederic_main_app.dart';
import 'package:frederic/main.dart';

class FredericAdminPanel extends StatefulWidget {
  const FredericAdminPanel({Key? key}) : super(key: key);

  @override
  _FredericAdminPanelState createState() => _FredericAdminPanelState();
}

class _FredericAdminPanelState extends State<FredericAdminPanel> {
  bool mainAppVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kScaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 40,
              color: kMainColor,
              child: Row(children: [
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      mainAppVisible = !mainAppVisible;
                    });
                  },
                  child: Icon(
                    Icons.exit_to_app_rounded,
                    size: 32,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 12),
                Icon(
                  Icons.admin_panel_settings_outlined,
                  size: 32,
                  color: Colors.white,
                ),
                SizedBox(width: 12),
                Text(
                  'frederic Admin Panel',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                )
              ]),
            ),
            Expanded(
              child: Row(
                children: [
                  AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      //constraints: BoxConstraints(maxWidth: 450),
                      width: mainAppVisible ? 450 : 0.0001,
                      child: FredericMainApp()),
                  Expanded(
                    child: AdminNavigationBar(screens: [
                      ScreenData(
                          'List all Users',
                          Icons.supervised_user_circle_outlined,
                          AdminListUserScreen()),
                      ScreenData(
                          'List all Activities',
                          Icons.fitness_center_outlined,
                          AdminListActivityScreen()),
                      ScreenData('List all Icons', Icons.landscape_outlined,
                          AdminListIconScreen()),
                    ]),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
