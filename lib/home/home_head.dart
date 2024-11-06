import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../component/confirmation_dialog.dart';
import '../component/image_slide_view.dart';
import '../repositories/home_list_repositories.dart';
import '../repositories/profile_repository.dart';
import '../whisky_app_style/whisky_app_text_style.dart';

class HomeHead extends StatefulWidget {
  const HomeHead({super.key});

  @override
  State<HomeHead> createState() => _HomeHeadState();
}

class _HomeHeadState extends State<HomeHead> {
  List<File> _images = [];
  final picker = ImagePicker();
  String _text = "";
  List<String> imageUrls = [];
  final HomeRepository _homeRepository = HomeRepository();
  late ProfileRepository _profileRepository;

  @override
  void initState() {
    super.initState();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    _profileRepository = ProfileRepository(firestore, auth);
  }

  Future<void> getImageFromGallery() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      });
    }
  }

  void _openImageSlideView(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageSlideView(
          images: _images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      // ファイル名を抽出して、ストレージに保存
      String fileName = imageFile.path.split('/').last;
      Reference storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);

      // アップロード完了を待機
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});

      // アップロード成功時にダウンロードURLを取得
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // ダウンロードURLが取得できた場合のみ返す
      return downloadUrl.isNotEmpty ? downloadUrl : null;
    } catch (e) {
      // アップロードに失敗した場合のエラーログ出力
      print("Error uploading image: $e");
      return null;
    }
  }


  void _resetFields() {
    setState(() {
      _images = [];
      _text = "";
      imageUrls = [];
    });
  }

  Future<void> _uploadImagesAndSaveToFirestore(List<File> imageFiles) async {
    for (File imageFile in imageFiles) {
      String? imageUrl = await _uploadImage(imageFile); // String? に対応
      if (imageUrl != null && imageUrl.isNotEmpty) {
        imageUrls.add(imageUrl); // 成功したURLのみ追加
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 10),
                  child: Container(
                    width: 90.0,
                    height: 90.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/person_icon.png"),
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.5),
                          BlendMode.screen,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 60, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          style: const TextStyle(color: Colors.white),
                          onChanged: (val) {
                            _text = val;
                          },
                          decoration: InputDecoration(
                            hintText: '今夜は何を飲んでますか？',
                            hintStyle: TextStyle(color: Colors.grey.shade500),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            filled: true,
                            fillColor: Colors.grey.shade900,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: _images.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    File image = entry.value;
                                    return GestureDetector(
                                      onTap: () => _openImageSlideView(index),
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Image.file(
                                              image,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return const Text(
                                                  '画像読み込み失敗',
                                                  style: TextStyle(color: Colors.red),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: getImageFromGallery,
                              icon: const Icon(Icons.image, color: Colors.orangeAccent),
                            ),
                            Text(
                              '追加',
                              style: WhiskyAppTextStyle.mBold.copyWith(color: Colors.white),
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 85,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orangeAccent,
                                ),
                                onPressed: () async {
                                  if (_text.isEmpty && _images.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('投稿内容または画像を追加してください')),
                                    );
                                    return;
                                  }

                                  ConfirmationDialog.show(
                                    context,
                                    '投稿確認',
                                    'この内容で投稿してもよろしいですか？',
                                        () async {
                                      await _uploadImagesAndSaveToFirestore(_images);
                                      final user = FirebaseAuth.instance.currentUser;

                                      if (user == null) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('ユーザーがログインしていません')),
                                        );
                                        return;
                                      }

                                      bool success = await _homeRepository.savePost(
                                        imageUrls,
                                        _text,
                                        user.displayName ?? 'Unknown',
                                      );

                                      if (success) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('投稿が正常に保存されました')),
                                        );
                                        _resetFields();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('投稿の保存に失敗しました')),
                                        );
                                      }
                                    },
                                  );
                                },
                                child: const Text(
                                  '投稿',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
