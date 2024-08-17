import 'package:flutter/material.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/ui/balance/balance_page.dart';
import 'package:splitly/ui/friends/friends_page.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
    required this.changeTheme,
    required this.appTitle,
    required this.name,
  });

  final void Function(bool useLightMode) changeTheme;
  final String appTitle;
  final String name;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;
  FriendProfile? selectedFriend = friends[0];

  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Balance',
      selectedIcon: Icon(Icons.home),
    ),
    NavigationDestination(
      icon: Icon(Icons.people_outline),
      label: 'Friends',
      selectedIcon: Icon(Icons.people),
    ),
    NavigationDestination(
      icon: Icon(Icons.settings_outlined),
      label: 'Settings',
      selectedIcon: Icon(Icons.settings),
    ),
  ];

  void _selectFriend(FriendProfile friend) {
    setState(() {
      selectedFriend = friend;
      tab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BalancePage(name: widget.name, friend: selectedFriend),
      FriendsPage(onFriendSelected: _selectFriend),
      const Center(
        child: Text('Settings'),
      )
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
        elevation: 4.0,
      ),
      body: IndexedStack(index: tab, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) {
          setState(() {
            tab = index;
          });
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
