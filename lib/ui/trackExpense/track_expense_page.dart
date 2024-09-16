import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/trackExpense/components/expense_input_field.dart';
import 'package:splitly/ui/widgets/buttons/large_button.dart';
import 'package:splitly/data/models/expense.dart';

import 'components/expense_details_section.dart';
import 'components/paid_amount_section.dart';
import 'components/should_be_paid_section.dart';

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
  double totalCost = 0.0;
  double _shouldBePaidByUser = 0.0;
  double _shouldBePaidByFriend = 0.0;
  double _paidByUser = 0.0;
  double _paidByFriend = 0.0;

  bool submitted = false;

  @override
  void initState() {
    super.initState();
    Expense? expense = widget.expense;
    if (expense != null) {
      totalCost = expense.shouldBePaidByUser + expense.shouldBePaidByFriend;
      _name = expense.name;
      _description = expense.description;
      _date = expense.date;
      _shouldBePaidByUser = expense.shouldBePaidByUser;
      _shouldBePaidByFriend = expense.shouldBePaidByFriend;
      _paidByUser = expense.paidByUser;
      _paidByFriend = expense.paidByFriend;
    } else {
      _date = DateTime.now(); // Default to current date if adding a new expense
    }
  }

  void _handleSubmit() {
    final selectedFriend = ref.read(repositoryProvider).selectedFriend;

    if (selectedFriend == null) {
      throw ArgumentError("There is no friend selected!");
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        submitted = true;
      });

      _formKey.currentState!.save();

      if (_description != null && _description!.isEmpty) {
        _description = null;
      }

      if (widget.expense != null) {
        // If editing, update the existing expense object
        widget.expense!
          ..name = _name!
          ..shouldBePaidByUser = _shouldBePaidByUser
          ..shouldBePaidByFriend = _shouldBePaidByFriend
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
          shouldBePaidByUser: _shouldBePaidByUser,
          shouldBePaidByFriend: _shouldBePaidByFriend,
          paidByUser: _paidByUser,
          paidByFriend: _paidByFriend,
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
    final RegExp digitRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');

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
                  ExpenseInputField(
                    label: 'Total cost:',
                    initialValue: totalCost.toString(),
                    enabled: !submitted,
                    onChanged: (value) {
                      final val = double.parse(value ?? '0');
                      setState(() {
                        totalCost = val;
                        // Adjust sliders when totalCost changes
                        _shouldBePaidByUser = val * 0.5; // Default 50-50 split
                        _shouldBePaidByFriend = val * 0.5;
                        _paidByUser = val * 0.5;
                        _paidByFriend = val * 0.5;
                      });
                    },
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        (value == null || !digitRegex.hasMatch(value))
                            ? 'Please enter a valid number'
                            : null,
                  ),
                  // Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
                  // Slider(
                  //   value: totalCost,
                  //   min: 0,
                  //   max: 1000,
                  //   // Adjust as needed
                  //   divisions: 100,
                  //   label: totalCost.toStringAsFixed(2),
                  //   onChanged: (value) {
                  //     setState(() {
                  //       totalCost = value;
                  //       // Adjust sliders when totalCost changes
                  //       _shouldBePaidByUser =
                  //           value * 0.5; // Default 50-50 split
                  //       _shouldBePaidByFriend = value * 0.5;
                  //       _paidByUser = value * 0.5;
                  //       _paidByFriend = value * 0.5;
                  //     });
                  //   },
                  // ),
                  const SizedBox(height: 20),
                  ShouldBePaidSection(
                    shouldBePaidByUser: _shouldBePaidByUser,
                    shouldBePaidByFriend: _shouldBePaidByFriend,
                    totalCost: totalCost,
                    submitted: submitted,
                    onSliderChanged: (user, friend) {
                      setState(() {
                        _shouldBePaidByUser = user;
                        _shouldBePaidByFriend = friend;
                      });
                    },
                    onTextFieldChanged: (user, friend) {
                      setState(() {
                        _shouldBePaidByUser = user;
                        _shouldBePaidByFriend = friend;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  PaidAmountsSection(
                    paidByUser: _paidByUser,
                    paidByFriend: _paidByFriend,
                    submitted: submitted,
                    totalCost: totalCost,
                    onSliderChanged: (user, friend) {
                      setState(() {
                        _paidByUser = user;
                        _paidByFriend = friend;
                      });
                    },
                    onTextFieldChanged: (user, friend) {
                      setState(() {
                        _paidByUser = user;
                        _paidByFriend = friend;
                      });
                    },
                  ),
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
