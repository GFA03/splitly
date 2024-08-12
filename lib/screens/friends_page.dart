import 'package:flutter/material.dart';
import 'package:splitly/components/friend_card.dart';
import 'package:splitly/models/friend_profile.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key, required this.onFriendSelected});

  final void Function(FriendProfile) onFriendSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onFriendSelected(friends[index]),
            child: FriendCard(friend: friends[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add new friend'),
                  content: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Enter friend\'s name',
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        friends.add(FriendProfile(
                            value, 'assets/profile_pics/profile_picture1.jpg'));
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ],
                );
              });
        },
        tooltip: 'Add Friend',
        child: const Icon(Icons.add),
      ),
    );
  }
}
