// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_storage/firebase_storage.dart'; // Firebase Storageをインポート
// import '../repositories/event_repository.dart';
// import '../model/event_model.dart';
//
// class EventNotifier extends StateNotifier<List<EventModel>> {
//   final EventRepository eventRepository;
//
//   EventNotifier(this.eventRepository) : super([]);
//
//   Future<void> fetchEvents({String? area, String? prefecture}) async {
//     try {
//       final events =
//           await eventRepository.fetch(area: area, prefecture: prefecture);
//       state = events;
//     } catch (e) {
//       print('Failed to fetch events: $e');
//     }
//   }
// }
//
// // eventRepositoryのプロバイダー
// final eventRepositoryProvider = Provider<EventRepository>((ref) {
//   final firestore = FirebaseFirestore.instance;
//   final storage = FirebaseStorage.instance;
//   return EventRepository(firestore, storage); // 2つの引数を渡す
// });
// // EventNotifierを管理するプロバイダー
// final eventProvider =
//     StateNotifierProvider<EventNotifier, List<EventModel>>((ref) {
//   // FirestoreとFirebase Storageのインスタンスを渡す
//   final repository = EventRepository(
//     FirebaseFirestore.instance,
//     FirebaseStorage.instance, // Storageのインスタンスも追加
//   );
//   return EventNotifier(repository);
// });
