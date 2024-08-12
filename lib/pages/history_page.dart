import 'package:flutter/material.dart';
import 'package:splitly/components/expense_card.dart';
import 'package:splitly/models/friend_profile.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    super.key,
    required this.friend,
  });

  final FriendProfile friend;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Splitly'),
        ),
        body: ListView.builder(
          itemCount: friend.expenses?.length,
          itemBuilder: (context, index) {
            int reversedIndex = (friend.expenses?.length ?? 0) - 1 - index;
            return ExpenseCard(expense: friend.expenses![reversedIndex]);
          },
        ));
  }
}
