import 'package:flutter/material.dart';
import 'package:splitly/models/expense.dart';
import 'package:splitly/models/friend_profile.dart';

class TrackExpense extends StatefulWidget {
  const TrackExpense({
    super.key,
    required this.friend,
  });

  final FriendProfile friend;

  @override
  State<TrackExpense> createState() => _TrackExpenseState();
}

class _TrackExpenseState extends State<TrackExpense> {
  final _formKey = GlobalKey<FormState>();
  int buttonSelected = 0;
  final RegExp _digitRegex = RegExp("^[0-9]+\$");
  final expense = Expense();
  late var submitted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Splitly'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 70,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Product name',
                labelStyle: TextStyle(color: Colors.purple),
              ),
              enabled: !submitted,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text!';
                }
                return null;
              },
              onSaved: (value) {
                expense.name = value!;
              },
            ),
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Who paid?'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: submitted ? null : () {
                    setState(() {
                      buttonSelected = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        buttonSelected == 0 ? Colors.purple : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('You'),
                ),
                ElevatedButton(
                  onPressed: submitted ? null : () {
                    setState(() {
                      buttonSelected = 1;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        buttonSelected == 1 ? Colors.purple : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Both'),
                ),
                ElevatedButton(
                  onPressed: submitted ? null : () {
                    setState(() {
                      buttonSelected = 2;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        buttonSelected == 2 ? Colors.purple : Colors.grey[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Alex'),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            (buttonSelected == 0 || buttonSelected == 1) ? TextFormField(
              validator: (inputValue) {
                if (buttonSelected == 2) {
                  return null;
                }
                if (inputValue == null || !_digitRegex.hasMatch(inputValue)) {
                  return 'Please enter a number';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'How much have you paid?',
                labelStyle: TextStyle(color: Colors.purple),
              ),
              enabled: ((buttonSelected == 0 || buttonSelected == 1) && !submitted),
              onSaved: (value) {
                if (value == null || value == "") {
                  return;
                }
                expense.paidByUser = double.parse(value);
              },
            ) : const SizedBox(height: 0,),
            (buttonSelected == 1) ? const SizedBox(
              height: 50,
            ) : const SizedBox(height: 0,),
            (buttonSelected == 1 || buttonSelected == 2) ? TextFormField(
              validator: (inputValue) {
                if (buttonSelected == 0) {
                  return null;
                }
                if (inputValue == null || !_digitRegex.hasMatch(inputValue)) {
                  return 'Please enter a number';
                }
                return null;
              },
              enabled: ((buttonSelected == 1 || buttonSelected == 2) && !submitted),
              decoration: const InputDecoration(
                labelText: 'How much have they paid?',
                labelStyle: TextStyle(color: Colors.purple),
              ),
              onSaved: (value) {
                if (value == null || value == "") {
                  return;
                }
                expense.paidByFriend = double.parse(value);
              },
            ) : const SizedBox(height: 0,),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description (optional):',
                labelStyle: TextStyle(color: Colors.purple),
              ),
              enabled: !submitted,
              onSaved: (value) {
                expense.description = value;
              },
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        submitted = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Processing Data'),
                        ),
                      );
                      _formKey.currentState!.save();
                      Navigator.pop(context, expense);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    textStyle: const TextStyle(fontSize: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 75, vertical: 20),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}