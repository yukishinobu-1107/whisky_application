import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/ranking_category_model.dart';
import '../repositories/ranking_repository.dart';

// カテゴリデータを非同期で取得するためのProvider
final rankingProvider = FutureProvider<List<RankingCategory>>((ref) async {
  final repository = RankingRepository();
  return repository.fetchCategories();
});

class RankingListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rankingAsyncValue = ref.watch(rankingProvider);

    return rankingAsyncValue.when(
      data: (categories) {
        return ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              title: Text(category.name),
              subtitle: Text('ID: ${category.categoryId}'),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
    );
  }
}
