import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/balance/balance_page.dart';
import 'package:splitly/ui/friends/friends_page.dart';

class Home extends ConsumerStatefulWidget {
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
  ConsumerState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  int _selectedIndex = 0;

  // TODO: make selected friend to be sharedprefs and read the sharedprefs in TrackExpense page to edit the expense.friendId field
  FriendProfile? _selectedFriend;

  static const String prefSelectedIndexKey = 'selectedIndex';
  static const String prefSelectedFriendKey = 'selectedFriend';

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

  void _saveFriend(FriendProfile friend) {
    final prefs = ref.read(sharedPrefProvider);
    prefs.setString(prefSelectedFriendKey, friend.id);
  }

  void _saveCurrentIndex() {
    final prefs = ref.read(sharedPrefProvider);
    prefs.setInt(prefSelectedIndexKey, _selectedIndex);
  }

  void _selectFriend(FriendProfile friend) {
    _saveFriend(friend);
    setState(() {
      _selectedFriend = friend;
      _selectedIndex = 0;
    });
    _saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BalancePage(name: widget.name, friend: _selectedFriend),
      FriendsPage(onFriendSelected: _selectFriend),
      const Center(
        child: Text('Settings'),
      )
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // avoid overflow issue when going back to home page with mobile keyboard opened
      appBar: AppBar(
        title: Text(widget.appTitle),
        elevation: 4.0,
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _saveCurrentIndex();
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
