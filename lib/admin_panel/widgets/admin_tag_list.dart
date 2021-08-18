import 'package:flutter/material.dart';
import 'package:frederic/main.dart';

class AdminTagList extends StatelessWidget {
  const AdminTagList(this.tags, {required this.onDeleteElement, Key? key})
      : super(key: key);

  final List<String> tags;
  final void Function(int) onDeleteElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        spacing: 8,
        children: List<Chip>.generate(
            tags.length,
            (index) => Chip(
                  onDeleted: () => onDeleteElement(index),
                  deleteIcon: Icon(
                    Icons.highlight_remove_outlined,
                    color: Colors.white,
                  ),
                  backgroundColor: kMainColor,
                  label: Text(
                    tags[index],
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                    ),
                  ),
                )),
      ),
    );
  }
}
