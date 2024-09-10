import 'package:flutter/foundation.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/data/repositories/repository.dart';

class MemoryRepository with ChangeNotifier implements Repository {
  final List<FriendProfile> _currentFriends = [
    FriendProfile(
        id: '24f183b5-006a-47cc-8b5d-b2bacf484765',
        name: 'Alex Gavrila',
        imageUrl: 'assets/profile_pics/profile_picture2.jpg'),
    FriendProfile(
        id: '458644d3-2543-41d4-9bfa-ce736f74008f',
        name: 'James Rodriguez',
        imageUrl: 'assets/profile_pics/profile_picture3.jpg'),
    FriendProfile(
        id: '9cbc96dc-eb41-430c-b083-0130bbde61a8',
        name: 'Layla Ponta',
        imageUrl: 'assets/profile_pics/profile_picture4.jpg'),
    FriendProfile(
        id: 'c3893d45-e4a2-44fe-898d-e84662d9d691',
        name: 'Crezulo Davinci',
        imageUrl: 'assets/profile_pics/profile_picture5.jpg'),
    FriendProfile(
        id: '5aa326ca-59b1-4280-a84a-9281e73f9d57',
        name: 'John Doe',
        imageUrl: 'assets/profile_pics/profile_picture6.jpg'),
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

  @override
  void editFriendName(FriendProfile friend, String newName) {
    friend.name = newName;
    notifyListeners();
  }

  @override
  void editExpense(Expense oldExpense, Expense newExpense) {
    oldExpense = newExpense;
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
