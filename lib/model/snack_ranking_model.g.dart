// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snack_ranking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SnackRankingModelImpl _$$SnackRankingModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SnackRankingModelImpl(
      id: json['id'] as String?,
      categoryId: (json['categoryId'] as num).toInt(),
      name: json['name'] as String,
      like: (json['like'] as num).toInt(),
      createdBy: json['createdBy'] as String,
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      isDeleted: json['isDeleted'] as bool,
    );

Map<String, dynamic> _$$SnackRankingModelImplToJson(
        _$SnackRankingModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'name': instance.name,
      'like': instance.like,
      'createdBy': instance.createdBy,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'isDeleted': instance.isDeleted,
    };
