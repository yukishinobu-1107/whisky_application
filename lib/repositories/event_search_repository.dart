import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whisky_application/model/event_model.dart';

class EventSearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
}
