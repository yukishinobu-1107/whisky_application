import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key});

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

// import 'package:flutter/material.dart';
//
// import 'add_image.dart';
//
// class DialogWidget extends StatelessWidget {
//   const DialogWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//
//
//     return SimpleDialog(
//       backgroundColor: Colors.blueAccent,
//       title: Text("Title"),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.all(Radius.circular(20))),
//       children: <Widget>[
//         SimpleDialogOption(
//           onPressed: () {
//             AddImage();
//             Navigator.pop(context);
//             showSimpleSnackBar(context, 'This is First Item.');
//           },
//           child: Text("・First Item"),
//         ),
//         SimpleDialogOption(
//           onPressed: () {
//             AddImage();
//             Navigator.pop(context);
//             showSimpleSnackBar(context, 'This is Second Item.');
//           },
//           child: Text("・Second Item"),
//         ),
//       ],
//     );
//   }
// }
//
// void showSimpleSnackBar(BuildContext context, String message) {
//   final snackBar = SnackBar(
//     content: Row(children: <Widget>[
//       Icon(Icons.check),
//       Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 8.0),
//         child: Text(message),
//       )
//     ]),
//   );
//   //Scaffold.of(context).showSnackBar(snackBar);
// }
