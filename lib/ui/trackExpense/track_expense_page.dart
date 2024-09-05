import 'package:flutter/material.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/data/models/friend_profile.dart';

class TrackExpense extends StatefulWidget {
  const TrackExpense({
    super.key,
    required this.friend,
    this.expense,
  });

  final FriendProfile friend;
  final Expense? expense;

  @override
  State<TrackExpense> createState() => _TrackExpenseState();
}

class _TrackExpenseState extends State<TrackExpense> {
  final _formKey = GlobalKey<FormState>();
  final RegExp _digitRegex = RegExp(r'^[0-9]+(\.[0-9]{1,2})?$');
  final Expense expense = Expense();
  bool submitted = false;

  PaymentOptions paymentView = PaymentOptions.you;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      expense
        ..name = widget.expense!.name
        ..paidByUser = widget.expense!.paidByUser
        ..paidByFriend = widget.expense!.paidByFriend
        ..description = widget.expense!.description
        ..date = widget.expense!.date;
      paymentView = _determinePaymentSelection();
    }
  }

  PaymentOptions _determinePaymentSelection() {
    if (expense.paidByUser > 0 && expense.paidByFriend > 0) {
      return PaymentOptions.both; // Both paid
    } else if (expense.paidByFriend > 0) {
      return PaymentOptions.them; // Friend paid
    }
    return PaymentOptions.you; // User paid
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Earliest selectable date
      lastDate: DateTime.now(), // Latest selectable date
    );
    if (pickedDate != null && pickedDate != expense.date) {
      setState(() {
        expense.date = pickedDate;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        submitted = true;
      });

      _formKey.currentState!.save();

      if (widget.expense != null) {
        widget.expense!
          ..name = expense.name
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
      appBar: AppBar(title: const Text('Splitly')),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 70),
                    _buildExpenseFormField(
                      label: 'Expense name',
                      initialValue: widget.expense?.name,
                      enabled: !submitted,
                      onSaved: (value) => expense.name = value!,
                      validator: (value) => value == null || value.isEmpty
                          ? 'Please enter some text!'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date of Expense',
                        labelStyle: TextStyle(color: Colors.purple),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context), // Open date picker
                      controller: TextEditingController(
                        text: "${expense.date.toLocal()}".split(' ')[0],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Who paid?', style: TextStyle(fontSize: 16)),
                    PaymentChoice(
                      paymentView: paymentView,
                      onPaymentOptionChanged: (PaymentOptions newOption) {
                        setState(() {
                          paymentView = newOption;
                        });
                      },
                    ),
                    const SizedBox(height: 50),
                    _buildPaidAmountFields(),
                    const SizedBox(height: 50),
                    _buildExpenseFormField(
                      label: 'Description (optional):',
                      initialValue: widget.expense?.description,
                      enabled: !submitted,
                      onSaved: (value) => expense.description = value,
                      keyboardType: TextInputType.multiline,
                    ),
                    const Spacer(),
                    _buildSubmitButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaidAmountFields() {
    return Column(
      children: [
        _buildYouPaidField(),
        if (paymentView == PaymentOptions.both) const SizedBox(height: 20),
        _buildThemPaidField(),
      ],
    );
  }

  Widget _buildYouPaidField() {
    if (paymentView == PaymentOptions.you ||
        paymentView == PaymentOptions.both) {
      return _buildExpenseFormField(
        label: 'How much have you paid?',
        initialValue: widget.expense?.paidByUser.toString(),
        enabled: !submitted,
        keyboardType: TextInputType.number,
        validator: (value) => (value == null || !_digitRegex.hasMatch(value))
            ? 'Please enter a number!'
            : null,
        onSaved: (value) => expense.paidByUser = double.parse(value ?? '0'),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildThemPaidField() {
    if (paymentView == PaymentOptions.both ||
        paymentView == PaymentOptions.them) {
      return _buildExpenseFormField(
        label: 'How much have they paid?',
        initialValue: widget.expense?.paidByFriend.toString(),
        enabled: !submitted,
        keyboardType: TextInputType.number,
        validator: (value) => (value == null || !_digitRegex.hasMatch(value))
            ? 'Please enter a number!'
            : null,
        onSaved: (value) => expense.paidByFriend = double.parse(value ?? '0'),
      );
    }
    return const SizedBox.shrink();
  }

  Padding _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          textStyle: const TextStyle(fontSize: 20),
          padding: const EdgeInsets.symmetric(horizontal: 75, vertical: 20),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildExpenseFormField({
    required String label,
    required String? initialValue,
    required bool enabled,
    required void Function(String?) onSaved,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.purple),
      ),
      initialValue: initialValue,
      enabled: enabled,
      validator: validator,
      onSaved: onSaved,
      keyboardType: keyboardType,
    );
  }
}

enum PaymentOptions { you, both, them }

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
    return SegmentedButton(
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
    );
  }
}
