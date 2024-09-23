import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(DateTime date) {
  return DateFormat.yMMMd().format(date);
}

void showSnackBar(BuildContext context, String message,
    [String? actionLabel, VoidCallback? action]) {
  final snackBar = SnackBar(
    content: Text(message),
    action: actionLabel != null
        ? SnackBarAction(label: actionLabel, onPressed: action!)
        : null,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
