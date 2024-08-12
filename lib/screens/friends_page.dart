import 'package:flutter/material.dart';
import 'package:splitly/components/friend_card.dart';
import 'package:splitly/models/friend_profile.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return FriendCard(friend: friends[index]);
        },
    );
  }
}
