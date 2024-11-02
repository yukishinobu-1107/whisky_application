import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'snack_ranking_model.freezed.dart';
part 'snack_ranking_model.g.dart';

@freezed
class SnackRankingModel with _$SnackRankingModel {
  factory SnackRankingModel({
    String? id, // FirestoreのドキュメントID
    required int categoryId,
    required String name,
    required int like,
    required String createdBy,
    @TimestampConverter() required DateTime createdAt,
    @TimestampConverter() required DateTime updatedAt,
    required bool isDeleted,
  }) = _SnackRankingModel;

  factory SnackRankingModel.fromJson(Map<String, dynamic> json) =>
      _$SnackRankingModelFromJson(json);
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
