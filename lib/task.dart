import 'package:flutter/material.dart';

class Task {
  final String name;
  final String category;
  final String time;
  final List<String> hangouts;
  final Color color;
  final bool finished;

  Task(
      {this.name,
        this.category,
        this.time,
        this.hangouts,
        this.color,
        this.finished});
}