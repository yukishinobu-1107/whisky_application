import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/event_model.dart';
import '../repositories/event_search_repository.dart';

final eventSearchProvider = StateNotifierProvider<EventSearchViewModel, List<Event>>((ref) {
  final eventRepository = EventSearchRepository();
  return EventSearchViewModel(eventRepository);
});

class EventSearchViewModel extends StateNotifier<List<Event>> {
  final EventSearchRepository _eventRepository;

  EventSearchViewModel(this._eventRepository) : super([]);

  // イベントデータを取得し、都道府県フィルタリングを行うメソッド
  Future<void> fetchEvents(String? prefecture) async {
    try {
      // Eventモデルのリストを取得
      final events = await _eventRepository.fetchEvents();

      // 都道府県が選択された場合にフィルタリング
      final filteredEvents = prefecture != null && prefecture.isNotEmpty
          ? events.where((event) => event.prefecture == prefecture).toList()
          : events;

      print("取得したイベント数: ${filteredEvents.length}"); // デバッグ用
      state = filteredEvents; // 状態を更新
    } catch (e) {
      print("イベントの取得に失敗しました: $e");
      // 必要に応じてエラーハンドリングの処理を追加
      state = []; // エラー時には空のリストに設定
    }
  }

  // 状態をクリアするメソッド（例えば検索リセット用）
  void clearEvents() {
    state = [];
  }
}
