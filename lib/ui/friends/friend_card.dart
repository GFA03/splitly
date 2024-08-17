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

  void _showEditDialog(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: friend.name);

    showDialog(
      context: context,
      builder: (context) {
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
            const SizedBox(
              width: 15.0,
            ),
            Text(friend.name),
            const Spacer(),
            IconButton(
                onPressed: () {
                  _showEditDialog(context);
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: 18,
                ))
          ],
        ),
      ),
    );
  }
}
