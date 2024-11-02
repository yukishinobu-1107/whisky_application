// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:intl/intl.dart';
// import '../constants/regions_and_prefectures.dart';
// import '../repositories/event_repository.dart';
// import '../view_model/event_view_model.dart';
// import 'add_event.dart';
// import 'event_details.dart'; // イベント詳細ページのインポート
//
// // エリアのプロバイダー
// final selectedAreaProvider = StateProvider<String>((ref) => regions[0]);
//
// // 都道府県のプロバイダー
// final selectedPrefectureProvider = StateProvider<String?>((ref) => null);
//
// // フィルタリングされた都道府県リストのプロバイダー
// final filteredPrefectureProvider = StateProvider<List<String>>((ref) {
//   return regionToPrefectures[regions[0]] ?? [];
// });
//
// class EventScreen extends ConsumerStatefulWidget {
//   @override
//   _EventScreenState createState() => _EventScreenState();
// }
//
// class _EventScreenState extends ConsumerState<EventScreen> {
//   late EventRepository eventRepository;
//   @override
//   void initState() {
//     super.initState();
//     // 初期表示時に「北海道」のイベントを取得
//     final selectedArea = ref.read(selectedAreaProvider);
//     ref.read(eventProvider.notifier).fetchEvents(area: selectedArea);
//     // EventRepositoryを初期化
//     eventRepository =
//         EventRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final selectedArea = ref.watch(selectedAreaProvider);
//     final selectedPrefecture = ref.watch(selectedPrefectureProvider);
//     final filteredPrefectures =
//         ref.watch(filteredPrefectureProvider); // フィルタリングされた都道府県リスト
//     final events = ref.watch(eventProvider);
//
//     return Scaffold(
//       backgroundColor: Colors.black, // 背景を黒に
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'イベント情報検索',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.white, // タイトルを白に
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (_) => AddEvent()));
//             },
//             icon: Icon(Icons.add, color: Colors.white),
//           )
//         ],
//         backgroundColor: Colors.transparent, // 背景を透明に
//         elevation: 0, // 影を無くす
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Column(
//         children: [
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade900,
//               borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black54,
//                   blurRadius: 8,
//                   offset: Offset(0, 4),
//                 )
//               ],
//             ),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.location_on, color: Colors.orangeAccent),
//                     SizedBox(width: 8),
//                     DropdownButton<String>(
//                       value: selectedArea,
//                       icon: Icon(Icons.arrow_drop_down, color: Colors.white),
//                       dropdownColor: Colors.grey.shade800,
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                       underline: Container(height: 0),
//                       onChanged: (String? newValue) {
//                         if (newValue != null) {
//                           ref.read(selectedAreaProvider.notifier).state =
//                               newValue;
//                           ref.read(filteredPrefectureProvider.notifier).state =
//                               regionToPrefectures[newValue] ?? [];
//                           ref
//                               .read(eventProvider.notifier)
//                               .fetchEvents(area: newValue);
//                         }
//                       },
//                       items:
//                           regions.map<DropdownMenuItem<String>>((String value) {
//                         return DropdownMenuItem<String>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.location_city, color: Colors.orangeAccent),
//                     SizedBox(width: 8),
//                     DropdownButton<String?>(
//                       value: selectedPrefecture,
//                       hint: Text('都道府県を選択',
//                           style: TextStyle(color: Colors.white)),
//                       icon: Icon(Icons.arrow_drop_down, color: Colors.white),
//                       dropdownColor: Colors.grey.shade800,
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                       underline: Container(height: 0),
//                       onChanged: (String? newValue) {
//                         ref.read(selectedPrefectureProvider.notifier).state =
//                             newValue;
//                         ref
//                             .read(eventProvider.notifier)
//                             .fetchEvents(prefecture: newValue);
//                       },
//                       items: filteredPrefectures
//                           .map<DropdownMenuItem<String?>>((String value) {
//                         return DropdownMenuItem<String?>(
//                           value: value,
//                           child: Text(value),
//                         );
//                       }).toList(),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           Expanded(
//             child: events.isEmpty
//                 ? Center(
//                     child: Text(
//                       '該当するイベントがありません',
//                       style: TextStyle(fontSize: 18, color: Colors.white70),
//                     ),
//                   )
//                 : ListView.builder(
//                     itemCount: events.length,
//                     padding: EdgeInsets.symmetric(horizontal: 16),
//                     itemBuilder: (context, index) {
//                       final event = events[index];
//                       return Card(
//                         color: Colors.grey.shade900,
//                         margin: EdgeInsets.symmetric(vertical: 10),
//                         elevation: 3,
//                         shape: RoundedRectangleBorder(
//                           side:
//                               BorderSide(color: Colors.grey.shade800, width: 1),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: Text(
//                                   DateFormat('yyyy-MM-dd')
//                                       .format(event.eventDate),
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.orangeAccent,
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(height: 12),
//                               Row(
//                                 children: [
//                                   ClipOval(
//                                     child: Image.network(
//                                       event.images.isNotEmpty
//                                           ? event.images[0]
//                                           : 'https://via.placeholder.com/150',
//                                       width: 50,
//                                       height: 50,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   SizedBox(width: 16),
//                                   Expanded(
//                                     child: Text(
//                                       event.name,
//                                       style: TextStyle(
//                                         fontSize: 20,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.white,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 12),
//                               Text(
//                                 event.details,
//                                 style: TextStyle(
//                                     fontSize: 16, color: Colors.white70),
//                               ),
//                               SizedBox(height: 12),
//                               if (event.images.isNotEmpty)
//                                 Container(
//                                   height: 100,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: event.images.length,
//                                     itemBuilder: (context, imgIndex) {
//                                       return Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 8.0),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(15),
//                                           child: Image.network(
//                                             event.images[imgIndex],
//                                             width: 100,
//                                             height: 100,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               SizedBox(height: 12),
//                               // イベント詳細へ遷移するボタンを追加
//                               Align(
//                                 alignment: Alignment.centerRight,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => EventDetails(
//                                           event: event,
//                                           eventRepository: eventRepository,
//                                         ), // イベント詳細ページへ遷移
//                                       ),
//                                     );
//                                   },
//                                   style: ElevatedButton.styleFrom(
//                                     backgroundColor:
//                                         Colors.orangeAccent, // ボタンの背景色
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10),
//                                     ),
//                                   ),
//                                   child: Text(
//                                     '詳細を見る',
//                                     style: TextStyle(
//                                         color: Colors.black), // ボタンのテキスト色
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           )
//         ],
//       ),
//     );
//   }
// }
