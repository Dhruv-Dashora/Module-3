// ignore_for_file: file_names, unused_import, unused_local_variable, avoid_print

import 'package:calculator/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void createUser(email, password) async {
  try {
    final credentials = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password is too weak. Please choose a stronger password.');
    } else {
      print('User is not signed in');
    }
  }
}

Future<bool> signIn(BuildContext context, String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return true; // Login successful
  } on FirebaseAuthException catch (e) {
    // Handle errors and return false
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      print('Invalid credentials.');
      return false; // Login failed
    } else {
      print('Error signing in: ${e.message}');
      return false; // Login failed
    }
  }
}
