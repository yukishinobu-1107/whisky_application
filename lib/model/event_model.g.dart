// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$EventModelImpl _$$EventModelImplFromJson(Map<String, dynamic> json) =>
    _$EventModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      details: json['details'] as String,
      url: json['url'] as String,
      eventDate: DateTime.parse(json['eventDate'] as String),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      eventPrefecture: json['eventPrefecture'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      eventJoin: (json['eventJoin'] as num).toInt(),
    );

Map<String, dynamic> _$$EventModelImplToJson(_$EventModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'details': instance.details,
      'url': instance.url,
      'eventDate': instance.eventDate.toIso8601String(),
      'images': instance.images,
      'eventPrefecture': instance.eventPrefecture,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'eventJoin': instance.eventJoin,
    };
