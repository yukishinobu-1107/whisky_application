// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// Future<User?> signInWithGoogle() async {
//   final GoogleSignIn googleSignIn = GoogleSignIn();
//   final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//
//   if (googleUser != null) {
//     final GoogleSignInAuthentication googleAuth =
//         await googleUser.authentication;
//     final credential = GoogleAuthProvider.credential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//
//     // Firebaseでサインイン
//     final userCredential =
//         await FirebaseAuth.instance.signInWithCredential(credential);
//     return userCredential.user;
//   }
//   return null;
// }
//
// Future<User?> signUpWithEmail(String email, String password) async {
//   try {
//     final userCredential =
//         await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//     return userCredential.user;
//   } on FirebaseAuthException catch (e) {
//     print('Failed with error code: ${e.code}');
//     return null;
//   }
// }
//
// Future<void> saveUserProfile(
//     String uid, String nickname, String imageUrl) async {
//   await FirebaseFirestore.instance.collection('users').doc(uid).set({
//     'nickname': nickname,
//     'profileImageUrl': imageUrl,
//     'createdAt': FieldValue.serverTimestamp(),
//   });
// }
//
// Future<void> handleGoogleSignIn() async {
//   User? user = await signInWithGoogle();
//
//   if (user != null) {
//     String nickname = 'ユーザー名を入力'; // 任意の入力を求める
//     String imageUrl = user.photoURL ?? 'デフォルトの画像URL';
//
//     await saveUserProfile(user.uid, nickname, imageUrl);
//   }
// }
//
// Future<DocumentSnapshot> getUserProfile(String uid) async {
//   return await FirebaseFirestore.instance.collection('users').doc(uid).get();
// }
//
// Future<void> displayUserProfile() async {
//   User? user = FirebaseAuth.instance.currentUser;
//
//   if (user != null) {
//     DocumentSnapshot userProfile = await getUserProfile(user.uid);
//     String nickname = userProfile['nickname'];
//     String profileImageUrl = userProfile['profileImageUrl'];
//
//     // 画面に表示する処理
//     print('Nickname: $nickname');
//     print('Profile Image: $profileImageUrl');
//   }
// }
//
// Future<void> createEvent(String eventName) async {
//   User? user = FirebaseAuth.instance.currentUser;
//
//   if (user != null) {
//     // Firestoreからユーザーのプロフィールを取得
//     DocumentSnapshot userProfile = await getUserProfile(user.uid);
//     String nickname = userProfile['nickname'];
//     String profileImageUrl = userProfile['profileImageUrl'];
//
//     // Firestoreにイベントを保存
//     await FirebaseFirestore.instance.collection('events').add({
//       'eventName': eventName,
//       'userNickname': nickname,
//       'userProfileImageUrl': profileImageUrl,
//       'createdAt': FieldValue.serverTimestamp(),
//     });
//   }
// }
//
// Future<void> joinEvent(String eventId) async {
//   User? user = FirebaseAuth.instance.currentUser;
//
//   if (user != null) {
//     // 参加するユーザーのニックネームを取得
//     DocumentSnapshot userProfile = await getUserProfile(user.uid);
//     String nickname = userProfile['nickname'];
//
//     // イベントに参加者を追加
//     await FirebaseFirestore.instance.collection('events').doc(eventId).update({
//       'participants': FieldValue.arrayUnion([nickname]), // 参加者リストに追加
//     });
//   }
// }
