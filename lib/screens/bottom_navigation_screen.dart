import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/main.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen(this.screens);

  final List<FredericScreen> screens;

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  late int currentIndex;
  late List<BottomNavigationBarItem> items;
  late List<Widget> screens;
  PageController? pageController;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    screens = <Widget>[];
    items = <BottomNavigationBarItem>[];
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
    return CupertinoScaffold(
      body: Scaffold(
        backgroundColor: theme.backgroundColor,
        extendBodyBehindAppBar: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark,
          child: PageView(
            children: screens,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(15), topLeft: Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x17000000), spreadRadius: 0, blurRadius: 3),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            child: BottomNavigationBar(
              items: items,
              elevation: 0,
              backgroundColor: theme.backgroundColor,
              selectedItemColor: theme.accentColor,
              unselectedItemColor: theme.mainColor,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                setState(() {
                  currentIndex = index;
                  pageController!.jumpToPage(index);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}

class FredericScreen {
  FredericScreen(
      {required this.screen,
      required this.icon,
      required this.label,
      this.appbar});

  FredericAppBar? appbar;
  Widget screen;
  IconData icon;
  String label;
}

class FredericAppBar {
  FredericAppBar({required this.title, this.leading, this.actions});
  Widget title;
  Widget? leading;
  List<Widget>? actions;
}
