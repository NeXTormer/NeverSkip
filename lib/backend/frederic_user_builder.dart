import 'package:flutter/material.dart';
import 'package:frederic/backend/backend.dart';

class FredericUserBuilder extends StatefulWidget {
  FredericUserBuilder({required this.builder});

  final Widget Function(BuildContext, FredericUser?) builder;

  @override
  _FredericUserBuilderState createState() => _FredericUserBuilderState();
}

class _FredericUserBuilderState extends State<FredericUserBuilder> {
  FredericBackend? _backend;
  FredericUser? currentUser;

  @override
  void initState() {
    _backend = FredericBackend.instance();
    _backend!.currentUser!.addListener(updateData);

    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, currentUser);
  }

  void updateData() {
    setState(() {
      currentUser = _backend!.currentUser;
    });
  }

  @override
  void dispose() {
    _backend!.currentUser!.removeListener(updateData);
    super.dispose();
  }
}
