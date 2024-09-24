import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/current_friend_data.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';
import 'package:splitly/data/repositories/repository.dart';

class MemoryRepository extends Notifier<CurrentFriendData>
    implements Repository {
  late Stream<List<FriendProfile>> _friendStream;
  late Stream<List<Expense>> _expenseStream;

  final StreamController _friendStreamController =
      StreamController<List<FriendProfile>>();
  final StreamController _expenseStreamController =
      StreamController<List<Expense>>();

  MemoryRepository() {
    _friendStream = _friendStreamController.stream.asBroadcastStream(
      onListen: (subscription) {
        // send current friends to new subscriber
        _friendStreamController.sink.add(state.currentFriends);
      },
    ) as Stream<List<FriendProfile>>;
    _expenseStream = _expenseStreamController.stream.asBroadcastStream(
      onListen: (subscription) {
        // send current expenses to new subscriber
        _expenseStreamController.sink.add(state.currentExpenses);
      },
    ) as Stream<List<Expense>>;
  }

  @override
  CurrentFriendData build() {
    var currentFriendData =
        CurrentFriendData(selectedFriend: dummyFriendData[0]);
    return currentFriendData;
  }

  @override
  Stream<List<FriendProfile>> watchAllFriends() {
    return _friendStream;
  }

  @override
  Stream<List<Expense>> watchAllExpenses() {
    return _expenseStream;
  }

  @override
  Future<List<FriendProfile>> findAllFriends() {
    return Future.value(state.currentFriends);
  }

  @override
  Future<Expense> findExpenseById(String id) {
    return Future.value(
        state.currentExpenses.firstWhere((expense) => expense.id == id));
  }

  @override
  Future<FriendProfile> findFriendById(String id) {
    return Future.value(
        state.currentFriends.firstWhere((friend) => friend.id == id));
  }

  @override
  Future<List<Expense>> findAllExpenses() {
    return Future.value(state.currentExpenses);
  }

  @override
  Future<List<Expense>> findFriendExpenses(String friendId) {
    return Future.value(state.currentExpenses
        .where((expense) => expense.friendId == friendId)
        .toList());
  }

  @override
  Future<void> selectFriend(FriendProfile friend) {
    state = state.copyWith(selectedFriend: friend);

    return Future.value();
  }

  @override
  Future<int> insertFriend(FriendProfile friend) {
    state = state.copyWith(currentFriends: [...state.currentFriends, friend]);
    _friendStreamController.sink.add(state.currentFriends);
    return Future.value(0);
  }

  @override
  Future<int> insertExpense(Expense expense) {
    state =
        state.copyWith(currentExpenses: [...state.currentExpenses, expense]);
    _expenseStreamController.sink.add(state.currentExpenses);
    return Future.value(0);
  }

  @override
  Future<void> editFriendName(FriendProfile friend, String newName) {
    final updatedFriends = state.currentFriends.map((f) {
      if (f.id == friend.id) {
        return FriendProfile(id: f.id, name: newName, imageUrl: f.imageUrl);
      }
      return f;
    }).toList();

    state = state.copyWith(currentFriends: updatedFriends);
    _friendStreamController.sink.add(state.currentFriends);
    return Future.value();
  }

  @override
  Future<void> editExpense(Expense oldExpense, Expense newExpense) {
    final updatedExpenses = state.currentExpenses.map((e) {
      if (e.id == oldExpense.id) {
        return newExpense;
      }
      return e;
    }).toList();

    state = state.copyWith(currentExpenses: updatedExpenses);
    _expenseStreamController.sink.add(state.currentExpenses);
    return Future.value();
  }

  @override
  Future<void> deleteFriend(FriendProfile friend) {
    final updatedFriends =
        state.currentFriends.where((f) => f.id != friend.id).toList();
    final updatedSelectedFriend =
        state.selectedFriend == friend ? null : state.selectedFriend;
    state = state.copyWith(
        currentFriends: updatedFriends, selectedFriend: updatedSelectedFriend);
    _friendStreamController.sink.add(state.currentFriends);
    return Future.value();
  }

  @override
  Future<void> deleteExpense(Expense expense) {
    final updatedExpenses =
        state.currentExpenses.where((e) => e.id != expense.id).toList();
    state = state.copyWith(currentExpenses: updatedExpenses);
    _expenseStreamController.sink.add(state.currentExpenses);
    return Future.value();
  }

  @override
  Future<void> deleteExpenses(List<Expense> expenses) {
    final updatedExpenses = state.currentExpenses
        .where((expense) => !expenses.contains(expense))
        .toList();
    state = state.copyWith(currentExpenses: updatedExpenses);
    _expenseStreamController.sink.add(state.currentExpenses);
    return Future.value();
  }

  @override
  Future<void> deleteFriendExpenses(String friendId) {
    final updatedExpenses = state.currentExpenses
        .where((expense) => expense.friendId != friendId)
        .toList();
    state = state.copyWith(currentExpenses: updatedExpenses);
    _expenseStreamController.sink.add(state.currentExpenses);
    return Future.value();
  }

  @override
  Future init() {
    return Future.value(null);
  }

  @override
  void close() {
    _expenseStreamController.close();
    _friendStreamController.close();
  }
}
