import 'package:flutter/material.dart';
import 'package:frederic/screens/home_screen.dart';

void main() {
  runApp(Frederic());
}

class Frederic extends StatelessWidget {
  const Frederic({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Frederic',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.red[400],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}
