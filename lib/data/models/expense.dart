import 'package:uuid/uuid.dart';

class Expense {
  Expense({
    String? id,
    name = "",
    friendId = '0',
    shouldBePaidByUser = 0.0, // Amount the user should have paid
    shouldBePaidByFriend = 0.0, // Amount the friend should have paid
    paidByUser = 0.0, // Amount the user actually paid
    paidByFriend = 0.0, // Amount the friend actually paid
    description,
    DateTime? date,
  })  : _id = id ?? const Uuid().v4(),
        _name = name,
        _friendId = friendId,
        _shouldBePaidByUser = shouldBePaidByUser,
        _shouldBePaidByFriend = shouldBePaidByFriend,
        _paidByUser = paidByUser,
        _paidByFriend = paidByFriend,
        _description = description,
        _date = date ?? DateTime.now();

  final String _id;
  final String _name; // Name of the expense
  final String _friendId;
  final double _shouldBePaidByUser; // How much should have been paid by you
  final double
      _shouldBePaidByFriend; // How much should have been paid by the friend
  final double _paidByUser; // How much you actually paid
  final double _paidByFriend; // How much your friend actually paid
  final DateTime _date; // Date of the expense
  final String? _description; // Optional description of the expense

  // Get the total cost of the expense (sum of what both parties should pay)
  String get id => _id;

  String get name => _name;

  String get friendId => _friendId;

  double get shouldBePaidByUser => _shouldBePaidByUser;

  double get shouldBePaidByFriend => _shouldBePaidByFriend;

  double get paidByUser => _paidByUser;

  double get paidByFriend => _paidByFriend;

  double get totalCost => _shouldBePaidByUser + _shouldBePaidByFriend;

  DateTime get date => _date;

  String? get description => _description;

  double _calculateBalanceForBothPaid() {
    if (_paidByUser > _shouldBePaidByUser) {
      return _paidByUser - _shouldBePaidByUser;
    } else if (_paidByFriend > _shouldBePaidByFriend) {
      return -(_paidByFriend - _shouldBePaidByFriend);
    } else {
      return 0.0;
    }
  }

  // Get the balance adjustment based on who paid
  double get balance {
    if (_paidByUser > 0 && _paidByFriend == 0) {
      // You paid everything, so the friend owes you what they should have paid
      return totalCost - _shouldBePaidByUser;
    } else if (_paidByFriend > 0 && _paidByUser == 0) {
      // They paid everything, so you owe them what you should have paid
      return -(totalCost - _shouldBePaidByFriend);
    } else if (_paidByUser > 0 && _paidByFriend > 0) {
      // Both contributed, so balance based on the difference between actual and should pay
      return _calculateBalanceForBothPaid();
    } else {
      return 0.0; // No payment was made yet
    }
  }

  // Determine who the primary payer was (for display purposes)
  String get payer {
    if (_paidByUser > 0 && _paidByFriend == 0) {
      return "You";
    } else if (_paidByFriend > 0 && _paidByUser == 0) {
      return "Them";
    } else {
      return "Both";
    }
  }
}

// TODO: Set words limit on description (test if you have too many words how does it show in expense history)
