import 'package:flutter/material.dart';

// Reusable widget for input fields
class ExpenseInputField extends StatelessWidget {
  const ExpenseInputField({
    super.key,
    required this.label,
    this.initialValue,
    required this.enabled,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String label;
  final String? initialValue;
  final bool enabled;
  final void Function(String?) onSaved;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.purple),
      ),
      initialValue: initialValue ?? "",
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}
