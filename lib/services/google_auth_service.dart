import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_video_demo/models/user.dart';
import 'package:flutter_video_demo/utils/auth_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      return User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        profileImageUrl: user.photoURL,
        provider: AuthProvider.google,
      );
    } catch (e) {
      print('Google Sign-In Error: $e');
      return null;
    }
  }
}
