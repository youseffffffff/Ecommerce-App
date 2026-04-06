import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthServices {
  Future<bool> signInWithUserNameAndPassword(String username, String password);
  Future<bool> registerWithUserNameAndPassword(
    String username,
    String password,
  );
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
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    final user = userCredential.user;

    if (user == null) {
      return false;
    } else {
      return true;
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
}
