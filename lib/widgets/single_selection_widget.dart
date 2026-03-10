import 'package:flutter/material.dart';

class SingleSelectionOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SingleSelectionOption({
    required this.value,
    required this.label,
    this.icon,
  });
}

class SingleSelectionWidget<T> extends StatelessWidget {
  final String title;
  final T selectedValue;
  final List<SingleSelectionOption<T>> options;
  final ValueChanged<T> onChanged;

  const SingleSelectionWidget({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...options.map(
          (option) => RadioListTile<T>(
            value: option.value,
            groupValue: selectedValue,
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(option.icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(option.label),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
