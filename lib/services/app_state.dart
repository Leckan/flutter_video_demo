import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/video_upload.dart';

class AppState extends ChangeNotifier {
  User? currentUser;
  List<VideoUpload> uploads = [];
  bool isLoading = false;

  void setUser(User user) {
    currentUser = user;
    notifyListeners();
  }

  void addUpload(VideoUpload upload) {
    uploads.add(upload);
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }
}