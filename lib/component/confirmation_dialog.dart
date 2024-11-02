// confirmation_dialog.dart
import 'package:flutter/material.dart';

class ConfirmationDialog {
  static Future<void> show(BuildContext context, String title, String content,
      VoidCallback onConfirm) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: Text('キャンセル'),
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // ダイアログを閉じる
                onConfirm(); // 確認ボタンが押されたら実行される処理
              },
            ),
          ],
        );
      },
    );
  }
}
