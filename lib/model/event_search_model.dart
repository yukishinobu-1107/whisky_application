// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class EventModel {
//   final String id;
//   final String name;
//   final String details;
//   final DateTime eventDate;
//   final List<String> imageUrls;
//   final String location;
//
//   EventModel({
//     required this.id,
//     required this.name,
//     required this.details,
//     required this.eventDate,
//     required this.imageUrls,
//     required this.location,
//   });
//
//   factory EventModel.fromFirestore(DocumentSnapshot doc) {
//     final data = doc.data() as Map<String, dynamic>;
//     return EventModel(
//       id: doc.id,
//       name: data['name'] ?? '',
//       details: data['details'] ?? '',
//       eventDate: (data['eventDate'] as Timestamp).toDate(),
//       imageUrls: List<String>.from(data['imageUrls'] ?? []),
//       location: data['location'] ?? '',
//     );
//   }
// }
