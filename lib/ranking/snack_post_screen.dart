import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/ranking_category_model.dart';
import '../model/snack_ranking_model.dart';
import '../repositories/snack_ranking_repository.dart';
import '../view_model/ranking_provider.dart';
import '../view_model/snack_ranking_view_model.dart';

class SnackPostScreen extends ConsumerStatefulWidget {
  final bool isEditing; // 編集モードか新規投稿かを判断するフラグ
  final SnackRankingModel? existingSnack; // 編集時に渡される既存データ

  const SnackPostScreen({
    Key? key,
    this.isEditing = false, // デフォルトは新規投稿
    this.existingSnack,
  }) : super(key: key);

  @override
  _SnackPostScreenState createState() => _SnackPostScreenState();
}

class _SnackPostScreenState extends ConsumerState<SnackPostScreen> {
  final _formKey = GlobalKey<FormState>();
  String snackName = '';
  RankingCategory? selectedCategory;

  final SnackRankingRepository _snackRepository =
      SnackRankingRepository(); // リポジトリのインスタンス

  @override
  void initState() {
    super.initState();
    // 編集モードか新規投稿モードかで初期値を設定
    if (widget.isEditing && widget.existingSnack != null) {
      snackName = widget.existingSnack!.name;
      selectedCategory = RankingCategory(
        categoryId: widget.existingSnack!.categoryId,
        name: 'カテゴリ名', createdAt: DateTime.now(), updatedAt: DateTime.now(),
        isDeleted: false, // 仮のカテゴリ名。Firestoreのデータとマッチさせる必要あり
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Firestoreから取得したカテゴリーデータを監視
    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.isEditing ? 'ランキング編集' : 'おつまみを投稿',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        backgroundColor: Colors.black, // 背景を黒に設定
        iconTheme: const IconThemeData(color: Colors.white), // 戻るボタンのアイコン色を白に設定
      ),
      backgroundColor: Colors.black, // 全体の背景色を黒に設定
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // おつまみ名入力
              Card(
                color: Colors.grey[900], // カードの背景をダークグレーに
                elevation: 3, // カードに影を付ける
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // 角を丸める
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    initialValue: snackName, // 初期値を設定（編集時には既存の名前）
                    style: TextStyle(color: Colors.white), // 文字色を白に
                    decoration: InputDecoration(
                      labelText: 'おつまみ名',
                      labelStyle: TextStyle(
                          color: Colors.white, fontSize: 18), // ラベルの色を白に
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(8.0), // 入力フィールドの角を丸くする
                        borderSide:
                            BorderSide(color: Colors.white), // ボーダーの色を白に
                      ),
                      filled: true,
                      fillColor: Colors.grey[800], // 背景色をダークグレーに
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'おつまみ名を入力してください';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      snackName = value!;
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              // カテゴリー選択をカードで包む
              Card(
                color: Colors.grey[900], // カードの背景をダークグレーに
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: categoriesAsyncValue.when(
                    data: (categories) {
                      // categoryIdでソート
                      categories
                          .sort((a, b) => a.categoryId.compareTo(b.categoryId));

                      if (widget.isEditing && selectedCategory != null) {
                        selectedCategory = categories.firstWhere(
                          (category) =>
                              category.categoryId ==
                              selectedCategory!.categoryId,
                          orElse: () => RankingCategory(
                            categoryId: -1, // 無効なデフォルトカテゴリーID
                            name: 'カテゴリー未設定', // デフォルトのカテゴリー名
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            isDeleted: false,
                          ),
                        );
                      }

// カテゴリーが存在しない場合、デフォルトで選択する処理
                      if (selectedCategory == null && categories.isNotEmpty) {
                        selectedCategory = categories.first; // リストの最初のカテゴリーを選択
                      }

                      return DropdownButtonFormField<RankingCategory>(
                        decoration: InputDecoration(
                          labelText: 'カテゴリーを選択',
                          labelStyle: TextStyle(
                              color: Colors.white, fontSize: 18), // ラベルの色を白に
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.grey[800], // 背景色をダークグレーに
                        ),
                        dropdownColor: Colors.grey[850], // ドロップダウンの背景色
                        style: TextStyle(
                            color: Colors.white), // ドロップダウンのテキストカラーを白に
                        value: selectedCategory, // 初期選択
                        items: categories.map((category) {
                          return DropdownMenuItem<RankingCategory>(
                            value: category,
                            child: Text(category.name,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (RankingCategory? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      );
                    },
                    loading: () => CircularProgressIndicator(), // 読み込み中
                    error: (err, stack) => Text('カテゴリーの取得に失敗しました',
                        style: TextStyle(color: Colors.redAccent)),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // 投稿ボタン
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _submitSnack(); // 投稿処理
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20), // ボタンの角を丸く
                    ),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    elevation: 5, // ボタンに影を付ける
                  ),
                  child: Text(widget.isEditing ? '更新する' : '投稿する'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitSnack() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (selectedCategory == null) return; // カテゴリーが未選択の場合は処理を終了
    if (!_formKey.currentState!.validate()) return; // フォームのバリデーションチェック

    _formKey.currentState!.save();

    final snackRepository = SnackRankingRepository();

    if (widget.isEditing && widget.existingSnack != null) {
      // 編集モード
      final snack = widget.existingSnack!.copyWith(
        name: snackName,
        categoryId: selectedCategory!.categoryId,
        updatedAt: DateTime.now(), // 更新日時を現在時刻に更新
      );

      try {
        await snackRepository.updateSnack(snack); // 更新処理
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ランキングが更新されました')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('更新に失敗しました: $e')),
        );
      }
    } else {
      // 新規投稿モード
      final docRef = FirebaseFirestore.instance.collection('snacks').doc();
      final newSnack = SnackRankingModel(
        id: docRef.id,
        name: snackName,
        categoryId: selectedCategory!.categoryId,
        like: 0,
        createdBy: currentUser!.uid,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isDeleted: false,
      );

      try {
        await snackRepository.postSnack(newSnack);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('おつまみを投稿しました！')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('投稿に失敗しました: $e')),
        );
      }
    }

    ref.refresh(snackRankingProvider); // データをリフレッシュして画面更新
    Navigator.pop(context); // 投稿後、前の画面に戻る
  }
}
