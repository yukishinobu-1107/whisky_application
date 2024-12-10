import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatelessWidget {
  final File? coverImage;
  final List<File> selectedImages;
  final Function(File) onCoverImageSelected;
  final Function(List<File>) onImagesSelected;

  const ImageSelector(
      {required this.coverImage,
      required this.selectedImages,
      required this.onCoverImageSelected,
      required this.onImagesSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            final picker = ImagePicker();
            final cover = await picker.pickImage(source: ImageSource.gallery);
            if (cover != null) {
              onCoverImageSelected(File(cover.path));
            }
          },
          child: const Text('表紙画像を選択'),
        ),
        ElevatedButton(
          onPressed: () async {
            final picker = ImagePicker();
            final images = await picker.pickMultiImage();
            if (images != null) {
              onImagesSelected(
                  images.map((image) => File(image.path)).toList());
            }
          },
          child: const Text('その他の画像を選択'),
        ),
      ],
    );
  }
}
