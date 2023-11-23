import 'package:flutter/material.dart';

class RadioButtonWidget<T> extends StatelessWidget {
  const RadioButtonWidget({
    Key? key,
    required this.selectedValue,
    this.onChanged,
    required this.value,
    required this.title,
  }) : super(key: key);

  final T selectedValue;
  final ValueChanged<T>? onChanged;
  final T value;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<T>(
          value: value,
          groupValue: selectedValue,
          onChanged: onChanged != null
              ? (Object? value) => onChanged!(value as T)
              : null,
        ),
        Text(title),
      ],
    );
  }
}
