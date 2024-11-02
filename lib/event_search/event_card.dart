import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;

  const EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    print(event);
    int eventType = event['eventType']; // イベントの種類を取得

    // イベントタイプに応じた色とスタイルを決定
    Color backgroundColor;
    Color borderColor;
    String eventTypeLabel;
    switch (eventType) {
      case 0:
        // 個人イベント
        backgroundColor = Colors.grey[850]!;
        borderColor = Colors.transparent; // 枠線なし
        eventTypeLabel = "個人イベント";
        break;
      case 1:
        // 企業/団体イベント
        backgroundColor = Colors.blueAccent[700]!;
        borderColor = Colors.orangeAccent;
        eventTypeLabel = "企業/団体イベント";
        break;
      case 2:
      default:
        // その他イベント
        backgroundColor = Colors.green[700]!;
        borderColor = Colors.transparent;
        eventTypeLabel = "その他イベント";
        break;
    }

    // 開始時間と終了時間を取得してフォーマット
    final startTime = DateFormat('HH:mm').format(event['startTime'].toDate());
    final endTime = DateFormat('HH:mm').format(event['endTime'].toDate());

    print(startTime);
    print(endTime);
    return Card(
      color: backgroundColor, // イベントタイプに応じた背景色
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: borderColor, width: 2), // 枠線
      ),
      elevation: eventType == 1 ? 10 : 3, // 企業/団体イベントには高い影を設定
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // イベント画像
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                'assets/event2.jpg', // 仮の画像
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            // イベント名
            Text(
              event['name'],
              style: TextStyle(
                fontSize: eventType == 1 ? 24 : 20, // 企業/団体イベントは大きいフォント
                fontWeight:
                    eventType == 1 ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            // イベント詳細情報
            Row(
              children: [
                Icon(Icons.calendar_today,
                    color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  DateFormat('yyyy/MM/dd').format(event['eventDate'].toDate()),
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            // 開始時間と終了時間の表示
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
                  '主催者: ${event['organizer']}',
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
                  '場所: ${event['address']}',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 16),
            // イベントタイプ表示
            Text(
              eventTypeLabel,
              style: TextStyle(
                color: Colors.orangeAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // 詳細ボタン
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  // イベント詳細ページへの遷移
                },
                child: Text('詳細を見る'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: eventType == 1
                      ? Colors.white
                      : Colors.black, // 企業/団体イベントは白いテキスト
                  backgroundColor: eventType == 1
                      ? Colors.orangeAccent
                      : Colors.grey, // 企業/団体イベントはオレンジ色のボタン
                  padding: EdgeInsets.symmetric(
                    horizontal: eventType == 1 ? 30 : 20, // 企業/団体イベントは大きいボタン
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
