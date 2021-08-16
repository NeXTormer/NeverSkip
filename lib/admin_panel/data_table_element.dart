import 'package:flutter/material.dart';

abstract class DataTableElement<T> {
  List<DataColumn> toDataColumn();
  DataRow toDataRow(void Function(T)? onSelectElement);
}
