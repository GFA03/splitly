import 'package:flutter/material.dart';
import 'package:splitly/models/friend_profile.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friend,
  });

  final FriendProfile friend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Card(
        elevation: 12.0,
        shape: const RoundedRectangleBorder(),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(friend.imageUrl),
              radius: 25,
            ),
            const SizedBox(width: 15.0,),
            Text(friend.name),
          ],
        ),
      ),
    );
  }
}
