import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:location/location.dart' as loc;
import 'package:shebaone/pages/ambulance/controller/distance_between_rider_controller.dart';
import 'package:shebaone/pages/ambulance/service/change_destination.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shebaone/pages/ambulance/utils/constant_values.dart';
import 'package:shebaone/pages/ambulance/widgets/custom_button.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../controller/ambulance_search_controller.dart';
import 'dart:convert';

class SearchLocationOnMap extends StatefulWidget {
  final AmbulanceServiceController locationController =
      Get.find<AmbulanceServiceController>();
  // final DistanceBetweenRiderController distanceBetweenRiderController =
  //     Get.put(DistanceBetweenRiderController());
  final CameraPosition initialCameraPosition;
  SearchLocationOnMap({super.key, required this.initialCameraPosition});

  @override
  State<SearchLocationOnMap> createState() => _SearchLocationOnMapState();
}

final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchLocationOnMapState extends State<SearchLocationOnMap> {
  final AmbulanceServiceController locationController =
      Get.find<AmbulanceServiceController>();

  Set<Marker> markerList = {};
  late GoogleMapController googleMapController;
  final Mode _mode = Mode.overlay;

  final loc.Location location = loc.Location();

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies\
    _getCurrentLocation();
    super.didChangeDependencies();
  }

  // late Position position=position;

  Future<void> _getCurrentLocation() async {
    try {
      final locData = await location.getLocation();

      if (locData != null) {
        selectedPickUpLatitude = locData.latitude;
        selectedPickUpLongitude = locData.longitude;
        setState(() {
          initialCameraPosition = CameraPosition(
            target: LatLng(locationController.latitude.value,
                locationController.longitude.value),
            zoom: 11.0,
          );
          Set<Marker> newMarkers = {...markerList};
          newMarkers.add(
            Marker(
              markerId: const MarkerId("current_location"),
              position: LatLng(locData.latitude!, locData.longitude!),
              infoWindow: InfoWindow(title: "Current Location"),
            ),
          );

          // Update the marker list with the new markers
          markerList = newMarkers;
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(
        locationController.latitude.value, locationController.longitude.value),
    zoom: 11.0,
  );
  //--------------- pick up location and destination location ------------------------
  String selectedDestination = "";
  String selectedPickUpLocation = "";

  // Define variables to store selected pickup and destination latitudes and longitudes
  double? selectedPickUpLatitude;
  double? selectedPickUpLongitude;

  double? newselectedPickUpLatitude;
  double? newselectedPickUpLongitude;

  double? selectedDestinationLatitude;
  double? selectedDestinationLongitude;

  Future<void> _pickUpLocation() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: mapApiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white)),
      ),
      components: [
        Component(Component.country, "BD"),
        Component(Component.country, "US"),
        // United States
        Component(Component.country, "GB"),
        // United Kingdom
        Component(Component.country, "CN"),
        // China
        Component(Component.country, "JP"),
        // Japan
        // Component(Component.country, "AU"), // Australia
        // Component(Component.country, "NZ"), // New Zealand
        // Component(Component.country, "CA"),
        // Component(Component.country, "AL"), // Albania
        // Component(Component.country, "AD"), // Andorra
        // Component(Component.country, "AT"), // Austria
        // Component(Component.country, "BY"), // Belarus
        // Component(Component.country, "BE"), // Belgium
        // Component(Component.country, "BA"), // Bosnia and Herzegovina
        // Component(Component.country, "BG"), // Bulgaria
        // Component(Component.country, "HR"), // Croatia
        // Component(Component.country, "CY"), // Cyprus
        // Component(Component.country, "CZ"), // Czech Republic
        // Component(Component.country, "DK"), // Denmark
        // Component(Component.country, "EE"), // Estonia
        // Component(Component.country, "FO"), // Faroe Islands (Denmark)
        // Component(Component.country, "FI"), // Finland
        // Component(Component.country, "FR"), // France
        // Component(Component.country, "DE"), // Germany
        // Component(Component.country, "GI"), // Gibraltar (United Kingdom)
        // Component(Component.country, "GR"), // Greece
        // Component(Component.country, "GG"), // Guernsey (United Kingdom)
        // Component(Component.country, "HU"), // Hungary
        // Component(Component.country, "IS"), // Iceland
        // Component(Component.country, "IE"), // Ireland
        // Component(Component.country, "IM"), // Isle of Man (United Kingdom)
        // Component(Component.country, "IT"), // Italy
        // Component(Component.country, "JE"), // Jersey (United Kingdom)
        // Component(Component.country, "XK"), // Kosovo
        // Component(Component.country, "LV"), // Latvia
        // Component(Component.country, "LI"), // Liechtenstein
        // Component(Component.country, "LT"), // Lithuania
        // Component(Component.country, "LU"), // Luxembourg
        // Component(Component.country, "MT"), // Malta
        // Component(Component.country, "MD"), // Moldova
        // Component(Component.country, "MC"), // Monaco
        // Component(Component.country, "ME"), // Montenegro
        // Component(Component.country, "NL"), // Netherlands
        // Component(Component.country, "MK"), // North Macedonia
        // Component(Component.country, "NO"), // Norway
        // Component(Component.country, "PL"), // Poland
        // Component(Component.country, "PT"), // Portugal
        // Component(Component.country, "RO"), // Romania
        // Component(Component.country, "RU"), // Russia
        // Component(Component.country, "SM"), // San Marino
        // Component(Component.country, "RS"), // Serbia
        // Component(Component.country, "SK"), // Slovakia
        // Component(Component.country, "SI"), // Slovenia
        // Component(Component.country, "ES"), // Spain
        // Component(Component.country, "SJ"), // Svalbard and Jan Mayen (Norway)
        // Component(Component.country, "SE"), // Sweden
        // Component(Component.country, "CH"), // Switzerland
        // Component(Component.country, "UA"), // Ukraine
        //
        // Component(Component.country, "VA"), // Vatican City (Holy See)// Canada
      ],
    );

    displayPickUpPrediction(p!, searchScaffoldKey.currentState);
  }

  Future<void> _destinationLocation() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: mapApiKey,
      onError: onError,
      mode: _mode,
      language: 'en',
      strictbounds: false,
      types: [""],
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white)),
      ),
      components: [
        Component(Component.country, "BD"),
        Component(Component.country, "US"),
        // United States
        Component(Component.country, "GB"),
        // United Kingdom
        Component(Component.country, "CN"),
        // China
        Component(Component.country, "JP"),
        // Japan
        // Component(Component.country, "AU"), // Australia
        // Component(Component.country, "NZ"), // New Zealand
        // Component(Component.country, "CA"),
        // Component(Component.country, "AL"), // Albania
        // Component(Component.country, "AD"), // Andorra
        // Component(Component.country, "AT"), // Austria
        // Component(Component.country, "BY"), // Belarus
        // Component(Component.country, "BE"), // Belgium
        // Component(Component.country, "BA"), // Bosnia and Herzegovina
        // Component(Component.country, "BG"), // Bulgaria
        // Component(Component.country, "HR"), // Croatia
        // Component(Component.country, "CY"), // Cyprus
        // Component(Component.country, "CZ"), // Czech Republic
        // Component(Component.country, "DK"), // Denmark
        // Component(Component.country, "EE"), // Estonia
        // Component(Component.country, "FO"), // Faroe Islands (Denmark)
        // Component(Component.country, "FI"), // Finland
        // Component(Component.country, "FR"), // France
        // Component(Component.country, "DE"), // Germany
        // Component(Component.country, "GI"), // Gibraltar (United Kingdom)
        // Component(Component.country, "GR"), // Greece
        // Component(Component.country, "GG"), // Guernsey (United Kingdom)
        // Component(Component.country, "HU"), // Hungary
        // Component(Component.country, "IS"), // Iceland
        // Component(Component.country, "IE"), // Ireland
        // Component(Component.country, "IM"), // Isle of Man (United Kingdom)
        // Component(Component.country, "IT"), // Italy
        // Component(Component.country, "JE"), // Jersey (United Kingdom)
        // Component(Component.country, "XK"), // Kosovo
        // Component(Component.country, "LV"), // Latvia
        // Component(Component.country, "LI"), // Liechtenstein
        // Component(Component.country, "LT"), // Lithuania
        // Component(Component.country, "LU"), // Luxembourg
        // Component(Component.country, "MT"), // Malta
        // Component(Component.country, "MD"), // Moldova
        // Component(Component.country, "MC"), // Monaco
        // Component(Component.country, "ME"), // Montenegro
        // Component(Component.country, "NL"), // Netherlands
        // Component(Component.country, "MK"), // North Macedonia
        // Component(Component.country, "NO"), // Norway
        // Component(Component.country, "PL"), // Poland
        // Component(Component.country, "PT"), // Portugal
        // Component(Component.country, "RO"), // Romania
        // Component(Component.country, "RU"), // Russia
        // Component(Component.country, "SM"), // San Marino
        // Component(Component.country, "RS"), // Serbia
        // Component(Component.country, "SK"), // Slovakia
        // Component(Component.country, "SI"), // Slovenia
        // Component(Component.country, "ES"), // Spain
        // Component(Component.country, "SJ"), // Svalbard and Jan Mayen (Norway)
        // Component(Component.country, "SE"), // Sweden
        // Component(Component.country, "CH"), // Switzerland
        // Component(Component.country, "UA"), // Ukraine
        //
        // Component(Component.country, "VA"), // Vatican City (Holy See)// Canada
      ],
    );

    displayDestinationPrediction(p!, searchScaffoldKey.currentState);
  }

  Future<void> displayPickUpPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: mapApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      // Create a copy of the existing markers
      Set<Marker> newMarkers = {...markerList};

      // Add a marker for the searched location
      newMarkers.add(
        Marker(
          markerId: const MarkerId("searched_location"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: detail.result.name),
        ),
      );

      // Update the marker list with the new markers
      markerList = newMarkers;

      googleMapController.animateCamera(CameraUpdate.newLatLngZoom(
          LatLng(locationController.latitude.value,
              locationController.longitude.value),
          11.0));
      //storing for widget show
      selectedPickUpLocation = detail.result.name;
      newselectedPickUpLatitude = detail.result.geometry!.location.lat;
      newselectedPickUpLongitude = detail.result.geometry!.location.lng;
    });
  }

  Future<void> displayDestinationPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: mapApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    setState(() {
      // Create a copy of the existing markers
      Set<Marker> newMarkers = {...markerList};

      // Add a marker for the searched location
      newMarkers.add(
        Marker(
          markerId: const MarkerId("searched_location"),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: detail.result.name),
        ),
      );

      // Update the marker list with the new markers
      markerList = newMarkers;
      googleMapController
          .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 11.0));
      selectedDestination = detail.result.name; //storing for widget show
      selectedDestinationLatitude = detail.result.geometry!.location.lat;
      selectedDestinationLongitude = detail.result.geometry!.location.lng;
      print(
          "destinationPickUpLatitude&longitude----------------------------- >${selectedDestination}   ${selectedDestinationLatitude}  ${selectedDestinationLongitude}");
    });
  }

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Message',
        message: response.errorMessage!,
        contentType: ContentType.failure,
      ),
    ));
  }

  //-------------------------socket connection to send ride request-----------------------------
  // final socket = IO.io('https://worker.shebaone.com', <String, dynamic>{
  //   'transports': ['websocket', 'polling'],
  //   'autoConnect': false,
  // });
  //
  // void sendRideRequestThroughSocket() {
  //   // Replace 'http://your_server_address:port' with your Socket.IO server address
  //
  //   // Connect to the server
  //   socket.connect();
  //
  //   // Listen for the 'connect' event
  //   socket.on('connect', (data) {
  //     print('Connected to the server');
  //     print(socket.connected);
  //
  //     // Emit the 'patientUserRideRequestSend' event with data
  //     socket.emit('patientUserRideRequestSend',
  //         {'message': 'test again ', 'message2': 'tanim vai '});
  //
  //     // Handle the event data here
  //   });
  //
  //   // Listen for the 'patientUserRideRequestSend' event
  //   socket.on('patientUserRideRequestSend', (data) {
  //     print(
  //         'Received data from the server for patientUserRideRequestSend: $data');
  //     // Handle the data received with the event here
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   socket.disconnect();
  //   socket.dispose();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    print(
        "selectedPickUpLatitude&longitude----------------------------- >${selectedPickUpLatitude}  ${selectedPickUpLongitude}");

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markerList,
                mapType: MapType.normal,
                onMapCreated: (GoogleMapController controller) {
                  googleMapController = controller;
                },
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .51,
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                children: [
                  // Align(
                  //     alignment: Alignment.topRight,
                  //     child: GestureDetector(
                  //       onTap: () {
                  //         Navigator.pop(context);
                  //       },
                  //       child: Icon(
                  //         Icons.close,
                  //         size: 15,
                  //       ),
                  //     )),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Select pick and destination',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: _pickUpLocation,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black45, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.my_location,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            selectedPickUpLocation == ''
                                ? Text('Current Location')
                                : Text('${selectedPickUpLocation}')
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: _destinationLocation,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black45, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.my_location,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            selectedDestination == ''
                                ? Text('Destination')
                                : Text('${selectedDestination}')
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),

                  InkWell(
                      onTap: () {
                        //DistanceBetweenRiderController().checkDistance();
                      },
                      child: Text('Recent places')),

                  SizedBox(
                    height: 5,
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //Text('Recent places'),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        print("0000000000000000${newselectedPickUpLatitude}");

                        if (newselectedPickUpLatitude == null) {
                          Get.snackbar(
                              "Pickup not selected",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green.shade200,
                              "Please Select Pickup Location");
                        } else {
                          print('piclat--->${newselectedPickUpLatitude}');
                          print("piclon--->${newselectedPickUpLongitude}");

                          print(selectedDestinationLatitude);
                          print(selectedDestinationLongitude);

                          AmbulanceServiceController().sendLatLongData(
                            selectedDestinationLatitude!,
                            selectedDestinationLongitude!,
                            newselectedPickUpLatitude!,
                            newselectedPickUpLongitude!,
                            selectedPickUpLocation,
                            selectedDestination,
                          );
                        }
                      },
                      child: customButton('Confirm')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
