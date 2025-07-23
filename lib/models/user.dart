enum AuthProvider { google, facebook, email }
enum UploadStatus { uploading, completed, failed }

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
