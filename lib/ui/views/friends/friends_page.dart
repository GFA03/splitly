import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/views/friends/components/friend_card.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/utils.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key, required this.onFriendSelected});

  final void Function(FriendProfile) onFriendSelected;

  @override
  ConsumerState createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {

  static const String defaultProfileImage =
      'assets/profile_pics/profile_picture1.jpg';

  void _deleteFriend(int index) {
    final friends = ref.watch(repositoryProvider).currentFriends;
    final deletedFriend = friends[index];
    ref.read(repositoryProvider.notifier).deleteFriend(friends[index]);

    // TODO: add the friend back on their last index
    showSnackBar(context, '${deletedFriend.name} deleted', 'Undo', () {
      ref.read(repositoryProvider.notifier).insertFriend(deletedFriend);
    });
  }

  void _editFriendName(int index, String newName) {
    final friends = ref.watch(repositoryProvider).currentFriends;
    ref.read(repositoryProvider.notifier).editFriendName(friends[index], newName);
    showSnackBar(context, '${friends[index].name} edited successfully!');
  }

  void _addFriend(String? name) {
    if (name != null && name.isNotEmpty) {
      final newFriend = FriendProfile(name: name, imageUrl: defaultProfileImage);
      ref.read(repositoryProvider.notifier).insertFriend(newFriend);
      showSnackBar(context, '$name added');
      Navigator.of(context).pop();
    } else {
      showSnackBar(context, 'Friend\'s name cannot be empty!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(repositoryProvider);
    final friends = repository.currentFriends;
    return Scaffold(
      body: ListView.builder(
        itemCount: friends.length,
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
    final repository = ref.watch(repositoryProvider);
    final friends = repository.currentFriends;
    return Dismissible(
      key: Key(friends[index].name),
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
        onTap: () => widget.onFriendSelected(friends[index]),
        child: FriendCard(
          friend: friends[index],
          onEdit: (newName) => _editFriendName(index, newName),
        ),
      ),
    );
  }
}
