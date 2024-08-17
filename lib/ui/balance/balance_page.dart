import 'package:flutter/material.dart';
import 'package:splitly/ui/balance/balance_card.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/balance/track_expense_page.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({
    super.key,
    required this.name,
    required this.friend,
  });

  final String name;
  final FriendProfile? friend;

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  @override
  Widget build(BuildContext context) {
    return widget.friend == null ? const Center(child: Text('Please select a friend'),) : Column(
      children: [
        const SizedBox(
          height: 150.0,
        ),
        Text(
          'Hello ${widget.name}',
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 100.0,
        ),
        BalanceCard(friend: widget.friend!, onExpenseDeleted: () {
          setState(() {

          });
        },),
        const Spacer(),
        ElevatedButton(
          onPressed: () async {
            final newExpense = await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => TrackExpense(friend: widget.friend!)),
            );

            if (newExpense != null) {
              setState(() {
                widget.friend!.expenses.add(newExpense);
              });
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
            textStyle: const TextStyle(fontSize: 20),
            padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
          ),
          child: const Text(
            'Track expense',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        ),
      ],
    );
  }
}
