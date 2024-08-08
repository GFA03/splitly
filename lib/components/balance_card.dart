import 'package:flutter/material.dart';
import 'package:splitly/models/friend_profile.dart';
import 'package:splitly/components/profile_card.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.friend,
  });

  final FriendProfile friend;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProfileCard(profile: friends[0]),
            // SizedBox(width: 15.0,),
            // TODO: add currency option (and you should call an API to convert the selected currency to the settings selected currency
            Text(
              'Balance: ${friend.balance}',
              style: TextStyle(
                fontSize: 16.0,
                color: friend.balance > 0 ? Colors.green : Colors.red,
              ),
            ),
            // SizedBox(width: 15.0,),
            ProfileCard(profile: friend),
          ],
        ),
      ),
    );
  }
}
