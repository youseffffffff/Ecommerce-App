import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthServices {
  Future<bool> signInWithUserNameAndPassword(String username, String password);
  Future<bool> registerWithUserNameAndPassword(
    String username,
    String password,
  );
}

class AuthServicesImpl implements AuthServices {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> signInWithUserNameAndPassword(
    String username,
    String password,
  ) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: username, password: password);

    final user = userCredential.user;

    if (user == null) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<bool> registerWithUserNameAndPassword(
    String username,
    String password,
  ) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: username, password: password);
    final user = userCredential.user;

    if (user == null) {
      return false;
    } else {
      return true;
    }
  }
}
