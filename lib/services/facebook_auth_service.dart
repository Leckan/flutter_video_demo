import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_video_demo/models/user.dart';
import 'package:flutter_video_demo/utils/auth_provider.dart';

class FacebookAuthService {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  Future<User?> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status != LoginStatus.success) return null;

      final credential = fb.FacebookAuthProvider.credential(result.accessToken!.tokenString);
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      return User(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
        profileImageUrl: user.photoURL,
        provider: AuthProvider.facebook,
      );
    } catch (e) {
      print('Facebook Login Error: $e');
      return null;
    }
  }
}
