import 'package:flutter/material.dart';

// Widget for "Paid Amount" fields for both user and friend
class PaidAmountsSection extends StatelessWidget {
  const PaidAmountsSection({
    super.key,
    required this.paidByUser,
    required this.paidByFriend,
    required this.submitted,
    required this.totalCost,
    required this.onSliderChanged,
    required this.onTextFieldChanged,
  });

  final double paidByUser;
  final double paidByFriend;
  final bool submitted;
  final double totalCost;
  final void Function(double, double) onSliderChanged;
  final void Function(double, double) onTextFieldChanged;

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController =
    TextEditingController(text: paidByUser.toStringAsFixed(2));
    final TextEditingController friendController =
    TextEditingController(text: paidByFriend.toStringAsFixed(2));

      return Column(
        children: [
          const Text('Paid By You:'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: userController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    double userAmount = double.tryParse(value) ?? 0.0;
                    onTextFieldChanged(userAmount, totalCost - userAmount);
                  },
                ),
              ),
              Slider(
                value: paidByUser,
                min: 0,
                max: totalCost,
                divisions: 100,
                label: paidByUser.toStringAsFixed(2),
                onChanged: (value) {
                  onSliderChanged(value, totalCost - value);
                },
              ),
            ],
          ),
          const Text('Paid By Friend:'),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: friendController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    double friendAmount = double.tryParse(value) ?? 0.0;
                    onTextFieldChanged(totalCost - friendAmount, friendAmount);
                  },
                ),
              ),
              Slider(
                value: paidByFriend,
                min: 0,
                max: totalCost,
                divisions: 100,
                label: paidByFriend.toStringAsFixed(2),
                onChanged: (value) {
                  onSliderChanged(totalCost - value, value);
                },
              ),
            ],
          ),
        ],
      );
  }
}
