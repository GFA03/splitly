

// Widget for the expense details (name, description, and date)
import 'package:flutter/material.dart';

import 'expense_date_picker.dart';
import 'expense_input_field.dart';

class ExpenseDetailsSection extends StatelessWidget {
  const ExpenseDetailsSection({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    required this.submitted,
    required this.onNameSaved,
    required this.onDescriptionSaved,
    required this.onDateSelected,
  });

  final String? name;
  final String? description;
  final DateTime? date;
  final bool submitted;
  final void Function(String?) onNameSaved;
  final void Function(String?) onDescriptionSaved;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseInputField(
          label: 'Expense name',
          initialValue: name,
          enabled: !submitted,
          onSaved: onNameSaved,
          validator: (value) =>
          value == null || value.isEmpty ? 'Please enter some text!' : null,
        ),
        const SizedBox(height: 20),
        ExpenseDatePicker(
          selectedDate: date!,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(height: 20),
        ExpenseInputField(
          label: 'Description (optional)',
          initialValue: description,
          enabled: !submitted,
          onSaved: onDescriptionSaved,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
