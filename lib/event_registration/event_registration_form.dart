import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants/regions_and_prefectures.dart';
import '../model/event_model.dart';
import '../repositories/event_search_repository.dart';
import 'save_button.dart';

class EventRegistrationForm extends StatefulWidget {
  final bool isEditMode;
  final Event? event;

  EventRegistrationForm({this.isEditMode = false, this.event});
  @override
  _EventRegistrationFormState createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String _eventId = Uuid().v4();
  String? _selectedPrefecture;
  File? _coverImage;
  List<dynamic> _selectedImages = []; // FileとURLの両方をサポート
  List<String> _existingImageUrls = []; // 既存のURLを保持
  List<File> _newImageFiles = []; // 新規追加されたFileを保持
  List<String> _deletedImageUrls = []; // 削除対象の既存画像URL
  String? _coverImageUrl; // カバー画像URLを保持
  @override
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.event != null) {
      final event = widget.event!; // widget.eventとしてアクセス
      // 既存の画像URLを保持
      if (event.otherImageUrls != null && event.otherImageUrls!.isNotEmpty) {
        _existingImageUrls = List<String>.from(event.otherImageUrls!);
      }

      _eventId = event.id;
      _nameController.text = event.name;
      _detailsController.text = event.details;
      _placeController.text = event.place;
      _urlController.text = event.eventUrl ?? '';
      _selectedDate = event.eventDate;
      _eventDateController.text =
          DateFormat('yyyy/MM/dd').format(event.eventDate);
      _selectedStartTime = TimeOfDay.fromDateTime(event.startTime);
      _selectedEndTime = TimeOfDay.fromDateTime(event.endTime);
      _selectedPrefecture = event.prefecture;

      // カバー画像URLを保持しておく
      _coverImageUrl =
          event.coverImageUrl.isNotEmpty ? event.coverImageUrl : null;

      // その他の画像の初期化 (FileにせずURLのまま扱う)
      if (event.otherImageUrls != null && event.otherImageUrls!.isNotEmpty) {
        _selectedImages = event.otherImageUrls!; // URLをそのまま保持
      }
    }
  }

  // 都道府県選択
  void _showPrefectureDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.grey[900],
          child: ListView.builder(
            itemCount: prefectures.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(prefectures[index],
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  setState(() {
                    _selectedPrefecture = prefectures[index];
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

  // カバー画像選択
  Future<void> _pickCoverImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  // 画像を選択するメソッド(新規)
  Future<void> _pickOtherImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        for (var xFile in pickedFiles) {
          _newImageFiles.add(File(xFile.path));
        }
        print('Updated _newImageFiles: $_newImageFiles');
      });
    }
  }

  // 時刻選択
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _selectedStartTime = picked;
        } else {
          _selectedEndTime = picked;
        }
      });
    }
  }

  // 日付選択
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _eventDateController.text = DateFormat('yyyy/MM/dd').format(picked);
      });
    }
  }

  Widget _buildImagePreview() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: [
        // 既存のURL画像
        ..._existingImageUrls.map((imageUrl) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _existingImageUrls.remove(imageUrl);
                      _deletedImageUrls.add(imageUrl); // 削除リストに追加
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.red, size: 20),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
        // 新規追加のFile画像
        ..._newImageFiles.map((imageFile) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _newImageFiles.remove(imageFile);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.red, size: 20),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  Future<String> uploadImage(File imageFile, String path) async {
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(imageFile);
    return await ref.getDownloadURL(); // 新しい有効なURLを取得
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditMode ? 'イベント更新' : 'イベント登録', // 編集モードかどうかでタイトルを切り替え
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'イベント名',
                  labelStyle: TextStyle(color: Colors.orangeAccent),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'イベント名を入力してください' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _detailsController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'イベント詳細',
                  labelStyle: TextStyle(color: Colors.orangeAccent),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                maxLines: 3,
                validator: (value) =>
                    value == null || value.isEmpty ? 'イベント詳細を入力してください' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _placeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: '場所',
                  labelStyle: TextStyle(color: Colors.orangeAccent),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? '場所を入力してください' : null,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _urlController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'イベントURL',
                  labelStyle: TextStyle(color: Colors.orangeAccent),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _eventDateController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'イベント日付',
                  labelStyle: TextStyle(color: Colors.orangeAccent),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  _selectedStartTime == null
                      ? '開始時間を選択'
                      : '開始時間: ${_selectedStartTime!.format(context)}',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.access_time, color: Colors.orangeAccent),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text(
                  _selectedEndTime == null
                      ? '終了時間を選択'
                      : '終了時間: ${_selectedEndTime!.format(context)}',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.access_time, color: Colors.orangeAccent),
                onTap: () => _selectTime(context, false),
              ),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  _selectedPrefecture ?? '都道府県を選択してください',
                  style: TextStyle(color: Colors.white),
                ),
                trailing:
                    Icon(Icons.arrow_drop_down, color: Colors.orangeAccent),
                onTap: () => _showPrefectureDropdown(context),
              ),
              const SizedBox(height: 16.0),
              Text('表紙画像', style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickCoverImage,
                icon: Icon(Icons.add_a_photo, color: Colors.white),
                label: Text('画像を選択', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              _coverImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _coverImage!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    )
                  : (widget.event != null &&
                          widget.event!.coverImageUrl.isNotEmpty)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            widget.event!.coverImageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Text(
                          "選択された表紙画像はありません",
                          style: TextStyle(color: Colors.grey),
                        ),
              const SizedBox(height: 16.0),
              Text('その他の画像',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickOtherImages,
                icon: Icon(Icons.add_photo_alternate, color: Colors.white),
                label: Text('画像を選択', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 10),
              _buildImagePreview(),
              const SizedBox(height: 32.0),
              SaveButton(
                formKey: _formKey,
                onSave: () async {
                  final repository = EventSearchRepository();
                  // 既存のカバー画像URLがあればそのまま使用、新規画像があれば上書き
                  String coverImageUrl = _coverImageUrl ?? '';

                  // 既存と新規の画像を含むリストを初期化
                  List<String> otherImageUrls = List.from(_existingImageUrls);

                  // カバー画像を選択している場合、新しい画像をアップロードし、URLを更新
                  if (_coverImage != null) {
                    coverImageUrl =
                        await repository.uploadImageToStorage(_coverImage!);
                  }

                  // デバッグ: 初期状態の確認
                  print('Initial otherImageUrls (pre-upload): $otherImageUrls');
                  print('Selected Images for upload: $_newImageFiles');

                  // その他の画像を処理
                  if (_newImageFiles.isNotEmpty) {
                    for (var image in _newImageFiles) {
                      String url = await repository.uploadImageToStorage(image);
                      otherImageUrls.add(url);
                      print('Uploaded Image URL: $url');
                    }
                  }

                  // 削除対象画像のURLをStorageから削除
                  for (var imageUrl in _deletedImageUrls) {
                    await repository.deleteImageFromStorage(imageUrl);
                  }

                  // デバッグ: アップロード後のotherImageUrls確認
                  print(
                      'Final otherImageUrls before saving to DB: $otherImageUrls');

                  // Eventモデルのインスタンスを作成
                  final event = Event(
                    id: _eventId,
                    name: _nameController.text,
                    eventDate: _selectedDate!,
                    startTime: _selectedStartTime != null
                        ? DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedStartTime!.hour,
                            _selectedStartTime!.minute)
                        : DateTime.now(),
                    endTime: _selectedEndTime != null
                        ? DateTime(
                            _selectedDate!.year,
                            _selectedDate!.month,
                            _selectedDate!.day,
                            _selectedEndTime!.hour,
                            _selectedEndTime!.minute)
                        : DateTime.now(),
                    place: _placeController.text,
                    coverImageUrl: coverImageUrl, // 修正: カバー画像URLを保持または更新
                    otherImageUrls: otherImageUrls,
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    isDeleted: false,
                    address: _placeController.text,
                    details: _detailsController.text,
                    prefecture: _selectedPrefecture ?? '',
                    organizer: '主催者名',
                    eventType: 1,
                    eventUrl: _urlController.text.isNotEmpty
                        ? _urlController.text
                        : null,
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  );

                  print('Event object before saving: ${event.toJson()}');

                  // 保存処理
                  if (widget.isEditMode) {
                    await repository.updateEvent(event);
                  } else {
                    await repository.saveEvent(event.toJson());
                  }

                  print('Event saved successfully.');
                },
                buttonText: widget.isEditMode ? '更新' : '登録',
              )
            ],
          ),
        ),
      ),
    );
  }
}
