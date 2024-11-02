import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/event_search_repository.dart';

final eventSearchProvider =
    StateNotifierProvider<EventSearchViewModel, List<Map<String, dynamic>>>(
        (ref) {
  final eventRepository = EventSearchRepository();
  return EventSearchViewModel(eventRepository);
});

class EventSearchViewModel extends StateNotifier<List<Map<String, dynamic>>> {
  final EventSearchRepository _eventRepository;

  EventSearchViewModel(this._eventRepository) : super([]);

  Future<void> fetchEvents(String? prefecture) async {
    final events = await _eventRepository.fetchEvents();

    // 都道府県が選択された場合は、その都道府県のイベントだけをフィルタリング
    final filteredEvents = prefecture != null && prefecture.isNotEmpty
        ? events.where((event) => event['prefecture'] == prefecture).toList()
        : events;

    print("取得したイベント数: ${filteredEvents.length}"); // デバッグ用
    state = filteredEvents; // 状態を更新
  }
}
