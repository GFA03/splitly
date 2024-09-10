import 'package:flutter/material.dart';

import '../track_expense_page.dart';
import 'expense_input_field.dart';

// Widget for "Paid Amount" fields for both user and friend
class PaidAmountsSection extends StatelessWidget {
  const PaidAmountsSection({
    super.key,
    required this.paidByUser,
    required this.paidByFriend,
    required this.paymentView,
    required this.submitted,
    required this.onSavedPaidByUser,
    required this.onSavedPaidByFriend,
  });

  final double? paidByUser;
  final double? paidByFriend;
  final PaymentOptions paymentView;
  final bool submitted;
  final void Function(String?) onSavedPaidByUser;
  final void Function(String?) onSavedPaidByFriend;

  @override
  Widget build(BuildContext context) {
    final RegExp digitRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
    if (paymentView == PaymentOptions.both) {
      return Column(
        children: [
          ExpenseInputField(
            label: 'How much have you paid?',
            enabled: !submitted,
            onSaved: onSavedPaidByUser,
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || !digitRegex.hasMatch(value))
                ? 'Please enter a valid number!'
                : null,
          ),
          const SizedBox(height: 20),
          ExpenseInputField(
            label: 'How much have they paid?',
            enabled: !submitted,
            onSaved: onSavedPaidByFriend,
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || !digitRegex.hasMatch(value))
                ? 'Please enter a valid number!'
                : null,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
