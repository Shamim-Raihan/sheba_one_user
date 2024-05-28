import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/view/search_location_on_map.dart';

import 'package:shebaone/pages/ambulance/view/waitting_for_ride.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:location/location.dart' as loc;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MapScreen extends StatefulWidget {
  MapScreen(
      {super.key,
      required this.pickLat,
      required this.pickLon,
      required this.desLat,
      required this.desLon,
      required this.vehicleType,
      required this.rideCharge,
      required this.pickUpLoc,
      required this.desLoc});
  double pickLat;
  double pickLon;
  double desLat;
  double desLon;
  String vehicleType;
  double rideCharge;
  String pickUpLoc;
  String desLoc;
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final AmbulanceServiceController ambulanceServiceController =
      Get.find<AmbulanceServiceController>();

  loc.LocationData? _locationData; // Store the current location
  loc.Location location = loc.Location();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage.initStorage;
    sendRideRequest();
    initSocketForRideAcceptNotification();
    initSocketForRideCancelNotification();
    checkingForRide();

    ever(ambulanceServiceController.isAccepted, (bool isAccepted) {
      if (isAccepted) {
        timer?.cancel(); // Cancel the timer if isAccepted becomes true
      }
    });
    ever(ambulanceServiceController.errorOccurred, (bool errorOccurred) {
      if (errorOccurred) {
        AlertDialog(
          title: Text("Something was wrong."),
          content: Text("Please try again"),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                Get.to(() => SearchLocationOnMap(
                    initialCameraPosition: initialCameraPosition));
              },
            ),
          ],
        );
      }
    });




  }


  late IO.Socket socket;
  dynamic receivedRideRequestData = '';
  String patientUserName = '';
  String patientUserPickUpLocation = '';
  String distanceBetweenUserAndRider = '';
  bool isSwitched = true;
  bool isRightUser = false;
  bool isWaiting = true;
  dynamic rideDataFromAcceptSocket;

  // send ride request
  void sendRideRequest() {
    print('1st request created......');
    AmbulanceServiceController().sendRideRequest(
      widget.pickLat,
      widget.pickLon,
      widget.desLat,
      widget.desLon,
      widget.vehicleType,
      widget.rideCharge,
      ambulanceServiceController.attemtCounter.value.toInt(),

      widget.pickUpLoc,
      widget.desLoc,
    );
  }

// ------------------------if rider accept ride request----------------
  void initSocketForRideAcceptNotification() async {
    try {
      GetStorage.init();
      // Create the socket connection
      print('Connecting to the Socket.io server...');
      socket = IO.io(
        "https://worker.shebaone.com",
        <String, dynamic>{
          'autoConnect': false,
          'transports': ['websocket', 'polling'],
        },
      );
      // Connect to the server
      socket.connect();
      // Listen for the 'connect' event to confirm the connection.
      socket.on('connect', (_) {});
      socket.on('patientUserGetRideNotification', (data) {
        ambulanceServiceController.isAccepted.value = true;
        rideDataFromAcceptSocket = data["data"];
        storage.write("Rider_Id", '${data['Rider_Id']}');
        storage.write("User_Id", '${data['User_Id']}');

        storage.write("Order_Id", '${data['data']['data']['order']['id']}');

        if (data['User_Id'] == '${storage.read('User_Id')}' &&
            ambulanceServiceController.isAccepted.value == true) {
          timer!.cancel();

          isWaiting = false;
          // Navigate to RideOngoingPage with the received data

          Get.to(() => WaitingForRide(
                rideData: rideDataFromAcceptSocket,
                pickLat: widget.pickLat,
                pickLon: widget.pickLon,
                desLat: widget.desLat,
                desLon: widget.desLon,
              ));
        } else {}
      });
    } catch (e) {}
  }

  //------------checker------------
  checkingForRide() {
    print(".......checkinggggggggggggg-----");
    if (ambulanceServiceController.isAccepted.value == false) {
      Timer.periodic(Duration(seconds: 60), (Timer timer) {


        if (ambulanceServiceController.attemtCounter.value >= 5) {
          timer.cancel();
          Get.to(() => SearchLocationOnMap(
              initialCameraPosition: initialCameraPosition));
          return;
        } else {
          ambulanceServiceController.attemtCounter++;
          print(
              'attempt counter from map page -->${ambulanceServiceController.attemtCounter.value}');

          if (ambulanceServiceController.isAccepted.value == false) {
            Get.snackbar(
              'Please Wait', // Title of the snackbar
              'We are searching for a ride...',
              backgroundColor: Colors.teal,
              colorText: Colors.white,

            );
          }

          AmbulanceServiceController().sendRideRequest(
            widget.pickLat,
            widget.pickLon,
            widget.desLat,
            widget.desLon,
            widget.vehicleType,
            widget.rideCharge,
            ambulanceServiceController.attemtCounter.value.toInt(),
            widget.pickUpLoc,
            widget.desLoc,
          );

        }
      });
    } else {
      print(
          'compare user id -->${ambulanceServiceController.userIdFromRider} && ${storage.read('User_Id')}');

    }
  }

//-------------------if rider decline ride request--------
  void initSocketForRideCancelNotification() async {
    try {
      // Create the socket connection
      print('Connecting to the Socket.io server...');
      socket = IO.io(
        "https://worker.shebaone.com",
        <String, dynamic>{
          'autoConnect': false,
          'transports': ['websocket', 'polling'],
        },
      );

      // Connect to the server
      socket.connect();

      // Listen for the 'connect' event to confirm the connection.
      socket.on('connect', (_) {});

    } catch (e) {
      print('Error connecting to the Socket.io server');
      print(e);
    }
  }


  // list of locations to display polylines
  List<LatLng> latLen = [
    LatLng(23.791144, 90.408607),
  ];
  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(ambulanceServiceController.latitude.value,
        ambulanceServiceController.longitude.value),
    zoom: 11.0,
  );
  Set<Marker> markerList = {};
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition;

    if (_locationData != null) {
      initialCameraPosition = CameraPosition(
        target: LatLng(
          _locationData!.latitude!,
          _locationData!.longitude!,
        ),
        zoom: 15.0,
      );
    } else {

      // If location data is not available, set a default location (e.g., your default coordinates)
      initialCameraPosition = CameraPosition(
        target: LatLng(23.8117129, 90.3711568),
        zoom: 15.0,
      );
    }

    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Center(
            child: isWaiting == true
                ? Stack(
                    children: [
                      GoogleMap(
                        initialCameraPosition: initialCameraPosition,
                        markers: markerList,
                        mapType: MapType.normal,
                        onMapCreated: (GoogleMapController controller) {
                          googleMapController = controller;
                        },
                      ),
                      Positioned(
                          top: Get.height * .38,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              space5C,
                              Image.asset(
                                'assets/icons/loading.gif',
                                height: Get.height * .15,
                                width: Get.height * .15,
                              ),
                              space2C,
                              Container(
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    const TitleText(
                                      title: 'Please wait...',
                                      fontSize: 16,
                                    ),
                                    space2C,
                                    const TitleText(
                                      title:
                                          'We will notify you once rider is found',
                                      fontSize: 12,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ],
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}
