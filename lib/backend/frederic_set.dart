import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FredericSet {
  FredericSet(
      {@required this.reps, @required this.weight, @required this.timestamp});
  final int reps;
  final int weight;
  final DateTime timestamp;

  @override
  String toString() {
    return 'FredericSet[$reps with $weight weight on $timestamp]';
  }
}
