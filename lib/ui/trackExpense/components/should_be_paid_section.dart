// Widget for the "Should be paid" fields
import 'package:flutter/material.dart';

import 'expense_input_field.dart';

class ShouldBePaidSection extends StatelessWidget {
  const ShouldBePaidSection({
    super.key,
    required this.shouldBePaidByUser,
    required this.shouldBePaidByFriend,
    required this.submitted,
    required this.onSavedShouldBePaidByUser,
    required this.onSavedShouldBePaidByFriend,
  });

  final double? shouldBePaidByUser;
  final double? shouldBePaidByFriend;
  final bool submitted;
  final void Function(String?) onSavedShouldBePaidByUser;
  final void Function(String?) onSavedShouldBePaidByFriend;

  @override
  Widget build(BuildContext context) {
    final RegExp digitRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
    return Column(
      children: [
        ExpenseInputField(
          label: 'Should be paid by you',
          initialValue: shouldBePaidByUser.toString() == 'null' ? null : shouldBePaidByUser.toString(),
          enabled: !submitted,
          onSaved: onSavedShouldBePaidByUser,
          keyboardType: TextInputType.number,
          validator: (value) => (value == null || !digitRegex.hasMatch(value))
              ? 'Please enter a valid amount!'
              : null,
        ),
        const SizedBox(height: 20),
        ExpenseInputField(
          label: 'Should be paid by them',
          initialValue: shouldBePaidByFriend.toString() == 'null' ? null : shouldBePaidByFriend.toString(),
          enabled: !submitted,
          onSaved: onSavedShouldBePaidByFriend,
          keyboardType: TextInputType.number,
          validator: (value) => (value == null || !digitRegex.hasMatch(value))
              ? 'Please enter a valid amount!'
              : null,
        ),
      ],
    );
  }
}
