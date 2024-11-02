import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import '../repositories/profile_repository.dart';
import '../view_model/navigation_notifier.dart';

class Profile extends ConsumerStatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  File? _image;
  List<File> _images = [];
  List<String> _imageUrls = [];
  final picker = ImagePicker();
  late final ProfileRepository _profileRepository;
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  late bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final FirebaseAuth auth = FirebaseAuth.instance;
    _profileRepository = ProfileRepository(firestore, auth);
    _loadUserProfile();
  }

  // Firestoreからユーザープロファイルを取得してフィールドに反映
  Future<void> _loadUserProfile() async {
    try {
      final user = await _profileRepository.getCurrentUser();
      if (user != null) {
        Map<String, dynamic>? userProfile =
            await _profileRepository.getUserProfile(user.uid);

        if (userProfile != null) {
          // 各フィールドごとにログを追加してチェック
          if (userProfile.containsKey('name')) {
            print('Name: ${userProfile['name']}');
          } else {
            print('Nameフィールドが存在しません');
          }

          if (userProfile.containsKey('favoriteBrand')) {
            print('Favorite Brand: ${userProfile['favoriteBrand']}');
          } else {
            print('Favorite Brandフィールドが存在しません');
          }

          if (userProfile.containsKey('dateOfBirth')) {
            print('Date of Birth: ${userProfile['dateOfBirth']}');
          } else {
            print('Date of Birthフィールドが存在しません');
          }

          if (userProfile.containsKey('bio')) {
            print('Bio: ${userProfile['bio']}');
          } else {
            print('Bioフィールドが存在しません');
          }

          if (userProfile.containsKey('isPremiumUser')) {
            print('Is Premium User: ${userProfile['isPremiumUser']}');
          } else {
            print('Is Premium Userフィールドが存在しません');
          }

          setState(() {
            _nicknameController.text = userProfile['name'] ?? '';
            _brandController.text = userProfile['favoriteBrand'] ?? '';
            _dobController.text = userProfile['dateOfBirth'].toString() ?? '';
            _bioController.text = userProfile['bio'] ?? '';
            _isPremiumUser = userProfile['isPremiumUser'] ?? false;

            if (userProfile['profileImageUrls'] != null) {
              _imageUrls = List<String>.from(userProfile['profileImageUrls']);
            }
          });
        } else {
          print('ユーザープロファイルが存在しません。');
        }
      } else {
        print('ユーザーがログインしていません。');
      }
    } catch (e) {
      print('プロファイルの読み込みに失敗しました11111: $e');
    }
  }

  Future<void> _getImageFromGallery() async {
    print("=======_getImageFromGallery=========");

    final pickedFiles = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFiles != null) {
      setState(() {
        _image = File(pickedFiles.path); // 単一の画像を保持
        print(_image);
      });
    }
  }

  Future<void> _saveUserProfile() async {
    final user = await _profileRepository.getCurrentUser();
    try {
      List<String> uploadedImageUrls = [];
      String downloadUrl =
          await _profileRepository.uploadImageToFirebaseStorage(_image!);
      uploadedImageUrls.add(downloadUrl);
      if (user != null) {
        await _profileRepository.saveUserProfile(
            userId: user.uid,
            nickName: _nicknameController.text,
            favoriteBrand: _brandController.text,
            profileImageUrls: uploadedImageUrls,
            dob: int.parse(_dobController.text),
            bio: _bioController.text);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('プロフィールが保存されました')));
      ref.read(navigationProvider.notifier).setIndex(0);
    } catch (e) {
      print('プロファイルの保存に失敗しました: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('プロフィール',
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _image != null
                        ? FileImage(_image!) // 新しく選択された画像を表示
                        : (_imageUrls.isNotEmpty
                            ? NetworkImage(_imageUrls[0]) // Firestoreから取得した画像
                            : AssetImage('assets/person_icon.png')
                                as ImageProvider), // デフォルト画像
                    backgroundColor: Colors.grey[800],
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.orangeAccent,
                      child: IconButton(
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        onPressed: _getImageFromGallery,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              controller: _nicknameController,
              label: 'ニックネーム',
              icon: Icons.person,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _brandController,
              label: '好きな銘柄',
              icon: Icons.local_bar,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _dobController,
              label: '生年月日',
              icon: Icons.calendar_today,
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _bioController,
              label: '自己紹介',
              icon: Icons.info,
              maxLines: 3,
            ),
            SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  await _saveUserProfile();
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  child: Text('プロフィールを保存',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.orangeAccent),
        prefixIcon: Icon(icon, color: Colors.orangeAccent),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
