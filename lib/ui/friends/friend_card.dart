import 'package:flutter/material.dart';
import 'package:splitly/data/models/friend_profile.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
    required this.friend,
    required this.onEdit,
  });

  final FriendProfile friend;
  final void Function(String) onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: _buildFriendInfo(context),
      ),
    );
  }

  Row _buildFriendInfo(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(backgroundImage: AssetImage(friend.imageUrl), radius: 25),
        const SizedBox(width: 15.0),
        Text(friend.name),
        const Spacer(),
        _buildEditButton(context)
      ],
    );
  }

  IconButton _buildEditButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          _showEditDialog(context);
        },
        icon: Icon(
          Icons.edit,
          color: Theme.of(context).iconTheme.color,
          size: 18,
        ));
  }

  void _showEditDialog(BuildContext context) {
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
                  onEdit(controller
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
