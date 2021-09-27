import 'package:flutter/material.dart';

class SliverDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Container(
      color: const Color(0xFFC9C9C9),
      height: 0.5,
    ));
  }
}
