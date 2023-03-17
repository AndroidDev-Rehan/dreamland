
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Map<String, dynamic>> getMyUserMap(String uid) async{
DocumentSnapshot<Map<String,dynamic>> documentSnapshot = await  FirebaseFirestore.instance.collection('users').doc(uid).get();
Map<String,dynamic> myUserMap = documentSnapshot.data()!;
return myUserMap;
}