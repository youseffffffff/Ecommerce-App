import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthServices {
  Future<bool> signInWithUserNameAndPassword(String username, String password);
  Future<bool> registerWithUserNameAndPassword(
    String username,
    String password,
  );
  Future<bool> authenticateWithGoogle();

  User? currentUser();
  Future<void> logout();
}

class AuthServicesImpl implements AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> signInWithUserNameAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      if (user == null) {
        return false;
      } else {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  @override
  Future<bool> registerWithUserNameAndPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    final user = userCredential.user;

    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  User? currentUser() {
    final result = _firebaseAuth.currentUser;

    return result;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> authenticateWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    return (userCredential.user != null);
  }
}
