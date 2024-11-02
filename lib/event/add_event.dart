// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // FirebaseFirestoreをインポート
// import 'package:whisky_app/repositories/event_repository.dart';
// import '../constants/regions_and_prefectures.dart'; // 都道府県と地域をインポート
//
// class AddEvent extends StatefulWidget {
//   @override
//   _AddEventState createState() => _AddEventState();
// }
//
// class _AddEventState extends State<AddEvent> {
//   final _formKey = GlobalKey<FormState>();
//   final _eventNameController = TextEditingController();
//   final _eventDetailsController = TextEditingController();
//   final _eventUrlController = TextEditingController();
//   DateTime? _eventDate;
//   List<File> _eventImages = [];
//   final _picker = ImagePicker();
//   String? _selectedPrefecture;
//   String? _selectedRegion;
//   List<String> _filteredPrefectures = []; // フィルタリングされた都道府県
//
//   // EventRepositoryのインスタンス化
//   final EventRepository _eventRepository =
//       EventRepository(FirebaseFirestore.instance, FirebaseStorage.instance);
//
//   // フォームの送信処理
//   Future<void> _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         await _eventRepository.addEvent(
//           eventName: _eventNameController.text,
//           eventDetails: _eventDetailsController.text,
//           eventUrl: _eventUrlController.text.isNotEmpty
//               ? _eventUrlController.text
//               : null, // イベントURL（任意）
//           eventDate: _eventDate!,
//           eventImages: _eventImages,
//           eventPrefecture: _selectedPrefecture!,
//           eventRegion: _selectedRegion!,
//         );
//
//         // 成功メッセージを表示
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('イベントが正常に登録されました')),
//         );
//
//         // フォームのリセット
//         _resetForm();
//       } catch (e) {
//         // エラーメッセージを表示
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('イベントの登録に失敗しました: $e')),
//         );
//       }
//     }
//   }
//
//   // フォームのリセット処理
//   void _resetForm() {
//     _eventNameController.clear();
//     _eventDetailsController.clear();
//     _eventUrlController.clear();
//     setState(() {
//       _eventDate = null;
//       _eventImages = [];
//       _selectedPrefecture = null;
//       _selectedRegion = null;
//       _filteredPrefectures = [];
//     });
//   }
//
//   // カレンダーからイベント日を選択
//   Future<void> _selectEventDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _eventDate ?? DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _eventDate) {
//       setState(() {
//         _eventDate = picked;
//       });
//     }
//   }
//
//   // 画像をギャラリーから選択する
//   Future<void> _pickImages() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         _eventImages =
//             pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
//       });
//     }
//   }
//
//   // 地域が選択されたときに対応する都道府県をフィルタリング
//   void _onRegionChanged(String? newRegion) {
//     if (newRegion != null) {
//       setState(() {
//         _selectedRegion = newRegion;
//         _filteredPrefectures = regionToPrefectures[newRegion] ?? [];
//         _selectedPrefecture = null; // 地域が変わったら都道府県の選択をリセット
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('イベントを追加'),
//         backgroundColor: Colors.black,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               // イベント名
//               TextFormField(
//                 style: const TextStyle(color: Colors.white),
//                 controller: _eventNameController,
//                 decoration: InputDecoration(
//                   labelText: 'イベント名',
//                   hintText: 'イベントの名前を入力してください',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'イベント名は必須です';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//
//               // イベント詳細
//               TextFormField(
//                 style: const TextStyle(color: Colors.white),
//                 controller: _eventDetailsController,
//                 decoration: InputDecoration(
//                   labelText: 'イベント詳細',
//                   hintText: 'イベントの詳細を入力してください',
//                 ),
//                 maxLines: 5,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'イベント詳細は必須です';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//
//               // イベントURL（任意）
//               TextFormField(
//                 style: const TextStyle(color: Colors.white),
//                 controller: _eventUrlController,
//                 decoration: InputDecoration(
//                   labelText: 'イベントURL (任意)',
//                   hintText: 'イベントに関連するURLを追加してください',
//                 ),
//               ),
//               SizedBox(height: 16.0),
//
//               // イベント日入力エリア
//               ListTile(
//                 title: Text(_eventDate == null
//                     ? 'イベント日を選択'
//                     : 'イベント日: ${DateFormat('yyyy/MM/dd').format(_eventDate!)}'),
//                 trailing: Icon(Icons.calendar_today),
//                 onTap: _selectEventDate,
//               ),
//               SizedBox(height: 16.0),
//
//               // イベント写真追加
//               ElevatedButton(
//                 onPressed: _pickImages,
//                 child: Text('写真を追加'),
//               ),
//               SizedBox(height: 16.0),
//
//               // イベント開催地域
//               DropdownButtonFormField<String>(
//                 value: _selectedRegion,
//                 decoration: InputDecoration(labelText: 'イベント開催地域'),
//                 items: regions.map((String region) {
//                   return DropdownMenuItem<String>(
//                     value: region,
//                     child: Text(region),
//                   );
//                 }).toList(),
//                 onChanged: _onRegionChanged, // 地域が変更されたときに都道府県をフィルタリング
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '開催地域を選択してください';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//
//               // イベント開催県名（選択された地域に基づいてフィルタリング）
//               DropdownButtonFormField<String>(
//                 value: _selectedPrefecture,
//                 decoration: InputDecoration(labelText: 'イベント開催県名'),
//                 items: _filteredPrefectures.map((String prefecture) {
//                   return DropdownMenuItem<String>(
//                     value: prefecture,
//                     child: Text(prefecture),
//                   );
//                 }).toList(),
//                 onChanged: (newValue) {
//                   setState(() {
//                     _selectedPrefecture = newValue;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return '開催県を選択してください';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 16.0),
//
//               // フォームの送信ボタン
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('イベントを追加'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
