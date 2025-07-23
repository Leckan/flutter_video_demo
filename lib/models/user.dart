

import 'package:flutter_video_demo/utils/auth_provider.dart';

class User {
  final String id;
  final String email;
  final String? name;
  final String? profileImageUrl;
  final AuthProvider provider;

  User({
    required this.id,
    required this.email,
    this.name,
    this.profileImageUrl,
    required this.provider,
  });
}
