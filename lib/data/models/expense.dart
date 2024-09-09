import 'package:uuid/uuid.dart';

class Expense {
  Expense({
    String? id,
    this.name = "",
    this.friendId = '0',
    this.shouldBePaidByUser = 0.0, // Amount the user should have paid
    this.shouldBePaidByFriend = 0.0, // Amount the friend should have paid
    this.paidByUser = 0.0, // Amount the user actually paid
    this.paidByFriend = 0.0, // Amount the friend actually paid
    this.description,
    DateTime? date,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();

  final String id;
  String name; // Name of the expense
  String friendId;
  double shouldBePaidByUser; // How much should have been paid by you
  double shouldBePaidByFriend; // How much should have been paid by the friend
  double paidByUser; // How much you actually paid
  double paidByFriend; // How much your friend actually paid
  DateTime date; // Date of the expense
  String? description; // Optional description of the expense

  // Get the total cost of the expense (sum of what both parties should pay)
  double get totalCost => shouldBePaidByUser + shouldBePaidByFriend;

  double _calculateBalanceForBothPaid() {
    if (paidByUser > shouldBePaidByUser) {
      return paidByUser - shouldBePaidByUser;
    } else if (paidByFriend > shouldBePaidByFriend) {
      return paidByFriend - shouldBePaidByFriend;
    } else {
      return 0.0;
    }
  }

  // Get the balance adjustment based on who paid
  double get balance {
    if (paidByUser > 0 && paidByFriend == 0) {
      // You paid everything, so the friend owes you what they should have paid
      return totalCost - shouldBePaidByUser;
    } else if (paidByFriend > 0 && paidByUser == 0) {
      // They paid everything, so you owe them what you should have paid
      return -(totalCost - shouldBePaidByFriend);
    } else if (paidByUser > 0 && paidByFriend > 0) {
      // Both contributed, so balance based on the difference between actual and should pay
      return _calculateBalanceForBothPaid();
    } else {
      return 0.0; // No payment was made yet
    }
  }

  // Determine who the primary payer was (for display purposes)
  String get payer {
    if (paidByUser > 0 && paidByFriend == 0) {
      return "You";
    } else if (paidByFriend > 0 && paidByUser == 0) {
      return "Them";
    } else {
      return "Both";
    }
  }
}

List<Expense> expensesTest = [
  Expense(
      name: 'Un Pizza Fresco',
      shouldBePaidByFriend: 10.0,
      shouldBePaidByUser: 14.0,
      paidByUser: 24.0,
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse sit amet mauris nec lacus tempus facilisis. Aenean auctor convallis pretium. Nulla a nisl eros. Nullam accumsan venenatis suscipit. Maecenas rhoncus, nisi at semper scelerisque, est arcu mattis dui, eu lobortis quam urna non ipsum. Quisque pharetra venenatis viverra. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nullam rutrum ligula orci, nec dignissim massa tincidunt eget. Curabitur euismod molestie dolor id feugiat. Aenean sed pellentesque sem.'),
  Expense(
      name: 'Aventura Park',
      shouldBePaidByFriend: 40.0,
      shouldBePaidByUser: 14.0,
      paidByUser: 54.0,
      description:
          'Duis laoreet quis risus ut auctor. Nullam vel feugiat ante, a tempor elit. Aliquam in quam tincidunt, viverra eros in, consequat sem. Vivamus facilisis enim in diam interdum euismod. Aenean id nunc est. Suspendisse quis iaculis libero. Morbi tristique sapien lorem, vitae tempus turpis vestibulum et. Integer eu nisi dapibus, elementum sem quis, volutpat velit. Sed arcu velit, congue ac volutpat at, hendrerit ac metus. Nullam interdum, dui a sodales pharetra, lectus sem blandit odio, sit amet tempus nunc arcu et mi. Mauris hendrerit enim nec ultrices mattis. Praesent sollicitudin in leo vitae hendrerit. Morbi et dapibus dui. '),
  Expense(
      name: 'Costinesti expedition',
      shouldBePaidByFriend: 150.0,
      shouldBePaidByUser: 230.0,
      paidByUser: 150.0,
      paidByFriend: 230.0),
  Expense(
      name: 'Munich Trip',
      shouldBePaidByFriend: 144.0,
      shouldBePaidByUser: 100.0,
      paidByFriend: 244.0),
  Expense(
      name: 'Germany holiday',
      shouldBePaidByFriend: 2.0,
      shouldBePaidByUser: 3.0,
      paidByUser: 5.0),
];

// TODO: Set words limit on description (test if you have too many words how does it show in expense history)
