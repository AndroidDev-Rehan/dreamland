import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

DateFormat dateFormat = DateFormat("dd-MM-yyyy");

Future<Map<String, dynamic>> getMyUserMap(String uid) async {
  DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
  Map<String, dynamic> myUserMap = documentSnapshot.data()!;
  return myUserMap;
}

Future<String?> uploadAndGetFileDownloadUrl(Uint8List imageBytes) async {
  TaskSnapshot taskSnapshot = await FirebaseStorage.instance
      .ref(DateTime.now().millisecondsSinceEpoch.toString())
      .putData(imageBytes);
  return (await taskSnapshot.ref.getDownloadURL());
}
