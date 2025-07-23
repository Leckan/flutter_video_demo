import 'dart:io';
import 'package:googleapis/storage/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:path/path.dart' as p;

class VideoUploadService {
  double _progress = 0.0;

  Future<String> uploadVideo(File videoFile, String userId) async {
    try {
      final credentials = ServiceAccountCredentials.fromJson({
        // Mock credentials - replace with actual GCS credentials
        "type": "service_account",
        "project_id": "flutter-challenge-project",
        "private_key_id": "...",
        "private_key": "...",
        "client_email": "...",
        "client_id": "...",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token"
      });

      final client = await clientViaServiceAccount(
        credentials,
        [StorageApi.devstorageReadWriteScope],
      );

      final storage = StorageApi(client);
      final bucket = 'flutter-challenge-uploads';
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = p.basename(videoFile.path);
      final gcsPath = 'uploads/$userId/$timestamp-$filename';

      final stream = videoFile.openRead().asBroadcastStream();
      final media = Media(stream, videoFile.lengthSync());

      await storage.objects.insert(
        null,
        bucket,
        name: gcsPath,
        uploadMedia: media,
      );

      client.close();
      return 'gs://$bucket/$gcsPath';
    } catch (e) {
      print('Upload Error: $e');
      throw Exception('Failed to upload video');
    }
  }

  Future<double> getUploadProgress() async {
    return _progress;
  }
}
