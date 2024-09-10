import 'package:flutter/material.dart';

// Date picker widget
class ExpenseDatePicker extends StatelessWidget {
  const ExpenseDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Date of Expense',
        labelStyle: TextStyle(color: Colors.purple),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      controller: TextEditingController(
        text: "${selectedDate.toLocal()}".split(' ')[0],
      ),
    );
  }
}
