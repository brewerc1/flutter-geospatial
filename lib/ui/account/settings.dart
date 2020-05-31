import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Color color;

  SettingsScreen(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}