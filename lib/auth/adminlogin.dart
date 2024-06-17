import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:login/admin/admin_dashborad.dart';

class AdminAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> signInAdmin(
      BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot adminSnapshot =
            await _firestore.collection('users').doc(user.uid).get();

        if (adminSnapshot.exists && adminSnapshot.get('isAdmin') == true) {
          // Redirect to admin dashboard
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => addash()),
          );
        } else {
          // Show error message or redirect to user page
          print('User is not an admin');
          _auth.signOut(); // Sign out the user if they are not an admin
        }
      }
    } catch (e) {
      print('Failed to sign in: $e');
    }
  }
}
