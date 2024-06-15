import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register a new user with email and password
  Future<User?> registerWithEmailAndPassword(
    String name,
    String phoneNumber,
    String email,
    String address,
    String state,
    String pinCode,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'phoneNumber': phoneNumber,
          'email': email,
          'address': address,
          'state': state,
          'pinCode': pinCode,
          'role': 'user',
        });
      }
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Register a new worker with email and password
  Future<User?> registerWorkerWithEmailAndPassword(
    String name,
    String phoneNumber,
    String email,
    String address,
    String state,
    String pinCode,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('workers').doc(user.uid).set({
          'name': name,
          'phoneNumber': phoneNumber,
          'email': email,
          'address': address,
          'state': state,
          'pinCode': pinCode,
          'role': 'worker',
        });
      }
      return user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Sign in a user with email and password
  Future<User?> signInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot userDoc =
            await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          return user;
        } else {
          print("User document not found in Firestore.");
          return null;
        }
      }
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Sign in a worker with email and password
  Future<User?> signInWorkerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        DocumentSnapshot workerDoc =
            await _firestore.collection('workers').doc(user.uid).get();
        if (workerDoc.exists) {
          return user;
        } else {
          print("Worker document not found in Firestore.");
          return null;
        }
      }
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error);
    }
  }

  // Stream of authentication state changes
  Stream<User?> get user {
    return _auth.authStateChanges();
  }
}
