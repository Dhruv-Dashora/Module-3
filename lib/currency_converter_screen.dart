// ignore_for_file: avoid_print, unused_local_variable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  State<CurrencyConverterScreen> createState() =>
      _CurrencyConverterScreenState();
}

class _CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  // Selected currencies
  String fromCurrency = "USD";
  String toCurrency = "EUR";

  // Entered amount
  double amount = 0.0;

  // Conversion rate (initially set to 1 for placeholder)
  double conversionRate = 1.0;
  String convertedAmount = ""; // To store the converted amount

  // Function to fetch conversion rate
  Future<void> fetchConversionRate() async {
    const apiKey =
        "6f131f8aed1d29fb8dd3d202"; // Replace with your ExchangeRate-API key
    final url = Uri.parse(
        "https://v6.exchangerate-api.com/v6/$apiKey/pair/$fromCurrency/$toCurrency");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final conversion = data["conversion_rate"];
      conversionRate = conversion;
      setState(() {}); // Update UI with new conversion rate
    } else {
      // Handle error (e.g., show error message)
      print("Error fetching conversion rate: ${response.statusCode}");
    }
  }

  // Function to perform conversion
  void convertCurrency() {
    if (amount > 0.0) {
      final convertedAmount = amount * conversionRate;
      setState(() {
        // Update UI with converted amount (replace placeholder text)
      });
    } else {
      // Handle invalid input (e.g., show error message)
      print("Please enter a valid amount.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Input Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 350.0,
                  height: 350.0,
                  child: DropdownButton<String>(
                    value: fromCurrency,
                    items: const [
                      DropdownMenuItem(
                        value: "USD",
                        child: Text("USD"),
                      ),
                      DropdownMenuItem(
                        value: "EUR",
                        child: Text("EUR"),
                      ),
                      DropdownMenuItem(
                        value: "INR",
                        child: Text("INR"),
                      ),
                      DropdownMenuItem(
                        value: "JPY",
                        child: Text("JPY"),
                      ),
                      DropdownMenuItem(
                        value: "CHF",
                        child: Text("CHF"),
                      ),
                      DropdownMenuItem(
                        value: "GBP",
                        child: Text("GBP"),
                      ),
                      DropdownMenuItem(
                        value: "AUD",
                        child: Text("AUD"),
                      ),
                      DropdownMenuItem(
                        value: "AED",
                        child: Text("AED"),
                      ),
                      DropdownMenuItem(
                        value: "SGD",
                        child: Text("SGD"),
                      ),
                      DropdownMenuItem(
                        value: "NOK",
                        child: Text("NOK"),
                      ),

                      // Add more currencies as needed
                    ],
                    onChanged: (value) => setState(() => fromCurrency = value!),
                  ),
                ),
                SizedBox(
                  width: 350.0,
                  height: 350.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "Enter amount",
                    ),
                    onChanged: (value) {
                      amount = double.tryParse(value) ?? 0.0;
                    },
                  ),
                ),
                SizedBox(
                  width: 350.0,
                  height: 350.0,
                  child: DropdownButton<String>(
                    value: toCurrency,
                    items: const [
                      DropdownMenuItem(
                        value: "EUR",
                        child: Text("EUR"),
                      ),
                      DropdownMenuItem(
                        value: "USD",
                        child: Text("USD"),
                      ),
                      DropdownMenuItem(
                        value: "INR",
                        child: Text("INR"),
                      ),
                      DropdownMenuItem(
                        value: "JPY",
                        child: Text("JPY"),
                      ),
                      DropdownMenuItem(
                        value: "CHF",
                        child: Text("CHF"),
                      ),
                      DropdownMenuItem(
                        value: "GBP",
                        child: Text("GBP"),
                      ),
                      DropdownMenuItem(
                        value: "AUD",
                        child: Text("AUD"),
                      ),
                      DropdownMenuItem(
                        value: "AED",
                        child: Text("AED"),
                      ),
                      DropdownMenuItem(
                        value: "SGD",
                        child: Text("SGD"),
                      ),
                      DropdownMenuItem(
                        value: "NOK",
                        child: Text("NOK"),
                      ),

                      // Add more currencies as needed
                    ],
                    onChanged: (value) => setState(() => toCurrency = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0, width: 25.0),
            ElevatedButton(
              onPressed: () async {
                await fetchConversionRate();
                convertCurrency();
              },
              child: const Text("Convert"),
            ),
            const SizedBox(height: 25.0, width: 25.0),
            // Output Section
            Text(
              "Converted amount: ${amount * conversionRate} $toCurrency", // Update with converted amount
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
