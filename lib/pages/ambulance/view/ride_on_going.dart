import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class RideOngoing extends StatefulWidget {
  dynamic rideData;

  RideOngoing({super.key, this.rideData});

  @override
  State<RideOngoing> createState() => _RideOngoingState();
}

class _RideOngoingState extends State<RideOngoing> {
  Set<Marker> markerList = {};
  late GoogleMapController googleMapController;

  late CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(23.8103,90.4125
    ),
    zoom: 11.0,
  );
  // @override
  // void initState() {
  //   super.initState();
  //   // Print the initial rideData
  //   print('Initial rideData: ${widget.rideData}');
  // }
  //
  // @override
  // void didUpdateWidget(covariant RideOngoing oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   // Print the updated rideData
  //   print('Updated rideData: ${widget.rideData}');
  // }

  //--------------for calling rider------------------
  _launchPhoneDialer(String phoneNumber) async {
    String uri = 'tel:$phoneNumber';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }


  double Calculation_distance=100;

  @override
  Widget build(BuildContext context) {
    print('yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy');
    print(widget.rideData);
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

                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Waiting for rider',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 1,
                  ),
                  Divider(),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rider: ${widget.rideData['data']['rider']['name']}',
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Total Charge: ${widget.rideData['data']['order']['total_charge']}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Destination: ${widget.rideData['data']['order']['destination_location']}',
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600),
                      ),
                      TextButton(onPressed: (){}, child: Text('Change Destination',style: TextStyle(color: Colors.green),))
                    ],
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(width:150,child: ElevatedButton(onPressed: (){_launchPhoneDialer('${widget.rideData['data']['rider']['phone']}');}, child: Text('Call'))),
                      Container(width:150,child: ElevatedButton(onPressed: (){}, child: Text('Message'))),
                    ],
                  )

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
