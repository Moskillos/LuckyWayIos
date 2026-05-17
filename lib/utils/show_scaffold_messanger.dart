import 'package:flutter/material.dart';

void showScaffoldMessenger(String message, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),
  ));
}