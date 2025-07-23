
import 'package:flutter_video_demo/utils/upload_status.dart';

class VideoUpload {
  final String id;
  final String userId;
  final String filename;
  final String gcsUrl;
  final DateTime uploadedAt;
  final UploadStatus status;

  VideoUpload({
    required this.id,
    required this.userId,
    required this.filename,
    required this.gcsUrl,
    required this.uploadedAt,
    required this.status,
  });
}