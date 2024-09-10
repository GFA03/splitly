import 'package:uuid/uuid.dart';

import '../repositories/repository.dart';

class FriendProfile {
  FriendProfile({String? id, required this.name, this.imageUrl})
      : id = id ?? const Uuid().v4();

  final String id;
  String name;
  String? imageUrl;

  set setName(String newName) {
    if (newName.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    name = newName;
  }

  double calculateBalance(Repository repository) {
    final expenses = repository.findFriendExpenses(id);
    if (expenses.isEmpty) {
      return 0;
    }
    return expenses.fold<double>(
        0, (previousValue, element) => previousValue + element.balance);
  }
}
