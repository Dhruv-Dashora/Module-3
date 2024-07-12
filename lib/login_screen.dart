// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, unused_element, use_build_context_synchronously, unnecessary_cast, unused_import, no_leading_underscores_for_local_identifiers
import 'package:calculator/SignIn.dart';
import 'package:calculator/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //bool _obscureText = true; // State variable to track password visibility
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                setState(() {
                  emailController.text = value;
                });
              },
            ),
            TextField(
              controller: passwordController,
              // Set obscureText to true to hide characters
              // Set based on state variable
              //obscureText: _obscureText,
              decoration: InputDecoration(
                hintText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200],
                // suffixIcon: IconButton(
                //   icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                //   onPressed: () {
                //     setState(() {
                //       _obscureText = !_obscureText;
                //     });
                //   },
                // ),
              ),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) =>
                  passwordController.text = value, // Concise arrow function
            ),
            ElevatedButton.icon(
              onPressed: () {
                createUser(emailController.text, passwordController.text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              icon: Icon(Icons.mail),
              label: Text('SignUp'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                bool loginSuccessful = await signIn(
                    context, emailController.text, passwordController.text);
                if (loginSuccessful) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CalculatorApp()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Invalid email or password. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: Icon(Icons.mail),
              label: Text('SignIn'),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                bool loginSuccessful = await signIn(
                    context, emailController.text, passwordController.text);
                if (loginSuccessful) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => CalculatorApp()));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content:
                          Text('Invalid email or password. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
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
