import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/current_friend_data.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/data/repositories/repository.dart';

class MemoryRepository extends Notifier<CurrentFriendData>
    implements Repository {
  @override
  CurrentFriendData build() {
    // final List<FriendProfile> state.currentFriends = [
    //   FriendProfile(
    //       id: '24f183b5-006a-47cc-8b5d-b2bacf484765',
    //       name: 'Alex Gavrila',
    //       imageUrl: 'assets/profile_pics/profile_picture2.jpg'),
    //   FriendProfile(
    //       id: '458644d3-2543-41d4-9bfa-ce736f74008f',
    //       name: 'James Rodriguez',
    //       imageUrl: 'assets/profile_pics/profile_picture3.jpg'),
    //   FriendProfile(
    //       id: '9cbc96dc-eb41-430c-b083-0130bbde61a8',
    //       name: 'Layla Ponta',
    //       imageUrl: 'assets/profile_pics/profile_picture4.jpg'),
    //   FriendProfile(
    //       id: 'c3893d45-e4a2-44fe-898d-e84662d9d691',
    //       name: 'Crezulo Davinci',
    //       imageUrl: 'assets/profile_pics/profile_picture5.jpg'),
    //   FriendProfile(
    //       id: '5aa326ca-59b1-4280-a84a-9281e73f9d57',
    //       name: 'John Doe',
    //       imageUrl: 'assets/profile_pics/profile_picture6.jpg'),
    // ];
    const currentFriendData = CurrentFriendData(
      currentFriends: [],
      currentExpenses: [],
      selectedFriend: null,
    );
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
