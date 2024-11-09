import 'package:flutter/material.dart';

class SaveButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Future<void> Function() onSave; // 非同期の保存処理

  const SaveButton({required this.formKey, required this.onSave});

  @override
  _SaveButtonState createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  bool _isSaving = false; // 保存中の状態管理

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isSaving
          ? null // 保存中はボタンを無効化
          : () async {
              if (widget.formKey.currentState!.validate()) {
                setState(() {
                  _isSaving = true;
                });
                try {
                  await widget.onSave();
                } finally {
                  setState(() {
                    _isSaving = false;
                  });
                }
              }
            },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orangeAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        minimumSize: const Size(150, 40),
        elevation: 5,
      ),
      child: _isSaving
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : const Text(
              '登録',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
    );
  }
}
