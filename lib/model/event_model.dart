import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

@freezed
class EventModel with _$EventModel {
  const factory EventModel({
    required String id,
    required String name,
    required String details,
    required String url,
    required DateTime eventDate,
    required List<String> images,
    required String eventPrefecture,
    required DateTime createdAt, // createdAt 追加
    required DateTime updatedAt, // updatedAt 追加
    required int eventJoin,
  }) = _EventModel;

  factory EventModel.fromJson(Map<String, dynamic> json) =>
      _$EventModelFromJson(json);

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      name: data['eventName'] ?? '',
      details: data['eventDetails'] ?? '',
      url: data['eventUrl'] ?? '',
      eventDate: (data['eventDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      images: List<String>.from(data['eventImages'] ?? []),
      eventPrefecture: data['eventPrefecture'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      eventJoin: data['eventJoin'] ?? 0, // eventJoin の初期値を 0 に設定
    );
  }
}
