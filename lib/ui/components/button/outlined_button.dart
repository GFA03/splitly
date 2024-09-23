import 'package:flutter/material.dart';

class ButtonOutlined extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const ButtonOutlined(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        backgroundColor: Colors.purple,
        textStyle: const TextStyle(fontSize: 20),
        padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
      ),
      onPressed: onPressed,
      child: Text(label,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),),
    );
  }
}
