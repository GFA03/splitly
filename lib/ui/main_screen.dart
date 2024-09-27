import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/theme/colors.dart';
import 'package:splitly/ui/views/balance/balance_page.dart';
import 'package:splitly/ui/views/friends/friends_page.dart';
import 'package:splitly/ui/views/settings/settings_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({
    super.key,
  });

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  List<Widget> pageList = <Widget>[];

  static const String prefSelectedIndexKey = 'selectedIndex';

  @override
  void initState() {
    super.initState();
    pageList.add(const BalancePage(name: 'John Doe'));
    pageList.add(const FriendsPage());
    pageList.add(const SettingsPage());
  }

  void _saveCurrentIndex() {
    final prefs = ref.read(sharedPrefProvider);
    final bottomNavigation = ref.read(bottomNavigationProvider);
    prefs.setInt(prefSelectedIndexKey, bottomNavigation.selectedIndex);
  }

  void _onItemTapped(int index) {
    ref.read(bottomNavigationProvider.notifier).updateSelectedIndex(index);
    _saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // avoid overflow issue when going back to home page with mobile keyboard opened
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _createBottomNavigationBar(),
      body: SafeArea(
          child: IndexedStack(
        index: ref.watch(bottomNavigationProvider).selectedIndex,
        children: pageList,
      )),
    );
  }

  BottomNavigationBar _createBottomNavigationBar() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
        isDarkMode ? darkBackgroundColor : smallCardBackgroundColor;
    final bottomNavigationIndex =
        ref.watch(bottomNavigationProvider).selectedIndex;
    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      currentIndex: bottomNavigationIndex,
      selectedItemColor: selectedColor,
      unselectedItemColor: Colors.grey,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.balance),
          label: 'Balance',
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.people),
          backgroundColor:
              bottomNavigationIndex == 1 ? iconBackgroundColor : Colors.black,
          label: 'Friends',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
      onTap: _onItemTapped,
    );
  }
}
