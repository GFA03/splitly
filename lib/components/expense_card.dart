import 'package:flutter/material.dart';
import 'package:splitly/models/expense.dart';
import 'package:splitly/utils.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
  });

  final Expense expense;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 10.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.expense.name),
                    Text(
                      formatDate(widget.expense.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(children: [
                  Center(
                    child: Text(
                      '${widget.expense.totalCost}\$',
                    ),
                  ),
                  Text(
                    '(Paid by ${widget.expense.payer})',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 10,
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      );
  }
}
