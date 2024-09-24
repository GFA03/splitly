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

  set id(String newId) => id = newId;
  // Get the total cost of the expense (sum of what both parties should pay)
  double get totalCost => shouldBePaidByUser + shouldBePaidByFriend;

  double _calculateBalanceForBothPaid() {
    if (paidByUser > shouldBePaidByUser) {
      return paidByUser - shouldBePaidByUser;
    } else if (paidByFriend > shouldBePaidByFriend) {
      return -(paidByFriend - shouldBePaidByFriend);
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

// TODO: Set words limit on description (test if you have too many words how does it show in expense history)
