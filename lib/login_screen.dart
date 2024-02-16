// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:calculator/main.dart';


class  LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton.icon(
              onPressed: () {
                // Add your Google login logic here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorApp()),
                );
              },
              icon: Icon(Icons.mail),
              label: Text('Login via Google'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Add your Email login logic here

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculatorApp()),
                );
              },
              icon: Icon(Icons.mail),
              label: Text('Login via Email'),
            ),
          ],
        ),
      ),
    );
  }
}
