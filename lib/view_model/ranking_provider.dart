import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/ranking_category_model.dart';
import '../repositories/ranking_repository.dart';

// カテゴリデータを取得するFutureProvider
final categoriesProvider = FutureProvider<List<RankingCategory>>((ref) async {
  final repository = RankingRepository();
  return repository.fetchCategories();
});
