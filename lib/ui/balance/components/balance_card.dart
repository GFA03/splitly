import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/balance/components/profile_card.dart';
import 'package:splitly/ui/history/history_page.dart';

class BalanceCard extends ConsumerStatefulWidget {
  const BalanceCard({
    super.key,
  });

  @override
  ConsumerState<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends ConsumerState<BalanceCard> {
  @override
  Widget build(BuildContext context) {
    String profileImage = 'assets/profile_pics/profile_picture1.jpg';
    final repository = ref.watch(repositoryProvider);
    final prefs = ref.watch(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');
    final friend = repository.findFriendById(currentFriendId!);
    final balance = friend.calculateBalance();
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileRow(friend, profileImage, balance, balanceColor),
            const SizedBox(height: 20.0),
            _buildExpenseDetails(friend),
          ],
        ),
      ),
    );
  }

  Row _buildProfileRow(FriendProfile friend, String profileImage,
      double balance, MaterialColor balanceColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileCard(
            profile: FriendProfile(name: 'You', imageUrl: profileImage)),
        // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
        Text(
          'Balance: $balance\$',
          style: TextStyle(
            fontSize: 16.0,
            color: balanceColor,
          ),
        ),
        ProfileCard(profile: friend),
      ],
    );
  }

  Widget _buildExpenseDetails(FriendProfile friend) {
    if (friend.expenses.isEmpty) {
      return _buildNoExpensesCard();
    }
    return _buildHistoryCard(friend);
  }

  Widget _buildNoExpensesCard() {
    return const Text('There are no expenses yet!');
  }

  Widget _buildHistoryCard(FriendProfile friend) {
    final lastExpense = friend.expenses.last;
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
                  builder: (context) => const HistoryPage(),
                ),
              );

              if (updated == true) {
                setState(() {});
              }
            },
            child: const Text(
              'See all history',
              style: TextStyle(decoration: TextDecoration.underline),
            )),
      ],
    );
  }
}
