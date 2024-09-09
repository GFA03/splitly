import 'package:flutter/material.dart';
import 'package:splitly/ui/friends/components/friend_card.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/utils.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key, required this.onFriendSelected});

  final void Function(FriendProfile) onFriendSelected;

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late List<FriendProfile> persons;
  static const String defaultProfileImage =
      'assets/profile_pics/profile_picture1.jpg';

  @override
  void initState() {
    super.initState();
    persons = friends;
  }

  //TODO: change State Management to separate concerns

  void _deleteFriend(int index) {
    final deletedFriend = persons[index];
    setState(() {
      persons.removeAt(index);
    });

    showSnackBar(context, '${deletedFriend.name} deleted', 'Undo', () {
      setState(() {
        persons.insert(index, deletedFriend);
      });
    });
  }

  void _editFriendName(int index, String newName) {
    setState(() {
      persons[index].name = newName;
    });
    showSnackBar(context, '${persons[index].name} edited successfully!');
  }

  void _addFriend(String? newFriendName) {
    if (newFriendName != null && newFriendName.isNotEmpty) {
      setState(() {
        persons.add(FriendProfile(name: newFriendName, imageUrl: defaultProfileImage));
      });
      showSnackBar(context, '$newFriendName added');
      Navigator.of(context).pop();
    } else {
      showSnackBar(context, 'Friend\'s name cannot be empty!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          return _buildFriendListItem(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddFriendDialog(context);
        },
        tooltip: 'Add Friend',
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return _buildAddFriendDialog(context);
        });
  }

  AlertDialog _buildAddFriendDialog(BuildContext context) {
    String? newFriendName;
    return AlertDialog(
      title: const Text('Add new friend'),
      content: TextField(
        decoration: const InputDecoration(
          hintText: 'Enter friend\'s name',
        ),
        onChanged: (value) {
          newFriendName = value;
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            _addFriend(newFriendName);
          },
          child: const Text('Save'),
        )
      ],
    );
  }

  Dismissible _buildFriendListItem(int index) {
    return Dismissible(
      key: Key(persons[index].name),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteFriend(index);
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
        child: FriendCard(
          friend: persons[index],
          onEdit: (newName) => _editFriendName(index, newName),
        ),
      ),
    );
  }
}
