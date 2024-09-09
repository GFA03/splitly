import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/widgets/buttons/large_button.dart';

import '../../data/models/expense.dart';

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
    final repository = ref.read(repositoryProvider);
    final prefs = ref.read(sharedPrefProvider);
    final currentFriendId = prefs.getString('selectedFriend');
    final currentFriend = repository.findFriendById(currentFriendId!);

    if (_formKey.currentState!.validate()) {
      setState(() {
        submitted = true;
      });

      _formKey.currentState!.save();

      if (_description != null && _description!.isEmpty) {
        _description = null;
      }

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
        friendId: currentFriend.id,
      );

      if (widget.expense != null) {
        // If editing, update the existing expense object
        widget.expense!
          ..name = newExpense.name
          ..shouldBePaidByUser = newExpense.shouldBePaidByUser
          ..shouldBePaidByFriend = newExpense.shouldBePaidByFriend
          ..paidByUser = newExpense.paidByUser
          ..paidByFriend = newExpense.paidByFriend
          ..description = newExpense.description
          ..date = newExpense.date;
        Navigator.pop(context, widget.expense);
      } else {
        // If new, return the new expense object
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

// Widget for the expense details (name, description, and date)
class ExpenseDetailsSection extends StatelessWidget {
  const ExpenseDetailsSection({
    super.key,
    required this.name,
    required this.description,
    required this.date,
    required this.submitted,
    required this.onNameSaved,
    required this.onDescriptionSaved,
    required this.onDateSelected,
  });

  final String? name;
  final String? description;
  final DateTime? date;
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
          initialValue: name,
          enabled: !submitted,
          onSaved: onNameSaved,
          validator: (value) =>
              value == null || value.isEmpty ? 'Please enter some text!' : null,
        ),
        const SizedBox(height: 20),
        ExpenseDatePicker(
          selectedDate: date!,
          onDateSelected: onDateSelected,
        ),
        const SizedBox(height: 20),
        ExpenseInputField(
          label: 'Description (optional)',
          initialValue: description,
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
    required this.shouldBePaidByUser,
    required this.shouldBePaidByFriend,
    required this.submitted,
    required this.onSavedShouldBePaidByUser,
    required this.onSavedShouldBePaidByFriend,
  });

  final double? shouldBePaidByUser;
  final double? shouldBePaidByFriend;
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
    required this.paidByUser,
    required this.paidByFriend,
    required this.paymentView,
    required this.submitted,
    required this.onSavedPaidByUser,
    required this.onSavedPaidByFriend,
  });

  final double? paidByUser;
  final double? paidByFriend;
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
    this.initialValue,
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
      initialValue: initialValue ?? "",
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