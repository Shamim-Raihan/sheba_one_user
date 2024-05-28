import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';

import 'package:shebaone/pages/ambulance/service/cancel_ride.dart';

import 'package:shebaone/pages/ambulance/service/distance_between_rider.dart';
import 'package:shebaone/pages/ambulance/view/chat_bot.dart';
import 'package:shebaone/pages/home/home_screen.dart';

import 'package:shebaone/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../services/ssl.dart';

import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;

class WaitingForRide extends StatefulWidget {
  dynamic rideData;
  double pickLat;
  double pickLon;
  double desLat;
  double desLon;

  WaitingForRide(
      {super.key,
      this.rideData,
      required this.pickLat,
      required this.pickLon,
      required this.desLat,
      required this.desLon});

  @override
  State<WaitingForRide> createState() => _WaitingForRideState();
}

class _WaitingForRideState extends State<WaitingForRide> {
  final AmbulanceServiceController ambulanceServiceController =
      Get.put(AmbulanceServiceController());

  // final DistanceBetweenRiderController distanceBetweenRiderController =
  //     Get.put(DistanceBetweenRiderController());
  Set<Marker> markerList = {};
  late GoogleMapController googleMapController;
  int selectedPaymentMethod = 0;
  bool cashOnDelivery = false;
  bool onlinePayment = false;
  bool _isMounted = true;

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(23.8103, 90.4125),
    zoom: 11.0,
  );

