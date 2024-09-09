import 'package:flutter/material.dart';
import 'package:splitly/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/ui/balance/components/balance_card.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/trackExpense/track_expense_page.dart';
import 'package:splitly/ui/widgets/buttons/large_button.dart';

class BalancePage extends ConsumerStatefulWidget {
  const BalancePage({
    super.key,
    required this.name,
    required this.friend,
  });

  final String name;
  final FriendProfile? friend;

  @override
  ConsumerState<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends ConsumerState<BalancePage> {
  @override
  Widget build(BuildContext context) {
    if (widget.friend == null) {
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
        BalanceCard(
          friend: widget.friend!,
          onExpenseDeleted: () {
            setState(() {});
          },
        ),
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
          final repository = ref.watch(repositoryProvider);
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrackExpense()),
          );

          if (newExpense != null) {
            repository.insertExpense(newExpense);
            setState(() {
              widget.friend!.expenses.add(newExpense);
            });
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
