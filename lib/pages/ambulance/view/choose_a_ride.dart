import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/utils/constant_values.dart';
import 'package:shebaone/pages/ambulance/view/map_button.dart';
import 'package:shebaone/pages/ambulance/widgets/custom_button.dart';
import 'package:google_maps_webservice/directions.dart' as directions;
import '../model/vehicle_details_model.dart';

class ChooseRide extends StatefulWidget {
  final VehicleDetailsModel? ambulance;
  final VehicleDetailsModel? car;
  final VehicleDetailsModel? micro;
  final double pickupLatitude;
  final double pickupLongitude;
  final double destinationLatitude;
  final double destinationLongitude;
  String pickUpLoc;
  String desLoc;

  ChooseRide({
    Key? key,
    this.ambulance,
    this.car,
    this.micro,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.destinationLatitude,
    required this.destinationLongitude,
    required this.pickUpLoc,
    required this.desLoc,
  }) : super(key: key);

  @override
  State<ChooseRide> createState() => _ChooseRideState();
}

class _ChooseRideState extends State<ChooseRide> {
  Completer<GoogleMapController> _controller = Completer();

  bool isAmbulance = false;
  bool isCar = false;
  bool isMicro = false;

  late CameraPosition initialCameraPosition;
  Set<Marker> markerList = {};

  late GoogleMapController googleMapController;

  final Mode _mode = Mode.overlay;
  VehicleDetailsModel? selectedVehicle;
  double? selectedRideCharge;
  String? vehicleType;

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
//----------convert latlon for polyline-------

  // list of locations to display polylines
  late List<LatLng> latLen;

