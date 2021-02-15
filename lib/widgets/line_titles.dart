import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LineTitles {
  static getTitleData() => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 0, // bottom space
          getTextStyles: (value) => TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
              case 1:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
              case 2:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
              case 3:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
              case 4:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
              case 5:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
              case 6:
                return DateFormat('dd.MM').format(
                    DateTime.now().subtract(Duration(days: 5 - value.toInt())));
            }
            return '';
          },
          margin: 18,
        ),
        leftTitles: SideTitles(
            showTitles: true,
            getTextStyles: (value) => TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
            reservedSize: 0,
            margin: 18.0,
            getTitles: (value) {
              switch (value.toInt()) {
                case 0:
                  return '0';
                case 1:
                  return '10';
                case 2:
                  return '20';
                case 3:
                  return '30';
              }
              return '';
            }),
      );
}
