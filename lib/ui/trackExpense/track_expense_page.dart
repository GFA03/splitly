import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/ui/widgets/buttons/large_button.dart';
import 'package:splitly/utils/friend_utils.dart';
import 'package:splitly/data/models/expense.dart';

import 'components/expense_details_section.dart';
import 'components/paid_amount_section.dart';
import 'components/payment_choice.dart';
import 'components/should_be_paid_section.dart';

enum PaymentOptions { you, both, them }

class TrackExpense extends ConsumerStatefulWidget {
  const TrackExpense({super.key, this.expense});

  final Expense? expense;

  @override
  ConsumerState<TrackExpense> createState() => _TrackExpenseState();
}

class _TrackExpenseState extends ConsumerState<TrackExpense> {
  final _formKey = GlobalKey<FormState>();

  // Separate variables for each form field
  String? _name;
  String? _description;
  DateTime? _date;
  double? _shouldBePaidByUser;
  double? _shouldBePaidByFriend;
  double _paidByUser = 0.0;
  double _paidByFriend = 0.0;

  PaymentOptions paymentView = PaymentOptions.you;
  bool submitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _name = widget.expense!.name;
      _description = widget.expense!.description;
      _date = widget.expense!.date;
      _shouldBePaidByUser = widget.expense!.shouldBePaidByUser;
      _shouldBePaidByFriend = widget.expense!.shouldBePaidByFriend;
      _paidByUser = widget.expense!.paidByUser;
      _paidByFriend = widget.expense!.paidByFriend;
      paymentView = _determinePaymentSelection();
    } else {
      _date = DateTime.now(); // Default to current date if adding a new expense
    }
  }

  PaymentOptions _determinePaymentSelection() {
    if (_paidByUser > 0 && _paidByFriend > 0) {
      return PaymentOptions.both;
    } else if (_paidByFriend > 0) {
      return PaymentOptions.them;
    }
    return PaymentOptions.you;
  }

  void _handleSubmit() {
    final selectedFriend = FriendUtils.getSelectedFriend(ref);

    if (_formKey.currentState!.validate()) {
      setState(() {
        submitted = true;
      });

      _formKey.currentState!.save();

      if (paymentView == PaymentOptions.both) {
        // Validate that paidByUser + paidByFriend == shouldBePaidByUser + shouldBePaidByFriend
        final totalShouldBePaid =
            (_shouldBePaidByUser ?? 0) + (_shouldBePaidByFriend ?? 0);
        final totalPaid = _paidByUser + _paidByFriend;

        if (totalPaid != totalShouldBePaid) {
          // Show an error if the totals do not match
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'The total paid amount does not match the total amount that should be paid!'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() {
            submitted =
                false; // Reset submission state to allow for further edits
          });
          return;
        }
      }

      if (_description != null && _description!.isEmpty) {
        _description = null;
      }

      if (widget.expense != null) {
        // If editing, update the existing expense object
        widget.expense!
          ..name = _name!
          ..shouldBePaidByUser = _shouldBePaidByUser!
          ..shouldBePaidByFriend = _shouldBePaidByFriend!
          ..paidByUser = _paidByUser
          ..paidByFriend = _paidByFriend
          ..description = _description
          ..date = _date!;
        Navigator.pop(context, widget.expense);
      } else {
        // If new, return the new expense object
        final newExpense = Expense(
          name: _name!,
          description: _description,
          date: _date,
          shouldBePaidByUser: _shouldBePaidByUser!,
          shouldBePaidByFriend: _shouldBePaidByFriend!,
          paidByUser: paymentView == PaymentOptions.you
              ? _shouldBePaidByUser! + _shouldBePaidByFriend!
              : _paidByUser,
          paidByFriend: paymentView == PaymentOptions.them
              ? _shouldBePaidByUser! + _shouldBePaidByFriend!
              : _paidByFriend,
          friendId: selectedFriend.id,
        );
        Navigator.pop(context, newExpense);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.expense != null
              ? 'Expense edited successfully!'
              : 'Expense tracked!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Expense')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ExpenseDetailsSection(
                    name: _name,
                    description: _description,
                    date: _date,
                    submitted: submitted,
                    onNameSaved: (value) => _name = value!,
                    onDescriptionSaved: (value) => _description = value,
                    onDateSelected: (date) => setState(() => _date = date),
                  ),
                  const SizedBox(height: 20),
                  PaymentChoice(
                    paymentView: paymentView,
                    onPaymentOptionChanged: (PaymentOptions newOption) {
                      setState(() {
                        paymentView = newOption;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ShouldBePaidSection(
                    shouldBePaidByUser: _shouldBePaidByUser,
                    shouldBePaidByFriend: _shouldBePaidByFriend,
                    submitted: submitted,
                    onSavedShouldBePaidByUser: (value) =>
                        _shouldBePaidByUser = double.parse(value ?? '0'),
                    onSavedShouldBePaidByFriend: (value) =>
                        _shouldBePaidByFriend = double.parse(value ?? '0'),
                  ),
                  const SizedBox(height: 20),
                  PaidAmountsSection(
                    paidByUser: _paidByUser,
                    paidByFriend: _paidByFriend,
                    paymentView: paymentView,
                    submitted: submitted,
                    onSavedPaidByUser: (value) =>
                        _paidByUser = double.parse(value ?? '0'),
                    onSavedPaidByFriend: (value) =>
                        _paidByFriend = double.parse(value ?? '0'),
                  ),
                  const SizedBox(height: 50),
                  LargeButton(onPressed: _handleSubmit, label: 'Submit')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}