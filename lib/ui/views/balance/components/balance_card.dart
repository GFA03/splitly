import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/views/balance/components/profile_card.dart';
import 'package:splitly/ui/views/history/history_page.dart';
import 'package:splitly/utils/friend_utils.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the repository state (which contains friends and expenses)
    final currentFriendData = ref.watch(repositoryProvider); // Watching the state
    final selectedFriend = currentFriendData.selectedFriend;

    if (selectedFriend == null) {
      return const Text('No friend selected');
    }

    final balance = selectedFriend.calculateBalance(ref.read(repositoryProvider.notifier));
    final balanceColor = balance >= 0 ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileRow(selectedFriend, balance, balanceColor),
            const SizedBox(height: 20.0),
            _buildExpenseDetails(context, ref),
          ],
        ),
      ),
    );
  }

  Row _buildProfileRow(
      FriendProfile friend, double balance, MaterialColor balanceColor) {
    String profileImage = 'assets/profile_pics/profile_picture1.jpg';
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

  Widget _buildExpenseDetails(BuildContext context, WidgetRef ref) {
    final repository = ref.read(repositoryProvider.notifier);
    final selectedFriend = ref.watch(repositoryProvider).selectedFriend;
    if (repository.findFriendExpenses(selectedFriend!.id).isEmpty) {
      return _buildNoExpensesCard();
    }
    return _buildHistoryCard(context, ref);
  }

  Widget _buildNoExpensesCard() {
    return const Text('There are no expenses yet!');
  }

  Widget _buildHistoryCard(BuildContext context, WidgetRef ref) {
    final friendExpenses = FriendUtils.getSelectedFriendExpenses(ref);
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
}
