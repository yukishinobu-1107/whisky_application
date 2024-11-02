import 'package:cloud_firestore/cloud_firestore.dart';

class EventSearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestore からイベントデータを取得するメソッド
  Future<List<Map<String, dynamic>>> fetchEvents() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('events').get();

      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'],
          'eventDate': doc['eventDate'],
          'startTime': doc['startTime'],
          'endTime': doc['endTime'],
          'place': doc['place'],
          'coverImageUrl': doc['coverImageUrl'], // 表紙画像URL
          'otherImageUrls':
              List<String>.from(doc['otherImageUrls'] ?? []), // その他画像URLリスト
          'createdAt': doc['createdAt'],
          'updatedAt': doc['updatedAt'],
          'isDeleted': doc['isDeleted'],
          'address': doc['address'],
          'prefecture': doc['prefecture'],
          'organizer': doc['organizer'],
          'eventType': doc['eventType'],
          'eventUrl': doc['eventUrl']
        };
      }).toList();
    } catch (e) {
      print('データの取得に失敗しました: $e');
      return [];
    }
  }

  // Firestore にイベントデータを保存するメソッド
  Future<void> saveEvent(Map<String, dynamic> eventData) async {
    try {
      // ドキュメントIDを生成（既存のIDがある場合は上書き）
      String eventId =
          eventData['id'] ?? _firestore.collection('events').doc().id;

      // Firestoreの 'events' コレクションにデータを保存
      await _firestore.collection('events').doc(eventId).set({
        'name': eventData['name'],
        'eventDate': eventData['eventDate'],
        'startTime': eventData['startTime'],
        'endTime': eventData['endTime'],
        'place': eventData['place'],
        'coverImageUrl': eventData['coverImageUrl'], // 表紙画像URL
        'otherImageUrls': eventData['otherImageUrls'], // その他画像URLリスト
        'createdAt': eventData['createdAt'] ?? FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(), // 更新日時
        'isDeleted': eventData['isDeleted'] ?? false, // デフォルトで削除されていない
        'address': eventData['address'],
        'prefecture': eventData['prefecture'],
        'organizer': eventData['organizer'],
        'eventType': eventData['eventType'],
        'eventUrl': eventData['eventUrl'],
      });

      print('イベントが正常に保存されました');
    } catch (e) {
      print('イベントの保存に失敗しました: $e');
      throw Exception('イベントの保存に失敗しました');
    }
  }
}
