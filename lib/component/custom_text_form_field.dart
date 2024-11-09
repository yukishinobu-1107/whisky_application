import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool isRequired;
  final TextStyle labelStyle;
  final TextStyle hintStyle;
  final TextStyle textStyle;
  final VoidCallback? onTap;
  final int maxLines;
  final bool readOnly;

  const CustomTextFormField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.isRequired = false,
    this.labelStyle = const TextStyle(color: Colors.white, fontSize: 16.0),
    this.hintStyle = const TextStyle(color: Colors.grey, fontSize: 14.0),
    this.textStyle = const TextStyle(color: Colors.white, fontSize: 16.0),
    this.onTap,
    this.maxLines = 1,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (isRequired)
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(
                  '必須',
                  style: TextStyle(color: Colors.red.shade300, fontSize: 12),
                ),
              ),
            Text(
              labelText,
              style: labelStyle,
            ),
          ],
        ),
        const SizedBox(height: 6.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Colors.grey[850],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: hintStyle,
              border: InputBorder.none, // 下線と枠線を消す
            ),
            style: textStyle,
            maxLines: maxLines,
            onTap: onTap,
            readOnly: readOnly,
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

