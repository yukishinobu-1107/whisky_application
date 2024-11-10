import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../event_details/event_detail_screen.dart';
import '../event_registration/event_registration_form.dart';
import '../model/event_model.dart';
import '../repositories/event_search_repository.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final EventSearchRepository repository; // リポジトリを追加
  final VoidCallback onDelete; // 削除後の画面リフレッシュ用コールバック

  const EventCard({
    Key? key,
    required this.event,
    required this.repository,
    required this.onDelete,
    required String uid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('^------------------------------');
    print(event);

    // イベントタイプによるカードデザインの設定
    int eventType = event.eventType;
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
      default:
        backgroundColor = Colors.green[700]!;
        borderColor = Colors.transparent;
        eventTypeLabel = "その他イベント";
        break;
    }

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
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    event.coverImageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                if (event.uid == currentUserUid) // ユーザーのイベントにのみ表示
                  Positioned(
                    top: 10,
                    right: 10,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (String result) {
                        if (result == 'edit') {
                          // 編集処理
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventRegistrationForm(
                                isEditMode: true,
                                event: event, // 編集対象のeventデータを渡す
                              ),
                            ),
                          );
                        } else if (result == 'delete') {
                          // 削除処理
                          _showDeleteConfirmation(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Text('編集'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child:
                              Text('削除', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              event.name,
              style: TextStyle(
                fontSize: eventType == 1 ? 24 : 20,
                fontWeight:
                    eventType == 1 ? FontWeight.bold : FontWeight.normal,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today,
                    color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 5),
                Text(
                  DateFormat('yyyy/MM/dd').format(event.eventDate),
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.access_time,
                    color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 5),
                Text(
                  '時間: $startTime - $endTime',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 5),
                Text(
                  '主催者: ${event.organizer}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 5),
                Text(
                  '場所: ${event.address}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              eventTypeLabel,
              style: const TextStyle(
                color: Colors.orangeAccent,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // 右下に「詳細を見る」ボタンを配置
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetailScreen(event: event),
                    ),
                  );
                },
                child: const Text(
                  '詳細を見る',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 削除確認ダイアログの表示
  Future<void> _showDeleteConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('イベントの削除'),
          content: const Text('このイベントを削除してもよろしいですか？'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('削除', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    // ダイアログで削除が確認された場合
    if (result == true) {
      try {
        // Firebase Storageからカバー画像を削除
        if (event.coverImageUrl.isNotEmpty) {
          final coverImageRef =
              FirebaseStorage.instance.refFromURL(event.coverImageUrl);
          await coverImageRef.delete();
        }

        // Firebase Storageからその他の画像を削除
        if (event.otherImageUrls != null) {
          for (String imageUrl in event.otherImageUrls!) {
            if (imageUrl.isNotEmpty) {
              final imageRef = FirebaseStorage.instance.refFromURL(imageUrl);
              await imageRef.delete();
            }
          }
        }

        // Firestoreからイベントデータを削除
        await repository.deleteEvent(event.id);

        // 削除後の更新通知
        onDelete();
      } catch (e) {
        print('エラー: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('イベントの削除に失敗しました: $e')),
        );
      }
    }
  }
}
