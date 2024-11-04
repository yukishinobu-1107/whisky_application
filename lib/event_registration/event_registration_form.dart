import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart'; // 圧縮用パッケージを追加
import '../component/show_loading_dialog.dart';
import '../constants/regions_and_prefectures.dart';
import '../repositories/event_search_repository.dart';

class EventRegistrationForm extends StatefulWidget {
  @override
  _EventRegistrationFormState createState() => _EventRegistrationFormState();
}

class _EventRegistrationFormState extends State<EventRegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String _eventId = '';
  String? _selectedPrefecture;
  File? _coverImage;
  List<File> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();
  final EventSearchRepository _eventSearchRepository = EventSearchRepository();

  @override
  void initState() {
    super.initState();
    _eventId = Uuid().v4();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _eventDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedStartTime) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedEndTime) {
      setState(() {
        _selectedEndTime = picked;
      });
    }
  }

  void _showPrefectureDropdown(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          color: Colors.black,
          child: ListView.builder(
            itemCount: prefectures.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  prefectures[index],
                  style: const TextStyle(color: Colors.white),
                ),
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

  Future<void> _pickCoverImage() async {
    final XFile? pickedFile =
    await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickOtherImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _selectedImages
            .addAll(pickedFiles.map((file) => File(file.path)).toList());
      });
    }
  }

  Future<File?> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      quality: 70,
    );
    if (result == null) return null;
    return File(file.path)..writeAsBytesSync(result);
  }

  Future<String> _uploadImage(File imageFile, String path) async {
    try {
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('画像のアップロードに失敗しました: $e');
      throw e;
    }
  }

  Future<List<String>> uploadImagesWithLimit(List<File> images, int limit) async {
    List<String> urls = [];
    for (int i = 0; i < images.length; i += limit) {
      final batch = images.skip(i).take(limit).map((file) async {
        final compressedFile = await compressImage(file);
        return await _uploadImage(compressedFile ?? file, 'event_images/$_eventId/other_images/${Uuid().v4()}.jpg');
      }).toList();
      final batchResults = await Future.wait(batch);
      urls.addAll(batchResults);
    }
    return urls;
  }

  Future<void> _saveEventToFirestore() async {
    // 現在のユーザーのuidを取得
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    // UIDがnullの場合の処理
    if (uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ユーザーが認証されていません')),
      );
      return;
    }

    if (_coverImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('表紙画像を選択してください')),
      );
      return;
    }

    if (_selectedStartTime == null || _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('開始時間と終了時間を選択してください')),
      );
      return;
    }

    final startDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedStartTime!.hour,
      _selectedStartTime!.minute,
    );
    final endDateTime = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedEndTime!.hour,
      _selectedEndTime!.minute,
    );

    showLoadingDialog(context);

    try {
      final compressedCoverImage = await compressImage(_coverImage!);
      final coverImageUrl = await _uploadImage(
        compressedCoverImage ?? _coverImage!,
        'event_images/$_eventId/cover_image.jpg',
      );

      final otherImageUrls = await uploadImagesWithLimit(_selectedImages, 3);

      final eventData = {
        'id': _eventId,
        'name': _nameController.text,
        'eventDate': _selectedDate,
        'startTime': Timestamp.fromDate(startDateTime),
        'endTime': Timestamp.fromDate(endDateTime),
        'place': _place.text,
        'coverImageUrl': coverImageUrl,
        'otherImageUrls': otherImageUrls,
        'address': _detailsController.text,
        'prefecture': _selectedPrefecture,
        'organizer': '主催者名',
        'eventType': 1,
        'eventUrl': _urlController.text,
        'createdAt': DateTime.now(),
        'updatedAt': DateTime.now(),
        'isDeleted': false,
        'uid': uid, // 登録者のuidを追加
      };

      await _eventSearchRepository.saveEvent(eventData);
      Navigator.of(context).pop(); // ローディング画面を閉じる
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('イベントが正常に登録されました')),
      );
      // event_search.dart画面に戻る
      Navigator.of(context).pushReplacementNamed('/event_search');
    } catch (e) {
      Navigator.of(context).pop(); // ローディング画面を閉じる
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('イベントの登録に失敗しました: $e')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: const Text('イベント登録',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white)),
      backgroundColor: Colors.black,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.black,
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'イベント名*',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  hintText: 'イベント名を入力してください',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'イベント詳細*',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  hintText: 'イベントの住所や重要事項を記載してください',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: null,
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _place,
                decoration: const InputDecoration(
                  labelText: '場所*',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  hintText: 'イベント開催場所を記載してください',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: null,
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'イベントURL',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  hintText: 'イベントのURLを入力してください',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _eventDateController,
                decoration: const InputDecoration(
                  labelText: 'イベント日付*',
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                  hintText: 'イベントの日付を選択してください',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onTap: () {
                  _selectDate(context);
                },
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  _selectedStartTime == null
                      ? '開始時間を選択*'
                      : '開始時間: ${_selectedStartTime!.format(context)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  _selectStartTime(context);
                },
                trailing: const Icon(Icons.access_time, color: Colors.white),
              ),
              const Divider(color: Colors.grey),
              ListTile(
                title: Text(
                  _selectedEndTime == null
                      ? '終了時間を選択*'
                      : '終了時間: ${_selectedEndTime!.format(context)}',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  _selectEndTime(context);
                },
                trailing: const Icon(Icons.access_time, color: Colors.white),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              ListTile(
                title: Text(
                  _selectedPrefecture ?? '都道府県を選択してください*',
                  style: const TextStyle(color: Colors.grey),
                ),
                onTap: () {
                  _showPrefectureDropdown(context);
                },
                trailing:
                const Icon(Icons.arrow_drop_down, color: Colors.white),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              const Text(
                'イベント表紙画像を選択*',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickCoverImage,
                icon: const Icon(Icons.add_a_photo, color: Colors.white),
                label: const Text(
                  '画像を選択',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _coverImage != null
                  ? Stack(
                children: [
                  Image.file(_coverImage!,
                      width: 100, height: 100, fit: BoxFit.cover),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _coverImage = null;
                        });
                      },
                    ),
                  ),
                ],
              )
                  : const Text(
                '選択された表紙画像はありません',
                style: TextStyle(color: Colors.grey),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 16.0),
              const Text(
                'その他の画像を選択',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _pickOtherImages,
                icon:
                const Icon(Icons.add_photo_alternate, color: Colors.white),
                label: const Text(
                  '画像を選択',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 10),
              _selectedImages.isNotEmpty
                  ? Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _selectedImages.map((image) {
                  return Stack(
                    children: [
                      Image.file(image,
                          width: 100, height: 100, fit: BoxFit.cover),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedImages.remove(image);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              )
                  : const Text(
                '選択された画像はありません',
                style: TextStyle(color: Colors.grey),
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveEventToFirestore();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 12.0),
                  minimumSize: Size(150, 40),
                  elevation: 5,
                ),
                child: const Text(
                  '登録',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}