import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import '../model/home_list_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ホーム画面の投稿リストを取得するストリーム
  Stream<List<HomeListModel>> getHomeListItems() {
    return _firestore.collection('homeScreen').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => HomeListModel.fromJson(doc.data())).toList());
  }

  // 画像をアップロードし、そのダウンロードURLを返すメソッド
  Future<String> uploadImage(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      Reference storageRef = _storage.ref().child('images/$fileName');
      UploadTask uploadTask = storageRef.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return '';
    }
  }

  // ホーム画面での投稿データをFirestoreに保存するメソッド
  Future<bool> savePost(
      List<String> imageUrls, String text, String nickName) async {
    try {
      final user = FirebaseAuth.instance.currentUser; // ユーザーをここで取得
      if (user == null) {
        print("エラー: ユーザーが認証されていません");
        return false;
      }
      String docId = _firestore.collection('homeScreen').doc().id;
      await _firestore.collection('homeScreen').doc(docId).set({
        'id': docId,
        'text': text,
        'timeStamp': FieldValue.serverTimestamp(),
        'userID': user.uid, // 現在のユーザーのuidを利用
        'userName': nickName,
        'drinkImageUrl': imageUrls,
      });
      print("データ登録処理完了: ドキュメントID: $docId");
      return true; // 成功時にtrueを返す
    } catch (e) {
      print("Error saving post: $e");
      return false; // エラー時にfalseを返す
    }
  }


  // プロフィール情報をFirestoreに保存するメソッド
  Future<void> addProfile(List<String> imageUrls, String name, String nickName,
      String favoriteBrand, String birthDate, String bio) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print("エラー: ユーザーが認証されていません");
        return;
      }
      String docId = _firestore.collection('users').doc(user.uid).id; // ドキュメントIDとしてユーザーのuidを使用
      await _firestore.collection('users').doc(user.uid).set({
        'id': docId,
        'profileImage': imageUrls,
        'name': name,
        'nickName': nickName,
        'favoriteBrand': favoriteBrand,
        'birthDate': birthDate,
        'bio': bio,
        'userId': user.uid,
        'createdAt': FieldValue.serverTimestamp()
      });
      print("プロフィール登録完了: ドキュメントID: $docId");
    } catch (e) {
      print("Error saving profile: $e");
    }
  }
}