//----------marker for map-------------

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};
  Completer<GoogleMapController> _controller = Completer();
  late List<LatLng> latLen;

  @override
  void initState() {
    storage.initStorage;

    startRideAlertSocket();
    endRideAlertSocket();
    _getLocation();
//---for marker between places------

    latLen = [
      LatLng(widget.pickLat, widget.pickLon),
      LatLng(widget.desLat, widget.desLon),
    ];
    // initialCameraPosition = CameraPosition(
    //     target: LatLng(widget.destinationLatitude, widget.destinationLongitude),
    //     zoom: 11.0);
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

      super.initState();
    }
  }

  String latt = "";
  String lonn = "";

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        latt = "${position.latitude}";
        lonn = "${position.longitude}";
      });
    } catch (e) {
      setState(() {});
    }
  }

  ///--------------------------------start ride alert socket=-----------
  void startRideAlertSocket() async {
    try {
      print('ride started by rider-->>');
      socket = IO.io(
        "https://worker.shebaone.com",
        <String, dynamic>{
          'autoConnect': false,
          'transports': ['websocket', 'polling'],
        },
      );
      socket.connect();
      socket.on('connect', (_) {});
      socket.on('patientUserRideStartGet', (data) {
        if (data['User_Id'] == '${storage.read('User_Id')}') {
          AmbulanceServiceController().isPaid.value = true;
          Get.snackbar('Ride started', 'Ride started by Rider');
        }
      });
    } catch (e) {
      print('Error connecting to the Socket.io server');
      print(e);
    }
  }

  ///--------------------------------End ride alert socket=-----------
  void endRideAlertSocket() async {
    try {
      print('Connecting to the Socket.io server...');
      socket = IO.io(
        "https://worker.shebaone.com",
        <String, dynamic>{
          'autoConnect': false,
          'transports': ['websocket', 'polling'],
        },
      );
      socket.connect();
      socket.on('connect', (_) {});
      socket.on('patientUserRideEndGet', (data) {
        if (_isMounted && GetStorage().read('User_Id') == data['userid']) {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Rider has Completed the Ride.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      socket.dispose();
                      ambulanceServiceController.isPaid.value = false;
                      Get.offAll(() => HomeScreen());
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      });
    } catch (e) {
      print('Error connecting to the Socket.io server');
      print(e);
    }
  }

  //--------------for calling rider------------------
  _launchPhoneDialer(String phoneNumber) async {
    String uri = 'tel:$phoneNumber';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  double calculated_distance = 9000;
  bool isdistance = true;

//------------destination search for change destination button----------
  String selectedDestination = "";
  String selectedPickUpLocation = "";
  String? newDestinationName;

  // Define variables to store selected pickup and destination latitudes and longitudes
  double? selectedPickUpLatitude;
  double? selectedPickUpLongitude;
  double? selectedDestinationLatitude;
  double? selectedDestinationLongitude;
  final searchScaffoldKey = GlobalKey<ScaffoldState>();
  final Mode _mode = Mode.overlay;

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

  ///----------------------------------------------------------------
  Future<void> changeDestination(
      int? current_order_id,
      double? new_current_location_longitude,
      double? new_current_location_latitude,
      double? new_destination_location_longitude,
      double? new_destination_location_latitude,
      String? new_destination_location,
      String? new_from_location,
      double? previous_current_location_longitude,
      double? previous_current_location_latitude) async {
    GetStorage().initStorage;

    print(current_order_id);
    print(new_current_location_longitude);
    print(new_current_location_latitude);
    print(new_destination_location_longitude);
    print(new_destination_location_latitude);

    print(new_destination_location);
    print(previous_current_location_latitude);
    print(previous_current_location_longitude);
    print(new_from_location);

    try {
      final response = await http.post(
          Uri.parse(
              'https://www.shebaone.com/api/patient-user/change-destination'),
          headers: {
            'Accept': 'application/json', // Set the content type
          },
          body: {
            'current_order_id': '$current_order_id',
            'new_current_location_longitude': '$new_current_location_longitude',
            'new_current_location_latitude': '$new_current_location_latitude',
            'new_destination_location_longitude':
                '$new_destination_location_longitude',
            'new_destination_location_latitude':
                '$new_destination_location_latitude',
            'new_destination_location': '$new_destination_location',
            'new_from_location': '$new_from_location',
            'previous_current_location_longitude':
                '$previous_current_location_longitude',
            'previous_current_location_latitude':
                '$previous_current_location_latitude'
          });

      if (response.statusCode == 201) {
        storage.initStorage;
        setState(() {
          storage.write('new_destination',
              '${jsonDecode(response.body)["data"]["order"]["destination_location"]}');
          storage.write('new_total_charge',
              '${jsonDecode(response.body)["data"]["order"]["total_charge"]}');
        });

        //---------socket for cancel ride from user app-------
        socket.connect();

        socket.emit('patientUserRideDestinationChange', {
          "new_current_location_longitude": new_current_location_longitude,
          "new_current_location_latitude": new_current_location_latitude,
          "new_destination_location_longitude":
              new_destination_location_longitude,
          "new_destination_location_latitude":
              new_destination_location_latitude,
          "data": jsonDecode(response.body),
        });
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }

  ///----------------------------------------------------------------

  Future<void> displayDestinationPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GetStorage.init();
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: mapApiKey,
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

    final lat = detail.result.geometry!.location.lat;

    final lng = detail.result.geometry!.location.lng;

    storage.write('new_des_lat', lat);
    storage.write('new_des_lon', lng);
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
      newDestinationName = detail.result.name;

      // Update the marker list with the new markers
      markerList = newMarkers;

      changeDestination(
        int.parse("${widget.rideData["data"]["order"]["id"]}"),
        double.parse('$lonn'),
        double.parse('$latt'),
        double.parse('${storage.read('new_des_lon')}'),
        double.parse('${storage.read('new_des_lat')}'),
        newDestinationName,
        "${widget.rideData['data']['rider']['address']}",
        double.parse(
            '${widget.rideData['data']['rider']['current_longitude']}'),
        double.parse('${widget.rideData['data']['rider']['current_latitude']}'),
      );

      setState(() {});

      selectedDestination = detail.result.name; //storing for widget show
      selectedDestinationLatitude = detail.result.geometry!.location.lat;
      selectedDestinationLongitude = detail.result.geometry!.location.lng;
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

  //------------check distance for payment alert------
  bool selectPayment = false;

  riderLocationCheckPerHalfMinutes() async {
    print('pick lat -->$selectedPickUpLatitude $selectedPickUpLongitude');
    await DistanceBetweenRiderService()
        .distanceBetweenRider(selectedPickUpLatitude, selectedPickUpLongitude);
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      riderLocationCheckPerHalfMinutes();
    });
    return SafeArea(
      child: Scaffold(
        body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Column(
            children: [
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
              Container(
                height: MediaQuery.of(context).size.height * .51,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => Align(
                        alignment: Alignment.center,
                        child: ambulanceServiceController.isPaid == true
                            ? Text(
                                'Ride On Going',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'Waiting for Ride',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rider: ${widget.rideData['data']['rider']['name']}',
                                style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Address: ${widget.rideData['data']['rider']['address']},${widget.rideData['data']['rider']['city']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Vehicle type: ${widget.rideData['data']['rider']['vehicle_type']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Car No.: ${widget.rideData['data']['rider']['car_no']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                'Pick Up: ${widget.rideData['data']['order']['from_location']}',
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              storage.read('new_destination') == null
                                  ? Text(
                                      'Destination: ${widget.rideData['data']['order']['destination_location']}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Text(
                                      'Destination:${storage.read('new_destination')}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w600),
                                    )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            storage.read('new_total_charge') == null
                                ? Text(
                                    'Total Charge: ${double.parse(widget.rideData['data']['order']['total_charge'])}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                : Text(
                                    'Total Charge: ${storage.read('new_total_charge')}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            TextButton(
                                onPressed: () async {
                                  // SSLCTransactionInfoModel res = await sslCommerzGeneralCallTest(
                                  //     (50), 'Patient Rider');
                                  startRideAlertSocket(); //----init for ride start notification from rider
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return PaymentDialog(
                                        riderData: widget.rideData,
                                      );
                                    },
                                  );
                                },
                                child: Text('Select Payment')),
                            TextButton(
                                onPressed: () {
                                  _destinationLocation();
                                  Future.delayed(Duration(seconds: 4), () {
                                    setState(() {});
                                    print(
                                        'ccccc-->${storage.read('new_total_charge')}');
                                    super.initState();
                                  });
                                },
                                child: Text(
                                  'Change \nDestination',
                                  style: TextStyle(color: Colors.green),
                                )),
                          ],
                        ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: 150,
                            child: ElevatedButton(
                                onPressed: () {
                                  _launchPhoneDialer(
                                      '${widget.rideData['data']['rider']['phone']}');
                                },
                                child: Text('Call'))),
                        Container(
                            width: 150,
                            child: ElevatedButton(
                                onPressed: () {
                                  Get.to(() => ChatBotPage());
                                },
                                child: Text('Message'))),
                      ],
                    ),
                    Obx(
                      () => ambulanceServiceController.isPaid == false
                          ? Container(
                              width: Get.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent),
                                  onPressed: () {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                              "Are you sure to cancel the ride?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  print(
                                                      '${widget.rideData['data']['rider']['id'].toString()}');
                                                  print(
                                                      'eeeeeeeee====>${widget.rideData['data']['order']['id'].toString()}');
                                                  CancelRideService().cancelRideRequest(
                                                      '${widget.rideData['data']['rider']['id'].toString()}',
                                                      '${widget.rideData['data']['order']['id'].toString()}');
                                                },
                                                child: Text("Yes")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text("No")),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text('Cancel Ride')))
                          : Container(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentDialog extends StatefulWidget {
  final Map<String, dynamic> riderData;

  PaymentDialog({required this.riderData});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final AmbulanceServiceController ambulanceServiceController =
      Get.put(AmbulanceServiceController());
  bool cashOnDelivery = false;
  bool onlinePayment = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Payment Method'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Checkbox(
                value: cashOnDelivery,
                onChanged: (bool? value) {
                  setState(() {
                    cashOnDelivery = value!;
                    onlinePayment =
                        !value; // Uncheck Online Payment if Cash on Delivery is selected
                  });
                },
              ),
              Text('Cash on Delivery'),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: onlinePayment,
                onChanged: (bool? value) {
                  setState(() {
                    onlinePayment = value!;
                    cashOnDelivery =
                        !value; // Uncheck Cash on Delivery if Online Payment is selected
                  });
                },
              ),
              Text('Online Payment'),
            ],
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            // Add your logic based on the selected payment method

            if (cashOnDelivery) {
              GetStorage().initStorage;

              ambulanceServiceController.isPaid.value = true;

              Navigator.of(context).pop();
              paymentDoneSocketToRider();
            } else if (onlinePayment) {
              SSLCTransactionInfoModel res = await sslCommerzGeneralCallTest(
                  (storage.read('new_total_charge') == null
                      ? double.parse(
                          '${double.parse(widget.riderData['data']['order']['total_charge'])}')
                      : storage.read('new_total_charge')),
                  'Patient Rider');
              ambulanceServiceController.isPaid.value = true;
              Navigator.of(context).pop();
              paymentDoneSocketToRider();
            }

            // Close the dialog
          },
          child: Text('Continue'),
        ),
      ],
    );
  }

  //--------------payment done socket to rider----------
  paymentDoneSocketToRider() {
    GetStorage.init();
    final socket = IO.io('https://worker.shebaone.com', <String, dynamic>{
      'transports': ['websocket', 'polling'],
      'autoConnect': false,
    });

    socket.connect();

    socket.emit('patientUserRideOnlinePayment', {
      "riderId": {
        "id": "${storage.read('Rider_Id')}",
      },
    });
  }
}
