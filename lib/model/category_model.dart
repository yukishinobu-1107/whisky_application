import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    required String id,
    required String name,
    @Default(false) bool isDeleted,
  }) = _CategoryModel;

  // Firestore から取得したデータを変換するファクトリメソッド
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  // Firestore ドキュメントから CategoryModel を生成
  factory CategoryModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] as String? ?? 'Unknown', // nullチェック
      isDeleted: data['isDeleted'] as bool? ?? false, // nullチェック
    );
  }
}
