import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../model/snack_ranking_model.dart';
import '../repositories/snack_ranking_repository.dart';

class SnackRankingNotifier extends StateNotifier<List<SnackRankingModel>> {
  final SnackRankingRepository repository;

  SnackRankingNotifier(this.repository) : super([]) {
    _fetchCategories();
  }
  // データの取得処理
  Future<void> _fetchCategories() async {
    try {
      final categories = await repository.fetchCategories();
      state = categories; // 取得したデータを状態にセット
    } catch (error) {
      // エラーハンドリングなどもここで行えます
      state = [];
    }
  }

  // Firestoreにいいねの数を増やす処理
  Future<void> likeSnack(SnackRankingModel snack) async {
    try {
      // Firestoreの更新処理を呼び出す
      await repository.likeSnack(snack);

      // ローカルの状態も更新
      state = state.map((s) {
        if (s.name == snack.name) {
          return s.copyWith(like: s.like + 1);
        }
        return s;
      }).toList();
    } catch (e) {
      // エラーハンドリング
      print('Error liking snack: $e');
    }
  }

  // Firestoreにいいねの数を減らす処理
  Future<void> unlikeSnack(SnackRankingModel snack) async {
    try {
      // Firestoreの更新処理を呼び出す
      await repository.unlikeSnack(snack);

      // ローカルの状態も更新
      state = state.map((s) {
        if (s.name == snack.name && s.like > 0) {
          return s.copyWith(like: s.like - 1);
        }
        return s;
      }).toList();
    } catch (e) {
      // エラーハンドリング
      print('Error unliking snack: $e');
    }
  }

  // 投稿を削除する処理
  Future<void> deleteSnack(SnackRankingModel snack) async {
    try {
      await repository.deleteSnack(snack.id!); // Firestoreから削除
      print('削除成功: ${snack.id}');
      // 状態から削除
      state = state.where((item) => item.id != snack.id).toList();
    } catch (e) {
      print('削除に失敗しました: $e'); // エラーログ
      throw Exception('削除に失敗しました: $e');
    }
  }
}

// プロバイダーを定義
final snackRankingProvider =
    StateNotifierProvider<SnackRankingNotifier, List<SnackRankingModel>>((ref) {
  final repository = SnackRankingRepository();
  return SnackRankingNotifier(repository);
});
