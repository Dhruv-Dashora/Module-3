// ignore_for_file: file_names, avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:calculator/main.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveCalculationHistory(String equation, String result) async {
    try {
      final String uid = FirebaseAuth.instance.currentUser!.uid;
      final CollectionReference historyRef =
          _firestore.collection('users').doc(uid).collection('history');

      final Map<String, String> historyData = {
        'equation': equation,
        'result': result,
        // 'timestamp': DateTime.now().toIso8601String(),
      };

      await historyRef.add(historyData);
    } catch (error) {
      print("Error saving calculation history: $error");
      // Handle the error appropriately (e.g., show a user-friendly message)
    }
  }

  Future<List<Map<String, String>>> fetchCalculationHistory(String uid) async {
    try {
      final CollectionReference historyRef =
          _firestore.collection('users').doc(uid).collection('history');
      final querySnapshot = await historyRef.limit(10).get();
      final historyData = querySnapshot.docs
          .map((doc) => doc.data() as Map<String, String>)
          .toList();
      return historyData;
    } catch (error) {
      print("Error fetching calculation history: $error");
      return []; // Handle error and return empty list
    }
  }
}

// JSON data structure for database
// {
//  "users": {},
//   "uid": {},
//   "history": {"equation": {},
//   "result": {}},
// }
//
// {
//   "uid": "user123",  // User's unique identifier
//   "history": [
//     {
//       "equation": "2 + 3",
//       "result": "5",
//     },
//     {
//       "equation": "10 / 5",
//       "result": "2",
//     }
//   ]
// }
