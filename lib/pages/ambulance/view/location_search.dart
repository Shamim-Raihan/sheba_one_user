import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:geocoding/geocoding.dart' as geoCode;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:shebaone/pages/ambulance/widgets/custom_button.dart';
import 'package:shebaone/pages/ambulance/widgets/custom_text_field.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class LocationSearch extends StatefulWidget {
  LocationSearch({super.key});

  @override
  State<LocationSearch> createState() => _LocationSearchState();
}

class _LocationSearchState extends State<LocationSearch> {
  TextEditingController fromCtrl = TextEditingController();
  TextEditingController toCtrl = TextEditingController();

  //----------------------------------------Google map---------------------------------------------------------------
  GoogleMapController? _mapController;
  loc.LocationData? _locationData; // Store the current location
  loc.Location location = loc.Location();
  // Set<Circle>? circles;

  String currentLocationAddress = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadCustomIcon().then((BitmapDescriptor bitmapDescriptor) {
      setState(() {
        customIcon = bitmapDescriptor;
      });
    }); // Call this to get the current location
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await location.getLocation();
      if (locationData != null) {
        setState(() {
          _locationData = locationData;
          // Set the current location to the 'fromCtrl' text field initially
          fromCtrl.text =
              'Lat: ${locationData.latitude}, Long: ${locationData.longitude}';
        });
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

//----------------------current address from map-------------------------
  Future<void> _fetchCurrentLocationAddress(Position locationData) async {
    try {
      List<geoCode.Placemark> placemarks =
          await geoCode.placemarkFromCoordinates(
        locationData.latitude,
        locationData.longitude,
      );

      if (placemarks.isNotEmpty) {
        geoCode.Placemark placemark = placemarks[0];
        String address = placemark.thoroughfare ?? "Address not found";
        setState(() {
          currentLocationAddress = address;
        });
      } else {
        setState(() {
          currentLocationAddress = "Address not found";
        });
      }
    } catch (e) {
      print('Error fetching location address: $e');
      setState(() {
        currentLocationAddress = "Error fetching location address";
      });
    }
  }

  //------------------------------------set another location and mark it----------------------
  Set<Marker> markers = Set<Marker>();

  // Method to add a new marker to the map
  void _addMarker(LatLng position) {
    final newMarker = Marker(
      markerId: MarkerId(
          position.toString()), // You can use any unique identifier here
      position: position,
      infoWindow: InfoWindow(title: 'New Location'),
    );

    setState(() {
      markers.add(newMarker);
    });
  }

  String apiKey = "AIzaSyDMnTS3Bada4m_-coPcG46JMShU1GOsRIc";

  //------------------map tapped location------------
  // Load the custom icon image and convert it to bytes
  Future<BitmapDescriptor> _loadCustomIcon() async {
    final ByteData byteData =
        await rootBundle.rootBundle.load('assets/icons/map location.png');
    final Uint8List byteList = byteData.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(byteList);
  }

  late BitmapDescriptor customIcon;

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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              height: 350,
              child: GoogleMap(
                onMapCreated: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
                initialCameraPosition: initialCameraPosition,
                markers: <Marker>[
                  Marker(
                    markerId: MarkerId('current_location'),
                    position: LatLng(
                      _locationData?.latitude ?? 0.0,
                      _locationData?.longitude ?? 0.0,
                    ),
                    infoWindow: InfoWindow(
                      title: 'Your Location',
                    ),
                  ),
                ].toSet(),
                circles: <Circle>[
                  Circle(
                    circleId: CircleId('current_location_circle'),
                    center: LatLng(
                      _locationData?.latitude ?? 0.0,
                      _locationData?.longitude ?? 0.0,
                    ),
                    radius: 500, // Adjust the radius as needed
                    fillColor:
                        Colors.blue.withOpacity(0.2), // Circle fill color
                    strokeColor: Colors.blue, // Circle border color
                    strokeWidth: 2, // Circle border width
                  ),
                ].toSet(),
                onTap: (LatLng latLng) async {
                  List<Placemark> placemarks = await placemarkFromCoordinates(
                    latLng.latitude,
                    latLng.longitude,
                  );

                  setState(() {
                    markers.clear(); // Clear all existing markers
                    markers.add(
                      Marker(
                        icon: BitmapDescriptor.defaultMarker,
                        markerId: MarkerId('tapped_location'),
                        position: latLng,
                        infoWindow: InfoWindow(
                          title: 'Tapped Location',
                        ),
                      ),
                    );
                  });
                  if (placemarks.isNotEmpty) {
                    Placemark placemark = placemarks[0];
                    final String address = placemark.name ?? '';
                    // A custom name if available
                    final String street = placemark.street ?? '';
                    final String locality = placemark.locality ?? '';
                    final String subLocality = placemark.subLocality ?? '';
                    final String thoroughfare = placemark.thoroughfare ?? '';
                    print('aaaaaaaaaaaaaaaaaaaaaaaaaa');
                    print(address);
                    print(street);
                    print(locality);
                    print(subLocality);
                    print(thoroughfare); // Get the address name
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Address: $address'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),



            // Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 500,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    color: Colors.white),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.close,
                              size: 15,
                            ),
                          )),
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
                      CustomTextField(
                        htext: 'Current Location', //${currentLocationAddress}
                        ctrl: fromCtrl,
                        ico: Icons.my_location,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // SearchMapPlaceWidget(
                      //   apiKey: apiKey, // Your Google Maps API key
                      //   language: 'en', // Optional: specify the language for the search results
                      //   placeholder: 'Destination',
                      //   icon: Icons.location_on,
                      //   onSelected: (Place place) {
                      //     // Handle the selected location
                      //     toCtrl.text = place.description!; // Set the text field with the selected location's description
                      //     // Update the map to show the selected location
                      //     final LatLng selectedLocation = LatLng(place.lat, place.lng);
                      //     _mapController!.animateCamera(
                      //       CameraUpdate.newLatLng(selectedLocation),
                      //     );
                      //   },
                      // ),


                      CustomTextField(
                        htext: 'Destination',
                        ctrl: toCtrl,
                        ico: Icons.location_on,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Divider(),
                      Text('Recent places'),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/map.png'),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Office',
                                  style: TextStyle(
                                      color: Color(0xff5A5A5A), fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  '2.7 km',
                                  style: TextStyle(
                                      color: Color(0xff5A5A5A), fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Text(
                                '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                                style: TextStyle(
                                    color: Color(0xffB8B8B8), fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Image.asset('assets/images/map.png'),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Coffe Shop',
                                  style: TextStyle(
                                      color: Color(0xff5A5A5A), fontSize: 16),
                                ),
                                Spacer(),
                                Text(
                                  '1.2 km',
                                  style: TextStyle(
                                      color: Color(0xff5A5A5A), fontSize: 16),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Text(
                                '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                                style: TextStyle(
                                    color: Color(0xffB8B8B8), fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      //Text('Recent places'),
                      Spacer(),
                      InkWell(
                          onTap: () {
                           // Get.to(() => SelectRide());
                          },
                          child: customButton('Confirm')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
