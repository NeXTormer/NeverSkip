import 'package:flutter/material.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen(this.screens, {this.fixedScreen = 10000});

  final List<FredericScreen> screens;
  final int fixedScreen;

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int currentIndex;
  List<BottomNavigationBarItem> items;
  List<Widget> screens;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
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
      backgroundColor: Colors.white,
      body: widget.fixedScreen < 100
          ? widget.screens[widget.fixedScreen].screen
          : PageView(
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
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.black87,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
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
