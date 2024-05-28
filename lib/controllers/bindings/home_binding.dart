import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/controllers/fitness_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/controller/distance_between_rider_controller.dart';

import '../fitness_appointment_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<HealthCareController>(HealthCareController(), permanent: true);
    Get.put<MedicineController>(MedicineController(), permanent: true);
    Get.put<LabController>(LabController(), permanent: true);
    Get.put<DoctorController>(DoctorController(), permanent: true);
    Get.put<FitnessController>(FitnessController(), permanent: true);
    Get.put<PrescriptionController>(PrescriptionController(), permanent: true);
    Get.put<DoctorAppointmentController>(DoctorAppointmentController(),
        permanent: true);
    Get.put<FitnessAppointmentController>(FitnessAppointmentController(),
        permanent: true);
    Get.lazyPut<AmbulanceServiceController>(() => AmbulanceServiceController());
    // Get.lazyPut<DistanceBetweenRiderController>(
    //     () => DistanceBetweenRiderController());
  }
}
