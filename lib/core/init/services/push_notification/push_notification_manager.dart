import 'ipush_notification_service.dart';
import 'services/firebase_push_notification_service.dart';

class PushNotificationManager implements IPushNotificationService {
  static final PushNotificationManager _instance = PushNotificationManager._init();
  static PushNotificationManager get instance => _instance;

  PushNotificationManager._init();

  IPushNotificationService _pushNotification = FirebasePushNotificationService();
  IPushNotificationService get pushNotification => _pushNotification;

  void changeDatabase(IPushNotificationService pushNotification) {
    _pushNotification = pushNotification;
  }

  @override
  Future<void> initPushNotification() async {
    await _pushNotification.initPushNotification();
  }
}
