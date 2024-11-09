import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_model.freezed.dart';
part 'event_model.g.dart';

// TimestampとDateTimeを相互変換するためのコンバーター
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) => timestamp.toDate();

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}

@freezed
class Event with _$Event {
  const factory Event({
    required String id,
    required String name,
    @TimestampConverter() required DateTime eventDate,
    @TimestampConverter() required DateTime startTime,
    @TimestampConverter() required DateTime endTime,
    required String place,
    required String coverImageUrl,
    List<String>? otherImageUrls,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required bool isDeleted,
    required String address,
    required String prefecture,
    required String organizer,
    required int eventType,
    String? eventUrl,
    required String uid,
  }) = _Event;

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
}
