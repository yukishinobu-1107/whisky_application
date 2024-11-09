import 'package:flutter/material.dart';

import '../constants/regions_and_prefectures.dart';

class PrefectureDropdown extends StatelessWidget {
  final String? selectedPrefecture;
  final Function(String) onPrefectureSelected;

  const PrefectureDropdown(
      {required this.selectedPrefecture, required this.onPrefectureSelected});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(selectedPrefecture ?? '都道府県を選択'),
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => ListView.builder(
          itemCount: prefectures.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(prefectures[index]),
              onTap: () {
                onPrefectureSelected(prefectures[index]);
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
