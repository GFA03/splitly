import 'package:splitly/models/expense.dart';

class FriendProfile {
  FriendProfile(this._name, this.imageUrl);

  String _name;
  String imageUrl;
  List<Expense> expenses = expensesTest;

  String get name => _name;

  set name(String newName) {
    if (newName.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    _name = newName;
  }

  double calculateBalance() {
    if (expenses.isEmpty) {
      return 0;
    }
    return expenses.fold<double>(0, (previousValue, element) => previousValue + (element.paidByUser - element.paidByFriend));
  }
}

List<FriendProfile> friends = [
  FriendProfile('Alex Gavrila', 'profile_pics/profile_picture2.jpg'),
  FriendProfile('James Rodriguez', 'assets/profile_pics/profile_picture3.jpg'),
  FriendProfile('Layla Ponta', 'assets/profile_pics/profile_picture4.jpg'),
  FriendProfile('Crezulo Davinci', 'assets/profile_pics/profile_picture5.jpg'),
  FriendProfile('John Doe', 'assets/profile_pics/profile_picture6.jpg'),
];