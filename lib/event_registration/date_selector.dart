import 'package:flutter/material.dart';

class DateSelector extends StatelessWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;

  const DateSelector(
      {required this.selectedDate, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(selectedDate != null
          ? selectedDate!.toLocal().toString().split(' ')[0]
          : '日付を選択'),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}
