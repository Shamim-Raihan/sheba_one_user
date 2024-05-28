import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class DistanceBetweenRiderService {
  double distanceValue = 0.0; // Variable to store the distance value
  double rider_latitude = 0.0;
  double rider_longitude = 0.0;
  dynamic riderId = GetStorage().read('Rider_Id');
  Future<void> distanceBetweenRider(
      double? pickUpLat, double? pickUpLon) async {
    try {
      GetStorage.init();

      final response = await http.post(
        Uri.parse(
            'https://www.shebaone.com/api/patient-user/rider/${riderId}/distance'),
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'current_location_latitude': pickUpLat,
          'current_location_longitude': pickUpLon,
        },
      );

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('--->....$data');

        // Extract the distance value from the "data" field
        final double distance = data['data']['distance'] ?? 0.0;
        final double riderLat =
            data['data']['rider']['current_latitude'] ?? 0.0;
        final double riderLon =
            data['data']['rider']['current_longitude'] ?? 0.0;
        distanceValue = distance;
        rider_latitude = riderLat;
        rider_longitude = riderLon;

        print('Distance: $distanceValue');
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } finally {}
  }
}
