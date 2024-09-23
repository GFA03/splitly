import 'package:flutter/material.dart';
import 'package:splitly/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/ui/views/balance/components/balance_card.dart';
import 'package:splitly/ui/views/expenseForm/expense_form_page.dart';
import 'package:splitly/ui/widgets/buttons/large_button.dart';

class BalancePage extends ConsumerStatefulWidget {
  const BalancePage({
    super.key,
    required this.name,
  });

  final String name;

  @override
  ConsumerState<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends ConsumerState<BalancePage> {
  @override
  Widget build(BuildContext context) {
    final currentFriendId = ref.watch(repositoryProvider).selectedFriend;
    if (currentFriendId == null) {
      return _buildNoFriendSelected();
    }
    return _buildFriendBalance(context);
  }

  Column _buildFriendBalance(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100.0,
        ),
        _welcomeUser(),
        const SizedBox(
          height: 100.0,
        ),
        const BalanceCard(),
        const Spacer(),
        _trackExpenseButton(context),
        const SizedBox(
          height: 60,
        ),
      ],
    );
  }

  LargeButton _trackExpenseButton(BuildContext context) {
    return LargeButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ExpenseFormPage()),
          );

          if (newExpense != null) {
            ref.read(repositoryProvider.notifier).insertExpense(newExpense);
          }
        },
        label: 'Track Expense');
  }

  Text _welcomeUser() {
    return Text(
      'Hello ${widget.name}',
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Center _buildNoFriendSelected() {
    return const Center(
      child: Text('Please select a friend'),
    );
  }
}
