import 'package:cloud_firestore/cloud_firestore.dart';

//firestoreへ仮データを入れるためだけのやつ
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firestoreにサンプルカテゴリーを自動で入力
//   Future<void> addSampleCategories() async {
//     // サンプルカテゴリーリスト
//     final List<Map<String, dynamic>> sampleCategories = [
//       {
//         'name': 'お肉類',
//         'categoryId': 1,
//         'createdAt': DateTime.now(),
//         'updatedAt': DateTime.now(),
//         'isDeleted': false,
//       },
//       {
//         'name': '魚介類',
//         'categoryId': 2,
//         'createdAt': DateTime.now(),
//         'updatedAt': DateTime.now(),
//         'isDeleted': false,
//       },
//       {
//         'name': 'ナッツ類',
//         'categoryId': 3,
//         'createdAt': DateTime.now(),
//         'updatedAt': DateTime.now(),
//         'isDeleted': false,
//       },
//       {
//         'name': 'サラダ類',
//         'categoryId': 4,
//         'createdAt': DateTime.now(),
//         'updatedAt': DateTime.now(),
//         'isDeleted': false,
//       },
//       {
//         'name': 'チーズ類',
//         'categoryId': 5,
//         'createdAt': DateTime.now(),
//         'updatedAt': DateTime.now(),
//         'isDeleted': false,
//       },
//     ];
//
//     // サンプルデータをFirestoreに追加
//     for (var category in sampleCategories) {
//       await _firestore.collection('categories').add(category);
//     }
//
//     print("サンプルカテゴリーをFirestoreに追加しました。");
//   }
// }
//
// List<Map<String, dynamic>> mockCategories = [
//   {
//     'name': 'お肉類',
//     'categoryId': 1,
//     'createdAt': DateTime.now(),
//     'updatedAt': DateTime.now(),
//     'isDeleted': false,
//   },
//   {
//     'name': '魚介類',
//     'categoryId': 2,
//     'createdAt': DateTime.now(),
//     'updatedAt': DateTime.now(),
//     'isDeleted': false,
//   },
//   {
//     'name': 'ナッツ類',
//     'categoryId': 3,
//     'createdAt': DateTime.now(),
//     'updatedAt': DateTime.now(),
//     'isDeleted': false,
//   },
//   {
//     'name': 'サラダ類',
//     'categoryId': 4,
//     'createdAt': DateTime.now(),
//     'updatedAt': DateTime.now(),
//     'isDeleted': false,
//   },
//   {
//     'name': 'チーズ類',
//     'categoryId': 5,
//     'createdAt': DateTime.now(),
//     'updatedAt': DateTime.now(),
//     'isDeleted': false,
//   },
// ];

// // 仮データを作成して追加
  Future<void> addMockData() async {
    final categories = [
      {
        'name': 'ビーフジャーキー',
        'categoryId': 1,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': '角煮',
        'categoryId': 1,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': '焼肉',
        'categoryId': 1,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': 'スモークサーモン',
        'categoryId': 2,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': '刺身',
        'categoryId': 2,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': 'カシューナッツ',
        'categoryId': 3,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': 'ピーナッツ',
        'categoryId': 3,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': 'シーザーサラダ',
        'categoryId': 4,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
      {
        'name': 'チェダーチーズ',
        'categoryId': 5,
        'like': 0,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false
      },
    ];

    // items コレクションに仮データを追加
    for (var item in categories) {
      await _firestore.collection('snacks').add(item);
    }
  }
}
