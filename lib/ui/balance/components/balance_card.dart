import 'package:flutter/material.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/balance/components/profile_card.dart';
import 'package:splitly/ui/history/history_page.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({
    super.key,
    required this.friend,
    required this.onExpenseDeleted,
  });

  final FriendProfile friend;
  final VoidCallback onExpenseDeleted;

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    String profileImage = 'assets/profile_pics/profile_picture1.jpg';
    final balance = widget.friend.calculateBalance();
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileRow(profileImage, balance, balanceColor),
            const SizedBox(height: 20.0),
            _buildExpenseDetails(),
          ],
        ),
      ),
    );
  }

  Row _buildProfileRow(
      String profileImage, double balance, MaterialColor balanceColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileCard(profile: FriendProfile('You', profileImage)),
        // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
        Text(
          'Balance: $balance\$',
          style: TextStyle(
            fontSize: 16.0,
            color: balanceColor,
          ),
        ),
        ProfileCard(profile: widget.friend),
      ],
    );
  }

  Widget _buildExpenseDetails() {
    if (widget.friend.expenses.isEmpty) {
      return _buildNoExpensesCard();
    }
    return _buildHistoryCard();
  }

  Widget _buildNoExpensesCard() {
    return const Text('There are no expenses yet!');
  }

  Widget _buildHistoryCard() {
    final lastExpense = widget.friend.expenses.last;
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
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    friend: widget.friend,
                    onExpenseDeleted: widget.onExpenseDeleted,
                  ),
                ),
              );

              if (updated == true) {
                setState(() {});
              }
            },
            child: const Text('See all history',
            style: TextStyle(decoration: TextDecoration.underline),)),
      ],
    );
  }
}
