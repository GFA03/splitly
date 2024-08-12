import 'package:flutter/material.dart';
import 'package:splitly/models/expense.dart';
import 'package:splitly/models/friend_profile.dart';
import 'package:splitly/pages/track_expense_page.dart';
import 'package:splitly/utils.dart';

class ExpenseCard extends StatefulWidget {
  const ExpenseCard({
    super.key,
    required this.expense,
    required this.friend,
    required this.onDelete,
  });

  final Expense expense;
  final FriendProfile friend;
  final VoidCallback onDelete;

  @override
  State<ExpenseCard> createState() => _ExpenseCardState();
}

class _ExpenseCardState extends State<ExpenseCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.expense.name,
                          style: const TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final editedExpense = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TrackExpense(
                                      friend: widget.friend, expense: widget.expense),
                                ));

                            if (editedExpense != null) {
                              setState(() {
                                final index = widget.friend.expenses!.indexOf(widget.expense);
                                widget.friend.expenses![index] = editedExpense;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Cost: ${widget.expense.totalCost}\$',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      'Paid by: ${widget.expense.payer}',
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                    if (widget.expense.description != null) ...[
                      const SizedBox(height: 10.0),
                      Text(
                        'Description: ${widget.expense.description}',
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            });
      },
      child: Padding(
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
      ),
    );
  }
}
