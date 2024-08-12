import 'package:flutter/material.dart';
import 'package:splitly/components/expense_card.dart';
import 'package:splitly/models/expense.dart';
import 'package:splitly/models/friend_profile.dart';

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
    expenses = widget.friend.expenses ?? [];
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
              // Re-add the expense (for simplicity, assuming the last deleted expense)
              // In a more complex app, you might store the deleted item and its index
              widget.friend.expenses?.insert(index, deletedExpense);
              widget.onExpenseDeleted();
            });
          },
        ),
      ),
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
            child: ExpenseCard(
              expense: expenses[reversedIndex],
              onDelete: () {
                deleteExpense(reversedIndex);
              },
            ),
          );
        },
      ),
    );
  }
}
