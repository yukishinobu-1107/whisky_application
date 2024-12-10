import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final List<dynamic> images; // FileまたはURLのリスト
  final Function(dynamic) onRemove; // 画像を削除する際のコールバック

  const ImagePreviewWidget({
    Key? key,
    required this.images,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: images.map((image) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: image is File
                  ? Image.file(
                      image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      image, // URLの場合
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => onRemove(image), // 削除時にコールバックを呼び出し
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.close, color: Colors.red, size: 20),
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}
