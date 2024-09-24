import 'package:flutter/material.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/ui/components/button/outlined_button.dart';
import 'package:splitly/ui/views/expenseForm/expense_form_page.dart';
import 'package:splitly/utils/friend_utils.dart';

import '../history/history_page.dart';

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
    final currentFriend = ref.watch(repositoryProvider).selectedFriend;
    if (currentFriend == null) {
      return _buildNoFriendSelected();
    }
    return _buildFriendBalance(context, currentFriend);
  }

  Column _buildFriendBalance(BuildContext context, FriendProfile friend) {
    return Column(
      children: [
        const SizedBox(
          height: 100.0,
        ),
        _welcomeUser(),
        const SizedBox(
          height: 100.0,
        ),
        _buildBalanceCard(friend),
        const Spacer(),
        _trackExpenseButton(context),
        const SizedBox(
          height: 60,
        ),
      ],
    );
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

  Card _buildBalanceCard(FriendProfile selectedFriend) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<Row>(
              future: _buildProfileRow(selectedFriend),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading balance');
                } else {
                  return snapshot.data ?? const SizedBox.shrink();
                }
              },
            ),
            const SizedBox(height: 20.0),
            FutureBuilder<Widget>(
              future: _buildExpenseDetails(ref),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('Error loading expenses');
                } else {
                  return snapshot.data ?? const SizedBox.shrink();
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Row> _buildProfileRow(FriendProfile selectedFriend) async {
    final balance = await
        selectedFriend.calculateBalance(ref.read(repositoryProvider.notifier));
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;
    String profileImage = 'assets/profile_pics/profile_picture1.jpg';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildProfileCard(
            profile: FriendProfile(name: 'You', imageUrl: profileImage)),
        // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
        Text(
          'Balance: ${balance.toStringAsFixed(2)}\$',
          style: TextStyle(
            fontSize: 16.0,
            color: balanceColor,
          ),
        ),
        _buildProfileCard(profile: selectedFriend),
      ],
    );
  }

  Future<Widget> _buildExpenseDetails(WidgetRef ref) async {
    final friendExpenses = await FriendUtils.getSelectedFriendExpenses(ref);
    if (friendExpenses.isEmpty) {
      return _buildNoExpensesCard();
    }
    return _buildHistoryCard(ref, friendExpenses);
  }

  Card _buildProfileCard({required FriendProfile profile}) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);

    return Card(
      elevation: 0.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          CircleAvatar(
            backgroundImage: AssetImage(profile.imageUrl ?? FriendUtils.unknownProfilePicture),
            radius: 40,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(profile.name),
          TextButton(
            onPressed: () {},
            child: Text(
              'Change picture',
              style: textTheme.apply(displayColor: Colors.purple).bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoExpensesCard() {
    return const Text('There are no expenses yet!');
  }

  Widget _buildHistoryCard(WidgetRef ref, List<Expense> friendExpenses) {
    final lastExpense = friendExpenses.last;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Last expense: ${lastExpense.name} ${lastExpense.totalCost}\$ (paid by ${lastExpense.payer})',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        TextButton(
            onPressed: () {
              Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryPage(),
                ),
              );
            },
            child: const Text(
              'See all history',
              style: TextStyle(decoration: TextDecoration.underline),
            )),
      ],
    );
  }

  ButtonOutlined _trackExpenseButton(BuildContext context) {
    return ButtonOutlined(
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

  Center _buildNoFriendSelected() {
    return const Center(
      child: Text('Please select a friend'),
    );
  }
}
