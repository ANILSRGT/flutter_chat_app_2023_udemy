import 'package:firebase_messaging/firebase_messaging.dart';

import '../ipush_notification_service.dart';

class FirebasePushNotificationService implements IPushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> initPushNotification() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // print(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // print(message);
    });

    _firebaseMessaging.subscribeToTopic('chat');
  }
}
