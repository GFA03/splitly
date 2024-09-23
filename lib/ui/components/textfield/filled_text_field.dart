import 'package:flutter/material.dart';

class FilledTextField extends StatelessWidget {
  const FilledTextField(
      {super.key,
      this.label,
      required this.value,
      required this.enabled,
      this.onSaved,
      this.onChanged,
      required this.validator,
      this.keyboardType});

  final String? label;
  final String? value;
  final bool enabled;
  final FormFieldSetter? onSaved;
  final FormFieldSetter? onChanged;
  final FormFieldValidator validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
      ),
      initialValue: value,
      enabled: enabled,
      onSaved: onSaved,
      onChanged: onChanged,
      validator: validator,
      keyboardType: keyboardType,
    );
  }
}
