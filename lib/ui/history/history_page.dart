import 'package:flutter/material.dart';
import 'package:splitly/ui/widgets/expense_card.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/widgets/track_expense_page.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({
    super.key,
    required this.friend,
    required this.onExpenseDeleted,
  });

  final FriendProfile friend;
  final VoidCallback onExpenseDeleted;

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late List<Expense> expenses;

  @override
  void initState() {
    super.initState();
    expenses = widget.friend.expenses;
  }

  void deleteExpense(int index) {
    Expense deletedExpense = expenses[index];
    setState(() {
      expenses.removeAt(index);
    });

    widget.onExpenseDeleted();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedExpense.name} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              widget.friend.expenses.insert(index, deletedExpense);
              widget.onExpenseDeleted();
            });
          },
        ),
      ),
    );
  }

  void _showExpenseDetails(Expense expense) {
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
                    expense.name,
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
                            friend: widget.friend,
                            expense: expense,
                          ),
                        ),
                      );

                      if (editedExpense != null) {
                        setState(() {
                          final index = widget.friend.expenses.indexOf(expense);
                          widget.friend.expenses[index] = editedExpense;
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
              const SizedBox(height: 10.0),
              Text(
                'Cost: ${expense.totalCost}\$',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                'Paid by: ${expense.payer}',
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              if (expense.description != null) ...[
                const SizedBox(height: 10.0),
                Text(
                  'Description: ${expense.description}',
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitly'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          int reversedIndex = expenses.length - 1 - index;
          return Dismissible(
            key: Key(expenses[reversedIndex].name),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteExpense(reversedIndex);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: GestureDetector(
              onTap: () => _showExpenseDetails(expenses[reversedIndex]),
              child: ExpenseCard(
                expense: expenses[reversedIndex],
              ),
            ),
          );
        },
      ),
    );
  }
}
