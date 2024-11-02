import 'dart:io';
import 'package:flutter/material.dart';

class ImageSlideView extends StatelessWidget {
  final List<File> images;
  final int initialIndex;

  const ImageSlideView({
    required this.images,
    this.initialIndex = 0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('画像ギャラリー'),
        backgroundColor: Colors.blue,
      ),
      body: PageView.builder(
        itemCount: images.length,
        controller: PageController(initialPage: initialIndex),
        itemBuilder: (context, index) {
          return Center(
            child: Image.file(
              images[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
