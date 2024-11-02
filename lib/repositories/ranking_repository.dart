import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/ranking_category_model.dart';

class RankingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestoreの`categories`コレクションからカテゴリデータを取得するメソッド
  Future<List<RankingCategory>> fetchCategories() async {
    final snapshot = await _firestore.collection('categories').get();
    // Firestoreのドキュメントを`RankingCategory`に変換してリストとして返す
    return snapshot.docs
        .map((doc) => RankingCategory.fromJson(doc.data()))
        .toList();
  }
}
