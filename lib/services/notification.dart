import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

int id = 0;
int createUniqueId() {
  id = id + 1;
  return id;
}

Future<void> botJoinNotification(String bot) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: 'Join Bot!!!',
      body: 'You have joined $bot successfully.',
      notificationLayout: NotificationLayout.Default,

      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'OKAY',
        label: 'Okay',
      )
    ],
  );
}

Future<void> fcmNotification(String title, String body) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,

      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
    // actionButtons: [
    //   NotificationActionButton(
    //     key: 'OKAY',
    //     label: 'Okay',
    //   )
    // ],
  );
}

Future<void> botLeaveNotification(String bot) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: createUniqueId(),
      channelKey: 'basic_channel',
      title: 'Leave Bot!!!',
      body: 'You have left $bot successfully.',
      backgroundColor: Colors.red,
      notificationLayout: NotificationLayout.Default,

      // bigPicture: 'asset://assets/notification_map.png',
      // notificationLayout: NotificationLayout.BigPicture,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'OKAY',
        label: 'Okay',
      )
    ],
  );
}
