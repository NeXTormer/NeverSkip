import 'package:flutter/material.dart';

class SliverDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Divider(color: const Color(0xFFC9C9C9)));
  }
}
