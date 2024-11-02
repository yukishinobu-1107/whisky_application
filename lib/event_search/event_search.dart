import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/regions_and_prefectures.dart';
import '../event_registration/event_registration_form.dart';
import '../view_model/event_search_view_model.dart';
import 'event_card.dart';

class EventSearchPage extends ConsumerStatefulWidget {
  @override
  _EventSearchPageState createState() => _EventSearchPageState();
}

class _EventSearchPageState extends ConsumerState<EventSearchPage> {
  String? _selectedPrefecture = '東京都'; // 選択された都道府県を保持

  // 仮のプレミアム会員ステータス
  bool isPremiumUser = true; // trueなら有料会員、falseなら非会員

  @override
  void initState() {
    super.initState();
    // 初期表示時に全イベントを取得
    Future.microtask(() => ref
        .read(eventSearchProvider.notifier)
        .fetchEvents(_selectedPrefecture));
  }

  // Function to show prefecture dropdown as a bottom sheet
  void _showPrefectureDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5, // 画面の半分の高さ
          color: Colors.black, // 背景を黒に設定
          child: ListView.builder(
            itemCount: prefectures.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  prefectures[index],
                  style: const TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    _selectedPrefecture = prefectures[index];
                    // 都道府県選択に応じてイベントを取得
                    ref
                        .read(eventSearchProvider.notifier)
                        .fetchEvents(_selectedPrefecture);
                  });
                  Navigator.pop(context); // ドロップダウンを閉じる
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final eventList = ref.watch(eventSearchProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'イベント検索',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,

        // 右側にプラスボタンを表示
        actions: [
          // プラスボタンを豪華に、華やかに装飾
          IconButton(
            onPressed: () {
              // イベント追加ページへの遷移処理
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => EventRegistrationForm()));
            },
            icon: Stack(
              alignment: Alignment.center,
              children: [
                // 背景の輝きを演出
                Positioned(
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.yellowAccent.withOpacity(0.3),
                          Colors.transparent,
                        ],
                        stops: [0.6, 1],
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.add_circle,
                  color: Colors.yellowAccent, // ゴールドに近い色で特権を強調
                  size: 36, // 通常より少し大きめ
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(
                _selectedPrefecture ?? '都道府県を選択してください',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              onTap: () {
                _showPrefectureDropdown(context); // モーダルボトムシートを表示
              },
              tileColor: Colors.grey[800],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.orangeAccent, width: 2),
              ),
              trailing:
                  const Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
            ),
          ),
          Expanded(
            child: eventList.isEmpty
                ? Center(
                    child: Text(
                      'イベントが見つかりません',
                      style: TextStyle(color: Colors.white70, fontSize: 18),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: eventList.length,
                      itemBuilder: (context, index) {
                        final event = eventList[index];
                        return EventCard(event: event);
                      },
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900], // 背景色
    );
  }
}
