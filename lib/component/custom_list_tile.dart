import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? trailingIcon;
  final VoidCallback? onTap;
  final bool isRequired;
  final TextStyle titleStyle;
  final TextStyle subtitleStyle;
  final Color backgroundColor;

  const CustomListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.trailingIcon,
    this.onTap,
    this.isRequired = false,
    this.titleStyle = const TextStyle(color: Colors.white, fontSize: 16.0),
    this.subtitleStyle = const TextStyle(color: Colors.grey, fontSize: 14.0),
    this.backgroundColor = Colors.grey,
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
              title,
              style: titleStyle,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subtitle ?? '選択してください',
                    style: subtitleStyle,
                  ),
                ),
                if (trailingIcon != null)
                  Icon(trailingIcon, color: Colors.white),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }
}
