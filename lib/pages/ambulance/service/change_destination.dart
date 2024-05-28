import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/view/search_location_on_map.dart';
import 'package:shebaone/utils/global.dart';

class ChangeDestinationService {
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
    final AmbulanceServiceController locationController =
        Get.find<AmbulanceServiceController>();
    print('qqqqqqqq----------------uuuuuuuuuuuuuuuuuuuuuuuuu');
    print(current_order_id);
    print(new_current_location_longitude);
    print(new_current_location_latitude);
    print(new_destination_location);
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

            // 'current_order_id': 3.toString(),
            // 'new_current_location_longitude': 89.92.toString(),
            // 'new_current_location_latitude': 24.25.toString(),
            // 'new_destination_location_longitude': 98.23.toString(),
            // 'new_destination_location_latitude': 22.45.toString(),
            // 'new_destination_location': 'tangail',
            // 'new_from_location': 'rajbari',
            // 'previous_current_location_longitude': 97.36.toString(),
            // 'previous_current_location_latitude': 22.45.toString()
          });
      print('====---->>>${response.body}');
      if (response.statusCode == 201) {
        storage.initStorage;
        storage.write('new_destination',
            '${jsonDecode(response.body)["data"]["order"]["destination_location"]}');
        storage.write('new_total_charge',
            '${jsonDecode(response.body)["data"]["order"]["total_charge"]}');
        print('====---->>>${response.body}');
        print('====xfdf---->>>${storage.read('new_destination')}');
        //---------socket for cancel ride from user app-------
        socket.connect();
        socket.emit(
            'patientUserRideDestinationChange', [jsonDecode(response.body)]);

        print(
            "=======destination_location=========${jsonDecode(response.body)["data"]["order"]["destination_location"]}");
        print(
            "=======distance=========${jsonDecode(response.body)["data"]["order"]["distance"]}");
        print(
            "=======total_charge=========${jsonDecode(response.body)["data"]["order"]["total_charge"]}");

        AmbulanceServiceController().new_destination.value =
            '${jsonDecode(response.body)["data"]["order"]["destination_location"]}';
        AmbulanceServiceController().new_total_charge.value =
            '${jsonDecode(response.body)["data"]["order"]["total_charge"]}';
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
