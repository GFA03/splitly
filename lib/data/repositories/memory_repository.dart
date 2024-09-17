import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/current_friend_data.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/data/repositories/repository.dart';

class MemoryRepository extends Notifier<CurrentFriendData>
    implements Repository {
  @override
  CurrentFriendData build() {
    const currentFriendData = CurrentFriendData();
    return currentFriendData;
  }

  @override
  List<FriendProfile> findAllFriends() {
    return state.currentFriends;
  }

  @override
  Expense findExpenseById(String id) {
    return state.currentExpenses.firstWhere((expense) => expense.id == id);
  }

  @override
  FriendProfile findFriendById(String id) {
    return state.currentFriends.firstWhere((friend) => friend.id == id);
  }

  @override
  List<Expense> findAllExpenses() {
    return state.currentExpenses;
  }

  @override
  List<Expense> findFriendExpenses(String friendId) {
    return state.currentExpenses
        .where((expense) => expense.friendId == friendId)
        .toList();
  }

  @override
  void selectFriend(FriendProfile friend) {
    state = state.copyWith(selectedFriend: friend);
  }

  @override
  int insertFriend(FriendProfile friend) {
    state = state.copyWith(
        currentFriends: [...state.currentFriends, friend]);
    return 0;
  }

  @override
  int insertExpense(Expense expense) {
    state = state.copyWith(
        currentExpenses: [...state.currentExpenses, expense]);
    return 0;
  }

  @override
  void editFriendName(FriendProfile friend, String newName) {
    final updatedFriends = state.currentFriends.map((f) {
      if (f.id == friend.id) {
        return FriendProfile(id: f.id, name: newName, imageUrl: f.imageUrl);
      }
      return f;
    }).toList();

    state = state.copyWith(currentFriends: updatedFriends);
  }

  @override
  void editExpense(Expense oldExpense, Expense newExpense) {
    final updatedExpenses = state.currentExpenses.map((e) {
      if (e.id == oldExpense.id) {
        return newExpense;
      }
      return e;
    }).toList();

    state = state.copyWith(currentExpenses: updatedExpenses);
  }

  @override
  void deleteFriend(FriendProfile friend) {
    final updatedFriends = state.currentFriends
        .where((f) => f.id != friend.id)
        .toList();
    final updatedSelectedFriend = state.selectedFriend == friend ? null : state.selectedFriend;
    state = state.copyWith(currentFriends: updatedFriends, selectedFriend: updatedSelectedFriend);
  }

  @override
  void deleteExpense(Expense expense) {
    final updatedExpenses = state.currentExpenses
        .where((e) => e.id != expense.id)
        .toList();
    state = state.copyWith(currentExpenses: updatedExpenses);
  }

  @override
  void deleteExpenses(List<Expense> expenses) {
    final updatedExpenses = state.currentExpenses
        .where((expense) => !expenses.contains(expense))
        .toList();
    state = state.copyWith(currentExpenses: updatedExpenses);
  }

  @override
  void deleteFriendExpenses(String friendId) {
    final updatedExpenses = state.currentExpenses
        .where((expense) => expense.friendId != friendId)
        .toList();
    state = state.copyWith(currentExpenses: updatedExpenses);
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {}
}
