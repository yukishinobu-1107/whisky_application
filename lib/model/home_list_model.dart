import 'package:cloud_firestore/cloud_firestore.dart';

class HomeListModel {
  final List<dynamic> drinkImageUrl;
  final int id;
  final String text;
  final DateTime timeStamp;
  final String userID;
  final String userName;
  final String userProfilePic;

  HomeListModel({
    required this.drinkImageUrl,
    required this.id,
    required this.text,
    required this.timeStamp,
    required this.userID,
    required this.userName,
    required this.userProfilePic,
  });

  // FirestoreのDocumentSnapshotからHomeListModelを作成するファクトリメソッド
  factory HomeListModel.fromDocument(DocumentSnapshot doc) {
    return HomeListModel(
      drinkImageUrl: doc['drinkImageUrl'] ?? '',
      id: (doc['id'] is int)
          ? doc['id']
          : int.tryParse(doc['id'].toString()) ?? 0,
      text: doc['text'] ?? '',
      timeStamp: (doc['timeStamp'] is Timestamp)
          ? (doc['timeStamp'] as Timestamp).toDate() // TimestampをDateTimeに変換
          : DateTime.now(),
      userID: (doc['userID'] is String)
          ? doc['userID']
          : int.tryParse(doc['userID'].toString()) ?? 0,
      userName: doc['userName'] ?? '',
      userProfilePic: doc['userProfilePic'] ?? '',
    );
  }

  // fromJsonメソッドを追加する
  factory HomeListModel.fromJson(Map<String, dynamic> json) {
    return HomeListModel(
      drinkImageUrl: json['drinkImageUrl'] ?? '',
      id: (json['id'] is int)
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      text: json['text'] ?? '',
      timeStamp: (json['timeStamp'] is Timestamp)
          ? (json['timeStamp'] as Timestamp).toDate() // TimestampをDateTimeに変換
          : (json['timeStamp'] != null)
              ? DateTime.parse(json['timeStamp'].toString()) // Stringとして処理
              : DateTime.now(),
      userID: (json['userID'] is String)
          ? json['userID']
          : int.tryParse(json['userID'].toString()) ?? 0,
      userName: json['userName'] ?? '',
      userProfilePic: json['userProfilePic'] ?? '',
    );
  }

  // toJsonメソッドも追加する（必要に応じて）
  Map<String, dynamic> toJson() {
    return {
      'drinkImageUrl': drinkImageUrl,
      'id': id,
      'text': text,
      'timeStamp': timeStamp.toIso8601String(),
      'userID': userID,
      'userName': userName,
      'userProfilePic': userProfilePic,
    };
  }
}
