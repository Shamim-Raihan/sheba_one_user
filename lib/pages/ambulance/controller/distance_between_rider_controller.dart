// import 'package:get/get.dart';
// import 'package:shebaone/pages/ambulance/service/distance_between_rider.dart';
// import 'dart:async';
// import 'package:get/get.dart';
// import 'package:shebaone/pages/ambulance/service/distance_between_rider.dart';

// class DistanceBetweenRiderController extends GetxController {
//   RxDouble distance = RxDouble(0.0);
//   // RxDouble riderLat = RxDouble(0.0);
//   // RxDouble riderLon = RxDouble(0.0);
//   final DistanceBetweenRiderService distanceBetweenRiderService =
//       DistanceBetweenRiderService();

//   late Timer _timer;

//   @override
//   void onInit() {
//     // TODO: implement onInit
//     // Start the timer on initialization
//     _startTimer();
//     super.onInit();
//   }

//   @override
//   void onClose() {
//     // Dispose of the timer when the controller is closed
//     _timer.cancel();
//     super.onClose();
//   }

//   void _startTimer() {
//     // Set up a recurring timer that fires every 30 seconds
//     _timer = Timer.periodic(Duration(seconds: 30), (timer) {
//       checkDistance();
//     });
//   }

//   void checkDistance() async {
//     try {
//       await distanceBetweenRiderService.distanceBetweenRider();
//       distance.value = distanceBetweenRiderService.distanceValue;
//       // riderLat.value = distanceBetweenRiderService.rider_latitude;
//       // riderLon.value = distanceBetweenRiderService.rider_longitude;
//     } catch (error) {
//       // Handle errors if necessary
//       print('Error: $error');
//     }
//   }
// }
