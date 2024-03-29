import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frederic/backend/backend.dart';
import 'package:frederic/main.dart';

class BottomNavigationScreen extends StatefulWidget {
  BottomNavigationScreen(this.screens);

  final List<FredericScreen> screens;

  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen>
    with SingleTickerProviderStateMixin, RouteAware {
  late int currentIndex;
  late List<BottomNavigationBarItem> items;
  late List<Widget> screens;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    screens = <Widget>[];
    items = <BottomNavigationBarItem>[];

    for (var screen in widget.screens) {
      items.add(BottomNavigationBarItem(
          icon: Icon(
            screen.icon,
          ),
          label: screen.label));
      screens.add(screen.screen);
    }

    _sendCurrentTabToAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        extendBodyBehindAppBar: false,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: theme.isDark || theme.isColorful
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          child: PageView(
            children: screens,
            controller: pageController,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
              _sendCurrentTabToAnalytics();
            },
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: theme.backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(12), topLeft: Radius.circular(12)),
            boxShadow: [
              BoxShadow(
                  color: Color(0x17000000), spreadRadius: 0, blurRadius: 3),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: BottomNavigationBar(
              items: items,
              elevation: 0,
              backgroundColor:
                  theme.isColorful ? theme.mainColor : theme.backgroundColor,
              selectedItemColor: theme.isColorful
                  ? theme.textColorColorfulBackground
                  : theme.accentColor,
              unselectedItemColor: theme.isColorful
                  ? theme.textColorColorfulBackground
                  : theme.mainColor,
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  currentIndex = index;
                  pageController.jumpToPage(index);
                });
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    FredericBackend.instance.analytics
        .logCurrentScreen(widget.screens[currentIndex].label);
  }
}

class FredericScreen {
  FredericScreen({
    required this.screen,
    required this.icon,
    required this.label,
  });

  Widget screen;
  IconData icon;
  String label;
}
