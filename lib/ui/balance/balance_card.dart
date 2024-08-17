import 'package:flutter/material.dart';
import 'package:splitly/ui/balance/see_history_card.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/widgets/profile_card.dart';

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

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ProfileCard(profile: FriendProfile('You', profileImage)),
                // SizedBox(width: 15.0,),
                // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
                Text(
                  'Balance: ${widget.friend.calculateBalance()}\$',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: widget.friend.calculateBalance() > 0 ? Colors.green : Colors.red,
                  ),
                ),
                // SizedBox(width: 15.0,),
                ProfileCard(profile: widget.friend),
              ],
            ),
            const SizedBox(height: 20.0),
            widget.friend.expenses.isEmpty ? const Text('There are no expenses yet!') : SeeHistoryCard(friend: widget.friend, onExpenseDeleted: widget.onExpenseDeleted,),
          ],
        ),
      ),
    );
  }
}
