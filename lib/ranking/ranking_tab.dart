import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/provider.dart';
import '../view_model/ranking_provider.dart';

class RankingTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Firestoreから取得したカテゴリーデータを監視
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return categoriesAsyncValue.when(
      data: (categories) {
        // 取得したカテゴリーデータが空でない場合のみタブを生成
        if (categories.isEmpty) {
          return const Center(child: Text('カテゴリが見つかりませんでした'));
        }
        // categoryIdに基づいて昇順ソート
        final sortedCategories = categories.toList()
          ..sort((a, b) => a.categoryId.compareTo(b.categoryId));
        return TabBar(
          tabs: sortedCategories
              .map((category) => Tab(text: category.name))
              .toList(),
          isScrollable: true, // タブを横スクロール可能にする
          labelColor: Colors.yellow, // 選択されたタブの文字色を黄色に設定
          unselectedLabelColor: Colors.white, // 選択されていないタブの文字色を白に設定
          indicatorColor: Colors.yellow, // 下線の色も黄色に設定
          onTap: (index) {
            // タブ選択時の処理（もし何かアクションが必要ならここで実行）
            print('Selected tab index: $index');
            ref.read(tabIndexProvider.notifier).state = index;
          },
        );
      },
      loading: () => Center(
          child: CircularProgressIndicator(color: Colors.white)), // 読み込み中
      error: (error, stack) => Center(
          child: Text('エラーが発生しました', style: TextStyle(color: Colors.red))),
    );
  }
}
