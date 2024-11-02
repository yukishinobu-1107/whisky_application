import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // 日付フォーマット用
import 'package:whisky_application/whisky_app_style/whisky_app_text_style.dart';

import '../view_model/home_list_view_model.dart';
import '../model/home_list_model.dart';

class HomeListView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeListAsyncValue =
        ref.watch(homeListViewModelProvider); // Riverpodからデータを取得

    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return homeListAsyncValue.when(
      data: (homeList) {
        if (homeList.isEmpty) {
          return Center(
            child: Text(
              '投稿がありません',
              style: TextStyle(color: Colors.white), // テキストを白に
            ),
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: homeList.length,
          itemBuilder: (BuildContext context, int index) {
            final HomeListModel homeItem = homeList[index];

            // タイムスタンプを表示用の時間に変換
            final DateTime datePublished = homeItem.timeStamp;
            final String formattedTime =
                DateFormat('h:mm a').format(datePublished);

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: _getImage(
                              homeItem.drinkImageUrl.isNotEmpty
                                  ? homeItem.drinkImageUrl[0]
                                  : null), // drinkImageUrlが空かどうか確認
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                homeItem.userName,
                                style: WhiskyAppTextStyle.mBold.copyWith(
                                  color: Colors.white, // テキストを白に
                                ),
                              ),
                            ),
                            Text(
                              homeItem.text,
                              style: WhiskyAppTextStyle.s.copyWith(
                                color: Colors.grey[300], // 本文のテキストを薄いグレーに
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            AspectRatio(
                              aspectRatio: 1, // 1:1のアスペクト比で画像を表示
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover, // 画像を枠内にフィット
                                    image: _getImage(
                                        homeItem.drinkImageUrl.isNotEmpty
                                            ? homeItem.drinkImageUrl[0]
                                            : null),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white), // アイコンを白に
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              formattedTime,
                              style: WhiskyAppTextStyle.s.copyWith(
                                color: Colors.grey[300], // タイムスタンプを薄いグレーに
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(color: Colors.grey), // Dividerの色を薄いグレーに
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(
          child: CircularProgressIndicator(
              color: Colors.white)), // ローディングインジケーターの色を白に
      error: (error, stack) => Center(
        child: Text(
          'エラーが発生しました: $error',
          style: const TextStyle(color: Colors.red), // エラーメッセージは赤に
        ),
      ), // エラーハンドリング
    );
  }

  // 画像の取得処理: 画像URLがnullまたは空なら代替画像を表示
  ImageProvider _getImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const AssetImage('assets/redspider.jpg'); // 代替画像を表示
    } else {
      return NetworkImage(imageUrl);
    }
  }
}
