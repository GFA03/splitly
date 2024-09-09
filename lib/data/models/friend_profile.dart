import 'package:splitly/data/models/expense.dart';
import 'package:uuid/uuid.dart';

class FriendProfile {
  FriendProfile({String? id, required this.name, this.imageUrl})
      : id = id ?? const Uuid().v4();

  final String id;
  String name;
  String? imageUrl;
  List<Expense> expenses = expensesTest;

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

List<FriendProfile> friends = [
  FriendProfile(name: 'Alex Gavrila', imageUrl: 'assets/profile_pics/profile_picture2.jpg'),
  FriendProfile(name: 'James Rodriguez', imageUrl:  'assets/profile_pics/profile_picture3.jpg'),
  FriendProfile(name: 'Layla Ponta', imageUrl: 'assets/profile_pics/profile_picture4.jpg'),
  FriendProfile(name: 'Crezulo Davinci', imageUrl: 'assets/profile_pics/profile_picture5.jpg'),
  FriendProfile(name: 'John Doe', imageUrl: 'assets/profile_pics/profile_picture6.jpg'),
];
