import 'package:flutter/material.dart';
import 'package:splitly/models/friend_profile.dart';
import 'package:splitly/pages/track_expense_page.dart';
import 'package:splitly/components/balance_card.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.changeTheme,
    required this.appTitle,
  });

  final void Function(bool useLightMode) changeTheme;
  final String appTitle;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 150.0,
          ),
          const Text(
            'Hello {name}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 100.0,
          ),
          BalanceCard(friend: friends[1]),
          const SizedBox(height: 20.0),
          Text(
            'Last expense: ${friends[1].expenses?.last.expenseName} ${friends[1].expenses?.last.cost}\$ (paid by ${friends[1].expenses?.last.payer})',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          TextButton(onPressed: () {}, child: const Text('See all history')),
          const Spacer(),
          ElevatedButton(
            onPressed: () async {
              final newExpense = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TrackExpense(friend: friends[1])),
              );

              if (newExpense != null) {
                setState(() {
                  friends[1].expenses?.add(newExpense);
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
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
