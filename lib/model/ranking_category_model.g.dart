// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ranking_category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RankingCategoryImpl _$$RankingCategoryImplFromJson(
        Map<String, dynamic> json) =>
    _$RankingCategoryImpl(
      name: json['name'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      createdAt:
          const TimestampConverter().fromJson(json['createdAt'] as Timestamp),
      updatedAt:
          const TimestampConverter().fromJson(json['updatedAt'] as Timestamp),
      isDeleted: json['isDeleted'] as bool,
    );

Map<String, dynamic> _$$RankingCategoryImplToJson(
        _$RankingCategoryImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'categoryId': instance.categoryId,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'updatedAt': const TimestampConverter().toJson(instance.updatedAt),
      'isDeleted': instance.isDeleted,
    };
