import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/snack_ranking_model.dart';

class SnackRankingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore => _firestore; // ゲッターを追加
  final User? user = FirebaseAuth.instance.currentUser; // ログイン中のユーザー取得
  // Firestoreの`categories`コレクションからカテゴリデータを取得するメソッド
  Future<List<SnackRankingModel>> fetchCategories() async {
    try {
      final snapshot = await _firestore.collection('snacks').get();
      return snapshot.docs
          .map((doc) => SnackRankingModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('データ取得エラー: $e');
      throw Exception('データの取得に失敗しました');
    }
  }

  // Firestoreの「いいね」数を増やす処理
  Future<void> likeSnack(SnackRankingModel snack) async {
    // snack.name でドキュメントを検索するクエリを実行
    final snackQuery = await _firestore
        .collection('snacks')
        .where('name', isEqualTo: snack.name)
        .limit(1)
        .get();

    if (snackQuery.docs.isNotEmpty) {
      final snackDoc = snackQuery.docs.first.reference; // 最初のドキュメントの参照を取得

      await snackDoc.update({
        'like': snack.like + 1, // Firestoreのlikeフィールドをインクリメント
        'likes': FieldValue.arrayUnion([user!.uid]), // ユーザーIDを追加
      });
    }
  }

  // Firestoreの「いいね」数を減らす処理
  Future<void> unlikeSnack(SnackRankingModel snack) async {
    // snack.name でドキュメントを検索するクエリを実行
    final snackQuery = await _firestore
        .collection('snacks')
        .where('name', isEqualTo: snack.name)
        .limit(1)
        .get();

    if (snackQuery.docs.isNotEmpty && user != null) {
      final snackDoc = snackQuery.docs.first.reference;

      // FirestoreのlikesリストからユーザーIDを削除
      await snackDoc.update({
        'like': snack.like > 0 ? snack.like - 1 : 0,
        'likes': FieldValue.arrayRemove([user!.uid]), // ユーザーIDを削除
      });
    }
  }

  // 新しいおつまみを投稿する処理
  Future<void> postSnack(SnackRankingModel snack) async {
    try {
      // 自動生成されたドキュメントIDを取得
      final docRef =
          _firestore.collection('snacks').doc(); // Firestoreの新しいドキュメント参照
      snack = snack.copyWith(id: docRef.id); // 自動生成されたIDをSnackRankingModelに設定

      // データをFirestoreに保存
      await docRef.set(snack.toJson());

      print('投稿が成功しました: ${snack.id}');
    } catch (e) {
      print('投稿に失敗しました: $e');
      throw Exception('投稿に失敗しました: $e');
    }
  }

  // おつまみの更新処理
  Future<void> updateSnack(SnackRankingModel snack) async {
    try {
      // ドキュメント参照を取得
      final docRef = _firestore.collection('snacks').doc(snack.id);

      // ドキュメントが存在するか確認
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // ドキュメントが存在する場合は更新処理
        await docRef.update(snack.toJson());
      } else {
        // ドキュメントが存在しない場合は新規作成（上書き）
        await docRef.set(snack.toJson());
      }
    } catch (e) {
      throw Exception('更新に失敗しました: $e');
    }
  }

  // おつまみを削除する処理
  Future<void> deleteSnack(String snackId) async {
    try {
      // Firestoreからドキュメントを削除
      await _firestore.collection('snacks').doc(snackId).delete();
      print('Firestoreから削除されました: $snackId');
    } catch (e) {
      print('Firestore削除に失敗しました: $e');
      throw Exception('削除に失敗しました: $e');
    }
  }
}
