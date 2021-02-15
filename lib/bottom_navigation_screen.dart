import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen(this.screens);

  final List<FredericScreen> screens;

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex = 0;
  List<BottomNavigationBarItem> items;
  List<Widget> screens;
  PageController pageController;

  @override
  void initState() {
    super.initState();

    items = List<BottomNavigationBarItem>();
    screens = List<Widget>();
    pageController = PageController();

    for (var screen in widget.screens) {
      items.add(BottomNavigationBarItem(
          icon: Icon(
            screen.icon,
          ),
          label: screen.label));
      screens.add(screen.screen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: screens,
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: items,
        selectedItemColor: Colors.orange,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
            pageController.jumpToPage(index);
          });
        },
      ),
    );
  }
}

class FredericScreen {
  FredericScreen(
      {@required this.screen, @required this.icon, @required this.label});

  Widget screen;
  IconData icon;
  String label;
}
