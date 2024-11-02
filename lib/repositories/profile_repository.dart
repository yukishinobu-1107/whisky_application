import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileRepository {
  late FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late FirebaseAuth _auth = FirebaseAuth.instance;

  ProfileRepository(this._firestore, this._auth);

  // ユーザーの現在の認証情報を取得する
  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  // Firestoreからユーザープロファイルを読み込む
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot userProfileSnapshot =
          await _firestore.collection('users').doc(userId).get();
      if (userProfileSnapshot.exists) {
        return userProfileSnapshot.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print('プロファイルの読み込みに失敗しました: $e');
    }
    return null;
  }

  // Firebase Storageに画像をアップロードするメソッド
  Future<String> uploadImageToFirebaseStorage(File imageFile) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef =
          FirebaseStorage.instance.ref().child('user_profiles/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL(); // ダウンロードURLを返す
    } catch (e) {
      throw Exception('画像のアップロードに失敗しました: $e');
    }
  }

  // Firestoreにユーザープロファイルを保存するメソッド
  Future<void> saveUserProfile({
    required String userId,
    required String nickName,
    required String favoriteBrand,
    required List<String> profileImageUrls, // 画像URLリスト
    required String bio,
    required int dob,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': nickName,
        'favoriteBrand': favoriteBrand,
        'profileImageUrls': profileImageUrls, // 画像URLを保存
        'bio': bio,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDeleted': false,
        'dateOfBirth': dob
      });
    } catch (e) {
      throw Exception('プロファイルの保存に失敗しました: $e');
    }
  }
}
