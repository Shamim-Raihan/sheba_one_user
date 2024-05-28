import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/view/search_location_on_map.dart';
import 'package:shebaone/utils/global.dart';

class CancelRideService {
  Future<void> cancelRideRequest(String? riderId, String? orderId) async {
    final AmbulanceServiceController locationController =
        Get.find<AmbulanceServiceController>();
    try {
      final response = await http.post(
          Uri.parse(
              'https://www.shebaone.com/api/patient-user/ride-cancel/$orderId'),
          headers: {
            'Accept': 'application/json', // Set the content type
          },
          body: {
            'rider_id': riderId
          });

      if (response.statusCode == 201) {
        print('ride request canceled successfully');
        print(response.statusCode);
        //---------socket for cancel ride from user app-------
        socket.connect();
        socket.emit('patientUserRideCancel', [response.body]);
        print('emitted ---->>>>>>>>Cancel');
        await locationController.getCurrentLocation();
        Get.offAll(() => SearchLocationOnMap(
                initialCameraPosition: CameraPosition(
              target: LatLng(locationController.latitude.value,
                  locationController.longitude.value),
              zoom: 15.0,
            )));
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
