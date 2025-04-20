import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recipe/pages/login.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    return auth.currentUser;
  }

  Future<void> signOut() async {
    await auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> deleteuser(BuildContext context) async {
    User? user = auth.currentUser;

    if (user != null) {
      try {
        // Delete from Firestore using UID
        await FirebaseFirestore.instance.collection("users").doc(user.uid).delete();

        // Delete from Firebase Auth
        await user.delete();

        // Clear local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        // Navigate to login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LogIn()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        // Show error if deletion fails
        print("Delete error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to delete account: ${e.message}",
              style: TextStyle(fontSize: 16.0),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
