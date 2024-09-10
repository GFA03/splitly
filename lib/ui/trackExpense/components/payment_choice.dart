import 'package:flutter/material.dart';

import '../track_expense_page.dart';

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
