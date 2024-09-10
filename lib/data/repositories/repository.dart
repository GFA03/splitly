import '../models/models.dart';

abstract class Repository {
  List<FriendProfile> findAllFriends();

  Expense findExpenseById(String id);

  FriendProfile findFriendById(String id);

  List<Expense> findAllExpenses();

  List<Expense> findFriendExpenses(String friendId);

  int insertFriend(FriendProfile friend);

  int insertExpense(Expense expense);

  void editFriendName(FriendProfile friend, String newName);

  void editExpense(Expense oldExpense, Expense newExpense);

  void deleteFriend(FriendProfile friend);

  void deleteExpense(Expense expense);

  void deleteExpenses(List<Expense> expenses);

  void deleteFriendExpenses(String friendId);

  Future init();
  void close();

}