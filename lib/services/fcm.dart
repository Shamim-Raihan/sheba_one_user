import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/call_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/jitsi_meet.dart';
import 'package:shebaone/services/notification.dart';
import 'package:shebaone/utils/global.dart';

Future<void> setupFirebaseMessenging() async {
  Get.put<CallController>(CallController(), permanent: true);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('getInitialMessaage');
      print(message);
    }
  });

  // onMessage is called when app is in foreground
  // and a message is arrived
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("onMessage");
    print(message);
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    globalLogger.d(message.toMap());

    final type = message.data['type'];

    if (type != null) {
      final data = message.data['addition'];
      final info = data.isEmpty ? {} : jsonDecode(data);
      if (type == 'delivery') {
        globalLogger.d('0', 'FCM_WORK');
        fcmNotification(message.notification!.title!, message.notification!.body!);
        if (info['delivery_status'] == 'accepted') {
          globalLogger.d('1', 'FCM_WORK');
          if (info['type'] == 'Live') {
            if ((HealthCareController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == HealthCareController.to.orderSuccessData['order_id']) ||
                (MedicineController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == MedicineController.to.orderSuccessData['order_id']) ||
                (PrescriptionController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == PrescriptionController.to.orderSuccessData['order_id'])) {
              globalLogger.d('3', 'FCM_WORK');
              AuthController.to
                  .syncDeliverymanOrderIdToLocal(deliverymanId: info['deliveryman_id'], orderId: info['order_id']);
              HomeController.to.deliveryStatus(DeliveryStatus.accepted);
              AuthController.to.redisServiceReady(info['deliveryman_id']);
            }
          } else {
            globalLogger.d('Normal Type', "TYPE");
          }
        } else if (info['delivery_status'] == 'picked up') {
          globalLogger.d('1', 'FCM_WORK');
          if (info['type'] == 'Live') {
            if ((HealthCareController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == HealthCareController.to.orderSuccessData['order_id']) ||
                (MedicineController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == MedicineController.to.orderSuccessData['order_id']) ||
                (PrescriptionController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == PrescriptionController.to.orderSuccessData['order_id'])) {
              globalLogger.d('3', 'FCM_WORK');
              HomeController.to.deliveryStatus(DeliveryStatus.pickedUp);
            }
          } else {
            globalLogger.d('Normal Type', "TYPE");
          }
        } else if (info['delivery_status'] == 'cancelled' || info['delivery_status'] == 'delivered') {
          ///Socket IO Close
          if (info['type'] == 'Live') {
            if ((HealthCareController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == HealthCareController.to.orderSuccessData['order_id']) ||
                (MedicineController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == MedicineController.to.orderSuccessData['order_id']) ||
                (PrescriptionController.to.orderSuccessData['order_id'] != null &&
                    info['order_id'] == PrescriptionController.to.orderSuccessData['order_id'])) {
              HomeController.to.deliveryStatus(
                  info['delivery_status'] == 'cancelled' ? DeliveryStatus.cancelled : DeliveryStatus.delivered);
            }
          } else {
            globalLogger.d('Normal Type', "TYPE");
          }
        }
      } else if (type == 'call' && info['call_status'] != null) {
        globalLogger.d(message.data['addition'], "message.data['addition']");
        if (info['call_status'] == 'user_ended') {
          var calls = await FlutterCallkitIncoming.activeCalls();
          globalLogger.d(calls, 'Call Data');
          final data = await FlutterCallkitIncoming.activeCalls();
          globalLogger.d(data, 'Active Call Data');

          await FlutterCallkitIncoming.endCall(calls[calls.length - 1]['id']);
        }
        if (info['call_status'] != 'ended' && info['call_status'] != 'user_ended') {
          globalLogger.d(DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds < 45);

          if (info['type'] != null &&
              info['ring_time'] != null &&
              DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds <= 45) {
            // await sendMessage(
            //   type: info['type'],
            //   token: info['token'],
            //   callStatus: 'ringing',
            // );
            sendPushMessage(
              callType: info['type'],
              token: info['token'],
              callStatus: 'ringing',
              notificationType: 'call',
              title: 'Current call',
              body: 'Notifying Patient. Please wait...',
            );
            await showCallkitIncoming(
              uuid: uuid.v4(),
              type: info['type'],
              image: info['image'],
              token: info['token'],
              name: info['name'],
              roomId: info['room_id'],
              ringTime: info['ring_time'],
            );
          } else if (info['type'] != null &&
              info['ring_time'] != null &&
              DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds > 45) {
            fcmNotification(
                "Missed Call",
                info['name'] +
                    " is called you ${DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds} sec ago");
          }
        } else if (info['call_status'] == 'ended') {
          globalLogger.d("------------------------------------");
          // fcmNotification(message.notification!.title!, info['body']);
          JitsiUtil.closeMeeting();
          await FlutterCallkitIncoming.endCall(calling);
          await requestHttp('END_CALL');
          CallController.to.callStatus(CallStatus.ended);
          callSubscription!.cancel();
          // Get.offAllNamed('/');
        }
      }
    }
    // joinMeeting(
    //     isVideoCallOptionEnable: body['type'] == 'audio' ? false : true);
    // globalLogger.d(info);
    if (notification != null && android != null) {
      // flutterLocalNotificationsPlugin.show(
      //     notification.hashCode,
      //     notification.title,
      //     notification.body,
      //     NotificationDetails(
      //       android: AndroidNotificationDetails(
      //         channel.id,
      //         channel.name,
      //         channel.description,
      //         // TODO add a proper drawable resource to android, for
      //
      //
      //
      //          now using
      //         //      one that already exists in example app.
      //         icon: 'launch_background',
      //       ),
      //     ));
    }
  });

  // onMessageOpnedApp is called when a notification is clicked
  // from the system tray and the app is opened by it.
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    // await fcmNotification(
    //     message.notification!.title!, message.notification!.body!);
    print('onMessageOpenedApp');
    print('A new onMessageOpenedApp event was published!');
    // Navigator.pushNamed(context, '/message',
    //     arguments: MessageArguments(message, true));
  });
}

