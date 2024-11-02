import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking_category_model.freezed.dart';
part 'ranking_category_model.g.dart';

@freezed
class RankingCategory with _$RankingCategory {
  factory RankingCategory({
    required String name,
    required int categoryId,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required bool isDeleted,
  }) = _RankingCategory;

  factory RankingCategory.fromJson(Map<String, dynamic> json) =>
      _$RankingCategoryFromJson(json);
}

// TimestampとDateTimeの変換を行うためのカスタムコンバーター
class TimestampConverter implements JsonConverter<DateTime, Timestamp> {
  const TimestampConverter();

  @override
  DateTime fromJson(Timestamp timestamp) {
    return timestamp.toDate();
  }

  @override
  Timestamp toJson(DateTime date) => Timestamp.fromDate(date);
}
