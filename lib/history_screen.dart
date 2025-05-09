import 'package:calculator/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<Map<String, String>> _calculationHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCalculationHistory();
  }

  Future<void> _fetchCalculationHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      final doc = await userDocRef.get();
      final data = doc.data();

      if (data != null && data['calcHistory'] != null) {
        final List<dynamic> rawHistory = data['calcHistory'];

        final history = rawHistory.map((item) {
          return {
            'equation': item['equation']?.toString() ?? '',
            'result': item['result']?.toString() ?? '',
          };
        }).toList();

        setState(() {
          _calculationHistory = List<Map<String, String>>.from(history);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching calculation history: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculation History'),
        backgroundColor: operatorColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _calculationHistory.isEmpty
              ? const Center(child: Text("No history found"))
              : ListView.builder(
                  itemCount: _calculationHistory.length,
                  itemBuilder: (context, index) {
                    final history = _calculationHistory[index];
                    return ListTile(
                      title: Text(history['equation'] ?? ''),
                      subtitle: Text("= ${history['result'] ?? ''}"),
                    );
                  },
                ),
    );
  }
}
