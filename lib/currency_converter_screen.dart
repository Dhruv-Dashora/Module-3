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
    const apiKey = "**********"; // Replace with your ExchangeRate-API key
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Currency Converter',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 0.05 * screenHeight),

            // Dropdown + TextField
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text("From"),
                      DropdownButton<String>(
                        value: fromCurrency,
                        isExpanded: true,
                        items: _buildCurrencyDropdownItems(),
                        onChanged: (value) =>
                            setState(() => fromCurrency = value!),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 0.05 * screenWidth),
                Expanded(
                  child: Column(
                    children: [
                      const Text("Amount"),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(hintText: "Enter amount"),
                        onChanged: (value) {
                          amount = double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 0.05 * screenWidth),
                Expanded(
                  child: Column(
                    children: [
                      const Text("To"),
                      DropdownButton<String>(
                        value: toCurrency,
                        isExpanded: true,
                        items: _buildCurrencyDropdownItems(),
                        onChanged: (value) =>
                            setState(() => toCurrency = value!),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 0.1 * screenHeight),

            // Convert Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                onPressed: () async {
                  await fetchConversionRate();
                  convertCurrency();
                },
                child: const Text("Convert"),
              ),
            ),

            SizedBox(height: 0.05 * screenHeight),

            // Result
            Center(
              child: Text(
                convertedAmount.isNotEmpty
                    ? "Converted amount: $convertedAmount $toCurrency"
                    : "Converted amount: ${amount * conversionRate} $toCurrency",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> _buildCurrencyDropdownItems() {
    const currencies = [
      "USD",
      "EUR",
      "INR",
      "JPY",
      "CHF",
      "GBP",
      "AUD",
      "AED",
      "SGD",
      "NOK"
    ];
    return currencies
        .map((code) => DropdownMenuItem(value: code, child: Text(code)))
        .toList();
  }
}
