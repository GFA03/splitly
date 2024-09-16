import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/balance/balance_page.dart';
import 'package:splitly/ui/friends/friends_page.dart';
import 'package:splitly/ui/settings/settings_page.dart';

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

  static const String prefSelectedIndexKey = 'selectedIndex';

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
    ref.read(repositoryProvider.notifier).selectFriend(friend);
  }

  void _saveCurrentIndex() {
    final prefs = ref.read(sharedPrefProvider);
    prefs.setInt(prefSelectedIndexKey, _selectedIndex);
  }

  void _selectFriend(FriendProfile friend) {
    _saveFriend(friend);
    setState(() {
      _selectedIndex = 0;
    });
    _saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    //todo: nu mai isi are rostul sa trimiti onFriendSelected intrucat selected friend il ai cu riverpod si indexedtab il schimbi din sharedprefs, astfel poti sa nu mai ai aici selected friend.

    final pages = [
      BalancePage(name: widget.name),
      FriendsPage(onFriendSelected: _selectFriend),
      const SettingsPage(),
    ];
    return Scaffold(
      // avoid overflow issue when going back to home page with mobile keyboard opened
      resizeToAvoidBottomInset: false,
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
