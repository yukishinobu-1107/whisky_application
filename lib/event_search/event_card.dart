import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../component/confirmation_dialog.dart';
import '../event_registration/event_registration_form.dart';
import '../repositories/event_search_repository.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final String uid; // 現在のユーザーID
  final EventSearchRepository _repository = EventSearchRepository(); // リポジトリインスタンス
  final VoidCallback onDelete; // 削除後のコールバック

  EventCard({
    required this.event,
    required this.uid,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    int eventType = event['eventType']; // イベントの種類を取得

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

    final startTime = DateFormat('HH:mm').format(event['startTime'].toDate());
    final endTime = DateFormat('HH:mm').format(event['endTime'].toDate());

    return Card(
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: borderColor, width: 2),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: event['coverImageUrl'] != null &&
                      event['coverImageUrl'].isNotEmpty
                      ? Image.network(
                    event['coverImageUrl'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Image.asset(
                    'assets/event2.jpg', // デフォルト画像
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // 右上の「...」メニュー（ユーザーが作成したイベントの場合のみ表示）
                if (event['uid'] == uid)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventRegistrationForm(
                                  eventData: event,
                                  isEditMode: true,
                                ),
                              ),
                            );
                          } else if (value == 'delete') {
                            // 削除処理
                            ConfirmationDialog.show(
                              context,
                              "削除しますか",
                              "このイベントを削除してもよろしいですか？",
                                  () async {
                                await _repository.deleteEvent(event['id']);
                                onDelete(); // 削除後のコールバックを呼び出し
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('イベントが削除されました')),
                                );
                              },
                            );
                          }
                        },
                        icon: Icon(Icons.more_vert, color: Colors.white),
                        itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Text(
                              '編集',
                              style: TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Text(
                              '削除',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              event['name'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
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
                Icon(Icons.calendar_today, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  DateFormat('yyyy/MM/dd').format(event['eventDate'].toDate()),
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(width: 15),
                Icon(Icons.access_time, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  '$startTime - $endTime',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orangeAccent, size: 16),
                SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '場所: ${event['address']}',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                eventTypeLabel,
                style: TextStyle(
                  color: Colors.orangeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
