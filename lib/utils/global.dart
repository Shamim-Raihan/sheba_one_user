import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:redis/redis.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';

var uuid = const Uuid();
GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

final storage = GetStorage();
final globalLogger = Logger();
double callCount = 0;
dynamic calling;
String? prescriptionPath;
StreamSubscription<CallEvent?>? callSubscription;
StreamSubscription<CallEvent?>? callSubscriptionMain;
String recentCallStatus = '';
//Decliner Socket
IO.Socket socket = IO.io(
  /*kReleaseMode ? 'https://nodejsredis.wiztecbd.online' :*/ /*"https://nodejs.proinfoedu.com"*/
  "https://worker.shebaone.com/",
  <String, dynamic>{
    'autoConnect': false,
    'transports': ['websocket', 'polling'],
  },
);
dynamic orderInfoConfirm = {};

init2SocketForDelivery() {
  globalLogger.d('Init Socket Enter');
  // globalLogger.d(socket!.id, 'Socket Var');
  socket.onConnect((_) {
    socket.on('userGetDeliveryManLocation', (newMessage) {
      if (newMessage['user_id'] == UserController.to.getUserInfo.userId) {
        globalLogger.d(newMessage, 'receive from deliveryman');
      } else {
        globalLogger.d(newMessage, 'ELSE');
      }
    });
  });
  socket.connect();
  socket.onDisconnect((_) => globalLogger.d('Connection Disconnection'));
  socket.onConnectError((err) => print(err));
  socket.onError((err) => print(err));
}

final conn = RedisConnection();
Location? location = Location();
StreamSubscription<LocationData>? locationSubscription;
Timer? timer;
const String mapApiKey = 'AIzaSyDMnTS3Bada4m_-coPcG46JMShU1GOsRIc';
// WebViewController controller = WebViewController()
//   ..setJavaScriptMode(JavaScriptMode.unrestricted)
//   ..setBackgroundColor(const Color(0x00000000))
//   ..setNavigationDelegate(
//     NavigationDelegate(
//       onProgress: (int progress) {
//         // Update loading bar.
//         globalLogger.d(progress);
//       },
//       onPageStarted: (String url) {},
//       onPageFinished: (String url) {},
//       onWebResourceError: (WebResourceError error) {},
//       onNavigationRequest: (NavigationRequest request) {
//         if (request.url.startsWith('https://www.youtube.com/')) {
//           return NavigationDecision.prevent;
//         }
//         return NavigationDecision.navigate;
//       },
//     ),
//   )
//   ..loadRequest(Uri.parse(HomeController.to.dynamicLink.value));
Future<dynamic> getGPSPermission() async {
  bool serviceEnabled;
  LocationPermission permission;
  // // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    // Fluttertoast.showToast(msg: "Your GPS is off. Turn on to get location based services.", timeInSecForIosWeb: 5);
    // Platform.isAndroid? await Geolocator.openLocationSettings():
    snackbarKey.currentState?.showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        content: const Text(
            'Your GPS is off. Turn on to get location based services.'),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.black,
        action: SnackBarAction(
          label: 'Close',
          textColor: Colors.blue,
          // backgroundColor: Colors.white,
          onPressed: () {
            snackbarKey.currentState?.removeCurrentSnackBar();
          },
        ),
      ),
    );
    return Future.error('Location services are disabled.');
  }
  permission = await Geolocator.checkPermission();
  globalLogger.d(permission);
  bool isAccept = false;
  if (permission == LocationPermission.denied) {
    await Get.defaultDialog(
      title: "Disclaimer",
      content: const Text(
          "This app uses user location for live search purposes. When you order medicine or health store product via live search this app store your location for delivery purpose and check background location when only delivery page is on."),
      barrierDismissible: false,
      // confirm: Text("ACCEPT"),
      // cancel: Text("DENY"),
      actions: [
        TextButton(
          onPressed: () async {
            if (permission == LocationPermission.denied) {
              permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied) {
                return Future.error('Location permissions are denied');
              }
            }
            if (permission == LocationPermission.deniedForever) {
              // Permissions are denied forever, handle appropriately.
              Fluttertoast.showToast(
                  msg: Platform.isIOS
                      ? "Location permissions are denied."
                      : "Location permissions are permanently denied, we cannot request permissions.\nGo Permission Setting and enable Location Access for this App.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 4,
                  backgroundColor: Colors.redAccent,
                  textColor: Colors.white,
                  fontSize: 16.0);
              return Future.error(
                  'Location permissions are permanently denied, we cannot request permissions.');
            }
            isAccept = true;
            Get.back();
          },
          child: Text(
            Platform.isIOS ? "Continue" : "ACCEPT",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
        TextButton(
          onPressed: () async {
            isAccept = false;
            Get.back();
          },
          child: const Text(
            "DENY",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );

    return isAccept;
  } else if (permission == LocationPermission.whileInUse ||
      permission == LocationPermission.always) {
    return true;
  }
}
