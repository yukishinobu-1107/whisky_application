// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventImpl _$$EventImplFromJson(Map<String, dynamic> json) => _$EventImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      eventDate:
          const TimestampConverter().fromJson(json['eventDate'] as Timestamp),
      startTime:
          const TimestampConverter().fromJson(json['startTime'] as Timestamp),
      endTime:
          const TimestampConverter().fromJson(json['endTime'] as Timestamp),
      place: json['place'] as String,
      coverImageUrl: json['coverImageUrl'] as String,
      otherImageUrls: (json['otherImageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      isDeleted: json['isDeleted'] as bool,
      address: json['address'] as String,
      details: json['details'] as String,
      prefecture: json['prefecture'] as String,
      organizer: json['organizer'] as String,
      eventType: (json['eventType'] as num).toInt(),
      eventUrl: json['eventUrl'] as String?,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$EventImplToJson(_$EventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'eventDate': const TimestampConverter().toJson(instance.eventDate),
      'startTime': const TimestampConverter().toJson(instance.startTime),
      'endTime': const TimestampConverter().toJson(instance.endTime),
      'place': instance.place,
      'coverImageUrl': instance.coverImageUrl,
      'otherImageUrls': instance.otherImageUrls,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'isDeleted': instance.isDeleted,
      'address': instance.address,
      'details': instance.details,
      'prefecture': instance.prefecture,
      'organizer': instance.organizer,
      'eventType': instance.eventType,
      'eventUrl': instance.eventUrl,
      'uid': instance.uid,
    };
