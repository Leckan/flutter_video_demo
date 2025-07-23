import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_video_demo/models/user.dart';
import 'package:flutter_video_demo/utils/auth_provider.dart';

class EmailAuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return null;

      return User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        provider: AuthProvider.email,
      );
    } catch (e) {
      print('Email Sign-In Error: $e');
      return null;
    }
  }

  Future<User?> registerWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) return null;

      return User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        provider: AuthProvider.email,
      );
    } catch (e) {
      print('Email Registration Error: $e');
      return null;
    }
  }
}