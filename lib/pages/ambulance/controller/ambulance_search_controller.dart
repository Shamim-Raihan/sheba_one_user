import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:shebaone/controllers/auth_controller.dart';

import 'package:shebaone/utils/global.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shebaone/pages/ambulance/model/vehicle_details_model.dart';
import 'package:shebaone/pages/ambulance/view/choose_a_ride.dart';


class AmbulanceServiceController extends GetxController {
  RxString paymentType = "Payment method".obs;
  RxBool isPaid = false.obs;
  RxString new_destination = ''.obs;
  RxString new_total_charge = ''.obs;
  RxBool riderAction = false.obs;
  RxBool isAccepted = false.obs;
  RxBool isDeclined = false.obs;
  RxInt attemtCounter = 0.obs;
  RxString userIdFromRider = ''.obs;
  RxString rideDataFromRider = ''.obs;
  RxBool errorOccurred = false.obs;

//----------------------get device current location --------------------
  RxDouble latitude = RxDouble(0.0);
  RxDouble longitude = RxDouble(0.0);

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude.value = position.latitude;
      longitude.value = position.longitude;
    } catch (e) {
      print(e);
    }
  }

  final socket = IO.io('https://worker.shebaone.com', <String, dynamic>{
    'transports': ['websocket', 'polling'],
    'autoConnect': false,
  });

  void sendRideRequestThroughSocket(
    dynamic response_rider_data,
    double pickUpLat,
    double pickUpLon,
    double desLat,
    double deLon,
    String pickUpLoc,
    String desLoc,
  ) {
    socket.connect();

    socket.emit('patientUserRideRequestSend', {
      "user": {
        "id": int.parse(storage.read('userId')),
        "name": "${AuthController.to.userPhone}",
        "phone": "",
        "pickUpLat": pickUpLat,
        "pickUpLon": pickUpLon,
        "desLat": desLat,
        "deLon": deLon,
        "pickUpLoc": "$pickUpLoc",
        "desLoc": "$desLoc"
      },
      "rider": response_rider_data,
    });
  }

  // @override
  // void dispose() {
  //   socket.disconnect();
  //   socket.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }
  //----------sending selected lat long to generate quote------------------------
  Future<void> sendLatLongData(double pickUpLat, double pickUpLong,
      double destLat, double destLong, String pickUpLoc, String desLoc) async {
    final url =
        'https://www.shebaone.com/api/patient-user/ride-quote'; // Replace with your server's URL
    late VehicleDetailsModel ambulance;
    late VehicleDetailsModel car;
    late VehicleDetailsModel micro;

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'current_location_latitude': pickUpLat.toString(),
          'current_location_longitude': pickUpLong.toString(),
          'destination_location_latitude': destLat.toString(),
          'destination_location_longitude': destLong.toString(),
        },
      );

      if (response.statusCode == 201) {
        // Request was successful
        // print('POST request successful');

        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        if (jsonResponse['error'] == false) {
          final Map<String, dynamic> vehicleData = jsonResponse['data'];

          ambulance = VehicleDetailsModel(
            name: 'Ambulance',
            charge: vehicleData['ambulance']['charge'].toDouble(),
            distanceKm: vehicleData['ambulance']['distance_km'].toDouble(),
          );

          car = VehicleDetailsModel(
            name: 'Patient Car',
            charge: vehicleData['car']['charge'].toDouble(),
            distanceKm: vehicleData['car']['distance_km'].toDouble(),
          );

          micro = VehicleDetailsModel(
            name: 'Patient Micro',
            charge: vehicleData['micro']['charge'].toDouble(),
            distanceKm: vehicleData['micro']['distance_km'].toDouble(),
          );

          // Now, you have the vehicle details ready to pass to the next page
        }

        //Get.to(() => SelectRide(ambulance: ambulance, car: car, micro: micro));
        Get.to(() => ChooseRide(
              destinationLatitude: pickUpLat,
              destinationLongitude: pickUpLong,
              pickupLatitude: destLat,
              pickupLongitude: destLong,
              ambulance: ambulance,
              car: car,
              micro: micro,
              pickUpLoc: pickUpLoc,
              desLoc: desLoc,
            ));
      } else {
        // Request failed
      }
    } catch (e) {
      // An error occurred
    }
  }

  //--------------------send ride request------------------------
  

  Future<void> sendRideRequest(
    double currentLat,
    double currentLong,
    double dstLat,
    double dsLong,
    String vehicleType,
    double rideCharge,
    int attempt,
    String pickUpLoc,
    String desLoc,
  ) async {
    final url = 'https://www.shebaone.com/api/patient-user/ride-request';

    try {
      print("Sending ride request:");
      print("currentLat: $currentLat, currentLong: $currentLong");
      print(
          "Vehicle Type: ${vehicleType.toLowerCase()}, Ride Charge: $rideCharge");
      print("Attempt: $attempt");
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'current_location_latitude': "$currentLat",
          'current_location_longitude': "$currentLong",
          'vehicle_type': "${vehicleType.toLowerCase()}",
          "ride_charge": "$rideCharge",
          'attempt': "$attempt",
        }),
        headers: {
          'Content-Type': 'application/json', // Set the content type
        },
      );


      dynamic responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {

        if (responseData["data"]["rider"].toString() == "null" &&
            attemtCounter <= 5) {

          attemtCounter++;


          await sendRideRequest(
            currentLat,
            currentLong,
            dstLat,
            dsLong,
            vehicleType,
            rideCharge,
            attemtCounter.toInt(),
            pickUpLoc,
            desLoc,
          );
        } else {
          // Rider value is not null, proceed with socket and navigation
          sendRideRequestThroughSocket(
            responseData["data"],
            currentLat,
            currentLong,
            dstLat,
            dsLong,
            pickUpLoc,
            desLoc,
          );
          print('Socket fired');
        }
      } else {

      }
    } catch (e) {
      // An error occurred
      print('Error making POST request: $e');
      errorOccurred.value = true;
    }
  }
}
