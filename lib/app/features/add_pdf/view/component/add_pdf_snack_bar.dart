import 'package:flutter/material.dart';

class AddPdfSnackBar {
  final String message;
  final Duration duration;
  final Color color;

  const AddPdfSnackBar({
    required this.message,
    this.duration = const Duration(seconds: 3),
    this.color = Colors.lightGreen,
  });

  void show(BuildContext context) {
    final snackBar = SnackBar(
      backgroundColor: color,
      content: Text(message),
      duration: duration,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}