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

  // Lazy-loaded list of pages
  final List<Widget> _pages = [
    const BalancePage(name: 'John Doe'),
    const FriendsPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _restoreSavedIndex();
  }

  // Restore saved bottom navigation index
  Future<void> _restoreSavedIndex() async {
    final prefs = ref.read(sharedPrefProvider);
    final savedIndex = prefs.getInt(prefSelectedIndexKey) ?? 0;

    // Schedule provider modification after the build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bottomNavigationProvider.notifier).updateSelectedIndex(savedIndex);
    });
  }

  void _saveCurrentIndex() {
    final prefs = ref.read(sharedPrefProvider);
    final selectedIndex = ref.read(bottomNavigationProvider).selectedIndex;
    prefs.setInt(prefSelectedIndexKey, selectedIndex);
  }

  void _onItemTapped(int index) {
    ref.read(bottomNavigationProvider.notifier).updateSelectedIndex(index);
    _saveCurrentIndex();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = ref.watch(bottomNavigationProvider).selectedIndex;

    return Scaffold(
      appBar: _buildAppBar(context),
      resizeToAvoidBottomInset: false, // Prevent keyboard from shifting layout
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: _pages,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: const Text(
        'Splitly',
        style: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor:
          isDarkMode ? darkBackgroundColor : lightBackgroundColor,
      centerTitle: true,
      elevation: 0,
      iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications),
          onPressed: () {
            // Add any notification action here
          },
        ),
      ],
    );
  }
}

// Extracted BottomNavigationBar Widget
class MainBottomNavigationBar extends StatelessWidget {
  const MainBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onItemTapped,
  });

  final int currentIndex;
  final Function(int) onItemTapped;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final selectedColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor =
        isDarkMode ? darkBackgroundColor : smallCardBackgroundColor;

    return BottomNavigationBar(
      backgroundColor: backgroundColor,
      currentIndex: currentIndex,
      selectedItemColor: selectedColor,
      unselectedItemColor: Colors.grey,
      items: _bottomNavigationItems(currentIndex),
      onTap: onItemTapped,
    );
  }

  List<BottomNavigationBarItem> _bottomNavigationItems(int currentIndex) {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.balance),
        label: 'Balance',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.people),
        backgroundColor: currentIndex == 1 ? iconBackgroundColor : Colors.black,
        label: 'Friends',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.settings),
        label: 'Settings',
      ),
    ];
  }
}
