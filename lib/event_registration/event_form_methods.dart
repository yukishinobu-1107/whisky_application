import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:uuid/uuid.dart';
import 'package:whisky_application/model/event_model.dart';
import 'package:whisky_application/repositories/event_search_repository.dart';

import '../component/show_loading_dialog.dart';

Future<void> saveEventToFirestore(
    BuildContext context,
    Event event, // Event オブジェクトを直接受け取る
    List<File> selectedImages,
    File? coverImage, // 新たにカバー画像としてFile? を渡す
    EventSearchRepository eventSearchRepository) async {
  // UIDがnullの場合の処理
  final String? uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ユーザーが認証されていません')),
    );
    return;
  }

  if (coverImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('表紙画像を選択してください')),
    );
    return;
  }

  showLoadingDialog(context);

  try {
    // 表紙画像の圧縮とアップロード
    final compressedCoverImage = await compressImage(coverImage);
    final coverImageUrl = await uploadImage(
      compressedCoverImage ?? coverImage,
      'event_images/${event.id}/cover_image.jpg',
    );

    // その他の画像のアップロード
    final otherImageUrls =
        await uploadImagesWithLimit(selectedImages, 3, event.id);

    // `Event`のコピーを作成し、アップロードされた画像URLを追加
    final updatedEvent = event.copyWith(
      coverImageUrl: coverImageUrl,
      otherImageUrls: otherImageUrls,
      updatedAt: DateTime.now(),
    );

    // Firestoreにイベントデータを保存
    await eventSearchRepository.saveEvent(updatedEvent.toJson());

    Navigator.of(context).pop(); // ローディング画面を閉じる
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('イベントが正常に登録されました')),
    );

    // イベント検索画面に戻る
    Navigator.of(context).pushReplacementNamed('/event_search');
  } catch (e) {
    Navigator.of(context).pop(); // ローディング画面を閉じる
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('イベントの登録に失敗しました: $e')),
    );
  }
}

// 画像を圧縮するメソッド
Future<File?> compressImage(File file) async {
  final result = await FlutterImageCompress.compressWithFile(
    file.absolute.path,
    quality: 70,
  );
  if (result == null) return null;
  return File(file.path)..writeAsBytesSync(result);
}

// 画像をアップロードしURLを返すメソッド
Future<String> uploadImage(File imageFile, String path) async {
  final ref = FirebaseStorage.instance.ref().child(path);
  await ref.putFile(imageFile);
  return await ref.getDownloadURL();
}

// リミットを適用して画像をアップロードするメソッド
Future<List<String>> uploadImagesWithLimit(
    List<File> images, int limit, String eventId) async {
  List<String> urls = [];
  for (int i = 0; i < images.length; i += limit) {
    final batch = images.skip(i).take(limit).map((file) async {
      final compressedFile = await compressImage(file);
      return await uploadImage(
        compressedFile ?? file,
        'event_images/$eventId/other_images/${Uuid().v4()}.jpg',
      );
    }).toList();
    final batchResults = await Future.wait(batch);
    urls.addAll(batchResults);
  }
  return urls;
}
