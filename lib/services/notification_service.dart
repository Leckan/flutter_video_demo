import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initializeNotifications() async {
    await _firebaseMessaging.requestPermission();
    
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    
    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handle notification tap
      },
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      handleNotification(message);
    });
  }

  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  void handleNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _notificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'upload_channel',
          'Upload Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}