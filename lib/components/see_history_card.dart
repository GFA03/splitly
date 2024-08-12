import 'package:flutter/material.dart';
import 'package:splitly/models/friend_profile.dart';
import 'package:splitly/screens/history_page.dart';

class SeeHistoryCard extends StatefulWidget {
  const SeeHistoryCard({
    super.key,
    required this.friend,
    required this.onExpenseDeleted,
  });

  final FriendProfile friend;
  final VoidCallback onExpenseDeleted;

  @override
  State<SeeHistoryCard> createState() => _SeeHistoryCardState();
}

class _SeeHistoryCardState extends State<SeeHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Last expense: ${widget.friend.expenses.last.name} ${widget.friend.expenses.last.totalCost}\$ (paid by ${widget.friend.expenses.last.payer})',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        TextButton(
            onPressed: () async {
              final updated = await Navigator.push<bool>(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(
                    friend: widget.friend,
                    onExpenseDeleted: () {
                      widget.onExpenseDeleted();
                    },
                  ),
                ),
              );

              if (updated == true) {
                setState(() {});
              }
            },
            child: const Text('See all history')),
      ],
    );
  }
}
