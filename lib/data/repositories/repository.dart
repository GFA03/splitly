import '../models/models.dart';

abstract class Repository {
  Stream<List<FriendProfile>> watchAllFriends();

  Stream<List<Expense>> watchAllExpenses();

  Future<List<FriendProfile>> findAllFriends();

  Future<Expense> findExpenseById(String id);

  Future<FriendProfile> findFriendById(String id);

  Future<List<Expense>> findAllExpenses();

  Future<List<Expense>> findFriendExpenses(String friendId);

  Future<void> selectFriend(FriendProfile friend);

  Future<int> insertFriend(FriendProfile friend);

  Future<int> insertExpense(Expense expense);

  Future<void> editFriendName(FriendProfile friend, String newName);

  Future<void> editExpense(Expense oldExpense, Expense newExpense);

  Future<void> deleteFriend(FriendProfile friend);

  Future<void> deleteExpense(Expense expense);

  Future<void> deleteExpenses(List<Expense> expenses);

  Future<void> deleteFriendExpenses(String friendId);

  Future init();
  void close();

}