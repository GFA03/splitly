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
  int buttonSelected = 0;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      expense
        ..name = widget.expense!.name
        ..paidByUser = widget.expense!.paidByUser
        ..paidByFriend = widget.expense!.paidByFriend
        ..description = widget.expense!.description;
      buttonSelected = _determineButtonSelection();
    }
  }

  int _determineButtonSelection() {
    if (expense.paidByUser > 0 && expense.paidByFriend > 0) {
      return 1; // Both paid
    } else if (expense.paidByFriend > 0) {
      return 2; // Friend paid
    }
    return 0; // User paid
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
          ..description = expense.description;
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

  Widget _buildPaymentButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPaymentButton(
          label: 'You',
          isSelected: buttonSelected == 0,
          onPressed: () => setState(() => buttonSelected = 0),
        ),
        _buildPaymentButton(
          label: 'Both',
          isSelected: buttonSelected == 1,
          onPressed: () => setState(() => buttonSelected = 1),
        ),
        _buildPaymentButton(
          label: widget.friend.name,
          isSelected: buttonSelected == 2,
          onPressed: () => setState(() => buttonSelected = 2),
        ),
      ],
    );
  }

  Widget _buildPaymentButton({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: submitted ? null : onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: isSelected ? Colors.purple : Colors.grey[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
    );
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
                    const SizedBox(height: 50),
                    const Text('Who paid?', style: TextStyle(fontSize: 16)),
                    _buildPaymentButtons(),
                    const SizedBox(height: 50),
                    if (buttonSelected == 0 || buttonSelected == 1)
                      _buildExpenseFormField(
                        label: 'How much have you paid?',
                        initialValue: widget.expense?.paidByUser.toString(),
                        enabled: !submitted,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            (value == null || !_digitRegex.hasMatch(value))
                                ? 'Please enter a number!'
                                : null,
                        onSaved: (value) =>
                            expense.paidByUser = double.parse(value ?? '0'),
                      ),
                    if (buttonSelected == 1)
                      const SizedBox(height:20),
                    if (buttonSelected == 1 || buttonSelected == 2)
                      _buildExpenseFormField(
                        label: 'How much have they paid?',
                        initialValue: widget.expense?.paidByFriend.toString(),
                        enabled: !submitted,
                        keyboardType: TextInputType.number,
                        validator: (value) =>
                            (value == null || !_digitRegex.hasMatch(value))
                                ? 'Please enter a number!'
                                : null,
                        onSaved: (value) =>
                            expense.paidByFriend = double.parse(value ?? '0'),
                      ),
                    const SizedBox(height: 50),
                    _buildExpenseFormField(
                      label: 'Description (optional):',
                      initialValue: widget.expense?.description,
                      enabled: !submitted,
                      onSaved: (value) => expense.description = value,
                      keyboardType: TextInputType.multiline,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: ElevatedButton(
                        onPressed: _handleSubmit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          textStyle: const TextStyle(fontSize: 20),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 75, vertical: 20),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
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
}
