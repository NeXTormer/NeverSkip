import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen(this.screens);

  final List<FredericScreen> screens;

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
    screens = List<Widget>();
    items = List<BottomNavigationBarItem>();
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
    AppBar appbar = AppBar(
      title: AnimatedSwitcher(
        child: widget.screens[currentIndex].appbar.title,
        duration: Duration(milliseconds: 100),
      ),
      centerTitle: true,
      //brightness: Brightness.dark,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12))),
      leading: AnimatedSwitcher(
        child: widget.screens[currentIndex].appbar.leading,
        duration: Duration(milliseconds: 100),
      ),
      actions: widget.screens[currentIndex].appbar.actions,
    );

    kAppBarHeight = 0;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: appbar,
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
        backgroundColor: Colors.white,
        selectedItemColor: kAccentColor,
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
      {@required this.screen,
      @required this.icon,
      @required this.label,
      @required this.appbar});

  FredericAppBar appbar;
  Widget screen;
  IconData icon;
  String label;
}

class FredericAppBar {
  FredericAppBar({@required this.title, this.leading, this.actions});
  Widget title;
  Widget leading;
  List<Widget> actions;
}
