// ignore_for_file: unused_import

import 'package:calculator/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:calculator/Firestore.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> _calculationHistory = [];
  // ignore: unused_field
  final HistoryService _historyService = HistoryService(); // Create instance

  @override
  void initState() {
    super.initState();
    _fetchCalculationHistory();
  }

  // HistoryScreen.dart
  Future<void> _fetchCalculationHistory() async {
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final history = await HistoryService().fetchCalculationHistory(uid);
    setState(() {
      _calculationHistory = history;
    });
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
