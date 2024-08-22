import 'package:flutter/material.dart';
import 'package:splitly/ui/widgets/expense_card.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/widgets/track_expense_page.dart';
import 'package:splitly/utils.dart';

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
    expenses = widget.friend.expenses.reversed.toList();
  }

  void deleteExpense(int index) {
    Expense deletedExpense = expenses.removeAt(index);
    widget.onExpenseDeleted();

    showSnackBar(context, '${deletedExpense.name} deleted', 'Undo', () {
      setState(() {
        widget.friend.expenses.insert(index, deletedExpense);
        widget.onExpenseDeleted();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Splitly')),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) => _buildExpenseItem(index),
      ),
    );
  }

  Dismissible _buildExpenseItem(int index) {
    final expense = expenses[index];
    return Dismissible(
      key: Key(expense.name),
      direction: DismissDirection.endToStart,
      onDismissed: (_) {
        deleteExpense(index);
      },
      background: _buildDeleteBackground(),
      child: GestureDetector(
        onTap: () => _showExpenseDetails(expense),
        child: ExpenseCard(expense: expense),
      ),
    );
  }

  Container _buildDeleteBackground() {
    return Container(
      color: Colors.red,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: const Icon(Icons.delete, color: Colors.white),
    );
  }

  void _showExpenseDetails(Expense expense) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildExpenseDetailsSheet(expense),
    );
  }

  Widget _buildExpenseDetailsSheet(expense) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildExpenseDetailsTitle(expense),
          const SizedBox(height: 10.0),
          Text('Cost: ${expense.totalCost}\$',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 10.0),
          Text('Paid by: ${expense.payer}',
              style: Theme.of(context).textTheme.titleSmall),
          ...?_buildExpenseDetailsDescription(expense),
        ],
      ),
    );
  }

  Row _buildExpenseDetailsTitle(Expense expense) {
    return Row(
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
                  builder: (context) =>
                      TrackExpense(friend: widget.friend, expense: expense)),
            );

            if (editedExpense != null) {
              setState(() {
                final index = widget.friend.expenses.indexOf(expense);
                widget.friend.expenses[index] = editedExpense;
              });
            }
          },
          icon: Icon(
            Icons.edit,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ],
    );
  }

  List<Widget>? _buildExpenseDetailsDescription(Expense expense) {
    if (expense.description != null) {
      return [
        const SizedBox(height: 10.0),
        Text(
          'Description: ${expense.description}',
          style: Theme.of(context)
              .textTheme
              .apply(displayColor: Theme.of(context).colorScheme.onSurface)
              .bodySmall,
        ),
      ];
    }
    return null;
  }
}
