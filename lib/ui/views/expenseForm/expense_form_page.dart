import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/ui/components/button/outlined_button.dart';
import 'package:splitly/ui/components/textfield/filled_text_field.dart';
import 'package:splitly/utils/friend_utils.dart';
import 'package:splitly/utils/validators.dart';

class ExpenseFormPage extends ConsumerStatefulWidget {
  const ExpenseFormPage({super.key, this.editExpense});

  final Expense? editExpense;

  @override
  ConsumerState<ExpenseFormPage> createState() => _ExpenseFormPageState();
}

class _ExpenseFormPageState extends ConsumerState<ExpenseFormPage> {
  final _formKey = GlobalKey<FormState>();

  String? expenseName;
  double? totalCost;
  double? userConsumption;
  double? paidByUser;
  double? friendConsumption;
  double? paidByFriend;
  String? description;
  DateTime date = DateTime.now();

  bool submitted = false;

  @override
  void initState() {
    super.initState();
    if (widget.editExpense != null) {
      Expense expense = widget.editExpense!;
      expenseName = expense.name;
      totalCost = expense.paidByFriend + expense.paidByUser;
      userConsumption = expense.shouldBePaidByUser;
      friendConsumption = expense.shouldBePaidByFriend;
      paidByUser = expense.paidByUser;
      paidByFriend = expense.paidByFriend;
      description = expense.description;
      date = expense.date;
    }
  }

