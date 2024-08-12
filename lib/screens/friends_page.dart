import 'package:flutter/material.dart';
import 'package:splitly/components/friend_card.dart';
import 'package:splitly/models/friend_profile.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key, required this.onFriendSelected});

  final void Function(FriendProfile) onFriendSelected;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late List<FriendProfile> persons;

  @override
  void initState() {
    super.initState();
    persons = friends;
  }

  void deleteFriend(int index) {
    FriendProfile deletedFriend = persons[index];
    setState(() {
      persons.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedFriend.name} deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              persons.insert(index, deletedFriend);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(persons[index].name),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              deleteFriend(index);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            child: GestureDetector(
              onTap: () => widget.onFriendSelected(persons[index]),
              child: FriendCard(friend: persons[index]),
            ),
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
                        persons.add(FriendProfile(
                            value, 'assets/profile_pics/profile_picture1.jpg'));
                        Navigator.of(context).pop();
                        setState(() {

                        });
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
