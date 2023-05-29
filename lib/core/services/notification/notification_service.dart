// import 'package:awesome_notifications/awesome_notifications.dart';

// class NotificationService {
//   String? timeZone;
//   Future initTimeZone() async {
//     timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
//   }

//   Future pushNotification({
//     required String title,
//     required String body,
//     required int id,
//     required int minute,
//     required int hour,  
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'key1',
//         title: title,
//         body: body,
//       ),
//       schedule: NotificationCalendar(
//         timeZone: timeZone,
//         repeats: true,
//         minute: minute,
//         hour: hour,
//       ),
//     );
//   }

//   Future monthlyPushNotification({
//     required String title,
//     required String body,
//     required int id,
//     required int minute,
//     required int hour,
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'key1',
//         title: title,
//         body: body,
//       ),
//       schedule: NotificationCalendar(
//         timeZone: timeZone,
//         day: DateTime.now().day,
//         minute: minute,
//         hour: hour,
//         repeats: true,
//       ),
//     );
//   }

//   Future yearsPushNotification({
//     required String title,
//     required String body,
//     required int id,
//     required int minute,
//     required int hour,
//   }) async {
//     await AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: id,
//         channelKey: 'key1',
//         title: title,
//         body: body,
//       ),
//       schedule: NotificationCalendar(
//         month: DateTime.now().month,
//         minute: minute,
//         hour: hour,
//         repeats: true,
//       ),
//     );
//   }

//   Future cancelPushNotification(int id) async {
//     await AwesomeNotifications().cancel(id);
//   }
// }
