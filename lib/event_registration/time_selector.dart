import 'package:flutter/material.dart';

class TimeSelector extends StatelessWidget {
  final String labelText;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay) onTimeSelected;

  const TimeSelector(
      {required this.labelText,
      required this.selectedTime,
      required this.onTimeSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(selectedTime != null
          ? selectedTime!.format(context)
          : '$labelTextを選択'),
      onTap: () async {
        final picked = await showTimePicker(
            context: context, initialTime: TimeOfDay.now());
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
    );
  }
}
