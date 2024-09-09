import 'package:splitly/data/models/expense.dart';
import 'package:uuid/uuid.dart';

class FriendProfile {
  FriendProfile({String? id, required this.name, this.imageUrl})
      : id = id ?? const Uuid().v4();

  final String id;
  String name;
  String? imageUrl;
  List<Expense> expenses = [];

  set setName(String newName) {
    if (newName.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    name = newName;
  }

  double calculateBalance() {
    if (expenses.isEmpty) {
      return 0;
    }
    return expenses.fold<double>(
        0, (previousValue, element) => previousValue + element.balance);
  }
}
