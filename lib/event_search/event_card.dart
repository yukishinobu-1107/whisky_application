import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/event_model.dart';

class EventCard extends StatelessWidget {
  final Event event; // 型をEventに変更

  const EventCard({required this.event, required Future<Null> Function() onDelete, required String uid});

  @override
  Widget build(BuildContext context) {
    print(event.toJson());
    int eventType = event.eventType;

    // イベントタイプに応じた色とスタイルを決定
    Color backgroundColor;
    Color borderColor;
    String eventTypeLabel;
    switch (eventType) {
      case 0:
        backgroundColor = Colors.grey[850]!;
        borderColor = Colors.transparent;
        eventTypeLabel = "個人イベント";
        break;
      case 1:
        backgroundColor = Colors.blueAccent[700]!;
        borderColor = Colors.orangeAccent;
        eventTypeLabel = "企業/団体イベント";
        break;
      case 2:
      default:
        backgroundColor = Colors.green[700]!;
        borderColor = Colors.transparent;
        eventTypeLabel = "その他イベント";
        break;
    }

    // 開始時間と終了時間を取得してフォーマット
    final startTime = DateFormat('HH:mm').format(event.startTime);
    final endTime = DateFormat('HH:mm').format(event.endTime);

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: borderColor, width: 2),
      ),
      elevation: eventType == 1 ? 10 : 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/event2.jpg',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              event.name,
              style: TextStyle(
                fontSize: eventType == 1 ? 24 : 20,
                fontWeight: eventType == 1 ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  DateFormat('yyyy/MM/dd').format(event.eventDate),
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  '時間: $startTime - $endTime',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.person, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  '主催者: ${event.organizer}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  '場所: ${event.address}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              eventTypeLabel,
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // イベント詳細ページへの遷移
                },
                child: Text('詳細を見る'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: eventType == 1 ? Colors.white : Colors.black,
                  backgroundColor: eventType == 1 ? Colors.orangeAccent : Colors.grey,
                  padding: EdgeInsets.symmetric(
                    horizontal: eventType == 1 ? 30 : 20,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
