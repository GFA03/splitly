import 'package:flutter/material.dart';
import 'package:splitly/ui/widgets/buttons/large_button.dart';

import '../../data/models/expense.dart';

class TrackExpense extends StatefulWidget {
  const TrackExpense({super.key, this.expense});

  final Expense? expense;

  @override
  State<TrackExpense> createState() => _TrackExpenseState();
}

class _TrackExpenseState extends State<TrackExpense> {
  final _formKey = GlobalKey<FormState>();
  final Expense expense = Expense();
  bool submitted = false;

  PaymentOptions paymentView = PaymentOptions.you;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      expense
        ..name = widget.expense!.name
        ..shouldBePaidByUser = widget.expense!.shouldBePaidByUser
        ..shouldBePaidByFriend = widget.expense!.shouldBePaidByFriend
        ..paidByUser = widget.expense!.paidByUser
        ..paidByFriend = widget.expense!.paidByFriend
        ..description = widget.expense!.description
        ..date = widget.expense!.date;
      paymentView = _determinePaymentSelection();
    }
  }

  PaymentOptions _determinePaymentSelection() {
    if (expense.paidByUser > 0 && expense.paidByFriend > 0) {
      return PaymentOptions.both;
    } else if (expense.paidByFriend > 0) {
      return PaymentOptions.them;
    }
    return PaymentOptions.you;
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        submitted = true;
      });

      _formKey.currentState!.save();

      if (expense.description != null && expense.description!.isEmpty) {
        expense.description = null;
      }
      if (paymentView == PaymentOptions.you) {
        expense.paidByUser =
            expense.shouldBePaidByUser + expense.shouldBePaidByFriend;
      } else if (paymentView == PaymentOptions.them) {
        expense.paidByFriend =
            expense.shouldBePaidByUser + expense.shouldBePaidByFriend;
      }

      if (widget.expense != null) {
        widget.expense!
          ..name = expense.name
          ..shouldBePaidByUser = expense.shouldBePaidByUser
          ..shouldBePaidByFriend = expense.shouldBePaidByFriend
          ..paidByUser = expense.paidByUser
          ..paidByFriend = expense.paidByFriend
          ..description = expense.description
          ..date = expense.date;
        Navigator.pop(context, widget.expense);
      } else {
        Navigator.pop(context, expense);
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
                    expense: expense,
                    submitted: submitted,
                    onNameSaved: (value) => expense.name = value!,
                    onDescriptionSaved: (value) => expense.description = value,
                    onDateSelected: (date) =>
                        setState(() => expense.date = date),
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
                    expense: expense,
                    submitted: submitted,
                    onSavedShouldBePaidByUser: (value) =>
                        expense.shouldBePaidByUser = double.parse(value ?? '0'),
                    onSavedShouldBePaidByFriend: (value) => expense
                        .shouldBePaidByFriend = double.parse(value ?? '0'),
                  ),
                  const SizedBox(height: 20),
                  PaidAmountsSection(
                    expense: expense,
                    paymentView: paymentView,
                    submitted: submitted,
                    onSavedPaidByUser: (value) =>
                        expense.paidByUser = double.parse(value ?? '0'),
                    onSavedPaidByFriend: (value) =>
                        expense.paidByFriend = double.parse(value ?? '0'),
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

// Widget for the expense details (name, description, and date)
class ExpenseDetailsSection extends StatelessWidget {
  const ExpenseDetailsSection({
    super.key,
    required this.expense,
    required this.submitted,
    required this.onNameSaved,
    required this.onDescriptionSaved,
    required this.onDateSelected,
  });

  final Expense expense;
  final bool submitted;
  final void Function(String?) onNameSaved;
  final void Function(String?) onDescriptionSaved;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpenseInputField(
          label: 'Expense name',
          initialValue: expense.name,
          enabled: !submitted,
          onSaved: onNameSaved,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter some text!' : null,
        ),
        const SizedBox(height: 20),
        ExpenseDatePicker(
          selectedDate: expense.date,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(height: 20),
        ExpenseInputField(
          label: 'Description (optional)',
          initialValue: expense.description,
          enabled: !submitted,
          onSaved: onDescriptionSaved,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}

// Widget for the "Should be paid" fields
class ShouldBePaidSection extends StatelessWidget {
  const ShouldBePaidSection({
    super.key,
    required this.expense,
    required this.submitted,
    required this.onSavedShouldBePaidByUser,
    required this.onSavedShouldBePaidByFriend,
  });

  final Expense expense;
  final bool submitted;
  final void Function(String?) onSavedShouldBePaidByUser;
  final void Function(String?) onSavedShouldBePaidByFriend;

  @override
  Widget build(BuildContext context) {
    final RegExp digitRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
    return Column(
      children: [
        ExpenseInputField(
          label: 'Should be paid by you',
          initialValue: expense.shouldBePaidByUser.toString(),
          enabled: !submitted,
          onSaved: onSavedShouldBePaidByUser,
          keyboardType: TextInputType.number,
          validator: (value) => (value == null || !digitRegex.hasMatch(value))
              ? 'Please enter a valid amount!'
              : null,
        ),
        const SizedBox(height: 20),
        ExpenseInputField(
          label: 'Should be paid by them',
          initialValue: expense.shouldBePaidByFriend.toString(),
          enabled: !submitted,
          onSaved: onSavedShouldBePaidByFriend,
          keyboardType: TextInputType.number,
          validator: (value) => (value == null || !digitRegex.hasMatch(value))
              ? 'Please enter a valid amount!'
              : null,
        ),
      ],
    );
  }
}

enum PaymentOptions { you, both, them }

// Widget for "Paid Amount" fields for both user and friend
class PaidAmountsSection extends StatelessWidget {
  const PaidAmountsSection({
    super.key,
    required this.expense,
    required this.paymentView,
    required this.submitted,
    required this.onSavedPaidByUser,
    required this.onSavedPaidByFriend,
  });

  final Expense expense;
  final PaymentOptions paymentView;
  final bool submitted;
  final void Function(String?) onSavedPaidByUser;
  final void Function(String?) onSavedPaidByFriend;

  @override
  Widget build(BuildContext context) {
    final RegExp digitRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
    if (paymentView == PaymentOptions.both) {
      return Column(
        children: [
          ExpenseInputField(
            label: 'How much have you paid?',
            initialValue: expense.paidByUser.toString(),
            enabled: !submitted,
            onSaved: onSavedPaidByUser,
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || !digitRegex.hasMatch(value))
                ? 'Please enter a valid number!'
                : null,
          ),
          const SizedBox(height: 20),
          ExpenseInputField(
            label: 'How much have they paid?',
            initialValue: expense.paidByFriend.toString(),
            enabled: !submitted,
            onSaved: onSavedPaidByFriend,
            keyboardType: TextInputType.number,
            validator: (value) => (value == null || !digitRegex.hasMatch(value))
                ? 'Please enter a valid number!'
                : null,
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}

// Reusable widget for input fields
class ExpenseInputField extends StatelessWidget {
  const ExpenseInputField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.enabled,
    required this.onSaved,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  final String label;
  final String? initialValue;
  final bool enabled;
  final void Function(String?) onSaved;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.purple),
      ),
      initialValue: initialValue,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      onSaved: onSaved,
    );
  }
}

// Date picker widget
class ExpenseDatePicker extends StatelessWidget {
  const ExpenseDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  final DateTime selectedDate;
  final void Function(DateTime) onDateSelected;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Date of Expense',
        labelStyle: TextStyle(color: Colors.purple),
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          onDateSelected(pickedDate);
        }
      },
      controller: TextEditingController(
        text: "${selectedDate.toLocal()}".split(' ')[0],
      ),
    );
  }
}

