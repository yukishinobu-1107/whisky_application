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
    // TODO: implement initState
    super.initState();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    _profileRepository = ProfileRepository(firestore, auth);
  }

  Future<void> getImageFromGallery() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images =
            pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
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

  Future<String> _uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      Reference storageRef =
          FirebaseStorage.instance.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  void _resetFields() {
    setState(() {
      _images = [];
      _text = "";
    });
  }

  Future<void> _uploadImagesAndSaveToFirestore(
      List<File> imageFiles, String _text) async {
    for (File imageFile in imageFiles) {
      String imageUrl = await _uploadImage(imageFile);
      if (imageUrl.isNotEmpty) {
        setState(() {
          imageUrls.add(imageUrl);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // 全体の背景を黒に設定
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
                      border: Border.all(
                        color: Colors.white, // 白い枠線を追加して背景と差別化
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                              .withOpacity(0.5), // 白の影を追加して画像を浮き立たせる
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover, // 画像全体を表示
                        image: AssetImage("assets/person_icon.png"),
                        colorFilter: ColorFilter.mode(
                          Colors.white.withOpacity(0.5), // 透明度を調整した白を使って明るくする
                          BlendMode.screen, // 明るさを強調するために BlendMode.screen を使用
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 60, left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 入力フィールド
                        TextField(
                          style:
                              const TextStyle(color: Colors.white), // テキストを白に
                          onChanged: (val) {
                            _text = val;
                          },
                          decoration: InputDecoration(
                            hintText: '今夜は何を飲んでますか？',
                            hintStyle: TextStyle(
                                color: Colors.grey.shade500), // ヒントの色をグレーに
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            filled: true,
                            fillColor: Colors.grey.shade900, // フィールドの背景をダークグレーに
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none, // 枠線を消す
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children:
                                      _images.asMap().entries.map((entry) {
                                    int index = entry.key;
                                    File image = entry.value;
                                    return GestureDetector(
                                      onTap: () => _openImageSlideView(index),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Stack(
                                              children: [
                                                Image.file(
                                                  image,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Text(
                                                        '画像読み込み失敗',
                                                        style: TextStyle(
                                                            color: Colors.red));
                                                  },
                                                ),
                                                // オーバーレイを追加して見やすくする
                                                Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.5)
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                              icon: const Icon(Icons.image,
                                  color: Colors.orangeAccent), // アイコンをオレンジに
                            ),
                            Text(
                              '追加',
                              style: WhiskyAppTextStyle.mBold
                                  .copyWith(color: Colors.white), // テキストを白に
                            ),
                            const Spacer(),
                            SizedBox(
                              width: 85,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.orangeAccent, // ボタンをオレンジに
                                ),
                                onPressed: () async {
                                  ConfirmationDialog.show(
                                    context,
                                    '投稿確認',
                                    'この内容で投稿してもよろしいですか？',
                                    () async {
                                      await _uploadImagesAndSaveToFirestore(
                                          _images, _text);
                                      final user = await _profileRepository
                                          .getCurrentUser();
                                      Map<String, dynamic>? userProfile =
                                          await _profileRepository
                                              .getUserProfile(user!.uid);
                                      if (userProfile != null) {
                                        print(userProfile['name']);
                                        _homeRepository.savePost(imageUrls,
                                            _text, user!, userProfile['name']);
                                      }
                                      setState(() {
                                        imageUrls = [];
                                      });
                                      _resetFields();
                                    },
                                  );
                                },
                                child: const Text(
                                  '投稿',
                                  style: TextStyle(
                                    color:
                                        Colors.black, // ボタンテキストを黒にしてコントラストを高める
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
