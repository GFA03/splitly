import 'package:flutter/material.dart';
import 'package:splitly/ui/friends/friend_card.dart';
import 'package:splitly/data/models/friend_profile.dart';

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

    _showSnackBar('${deletedFriend.name} deleted', 'Undo', () {
      setState(() {
        persons.insert(index, deletedFriend);
      });
    });
  }

  void _editFriendName(int index, String newName) {
    setState(() {
      persons[index].name = newName;
    });
    _showSnackBar('${persons[index].name} edited successfully!');
  }

  void _addFriend(String? newFriendName) {
    if (newFriendName != null && newFriendName.isNotEmpty) {
      setState(() {
        persons.add(FriendProfile(newFriendName, defaultProfileImage));
      });
      _showSnackBar('$newFriendName added');
      Navigator.of(context).pop();
    } else {
      _showSnackBar('Friend\'s name cannot be empty!');
    }
  }

  void _showSnackBar(String message,
      [String? actionLabel, VoidCallback? action]) {
    final snackBar = SnackBar(
      content: Text(message),
      action: actionLabel != null
          ? SnackBarAction(label: actionLabel, onPressed: action!)
          : null,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
