import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceLogin {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> logoutUser() async {
    try {
      await _auth.signOut();
    } catch (error) {
      print(error);
    }
  }
}
