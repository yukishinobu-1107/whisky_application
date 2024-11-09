import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/regions_and_prefectures.dart';
import '../event_registration/event_registration_form.dart';
import '../repositories/event_search_repository.dart';
import '../view_model/event_search_view_model.dart';
import 'event_card.dart';

class EventSearchPage extends ConsumerStatefulWidget {
  @override
  _EventSearchPageState createState() => _EventSearchPageState();
}

class _EventSearchPageState extends ConsumerState<EventSearchPage> {
  String? _selectedPrefecture = '東京都'; // 選択された都道府県を保持
  final EventSearchRepository _eventSearchRepository = EventSearchRepository();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref
        .read(eventSearchProvider.notifier)
        .fetchEvents(_selectedPrefecture));
  }

  void _showPrefectureDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colors.black,
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
                    ref
                        .read(eventSearchProvider.notifier)
                        .fetchEvents(_selectedPrefecture);
                  });
                  Navigator.pop(context);
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
    final eventList = ref.watch(eventSearchProvider); // List<Event> 型
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'イベント検索',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => EventRegistrationForm()));
            },
            icon: Icon(Icons.add, color: Colors.yellowAccent, size: 36),
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
                _showPrefectureDropdown(context);
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
                        return EventCard(
                          event: event,
                          uid: uid ?? '',
                          repository: _eventSearchRepository,
                          onDelete: () async {
                            await ref
                                .read(eventSearchProvider.notifier)
                                .fetchEvents(_selectedPrefecture);
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
    );
  }
}
