import 'package:flutter/material.dart';

// Widget for the "Should be paid" fields
class ShouldBePaidSection extends StatelessWidget {
  const ShouldBePaidSection({
    super.key,
    required this.shouldBePaidByUser,
    required this.shouldBePaidByFriend,
    required this.submitted,
    required this.totalCost,
    required this.onSliderChanged,
    required this.onTextFieldChanged,
  });

  final double shouldBePaidByUser;
  final double shouldBePaidByFriend;
  final bool submitted;
  final double totalCost;
  final void Function(double, double) onSliderChanged;
  final void Function(double, double) onTextFieldChanged;

  @override
  Widget build(BuildContext context) {
    final TextEditingController userController =
        TextEditingController(text: shouldBePaidByUser.toStringAsFixed(2));
    final TextEditingController friendController =
        TextEditingController(text: shouldBePaidByFriend.toStringAsFixed(2));

    return Column(
      children: [
        const Text('Should Be Paid By You:'),
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
              value: shouldBePaidByUser,
              min: 0,
              max: totalCost,
              divisions: 8,
              label: shouldBePaidByUser.toStringAsFixed(2),
              onChanged: (value) {
                onSliderChanged(value, totalCost - value);
              },
            ),
          ],
        ),
        const Text('Should Be Paid By Friend:'),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: friendController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  double friendAmount = double.tryParse(value) ?? 0.0;
                  onTextFieldChanged(friendAmount, totalCost - friendAmount);
                },
              ),
            ),
            Slider(
              value: shouldBePaidByFriend,
              min: 0,
              max: totalCost,
              divisions: 8,
              label: shouldBePaidByFriend.toStringAsFixed(2),
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
