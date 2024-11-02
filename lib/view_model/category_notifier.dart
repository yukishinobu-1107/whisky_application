import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/category_model.dart';

// カテゴリーデータを提供する StateNotifier
class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryModel>>> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CategoryNotifier() : super(const AsyncValue.loading()) {
    // 初期化時に Firestore からデータを取得
    fetchCategories();
  }

  // Firestore からカテゴリーデータを取得
  Future<void> fetchCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection('categories')
          .where('isDeleted', isEqualTo: false) // 削除されていないカテゴリーのみ取得
          .get();

      final categories = querySnapshot.docs
          .map((doc) => CategoryModel.fromDocument(doc))
          .toList();

      // 成功時にカテゴリーデータを状態に設定
      state = AsyncValue.data(categories);
    } catch (e, stackTrace) {
      // エラー発生時にエラー状態を設定
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

// Provider の定義
final categoryNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryModel>>>(
  (ref) => CategoryNotifier(),
);
