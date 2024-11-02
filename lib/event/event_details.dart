// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../model/event_model.dart';
// import '../repositories/event_repository.dart';
//
// class EventDetails extends StatefulWidget {
//   final EventModel event;
//   final EventRepository eventRepository;
//
//   const EventDetails({
//     Key? key,
//     required this.event,
//     required this.eventRepository,
//   }) : super(key: key);
//
//   @override
//   _EventDetailsState createState() => _EventDetailsState();
// }
//
// class _EventDetailsState extends State<EventDetails> {
//   bool _isJoined = false;
//   bool _isLoading = false; // Firestoreの更新中を表すフラグ
//
//   @override
//   void initState() {
//     super.initState();
//     _checkIfJoined();
//   }
//
//   Future<void> _checkIfJoined() async {
//     // FirebaseAuthで現在のユーザーを取得
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       // 参加済みかどうかを確認（Firestoreの「participants」フィールドにUIDが含まれているか）
//       bool isJoined =
//           await widget.eventRepository.isUserJoined(widget.event.id, user.uid);
//       setState(() {
//         _isJoined = isJoined;
//       });
//     }
//   }
//
//   Future<void> _joinEvent() async {
//     setState(() {
//       _isJoined = true; // 先にUIを更新する
//       _isLoading = true; // ローディング中に設定
//     });
//
//     try {
//       // 参加人数を更新する処理
//       await widget.eventRepository.incrementEventJoin(widget.event.id);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('参加しました！')),
//       );
//     } catch (e) {
//       // エラー時に再度ボタンを有効化
//       setState(() {
//         _isJoined = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('参加に失敗しました。もう一度お試しください。')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false; // 更新完了後にローディング終了
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text(
//           widget.event.name,
//           style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//         elevation: 0,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // イベント名
//               Text(
//                 widget.event.name,
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.orangeAccent,
//                 ),
//               ),
//               SizedBox(height: 16),
//               // イベント画像
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(20),
//                 child: Image.network(
//                   widget.event.images.isNotEmpty
//                       ? widget.event.images[0]
//                       : 'https://via.placeholder.com/150',
//                   width: double.infinity,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(height: 16),
//               // イベント詳細
//               Text(
//                 widget.event.details,
//                 style: TextStyle(fontSize: 18, color: Colors.white70),
//               ),
//               SizedBox(height: 16),
//               // イベント日
//               Row(
//                 children: [
//                   Icon(Icons.calendar_today, color: Colors.orangeAccent),
//                   SizedBox(width: 8),
//                   Text(
//                     'イベント日: ${DateFormat('yyyy/MM/dd').format(widget.event.eventDate)}',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 16),
//               // 現在の参加人数
//               Row(
//                 children: [
//                   Icon(Icons.group, color: Colors.orangeAccent),
//                   SizedBox(width: 8),
//                   Text(
//                     '現在の参加人数: ${widget.event.eventJoin}',
//                     style: TextStyle(fontSize: 18, color: Colors.white),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 32),
//               // 参加するボタン
//               Center(
//                 child: ElevatedButton.icon(
//                   onPressed: _isJoined || _isLoading
//                       ? null
//                       : () async {
//                           await _joinEvent();
//                         },
//                   icon: _isLoading
//                       ? CircularProgressIndicator(color: Colors.black)
//                       : Icon(
//                           _isJoined ? Icons.check_circle : Icons.check,
//                           color: Colors.black,
//                         ),
//                   label: Text(
//                     _isJoined ? '参加済み' : '参加する',
//                     style: TextStyle(
//                       color: _isJoined ? Colors.white : Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
//                     backgroundColor:
//                         _isJoined ? Colors.grey : Colors.orangeAccent,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
