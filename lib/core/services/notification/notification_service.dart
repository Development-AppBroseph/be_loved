import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationService {
  String? timeZone;
  Future initTimeZone() async {
    timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
  }

  Future pushNotification(
      {required String title,
      required String body,
      required int interval}) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'key1',
        title: title,
        body: body,
      ),
      schedule: NotificationInterval(
        interval: interval,
        timeZone: timeZone,
        repeats: true,
      ),
    );
  }

  Future monthlyPushNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'key1',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        timeZone: timeZone,
        day: DateTime.now().day,
        repeats: true,
      ),
    );
  }

  Future yearsPushNotification({
    required String title,
    required String body,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: 'key1',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar(
        month: DateTime.now().month,
        repeats: true,
      ),
    );
  }

  Future cancelPushNotification() async {
    await AwesomeNotifications().cancelAll();
  }
}
