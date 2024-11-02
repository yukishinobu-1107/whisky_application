import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisky_application/ranking/snack_post_screen.dart';
import 'package:whisky_application/ranking/snack_ranking_tile.dart';

import '../view_model/ranking_provider.dart';
import '../view_model/snack_ranking_view_model.dart';
import 'ranking_tab.dart'; // タブを実装したファイルをインポート

class RankingScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Firestoreから取得したカテゴリーデータを監視
    final categoriesAsyncValue = ref.watch(categoriesProvider);
    final snackRankingList = ref.watch(snackRankingProvider); // リストを直接取得

    return categoriesAsyncValue.when(
      data: (categories) {
        return DefaultTabController(
          length: categories.length, // タブの数をFirestoreから取得したデータの長さに設定
          child: Scaffold(
            backgroundColor: Colors.black, // 背景色を黒に設定
            appBar: AppBar(
              centerTitle: true,
              title: const Text(
                'おつまみランキング',
                style: TextStyle(
                  color: Colors.white, // タイトルの文字色を白に設定
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SnackPostScreen()));
                  },
                  icon: Icon(
                    color: Colors.white,
                    Icons.add,
                  ),
                )
              ],
              backgroundColor: Colors.black, // AppBarの背景も黒に設定
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(48.0),
                child: RankingTab(), // ranking_tab.dartのタブをここで呼び出す
              ),
            ),
            body: snackRankingList.isEmpty
                ? Center(
                    child: Text(
                      'データがありません',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: snackRankingList.length,
                    itemBuilder: (context, index) {
                      final snack = snackRankingList[index];

                      return SnackRankingTile(
                        snack: snack,
                        rank: index + 1,
                        context: context,
                      );
                    },
                  ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: Colors.black, // 背景色を黒に設定
        appBar: AppBar(
          title: const Text(
            'おつまみランキング',
            style: TextStyle(color: Colors.white), // タイトルの文字色を白に設定
          ),
          backgroundColor: Colors.black, // AppBarの背景も黒に設定
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: Colors.white, // 読み込み中のインジケータも目立つように白色
          ),
        ),
      ),
      error: (error, stack) => Scaffold(
        backgroundColor: Colors.black, // 背景色を黒に設定
        appBar: AppBar(
          title: const Text(
            'おつまみランキング',
            style: TextStyle(color: Colors.white), // タイトルの文字色を白に設定
          ),
          backgroundColor: Colors.black, // AppBarの背景も黒に設定
        ),
        body: Center(
          child: Text(
            'エラーが発生しました: $error',
            style: const TextStyle(
              color: Colors.red,
              fontSize: 18,
            ), // エラーメッセージを赤色で表示
          ),
        ),
      ),
    );
  }
}
