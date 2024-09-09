import 'package:flutter/foundation.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/data/repositories/repository.dart';

class MemoryRepository with ChangeNotifier implements Repository {
  final List<FriendProfile> _currentFriends = [
    FriendProfile(
        name: 'Alex Gavrila',
        imageUrl: 'assets/profile_pics/profile_picture2.jpg'),
    FriendProfile(
        name: 'James Rodriguez',
        imageUrl: 'assets/profile_pics/profile_picture3.jpg'),
    FriendProfile(
        name: 'Layla Ponta',
        imageUrl: 'assets/profile_pics/profile_picture4.jpg'),
    FriendProfile(
        name: 'Crezulo Davinci',
        imageUrl: 'assets/profile_pics/profile_picture5.jpg'),
    FriendProfile(
        name: 'John Doe', imageUrl: 'assets/profile_pics/profile_picture6.jpg'),
  ];

  final List<Expense> _currentExpenses = <Expense>[];

  @override
  List<FriendProfile> findAllFriends() {
    return _currentFriends;
  }

  @override
  Expense findExpenseById(String id) {
    return _currentExpenses.firstWhere((expense) => expense.id == id);
  }

  @override
  FriendProfile findFriendById(String id) {
    return _currentFriends.firstWhere((friend) => friend.id == id);
  }

  @override
  List<Expense> findAllExpenses() {
    return _currentExpenses;
  }

  @override
  List<Expense> findFriendExpenses(String friendId) {
    final friend =
        _currentFriends.firstWhere((friend) => friend.id == friendId);
    final friendExpenses = _currentExpenses
        .where((expense) => expense.friendId == friend.id)
        .toList();
    return friendExpenses;
  }

  @override
  int insertFriend(FriendProfile friend) {
    _currentFriends.add(friend);
    notifyListeners();
    return 0;
  }

  @override
  int insertExpense(Expense expense) {
    _currentExpenses.add(expense);
    notifyListeners();
    return 0;
  }

  void editFriendName(FriendProfile friend, String newName) {
    friend.name = newName;
    notifyListeners();
  }

  @override
  void deleteFriend(FriendProfile friend) {
    _currentFriends.remove(friend);
    notifyListeners();
  }

  @override
  void deleteExpense(Expense expense) {
    _currentExpenses.remove(expense);
    notifyListeners();
  }

  @override
  void deleteExpenses(List<Expense> expenses) {
    _currentExpenses.removeWhere((expense) => expenses.contains(expense));
  }

  @override
  void deleteFriendExpenses(String friendId) {
    _currentExpenses.removeWhere((expense) => expense.friendId == friendId);
    notifyListeners();
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
