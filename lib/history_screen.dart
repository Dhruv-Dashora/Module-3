// ignore_for_file: unused_import

import 'package:calculator/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> _calculationHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchCalculationHistory();
  }

  Future<void> _fetchCalculationHistory() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userDocRef = firestore
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final docSnapshot = await userDocRef.get();
    if (docSnapshot.exists) {
      final historyData = docSnapshot.data()!['calculationHistory'];
      if (historyData != null) {
        setState(() {
          _calculationHistory = List<Map<String, String>>.from(historyData);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        backgroundColor: operatorColor,
      ),
      body: ListView.builder(
        itemCount: _calculationHistory.length,
        itemBuilder: (context, index) {
          final historyItem = _calculationHistory[index];
          return ListTile(
            title: Text(historyItem['equation']!),
            subtitle: Text(historyItem['result']!),
          );
        },
      ),
    );
  }
}