  void _handleSubmit() {
    final selectedFriend = FriendUtils.getSelectedFriend(ref);

    if (selectedFriend == null) {
      throw Exception('No friend selected');
    }

    if (_formKey.currentState!.validate()) {
      setState(() {
        submitted = true;
      });

      _formKey.currentState!.save();

      if (description == null || description!.isEmpty) {
        description = null;
      }

      final newExpense = Expense(
        id: widget.editExpense?.id,
        name: expenseName!,
        description: description,
        date: date,
        shouldBePaidByUser: userConsumption!,
        shouldBePaidByFriend: friendConsumption!,
        paidByUser: paidByUser!,
        paidByFriend: paidByFriend!,
        friendId: selectedFriend.id,
      );

      Navigator.pop(context, newExpense);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.editExpense != null
              ? 'Expense edited successfully!'
              : 'Expense tracked!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Form'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTotalCostField(),
                  const SizedBox(height: 16.0),
                  _buildExpenseNameField(),
                  const SizedBox(height: 24.0),
                  _buildDatePicker(context),
                  const SizedBox(height: 24.0),
                  ..._buildPaySection(),
                  const SizedBox(height: 24.0),
                  _buildDescriptionField(),
                  const SizedBox(height: 32),
                  ButtonOutlined(
                      label: 'Add Expense', onPressed: _handleSubmit),
                ],
              ),
            )),
      ),
    );
  }

  FilledTextField _buildDescriptionField() {
    return FilledTextField(
      label: 'Description',
      value: description,
      enabled: !submitted,
      onSaved: (value) => {
        setState(() {
          description = value;
        })
      },
      validator: (value) => ValidatorUtils.canBeEmptyValidator(value),
    );
  }

  FilledTextField _buildTotalCostField() {
    return FilledTextField(
      label: 'Total cost',
      value: totalCost?.toStringAsFixed(2),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      enabled: !submitted,
      onChanged: (value) {
        try {
          final val = double.parse(value ?? '0');
          final resultFixedToTwoDecimals =
              double.parse((val * 0.5).toStringAsFixed(2));
          setState(() {
            totalCost = val;
            userConsumption = resultFixedToTwoDecimals;
            paidByUser = resultFixedToTwoDecimals;
            friendConsumption = resultFixedToTwoDecimals;
            paidByFriend = resultFixedToTwoDecimals;
          });
        } catch (e) {
          if (e is FormatException) {
            setState(() {
              totalCost = null;
              userConsumption = 0;
              paidByUser = 0;
              friendConsumption = 0;
              paidByFriend = 0;
            });
          }
        }
      },
      validator: (value) => ValidatorUtils.doubleOnlyValidator(value),
    );
  }

  FilledTextField _buildExpenseNameField() {
    return FilledTextField(
      label: 'Expense name',
      value: expenseName,
      enabled: !submitted,
      onSaved: (value) {
        setState(() {
          expenseName = value;
        });
      },
      validator: (value) => ValidatorUtils.mandatoryFieldValidator(value),
    );
  }

  TextFormField _buildDatePicker(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Date of Expense',
      ),
      readOnly: true,
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          setState(() => date = pickedDate);
        }
      },
      controller: TextEditingController(
        text: "${date.toLocal()}".split(' ')[0],
      ),
    );
  }

  List<Widget> _buildPaySection() {
    return [
      _buildCard(
          cardTitle: 'You',
          consumptionLabel: 'Your consumption:',
          paidLabel: 'You paid:',
          totalCost: totalCost,
          consumption: userConsumption,
          paid: paidByUser,
          onConsumptionChanged: (val) {
            if (totalCost == null) {
              return;
            }
            final valFixedToTwoDecimals = double.parse(val.toStringAsFixed(2));
            setState(() {
              userConsumption = valFixedToTwoDecimals;
              friendConsumption = totalCost! - valFixedToTwoDecimals;
            });
          },
          onPaidChanged: (val) {
            if (totalCost == null) {
              return;
            }
            final valFixedToTwoDecimals = double.parse(val.toStringAsFixed(2));
            setState(() {
              paidByUser = valFixedToTwoDecimals;
              paidByFriend = totalCost! - valFixedToTwoDecimals;
            });
          }),
      const SizedBox(height: 16.0),
      _buildCard(
          cardTitle: 'Your friend:',
          consumptionLabel: 'Friend\'s consumption:',
          paidLabel: 'Friend paid:',
          totalCost: totalCost,
          consumption: friendConsumption,
          paid: paidByFriend,
          onConsumptionChanged: (val) {
            if (totalCost == null) {
              return;
            }
            final valFixedToTwoDecimals = double.parse(val.toStringAsFixed(2));
            setState(() {
              friendConsumption = valFixedToTwoDecimals;
              userConsumption = totalCost! - valFixedToTwoDecimals;
            });
          },
          onPaidChanged: (val) {
            if (totalCost == null) {
              return;
            }
            final valFixedToTwoDecimals = double.parse(val.toStringAsFixed(2));
            setState(() {
              paidByFriend = valFixedToTwoDecimals;
              paidByUser = totalCost! - valFixedToTwoDecimals;
            });
          })
    ];
  }

  Widget _buildCard({
    required String cardTitle,
    required String consumptionLabel,
    required String paidLabel,
    required double? totalCost,
    required double? consumption,
    required double? paid,
    required ValueChanged<double> onConsumptionChanged,
    required ValueChanged<double> onPaidChanged,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(cardTitle),
            const SizedBox(height: 16.0),
            Text(
              consumptionLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: Colors.grey),
            ),
            _buildCardRow(
                value: consumption,
                totalCost: totalCost,
                onChanged: onConsumptionChanged),
            const SizedBox(height: 12.0),
            Text(
              paidLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.apply(color: Colors.grey),
            ),
            _buildCardRow(
                value: paid, totalCost: totalCost, onChanged: onPaidChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildCardRow(
      {required double? value,
      required double? totalCost,
      required ValueChanged<double> onChanged}) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: value ?? 0,
            max: totalCost ?? 0,
            divisions: 8,
            label: value?.toStringAsFixed(2),
            onChanged: onChanged,
          ),
        ),
        GestureDetector(
          onTap: () async {
            final double? result = await _showInputDialog(
              context: context,
              title: 'Enter Amount',
              initialValue: value?.toString() ?? '',
            );
            if (result != null && totalCost != null) {
              onChanged(result);
            }
          },
          child: Text(
            value?.toStringAsFixed(2) ?? '0.0',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Future<double?> _showInputDialog({
    required BuildContext context,
    required String title,
    required String initialValue,
  }) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    return showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Enter amount',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without returning a value
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                final value = double.tryParse(controller.text);
                if (value != null) {
                  Navigator.of(context).pop(value); // Return the parsed value
                } else {
                  // Optionally show an error or handle invalid input
                }
              },
            ),
          ],
        );
      },
    );
  }
}
