import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../constants/regions_and_prefectures.dart';
import '../model/event_model.dart';
import '../repositories/event_search_repository.dart';
import 'event_form_methods.dart';
import 'save_button.dart';

class EventRegistrationForm extends StatefulWidget {
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
  List<File> _selectedImages = [];

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

  // その他の画像選択
  Future<void> _pickOtherImages() async {
    final pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages
            .addAll(pickedFiles.map((file) => File(file.path)).toList());
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

  // その他画像プレビューと削除機能
  Widget _buildImagePreview() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: _selectedImages.map((image) {
        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                image,
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
                    _selectedImages.remove(image);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('イベント登録', style: TextStyle(color: Colors.white)),
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
                  : Text("選択された表紙画像はありません",
                      style: TextStyle(color: Colors.grey)),
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
                  final event = Event(
                    id: _eventId,
                    name: _nameController.text,
                    eventDate: _selectedDate!,
                    startTime: DateTime.now(),
                    endTime: DateTime.now(),
                    place: _placeController.text,
                    coverImageUrl: '',
                    otherImageUrls: [],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                    isDeleted: false,
                    address: _detailsController.text,
                    prefecture: _selectedPrefecture ?? '',
                    organizer: '主催者名',
                    eventType: 1,
                    eventUrl: _urlController.text,
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  );
                  await saveEventToFirestore(
                    context,
                    event,
                    _selectedImages,
                    _coverImage,
                    EventSearchRepository(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
