// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import '../model/event_model.dart'; // イベントモデルのインポート
//
// class EventRepository {
//   final FirebaseFirestore _firestore;
//   final FirebaseStorage _storage;
//
//   EventRepository(this._firestore, this._storage);
//
//   // イベントデータを追加するメソッド
//   Future<void> addEvent({
//     required String eventName,
//     required String eventDetails,
//     String? eventUrl,
//     required DateTime eventDate,
//     List<File>? eventImages,
//     required String eventPrefecture,
//     required String eventRegion,
//   }) async {
//     List<String> imageUrls = [];
//
//     // イベント画像があればFirebase Storageにアップロード
//     if (eventImages != null && eventImages.isNotEmpty) {
//       for (var imageFile in eventImages) {
//         String imageUrl = await _uploadImage(imageFile);
//         imageUrls.add(imageUrl);
//       }
//     }
//
//     try {
//       // Firestoreにデータを登録
//       await _firestore.collection('events').add({
//         'eventName': eventName,
//         'eventDetails': eventDetails,
//         'eventUrl': eventUrl ?? '',
//         'eventDate': Timestamp.fromDate(eventDate), // DateTimeからTimestampに変換
//         'eventImages': imageUrls.isNotEmpty ? imageUrls : null,
//         'eventPrefecture': eventPrefecture,
//         'eventRegion': eventRegion,
//         'createdAt': FieldValue.serverTimestamp(),
//         'updatedAt': FieldValue.serverTimestamp(),
//         'isDeleted': false,
//         'eventJoin': 0
//       });
//     } catch (e) {
//       throw Exception('イベントの登録に失敗しました: $e');
//     }
//   }
//
//   // Firebase Storageに画像をアップロードするメソッド
//   Future<String> _uploadImage(File imageFile) async {
//     try {
//       String fileName = imageFile.path.split('/').last;
//       Reference storageRef = _storage.ref().child('event_images/$fileName');
//       UploadTask uploadTask = storageRef.putFile(imageFile);
//       TaskSnapshot snapshot = await uploadTask;
//       return await snapshot.ref.getDownloadURL();
//     } catch (e) {
//       throw Exception('画像のアップロードに失敗しました: $e');
//     }
//   }
//
//   Future<List<EventModel>> fetch({String? area, String? prefecture}) async {
//     try {
//       Query query = _firestore.collection('events');
//
//       // エリアでフィルタリング
//       if (area != null && area.isNotEmpty) {
//         query = query.where('eventRegion', isEqualTo: area);
//       }
//
//       // 都道府県でフィルタリング
//       if (prefecture != null && prefecture.isNotEmpty) {
//         query = query.where('eventPrefecture', isEqualTo: prefecture);
//       }
//
//       final snapshot = await query.get();
//
//       return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
//     } catch (e) {
//       throw Exception('Failed to fetch events: $e');
//     }
//   }
//
//   // イベントデータを削除（論理削除）するメソッド
//   Future<void> deleteEvent(String eventId) async {
//     try {
//       await _firestore.collection('events').doc(eventId).update({
//         'isDeleted': true,
//         'updatedAt': FieldValue.serverTimestamp(), // 更新日
//       });
//     } catch (e) {
//       throw Exception('イベントの削除に失敗しました: $e');
//     }
//   }
//
//   // 参加人数を更新するメソッド
//   Future<void> incrementEventJoin(String eventId) async {
//     try {
//       final eventRef = _firestore.collection('events').doc(eventId);
//       User? user = FirebaseAuth.instance.currentUser;
//
//       // 参加人数をインクリメント
//       await eventRef.update({
//         'eventJoin': FieldValue.increment(1), // Firestoreで1増やす
//         'updatedAt': FieldValue.serverTimestamp(), // 更新日時も更新
//         'participants': FieldValue.arrayUnion([user!.uid])
//       });
//     } catch (e) {
//       throw Exception('参加人数の更新に失敗しました: $e');
//     }
//   }
//
//   Future<bool> isUserJoined(String eventId, String userId) async {
//     DocumentSnapshot eventDoc =
//         await _firestore.collection('events').doc(eventId).get();
//     List participants = eventDoc['participants'] ?? [];
//     return participants.contains(userId);
//   }
// }
