import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 日時フォーマット
    final String formattedDate =
        DateFormat('yyyy/MM/dd').format(event.eventDate);
    final String formattedStartTime =
        DateFormat('HH:mm').format(event.startTime);
    final String formattedEndTime = DateFormat('HH:mm').format(event.endTime);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // カバー画像
            if (event.coverImageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  event.coverImageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 16),

            // イベント名
            Text(
              event.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 8),

            // 日時
            Text(
              '日時: $formattedDate $formattedStartTime - $formattedEndTime',
              style: TextStyle(
                fontSize: 18, // 大きめのフォントサイズ
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),

            // 場所
            Text(
              '場所: ${event.place}',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),

            // 詳細説明
            Text(
              '詳細',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              event.details,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // その他の画像ギャラリー（横スライド式）
            if (event.otherImageUrls != null &&
                event.otherImageUrls!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'その他の画像',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orangeAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 100, // 高さを固定
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: event.otherImageUrls!.length,
                      itemBuilder: (context, index) {
                        final url = event.otherImageUrls![index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              url,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