/// Define a top-level named handler which background/terminated messages will
/// call.
/// To verify things are working, check out the native platform logs.
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('_firebaseMessagingBackgroundHandler');
  print(message);
  // fcmNotification(message.notification!.title!, message.notification!.body!);
  globalLogger.d(message.toMap());
  // fcmNotification(message.notification!.title!, message.notification!.body!);
  final data = message.data['addition'];
  final type = message.data['type'];
  final info = data.isEmpty ? {} : jsonDecode(data);

  if (type != null && type == 'call' && info['call_status'] != null) {
    if (info['call_status'] == 'user_ended') {
      globalLogger.d('OK I am ending');
      var calls = await FlutterCallkitIncoming.activeCalls();
      await FlutterCallkitIncoming.endCall(calls[calls.length - 1]);
    }
    if (info['call_status'] != 'ended' && info['call_status'] != 'user_ended') {
      globalLogger.d(DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds < 45);

      if (info['type'] != null &&
          info['ring_time'] != null &&
          DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds <= 45) {
        // await sendMessage(
        //   type: info['type'],
        //   token: info['token'],
        //   callStatus: 'ringing',
        // );
        sendPushMessage(
          callType: info['type'],
          token: info['token'],
          callStatus: 'ringing',
          notificationType: 'call',
          title: 'Current call',
          body: 'Notifying Patient. Please wait...',
        );
        await showCallkitIncoming(
          uuid: uuid.v4(),
          type: info['type'],
          image: info['image'],
          token: info['token'],
          name: info['name'],
          roomId: info['room_id'],
          ringTime: info['ring_time'],
        );
      } else if (info['type'] != null &&
          info['ring_time'] != null &&
          DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds > 45) {
        fcmNotification(
            "Missed Call",
            info['name'] +
                " is called you ${DateTime.now().difference(DateTime.parse(info['ring_time'])).inSeconds} sec ago");
      }
    } else if (info['call_status'] == 'ended') {
      JitsiUtil.closeMeeting();
      await FlutterCallkitIncoming.endCall(calling);
      await requestHttp('END_CALL');
      CallController.to.callStatus(CallStatus.ended);
      callSubscription!.cancel();
      // Get.offAllNamed('/');
    }
  }
}

