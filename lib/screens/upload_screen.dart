import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/video_upload_service.dart';
import '../services/notification_service.dart';
import '../services/mock_backend_service.dart';
import '../services/app_state.dart';
import '../models/video_upload.dart';
import 'package:uuid/uuid.dart';

import '../utils/upload_status.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _videoFile;
  final _picker = ImagePicker();
  double _uploadProgress = 0.0;

  Future<void> _pickVideo(ImageSource source) async {
    final pickedFile = await _picker.pickVideo(source: source);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadVideo(AppState appState) async {
    if (_videoFile == null || appState.currentUser == null) return;

    final videoService = VideoUploadService();
    final notificationService = NotificationService();
    final backendService = MockBackendService();

    try {
      appState.setLoading(true);
      final gcsUrl = await videoService.uploadVideo(_videoFile!, appState.currentUser!.id);
      
      final upload = VideoUpload(
        id: Uuid().v4(),
        userId: appState.currentUser!.id,
        filename: _videoFile!.path.split('/').last,
        gcsUrl: gcsUrl,
        uploadedAt: DateTime.now(),
        status: UploadStatus.completed,
      );

      appState.addUpload(upload);
      await backendService.saveUploadRecord(upload);
      
      final token = await notificationService.getFCMToken();
      if (token != null) {
        await backendService.sendNotification(
          token,
          'Your video has been uploaded successfully.',
        );
      }
    } catch (e) {
      appState.addUpload(VideoUpload(
        id: Uuid().v4(),
        userId: appState.currentUser!.id,
        filename: _videoFile!.path.split('/').last,
        gcsUrl: '',
        uploadedAt: DateTime.now(),
        status: UploadStatus.failed,
      ));
    } finally {
      appState.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Upload Video')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () => _pickVideo(ImageSource.gallery),
              child: Text('Pick from Gallery'),
            ),
            ElevatedButton(
              onPressed: () => _pickVideo(ImageSource.camera),
              child: Text('Record Video'),
            ),
            if (_videoFile != null) ...[
              Text('Selected: ${_videoFile!.path.split('/').last}'),
              ElevatedButton(
                onPressed: () => _uploadVideo(appState),
                child: Text('Upload'),
              ),
              LinearProgressIndicator(value: _uploadProgress),
            ],
            if (appState.isLoading) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
