import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// SIGN UP
  Future<User?> signUpEmailAndPassword(
    String name,
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );
      User? user = userCredential.user;

      if (user != null) {
        await user.updateDisplayName(name);

        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "name": name,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      return user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'weak-password') {
        throw Exception("Weak Password");
      } else if (error.code == 'email-already-in-use') {
        throw Exception("Email already in use");
      } else {
        throw Exception(error.message ?? "Signup Failed");
      }
    }
  }

  /// LOGIN
  Future<User?> loginEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email.trim(), password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (error) {
      if (error.code == 'user-not-found') {
        throw Exception("No user found");
      } else if (error.code == 'wrong-password') {
        throw Exception("Incorrect password");
      } else if (error.code == 'invalid-credential') {
        throw Exception("Invalid credentials");
      } else if (error.code == 'invalid-email') {
        throw Exception("Invalid email");
      } else {
        throw Exception(error.message ?? "Login Failed");
      }
    }
  }

  /// CHECK LOGIN STATUS
  Future<User?> checkLoginStatus() async {
    return _firebaseAuth.currentUser;
  }

  /// LOGOUT
  Future<void> logoutUser() async {
    await _firebaseAuth.signOut();
  }
}
