import 'package:flutter/material.dart';
import 'package:splitly/components/friend_card.dart';
import 'package:splitly/models/friend_profile.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key, required this.onFriendSelected});

  final void Function(FriendProfile) onFriendSelected;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => onFriendSelected(friends[index]),
          child: FriendCard(friend: friends[index]),
        );
      },
    );
  }
}
