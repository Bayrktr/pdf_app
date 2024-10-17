import 'package:flutter/material.dart';

class HomeDirectoryOpenSnackBar {
  final String message;
  final Duration duration;
  final Color? color;

  const HomeDirectoryOpenSnackBar({
    required this.message,
    this.duration = const Duration(seconds: 3),
    this.color,
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: color ?? Colors.lightGreen,
      content: Text(message),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}