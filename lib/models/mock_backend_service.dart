import '../models/video_upload.dart';

class MockBackendService {
  Future<void> saveUploadRecord(VideoUpload upload) async {
    await Future.delayed(Duration(seconds: 1));
  }

  Future<void> sendNotification(String fcmToken, String message) async {
    await Future.delayed(Duration(seconds: 2));
  }
}