import 'package:flutter/material.dart';

class EventField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;

  const EventField({
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: labelText),
        maxLines: maxLines,
      ),
    );
  }
}
