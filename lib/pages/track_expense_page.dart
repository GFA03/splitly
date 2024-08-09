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
                expense.expenseName = value!;
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
                expense.cost += double.parse(value);
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
                expense.cost -= double.parse(value);
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
                      if (buttonSelected == 0) {
                        expense.payer = 'You';
                      } else if (buttonSelected == 1) {
                        expense.payer = 'Both';
                      } else {
                        expense.payer = 'Them';
                      }
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

// return Scaffold(
//   appBar: AppBar(
//     title: const Text('Track Expense'),
//   ),
//   body: Padding(
//     padding: const EdgeInsets.all(16.0),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         TextField(
//           decoration: InputDecoration(
//             labelText: 'Product name',
//             fillColor: Colors.lightBlue[50],
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//         ),
//         const SizedBox(height: 20),
//         const Text(
//           'Who paid?',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         const SizedBox(height: 10),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.purple,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text('You'),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.grey[300],
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text('Both'),
//             ),
//             ElevatedButton(
//               onPressed: () {},
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.grey[300],
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               child: const Text('Alex'),
//             ),
//           ],
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           decoration: InputDecoration(
//             labelText: 'How much have you paid?',
//             fillColor: Colors.lightBlue[50],
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           keyboardType: TextInputType.number,
//         ),
//         const SizedBox(height: 20),
//         TextField(
//           decoration: InputDecoration(
//             labelText: 'Enter details (optional)',
//             fillColor: Colors.lightBlue[50],
//             filled: true,
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(10),
//               borderSide: BorderSide.none,
//             ),
//           ),
//           maxLines: 3,
//         ),
//         const Spacer(),
//         Center(
//           child: ElevatedButton(
//             onPressed: () {
//               // Handle form submission
//             },
//             style: ElevatedButton.styleFrom(
//               foregroundColor: Colors.purple,
//               padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30),
//               ),
//             ),
//             child: const Text(
//               'Track Expense',
//               style: TextStyle(
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         ),
//       ],
//     ),
//   ),
// );
