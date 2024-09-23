import 'package:flutter/material.dart';

class SliderField extends StatelessWidget {
  const SliderField({super.key});

  @override
  Widget build(BuildContext context) {
    return Slider(value: 10, onChanged: (v) {});
  }
}
