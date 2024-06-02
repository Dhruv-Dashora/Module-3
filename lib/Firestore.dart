// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  static Future<void> saveUser(String name, String email, String uid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
        .collection('users')
        .doc(uid)
        .set({'email': email, 'name': name});
  }
}
