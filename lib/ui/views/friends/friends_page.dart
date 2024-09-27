import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/utils.dart';
import 'package:splitly/utils/friend_utils.dart';

class FriendsPage extends ConsumerStatefulWidget {
  const FriendsPage({super.key});

  @override
  ConsumerState createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {

  void _deleteFriend(int index) {
    final friends = ref.watch(repositoryProvider).currentFriends;
    final deletedFriend = friends[index];
    ref.read(repositoryProvider.notifier).deleteFriend(friends[index]);

    if (ref.read(selectedFriendProvider) == deletedFriend) {
      ref.read(selectedFriendProvider.notifier).removeSelectedFriend();
    }

    // TODO: add the friend back on their last index
    showSnackBar(context, '${deletedFriend.name} deleted', 'Undo', () {
      ref.read(repositoryProvider.notifier).insertFriend(deletedFriend);
    });
  }

  void _editFriendName(FriendProfile friend, String newName) {
    ref.read(repositoryProvider.notifier).editFriendName(friend, newName);
    showSnackBar(context, '${friend.name} edited successfully!');
  }

  void _addFriend(String? name) {
    if (name != null && name.isNotEmpty) {
      final newFriend =
          FriendProfile(name: name, imageUrl: FriendUtils.defaultProfileImage);
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
          return _buildFriendListItem(friends[index], index);
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

  Dismissible _buildFriendListItem(FriendProfile friend, int index) {
    return Dismissible(
      key: Key(friend.name),
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
        onTap: () {
          FriendUtils.setSelectedFriend(ref, friend);
          ref.read(bottomNavigationProvider.notifier).updateSelectedIndex(0);
          //todo: use theme context everywhere instead of hard coded values
        },
        child: _buildFriendCard(
          friend: friend,
        ),
      ),
    );
  }

  Card _buildFriendCard({required FriendProfile friend}) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: _buildFriendInfo(context, friend),
      ),
    );
  }

  Row _buildFriendInfo(BuildContext context, FriendProfile friend) {
    return Row(
      children: [
        CircleAvatar(
            backgroundImage: AssetImage(
                friend.imageUrl ?? 'assets/profile_pics/profile_picture6.jpg'),
            radius: 25),
        const SizedBox(width: 15.0),
        Text(friend.name),
        const Spacer(),
        _buildEditButton(context, friend)
      ],
    );
  }

  IconButton _buildEditButton(BuildContext context, FriendProfile friend) {
    return IconButton(
        onPressed: () {
          _showEditDialog(context, friend);
        },
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).iconTheme.color,
          size: 18,
        ));
  }

  void _showEditDialog(BuildContext context, FriendProfile friend) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller =
            TextEditingController(text: friend.name);

        return AlertDialog(
          title: const Text('Edit Friend Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter new name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Cancel editing
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  _editFriendName(
                      friend,
                      controller
                          .text); // Call the edit callback with the new name
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
