import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
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
    const currentFriendData = CurrentFriendData();
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
  Stream<List<Expense>> watchFriendExpenses(String friendId) {
    return _expenseStream.map((expenses) =>
        expenses.where((expense) => expense.friendId == friendId).toList());
  }

  @override
  Future<double> calculateFriendBalance(String friendId) {
    final expenses = state.currentExpenses
        .where((expense) => expense.friendId == friendId)
        .toList();
    return Future.value(
        expenses.fold<double>(0, (prev, el) => prev + el.balance));
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
  Future<FriendProfile?> findFriendById(String id) {
    return Future.value(
        state.currentFriends.firstWhereOrNull((friend) => friend.id == id));
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
        return FriendProfile(
            id: f.id, name: newName, profilePicture: f.profilePicture);
      }
      return f;
    }).toList();

    state = state.copyWith(currentFriends: updatedFriends);
    _friendStreamController.sink.add(state.currentFriends);
    return Future.value();
  }

  @override
  Future<void> editFriendPicture(FriendProfile friend, String newPicture) {
    final updatedFriends = state.currentFriends.map((f) {
      if (f.id == friend.id) {
        return FriendProfile(
            id: f.id, name: f.name, profilePicture: newPicture);
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
    state = state.copyWith(currentFriends: updatedFriends);
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
