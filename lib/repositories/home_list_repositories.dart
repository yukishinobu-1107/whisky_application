import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:whisky_application/repositories/profile_repository.dart';

import '../model/home_list_model.dart';

class HomeRepository {
  // FirestoreとStorageのインスタンス
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  late ProfileRepository _profileRepository;
  final User? user = FirebaseAuth.instance.currentUser; // ログイン中のユーザー取得

  Stream<List<HomeListModel>> getHomeListItems() {
    return FirebaseFirestore.instance.collection('homeScreen').snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => HomeListModel.fromJson(doc.data()))
            .toList());
  }

  // 画像をアップロードし、そのURLを取得する
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      Reference storageRef = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  // Firestoreに投稿データを保存
  Future<void> savePost(
      List<String> imageUrls, String text, User user, String nickName) async {
    try {
      String docId = _firestore.collection('homeScreen').doc().id;
      await _firestore.collection('homeScreen').doc(docId).set({
        'id': docId,
        'text': text,
        'timeStamp': FieldValue.serverTimestamp(),
        'userID': user!.uid, // 例として固定ユーザーID
        'userName': nickName, // 例として固定ユーザー名
        'drinkImageUrl': imageUrls,
      });
      print("データ登録処理完了");
    } catch (e) {
      print("Error saving post: $e");
    }
  }

  // Firestoreに投稿データを保存
  Future<void> addProfile(List<String> imageUrls, String name, String nickName,
      String favoriteBrand, String birthDate, String bio) async {
    final Uuid _uuid = Uuid(); // UUIDインスタンス
    // UUIDを生成してuserIdとする
    String userId = _uuid.v4();
    try {
      String docId = _firestore.collection('homeScreen').doc().id;
      await _firestore.collection('homeScreen').doc(docId).set({
        'id': docId,
        'profileImage': imageUrls,
        'name': name,
        'nickName': nickName, // 例として固定ユーザーID
        'favoriteBrand': favoriteBrand, // 例として固定ユーザー名
        'birthDate': birthDate,
        'bio': bio,
        'userId': userId,
        'createdAt': FieldValue.serverTimestamp()
      });
    } catch (e) {
      print("Error saving post: $e");
    }
  }
}
