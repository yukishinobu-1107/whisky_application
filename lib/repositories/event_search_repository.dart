import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:whisky_application/model/event_model.dart';

class EventSearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Firestoreからイベントデータを取得
  Future<List<Event>> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();

      // FirestoreドキュメントをEventモデルのリストに変換
      return snapshot.docs.map((doc) {
        return Event.fromJson({
          'id': doc.id, // FirestoreのドキュメントIDをidに設定
          ...doc.data() as Map<String, dynamic>, // 残りのフィールドを追加
        });
      }).toList();
    } catch (e) {
      print('データの取得に失敗しました: $e');
      return [];
    }
  }

  // Firestoreにイベントデータを保存 (Map型を受け取る)
  Future<void> saveEvent(Map<String, dynamic> eventData) async {
    try {
      String eventId =
          eventData['id'] ?? _firestore.collection('events').doc().id;

      // Map形式のデータを直接Firestoreに保存
      await _firestore.collection('events').doc(eventId).set(eventData);

      print('イベントが正常に保存されました');
    } catch (e) {
      print('イベントの保存に失敗しました: $e');
      throw Exception('イベントの保存に失敗しました');
    }
  }

  // Firestoreのイベントデータを更新
  Future<void> updateEvent(Event event) async {
    try {
      await _firestore
          .collection('events')
          .doc(event.id)
          .update(event.toJson());
      print('イベントが正常に更新されました');
    } catch (e) {
      print('イベントの更新に失敗しました: $e');
      throw Exception('イベントの更新に失敗しました');
    }
  }

// 画像をFirebase Storageから削除するメソッド
  Future<void> deleteImageFromStorage(String imageUrl) async {
    try {
      // URLから参照を取得
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
      print('画像が正常に削除されました: $imageUrl');
    } catch (e) {
      print('画像の削除に失敗しました: $e');
      throw Exception('画像の削除に失敗しました');
    }
  }

  // Firestoreからイベントデータを削除
  Future<void> deleteEvent(String eventId) async {
    try {
      await _firestore.collection('events').doc(eventId).delete();
      print('イベントが正常に削除されました');
    } catch (e) {
      print('イベントの削除に失敗しました: $e');
      throw Exception('イベントの削除に失敗しました');
    }
  }

  // Firestoreのイベントデータと関連画像を削除
  Future<void> deleteEventWithImages(
      String eventId, List<String> imageUrls) async {
    try {
      // Firestoreからイベントデータを削除
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();

      // ストレージから画像を削除
      for (String url in imageUrls) {
        await FirebaseStorage.instance.refFromURL(url).delete();
      }

      print('イベントと関連画像が正常に削除されました');
    } catch (e) {
      print('イベント削除に失敗しました: $e');
      throw Exception('イベントの削除に失敗しました');
    }
  }

  // Firebase Storageに画像をアップロードしてURLを取得
  Future<String> uploadImageToStorage(File image) async {
    try {
      // ユニークなファイル名を生成
      String fileName =
          'event_images/${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
      Reference ref = _storage.ref().child(fileName);

      // Firebase Storageに画像をアップロード
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;

      // アップロード完了後、画像のURLを取得
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('画像のアップロードに失敗しました: $e');
      throw Exception('画像のアップロードに失敗しました');
    }
  }
}