  @override
  void initState() {
    latLen = [
      LatLng(widget.pickupLatitude, widget.pickupLongitude),
      LatLng(widget.destinationLatitude, widget.destinationLongitude),
    ];
    initialCameraPosition = CameraPosition(
        target: LatLng(widget.destinationLatitude, widget.destinationLongitude),
        zoom: 11.0);
    print("-------------------->${latLen}");
    // declared for loop for various locations
    for (int i = 0; i < latLen.length; i++) {
      _markers.add(
          // added markers
          Marker(
        markerId: MarkerId(i.toString()),
        position: latLen[i],
        infoWindow: InfoWindow(
          title: 'HOTEL',
          snippet: '${latLen[i]}',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
      setState(() {});
      _polyline.add(Polyline(
        polylineId: PolylineId('1'),
        points: latLen,
        color: Colors.green,
        width: 7,
      ));
      GetStorage().write('new_destination', null);
      GetStorage().write('new_total_charge', null);
      // TODO: implement initState
      //-------------test map-------

      super.initState();
    }
  }

  //------------test map---------------

  @override
  Widget build(BuildContext context) {
    print(_polyline);
    print(
        "destinationLatitude=${widget.destinationLatitude}  destinationLongitude= ${widget.destinationLongitude} pickupLatitude=${widget.pickupLatitude} pickupLongitude=${widget.pickupLongitude}");
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // Expanded(
            // child: GoogleMap(
            //   markers: Set<Marker>.from(marker2),
            //   initialCameraPosition: _initialLocation,
            //   myLocationEnabled: true,
            //   myLocationButtonEnabled: false,
            //   mapType: MapType.normal,
            //   zoomGesturesEnabled: true,
            //   zoomControlsEnabled: false,
            //   polylines: Set<Polyline>.of(polylines.values),
            //   onMapCreated: (GoogleMapController controller) {
            //     mapController = controller;
            //   },
            // ),
            // ),
            Expanded(
              child: GoogleMap(
                //given camera position
                initialCameraPosition: initialCameraPosition,
                // on below line we have given map type
                mapType: MapType.normal,
                // specified set of markers below
                markers: _markers,
                // on below line we have enabled location
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                // on below line we have enabled compass location
                compassEnabled: true,
                // on below line we have added polylines
                polylines: _polyline,
                // displayed google map
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  // Align(
                  //   alignment: Alignment.topRight,

                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.pop(context);
                  //     },
                  //     child: Icon(
                  //       Icons.close,
                  //       size: 15,
                  //     ),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Choose a ride',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  Divider(),
                  // SizedBox(
                  //   height: 10,
                  // ),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isMicro = false;
                          isCar = false;
                          isAmbulance = true;
                          vehicleType = "ambulance";
                          selectedRideCharge = widget.ambulance!.charge;
                        });
                        // // Print the selected vehicle's details
                        // print('nnnnnnnnnnnnnnnnnnn');
                        // print(selectedRideCharge);
                        // print(
                        //     'Selected Vehicle: ${vehicle.name}, Charge: ${vehicle.charge}, Distance: ${vehicle.distanceKm} km');
                      },
                      child: Container(
                        color: isAmbulance
                            ? Colors.green
                            : isCar
                                ? Colors.transparent
                                : Colors.transparent,
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/Mask Group 64.png'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text("${vehicle.charge}"),
                                          Text(
                                            '${widget.ambulance!.name}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Text(
                                          //   '${widget.ambulance.}',
                                          //   style: TextStyle(fontSize: 10),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'BDT ${widget.ambulance!.charge.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //trailing: isSelected ? Icon(Icons.check) : null,
                        ),
                      ),
                    ),
                  ),

                  ///.....................For car.............................///
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            isMicro = false;
                            isCar = true;
                            isAmbulance = false;
                            vehicleType = "car";
                            selectedRideCharge = double.parse(
                                "${widget.car!.charge.toStringAsFixed(2)}");

                            //     isMicro = true;
                            // isCar = false;
                            // isAmbulance = false;
                            // vehicleType = "micro";
                            // selectedRideCharge = double.parse(
                            //     "${widget.car!.charge.toStringAsFixed(2)}");
                          });
                          // // Print the selected vehicle's details
                          // print('nnnnnnnnnnnnnnnnnnn');
                          // print(selectedRideCharge);
                          // print(
                          //     'Selected Vehicle: ${vehicle.name}, Charge: ${vehicle.charge}, Distance: ${vehicle.distanceKm} km');
                        },
                        child: Container(
                            color: isAmbulance
                                ? Colors.transparent
                                : isCar
                                    ? Colors.green
                                    : Colors.transparent,
                            child: ListTile(
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/Mask Group 63.png',
                                            height: 35,
                                            width: 70,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text("${vehicle.charge}"),
                                              Text(
                                                '${widget.car!.name}',
                                                style: TextStyle(fontSize: 14),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              // Text(
                                              //   '${widget.ambulance.}',
                                              //   style: TextStyle(fontSize: 10),
                                              // ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Text(
                                        'BDT ${widget.car!.charge.toStringAsFixed(2)}',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              //trailing: isSelected ? Icon(Icons.check) : null,
                            )),
                      )),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isMicro = true;
                          isCar = false;
                          isAmbulance = false;
                          vehicleType = "micro";
                          selectedRideCharge = double.parse(
                              "${widget.car!.charge.toStringAsFixed(2)}");
                        });
                        // // Print the selected vehicle's details
                        // print('nnnnnnnnnnnnnnnnnnn');
                        // print(selectedRideCharge);
                        // print(
                        //     'Selected Vehicle: ${vehicle.name}, Charge: ${vehicle.charge}, Distance: ${vehicle.distanceKm} km');
                      },
                      child: Container(
                        color: isMicro
                            ? Colors.green
                            : isCar
                                ? Colors.transparent
                                : Colors.transparent,
                        child: ListTile(
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/Mask Group 65.png'),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Text("${vehicle.charge}"),
                                          Text(
                                            '${widget.micro!.name}',
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          // Text(
                                          //   '${widget.ambulance.}',
                                          //   style: TextStyle(fontSize: 10),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'BDT ${widget.micro!.charge.toStringAsFixed(2)}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          //trailing: isSelected ? Icon(Icons.check) : null,
                        ),
                      ),
                    ),
                  ),

                  // buildVehicleOption(
                  //   widget.ambulance,
                  //   isSelected: selectedVehicle == widget.ambulance,
                  // ),
                  // buildVehicleOption(
                  //   widget.car,
                  //   isSelected: selectedVehicle == widget.car,
                  // ),
                  // buildVehicleOption(
                  //   widget.micro,
                  //   isSelected: selectedVehicle == widget.micro,
                  // ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11.0, vertical: 11),
                    child: InkWell(
                      onTap: () {
                        double rideCharge = selectedRideCharge ??
                            0; // Assuming selectedVehicle is the chosen vehicle
                        //double attempt = 0; // You can change this as needed
                        double currentLat = widget.pickupLatitude;
                        double currentLong = widget
                            .pickupLongitude; // You can change this as needed
                        double destLat =
                            double.parse("${widget.destinationLatitude}");
                        double desLong =
                            double.parse("${widget.destinationLongitude}");
                        print(GetStorage().read('attempt_value'));
                        double atemm = double.parse(
                            "${GetStorage().read("attempt_value")}");
                        double.parse("${widget.destinationLongitude}");

                        print("...........................");
                        // AmbulanceServiceController().sendRideRequest(
                        //   currentLat,
                        //   currentLong,
                        //   destLat,
                        //   desLong,
                        //   vehicleType!,
                        //   rideCharge,
                        //   atemm,
                        //   widget.pickUpLoc,
                        //   widget.desLoc,
                        // );

                        // Navigate to map screen
                        Get.to(() => MapScreen(
                              pickLat: currentLat,
                              pickLon: currentLong,
                              desLat: destLat,
                              desLon: desLong,
                              vehicleType: vehicleType!,
                              rideCharge: rideCharge,
                              pickUpLoc: widget.pickUpLoc,
                              desLoc: widget.desLoc,
                            ));
                      },
                      child: customButton('Confirm'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
