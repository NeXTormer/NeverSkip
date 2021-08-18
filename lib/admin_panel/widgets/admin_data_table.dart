import 'package:flutter/material.dart';

import '../data_table_element.dart';

class AdminDataTable<T extends DataTableElement<T>> extends StatelessWidget {
  const AdminDataTable(
      {required this.elements,
      this.onSelectElement,
      this.selectedElement,
      Key? key})
      : super(key: key);

  final List<T> elements;
  final T? selectedElement;

  final void Function(T)? onSelectElement;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: elements.first.toDataColumn(),
        rows: [
          for (var element in elements)
            element.toDataRow(onSelectElement, element == selectedElement),
        ],
      ),
    );
  }
}