class PaymentChoice extends StatefulWidget {
  const PaymentChoice(
      {super.key,
      required this.paymentView,
      required this.onPaymentOptionChanged});

  final PaymentOptions paymentView;
  final ValueChanged<PaymentOptions> onPaymentOptionChanged;

  @override
  State<PaymentChoice> createState() => _PaymentChoiceState();
}

class _PaymentChoiceState extends State<PaymentChoice> {
  late PaymentOptions paymentView;

  @override
  void initState() {
    super.initState();
    paymentView = widget.paymentView;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Who paid?',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Colors.purple),
        ),
        SegmentedButton(
          segments: const <ButtonSegment<PaymentOptions>>[
            ButtonSegment<PaymentOptions>(
              value: PaymentOptions.you,
              label: Text('You'),
            ),
            ButtonSegment<PaymentOptions>(
              value: PaymentOptions.both,
              label: Text('Both'),
            ),
            ButtonSegment<PaymentOptions>(
              value: PaymentOptions.them,
              label: Text('Them'),
            ),
          ],
          selected: <PaymentOptions>{paymentView},
          onSelectionChanged: (Set<PaymentOptions> newSelection) {
            setState(() {
              paymentView = newSelection.first;
              widget.onPaymentOptionChanged(paymentView);
            });
          },
        ),
      ],
    );
  }
}
