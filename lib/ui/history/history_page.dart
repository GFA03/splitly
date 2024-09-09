import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/history/components/expense_card.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/ui/trackExpense/track_expense_page.dart';
import 'package:splitly/utils.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({
    super.key,
  });

  @override
  ConsumerState createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  void deleteExpense(int index) {
    final repository = ref.watch(repositoryProvider);
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');
    final friend = repository.findFriendById(currentFriendId!);
    final List<Expense> expenses = repository.findFriendExpenses(friend.id);
    Expense deletedExpense = expenses[index];
    setState(() {
      expenses.removeAt(index);
    });
    repository.deleteExpense(expenses[index]);

    showSnackBar(context, '${deletedExpense.name} deleted', 'Undo', () {
      repository.insertExpense(deletedExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(repositoryProvider);
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');
    final friend = repository.findFriendById(currentFriendId!);
    final List<Expense> expenses = repository.findFriendExpenses(friend.id);
    return Scaffold(
      appBar: AppBar(title: const Text('Splitly')),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          int reverseIndex = expenses.length - index - 1;
          return _buildExpenseItem(reverseIndex);
        },
      ),
    );
  }

  Dismissible _buildExpenseItem(int index) {
    final repository = ref.watch(repositoryProvider);
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');
    final friend = repository.findFriendById(currentFriendId!);
    final List<Expense> expenses = repository.findFriendExpenses(friend.id);
    Expense expense = expenses[index];
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
        // child: Container(),
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

  Widget _buildExpenseDetailsSheet(Expense expense) {
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
          const SizedBox(height: 4.0),
          Text('Your consumption: ${expense.shouldBePaidByUser}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey)),
          Text('You paid: ${expense.paidByUser}'),
          Text('Their consumption: ${expense.shouldBePaidByFriend}',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.grey)),
          Text('They paid: ${expense.paidByFriend}'),
          ...?_buildExpenseDetailsDescription(expense),
        ],
      ),
    );
  }

  Row _buildExpenseDetailsTitle(Expense expense) {
    final repository = ref.watch(repositoryProvider);
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');
    final friend = repository.findFriendById(currentFriendId!);
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
                  builder: (context) => TrackExpense(expense: expense)),
            );

            if (editedExpense != null) {
              setState(() {
                final index = friend.expenses.indexOf(expense);
                friend.expenses[index] = editedExpense;
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
