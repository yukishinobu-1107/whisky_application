import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../event_search/event_search.dart';
import '../home/home.dart';
import '../model/category_model.dart';
import '../profile/profile.dart';
import '../ranking/ranking_screen.dart';
import '../view_model/navigation_notifier.dart';

class NavBar extends ConsumerWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(navigationProvider); // 現在の選択状態を監視
// カテゴリーのデータをここで管理
    final CategoryModel category =
        CategoryModel(id: 'category123', name: '飲み物');
    return Scaffold(
      body: selectedIndex == 0
          ? const Home()
          : selectedIndex == 1
              ? EventSearchPage()
              : selectedIndex == 2
                  ? RankingScreen()
                  : Profile(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black, // 背景色を黒に設定
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'イベント情報',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chair),
            label: 'マイルーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'プロフィール',
          ),
        ],
        currentIndex: selectedIndex,
        selectedItemColor: Colors.amber[800], // 選択されたアイテムは黄色
        unselectedItemColor: Colors.grey, // 未選択のアイテムはグレー
        onTap: (index) {
          ref.read(navigationProvider.notifier).setIndex(index); // インデックス変更
        },
        type: BottomNavigationBarType.fixed, // アイテムのラベルが固定表示されるように設定
      ),
    );
  }
}
