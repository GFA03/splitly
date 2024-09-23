import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:splitly/data/models/expense.dart';
import 'package:splitly/providers.dart';
import 'package:splitly/ui/components/button/outlined_button.dart';
import 'package:splitly/ui/components/textfield/filled_text_field.dart';
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
    final selectedFriend = ref
        .read(repositoryProvider)
        .selectedFriend;

    if (selectedFriend == null) {
      throw ArgumentError('There is no friend selected!');
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
        name: expenseName!,
        description: description,
        date: date,
        shouldBePaidByUser: userConsumption!,
        shouldBePaidByFriend: friendConsumption!,
        paidByUser: paidByUser!,
        paidByFriend: paidByFriend!,
        friendId: selectedFriend.id,
      );

      if (widget.editExpense != null) {
        newExpense.id = widget.editExpense!.id;
      }

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
                  ButtonOutlined(label: 'Add Expense', onPressed: _handleSubmit),
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
                  onSaved: (value) =>
                  {
                    setState(() {
                      description = value;
                    })
                  },
                  validator: (value) =>
                      ValidatorUtils.canBeEmptyValidator(value),
                );
  }

  FilledTextField _buildTotalCostField() {
    return FilledTextField(
                  label: 'Total cost',
                  value: totalCost?.toStringAsFixed(2),
                  enabled: !submitted,
                  onChanged: (value) {
                    final val = double.parse(value ?? '0');
                    setState(() {
                      totalCost = val;
                      userConsumption = val * 0.5;
                      paidByUser = val * 0.5;
                      friendConsumption = val * 0.5;
                      paidByFriend = val * 0.5;
                    });
                  },
                  validator: (value) =>
                      ValidatorUtils.doubleOnlyValidator(value),
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
                  validator: (value) =>
                      ValidatorUtils.mandatoryFieldValidator(value),
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
    return [_buildCard(
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
          setState(() {
            userConsumption = val;
            friendConsumption = totalCost! - val;
          });
        },
        onPaidChanged: (val) {
          if (totalCost == null) {
            return;
          }
          setState(() {
            paidByUser = val;
            paidByFriend = totalCost! - val;
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
            setState(() {
              friendConsumption = val;
              userConsumption = totalCost! - val;
            });
          },
          onPaidChanged: (val) {
            if (totalCost == null) {
              return;
            }
            setState(() {
              paidByFriend = val;
              paidByUser = totalCost! - val;
            });
          })];
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
              style: Theme
                  .of(context)
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
              style: Theme
                  .of(context)
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

  Widget _buildCardRow({required double? value,
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
        Text(
          value?.toStringAsFixed(2) ?? '0.0',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