Future<void> showCallkitIncoming({
  required String uuid,
  required String type,
  required String image,
  required String name,
  required String token,
  required String ringTime,
  required String roomId,
}) async {
  globalLogger.d(type, "type type type");
  var params = <String, dynamic>{
    'id': uuid,
    'nameCaller': name,
    'appName': 'ShebaOne',
    'avatar': image,
    'handle': 'ShebaOne Server',
    'type': type == 'audio' ? 0 : 1,
    'duration': 45000,
    'textAccept': 'Accept',
    'textDecline': 'Decline',
    'textMissedCall': 'Missed call',
    'textCallback': 'Call back',
    'extra': <String, dynamic>{
      'userId': '1a2b3c4d',
      'token': token,
      'ringTime': ringTime,
      'roomId': roomId,
      'callCount': callCount,
    },
    'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    'android': <String, dynamic>{
      'isCustomNotification': true,
      'isShowLogo': false,
      'isShowCallback': false,
      'ringtonePath': 'system_ringtone_default',
      'backgroundColor': '#0955fa',
      'backgroundUrl': image,
      'actionColor': '#4CAF50'
    },
    'ios': <String, dynamic>{
      'iconName': 'CallKitLogo',
      'handleType': '',
      'supportsVideo': true,
      'maximumCallGroups': 2,
      'maximumCallsPerCallGroup': 1,
      'audioSessionMode': 'default',
      'audioSessionActive': true,
      'audioSessionPreferredSampleRate': 44100.0,
      'audioSessionPreferredIOBufferDuration': 0.005,
      'supportsDTMF': true,
      'supportsHolding': true,
      'supportsGrouping': false,
      'supportsUngrouping': false,
      'ringtonePath': 'system_ringtone_default'
    }
  };

  CallKitParams callKitParams = CallKitParams.fromJson(params);
  await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
  callSubscription = FlutterCallkitIncoming.onEvent.listen((event) async {
    globalLogger.d('Called', 'Call Listen Event');
    globalLogger.d(event!.event, 'Call Listen Event');
    recentCallStatus = event.event.toString().replaceAll('Event.', '');
    globalLogger.d(recentCallStatus, 'FlutterCallkitIncoming event');
    if (recentCallStatus == 'ACTION_CALL_DECLINE') {
      globalLogger.d(calling, 'calling');
      sendPushMessage(
        callType: type,
        token: token,
        callStatus: 'rejected',
        notificationType: 'call',
        title: 'Current call',
        body: 'Notifying Patient. Please wait...',
      );
      // await sendMessage(
      //   type: type,
      //   token: token,
      //   callStatus: 'rejected',
      // );
    }
  });
}

Future<void> sendPushMessage({
  required String body,
  required String title,
  required String callStatus,
  required String callType,
  required String token,
  required String notificationType,
}) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAm46EafU:APA91bFNoKECUnp-HSKb063VNMFKXxrOlXkEca-MfgfQAAzug5-NkEe9akmqzlXKJz4uZjKtWj6OyassSnuIJGmDXYKou8HlrXUAbaDOTlBYoS44shTrViUCKUW9rZAF19GlKn1_-kuC',
      },
      body: jsonEncode(
        {
          'notification': {'body': body, 'title': title},
          'priority': 'high',
          'timeToLive': 24 * 60 * 60,
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
            'type': notificationType,
            'postid': uuid.v4(),
            "addition": {
              'call_status': callStatus,
              'type': callType,
            },
          },
          "to": token,
        },
      ),
    );
  } catch (e) {
    print("error push notification");
  }
}

// Future sendMessage(
//     {required String callStatus,
//     required String type,
//     required String token}) async {
//     final token = await _getToken();
//     globalLogger.d(token);
//   globalLogger.d('called');
//   var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
//   final data = {
//     'notification_type': 'call',
//     'body': 'Calling',
//     'room_id': 'myroom111',
//     'call_status': callStatus,
//     'type': type,
//   };
//
//   String jsonStringMap = json.encode(data);
//   var res = await func.call(<String, dynamic>{
//     "targetDevices": [token],
//     "messageTitle": "Test title",
//     "messageBody": jsonStringMap,
//   });
//   globalLogger.d(data, res.data);
//   print("message was ${res.data as bool ? "sent!" : "not sent!"}");
// }
