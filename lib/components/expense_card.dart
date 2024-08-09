import 'package:flutter/material.dart';
import 'package:splitly/models/expense.dart';

class ExpenseCard extends StatelessWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${expense.expenseName} - ${expense.cost}\$'),
          Text('(Paid by ${expense.payer})'),
        ],
      ),
    );
  }
}
