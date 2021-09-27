import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';
import 'package:frederic/widgets/standard_elements/frederic_card.dart';

class AdminNavigationBar extends StatefulWidget {
  const AdminNavigationBar({required this.screens, Key? key}) : super(key: key);

  final List<ScreenData> screens;

  @override
  _AdminNavigationBarState createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {
  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 220),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tools',
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                ...List.generate(
                    widget.screens.length,
                    (index) => _SideNavigationBarItem(widget.screens[index],
                        onTap: () => setState(() => selectedScreen = index),
                        selected: index == selectedScreen)),
                Expanded(child: Container()),
                Divider(height: 1, color: Colors.grey),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Logged in as:'),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        Text(FredericBackend.instance.userManager.state.name)),
                Divider(height: 1, color: Colors.grey),
                InkWell(
                  onTap: () => FirebaseAuth.instance.signOut(),
                  child: Container(
                    height: 50,
                    child: Center(
                      child: Text('Log out'),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: widget.screens[selectedScreen].screen,
          ),
        ],
      ),
    );
  }
}

class _SideNavigationBarItem extends StatelessWidget {
  const _SideNavigationBarItem(this.screenData,
      {Key? key, this.selected = false, required this.onTap})
      : super(key: key);

  final ScreenData screenData;
  final bool selected;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FredericCard(
      onTap: onTap,
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      color: selected ? theme.greyColor : theme.backgroundColor,
      child: Row(
        children: [
          Icon(screenData.icon),
          SizedBox(width: 16),
          Text(screenData.name)
        ],
      ),
    );
  }
}

class ScreenData {
  ScreenData(this.name, this.icon, this.screen);

  final Widget screen;
  final IconData icon;
  final String name;
}
