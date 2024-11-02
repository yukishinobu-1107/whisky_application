import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whisky_application/ranking/snack_post_screen.dart';

import '../model/snack_ranking_model.dart';
import '../provider/provider.dart';
import '../view_model/snack_ranking_view_model.dart'; // StateNotifierProviderをインポート

class SnackRankingTile extends ConsumerWidget {
  final SnackRankingModel snack;
  final int rank;
  BuildContext context;

  SnackRankingTile({
    Key? key,
    required this.snack,
    required this.rank,
    required this.context,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 現在のユーザーを取得
    final currentUser = FirebaseAuth.instance.currentUser;

    // 自分の投稿かどうかを判定
    final bool isOwner =
        currentUser != null && snack.createdBy == currentUser.uid;

    // いいねが押されているかどうかを判定
    final isLiked = snack.like > 0;

    // タブのインデックスを監視
    final selectedTabIndex = ref.watch(tabIndexProvider);

    return CardDetails(
        selectedTabIndex, snack, rank, ref, isOwner); // isOwnerを渡す
  }

  Widget CardDetails(int tabIndex, SnackRankingModel snack, int rank,
      WidgetRef ref, bool isOwner) {
    // categoryIdとtabIndexを対応させるマップ
    final categoryMap = {
      0: 1, // お肉類 (tabIndex 0 -> categoryId 1)
      1: 2, // 魚介類 (tabIndex 1 -> categoryId 2)
      2: 3, // ナッツ類 (tabIndex 2 -> categoryId 3)
      3: 4, // サラダ類 (tabIndex 3 -> categoryId 4)
      4: 5, // チーズ類 (tabIndex 4 -> categoryId 5)
    };

    // tabIndexに対応するcategoryIdが存在し、snack.categoryIdと一致する場合のみCardを返す
    if (categoryMap[tabIndex] == snack.categoryId) {
      return buildSnackCard(snack, rank, ref, isOwner); // isOwnerを渡す
    }

    // 条件に合わない場合は何も表示しない（空のコンテナなど）
    return SizedBox.shrink();
  }

  // 重複しているCard部分を関数化
  Widget buildSnackCard(
      SnackRankingModel snack, int rank, WidgetRef ref, bool isOwner) {
    final isLiked = snack.like > 0; // いいねが押されているかどうかを判定

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          child: Text('${rank}位'), // ランキング番号を"1位", "2位"の形式にする
        ),
        title: Text(
          snack.name,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text('いいね: ${snack.like}件'), // いいね数の表示
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 削除ボタン: 投稿者本人のみ表示
            if (isOwner)
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _confirmDelete(context, ref); // 削除確認ダイアログを表示
                },
              ),
            // いいねアイコン
            IconButton(
              icon: Icon(
                isLiked
                    ? Icons.favorite
                    : Icons.favorite_border, // いいねの状態に応じたアイコン
                color: isLiked ? Colors.red : Colors.grey, // いいねの色を切り替え
              ),
              onPressed: () {
                if (isLiked) {
                  ref
                      .read(snackRankingProvider.notifier)
                      .unlikeSnack(snack); // いいねを減らす
                } else {
                  ref
                      .read(snackRankingProvider.notifier)
                      .likeSnack(snack); // いいねを増やす
                }
              },
            ),
            // 投稿者のみ編集アイコンを表示
            if (isOwner)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue), // 編集アイコン
                onPressed: () {
                  // 編集画面に遷移する処理
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SnackPostScreen(
                        isEditing: true,
                        existingSnack: snack, // 編集するデータを渡す
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  // 削除確認ダイアログを表示する処理
  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('削除確認'),
          content: Text('このランキングを削除してもよろしいですか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('キャンセル'),
            ),
            TextButton(
              onPressed: () {
                _deleteRanking(context, ref); // 削除処理
              },
              child: Text('削除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _deleteRanking(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(snackRankingProvider.notifier).deleteSnack(snack); // 削除処理
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ランキングが削除されました')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('削除に失敗しました: $e')),
      );
    } finally {
      Navigator.pop(context); // ダイアログを閉じる
    }
  }
}
