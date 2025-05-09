import 'package:calculator/colors.dart';
import 'package:calculator/currency_converter_screen.dart';
import 'package:calculator/firebase_options.dart';
import 'package:calculator/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class CalculatorApp extends StatefulWidget {
  const CalculatorApp({super.key});

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  //variables
  double firstNum = 0.0;
  double secondNum = 0.0;
  var input = "";
  var output = "";
  var operation = "";
  var hideInput = false;
  var outputSize = 34.0;
  // Added variable to store calculation history (optional)
  final List<Map<String, String>> _calculationHistory = [];
  void goToCurrencyConverter() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => const CurrencyConverterScreen()));
  }

  void _saveCalculationHistory() {
    if (input.isNotEmpty) {
      saveCalculationHistory(
          _calculationHistory); // Assuming this saves to Firestore
      input = "";
      output = "";
      setState(() {});
    }
  }

  void onButtonClick(value) {
    if (value == "AC") {
      input = "";
      output = "";
    } else if (value == "<") {
      if (input.isNotEmpty) {
        input = input.substring(0, input.length - 1);
      }
    } else if (value == "=") {
      if (input.isNotEmpty) {
        var userInput = input;
        userInput = userInput.replaceAll("X", "*"); // Replace "X" with "*"
        Parser p = Parser(); // Assuming this is for math expression parsing
        String equation = userInput;
        Expression expression = p.parse(userInput);
        ContextModel cm = ContextModel();
        var finalValue = expression.evaluate(EvaluationType.REAL, cm);
        output = finalValue.toString();
        if (output.endsWith(".0")) {
          output =
              output.substring(0, output.length - 2); // Remove trailing ".0"
        }
        String result = output;
        _calculationHistory.add({'equation': equation, 'result': result});
        input = output;
        hideInput = true;
        outputSize = 52;
      }
    } else {
      // Handle other button values
      input += value; // Append user input
      hideInput = false;
      outputSize = 34;
    }
    setState(() {});

    // Get current user (moved outside button press logic)
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId =
          user.uid; // Use this userId in your saveCalculationHistory functions
    }
  }

  Future<void> saveCalculationHistory(List<Map<String, String>> history) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    if (history.length > 10) {
      history.removeRange(0, history.length - 10); // Keep last 10
    }

    await userDocRef.set({
      'calcHistory': history,
    }, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton(
        onPressed: goToCurrencyConverter,
        child: const Icon(Icons.attach_money),
      ),
      body: Column(
        children: [
          //input output area
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hideInput ? "" : input,
                  style: const TextStyle(
                    fontSize: 48,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 0.1 * screenHeight,
                ),
                Text(
                  output,
                  style: TextStyle(
                    fontSize: outputSize,
                    color: Colors.lightGreenAccent,
                  ),
                ),
                SizedBox(
                  height: 0.1 * screenHeight,
                ),
              ],
            ),
          ),

          //buttons area
          Row(
            children: [
              button(
                  text: "Save History", buttonBgColor: Colors.lightGreenAccent),
            ],
          ),
          Row(
            children: [
              button(text: "AC", buttonBgColor: operatorColor),
              button(text: "<", buttonBgColor: operatorColor),
              button(text: "()", buttonBgColor: operatorColor),
              button(text: "/", buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "7"),
              button(text: "8"),
              button(text: "9"),
              button(text: "X", buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "4"),
              button(text: "5"),
              button(text: "6"),
              button(text: "-", buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "1"),
              button(text: "2"),
              button(text: "3"),
              button(text: "+", buttonBgColor: operatorColor),
            ],
          ),
          Row(
            children: [
              button(text: "%", buttonBgColor: operatorColor),
              button(text: "0"),
              button(text: ".", buttonBgColor: operatorColor),
              button(text: "=", buttonBgColor: operatorColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget button({text, tColor = Colors.white, buttonBgColor = buttonColor}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              backgroundColor: buttonBgColor),
          onPressed: () {
            if (text == "Save History") {
              _saveCalculationHistory();
              // Navigate to History Screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryScreen()),
              );
            } else {
              onButtonClick(text);
            }
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              color: tColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
