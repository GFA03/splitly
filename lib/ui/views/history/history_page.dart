import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/views/expenseForm/expense_form_page.dart';
import 'package:splitly/ui/views/history/components/expense_card.dart';
import 'package:splitly/data/models/expense.dart';
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
    final repository = ref.read(repositoryProvider.notifier);
    final currentFriendData = ref.read(repositoryProvider);
    final expenses = currentFriendData.selectedFriendExpenses;

    if (expenses.isEmpty) return;

    Expense deletedExpense = expenses[index];
    repository.deleteExpense(expenses[index]);
    showSnackBar(context, '${deletedExpense.name} deleted', 'Undo', () {
      repository.insertExpense(deletedExpense);
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentFriendData = ref.watch(repositoryProvider);

    if (currentFriendData.selectedFriend == null) {
      return const Scaffold(
        body: Center(child: Text('No friend selected')),
      );
    }

    final expenses = currentFriendData.selectedFriendExpenses;

    return Scaffold(
      appBar: AppBar(title: const Text('Splitly')),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          int reverseIndex = expenses.length - index - 1;
          return _buildExpenseItem(reverseIndex, expenses);
        },
      ),
    );
  }

  Dismissible _buildExpenseItem(int index, List<Expense> expenses) {
    Expense expense = expenses[index];
    return Dismissible(
      key: Key(expense.id),
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
            final repository = ref.read(repositoryProvider.notifier);
            Navigator.pop(context);
            final editedExpense = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExpenseFormPage(editExpense: expense)),
            );

            if (editedExpense != null) {
              repository.editExpense(expense, editedExpense);
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
