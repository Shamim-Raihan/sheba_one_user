import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/view/search_location_on_map.dart';
import 'package:shebaone/pages/doctor/ui/doctor_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/home/home_page.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/medicine/ui/medicine_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/pages/women_corner/women_corner_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/global.dart';

class TopServices extends StatelessWidget {
  final AmbulanceServiceController locationController =
      Get.find<AmbulanceServiceController>();
  TopServices({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BgContainer(
      horizontalPadding: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: kPrimaryColor,
            width: .5,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                'assets/images/style-bg.png',
                width: MediaQuery.of(context).size.width - 64,
                height: 190,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                children: [
                  TitleText(
                    title: 'Let’s Explore Our Top Services',
                    fontSize: 16,
                    color: kTextColor,
                  ),
                  space4C,
                  Row(
                    children: [
                      ServiceItem(
                        label: 'Fitness\nAppointment',
                        iconPath: 'doc-appointment',
                        onTap: () {
                          Get.toNamed(FitnessScreen.routeName);
                        },
                      ),
                      ServiceItem(
                        label: 'Women\nCorner',
                        iconPath: 'women-corner',
                        onTap: () {
                          Get.toNamed(WomenCornerScreen.routeName);
                        },
                      ),
                      ServiceItem(
                        label: 'Doctor\nAppointment',
                        iconPath: 'doc-appointment',
                        onTap: () {
                          Get.toNamed(DoctorScreen.routeName);
                        },
                      ),
                    ],
                  ),
                  space4C,
                  Row(
                    children: [
                      ServiceItem(
                        label: 'Healthcare\nProducts',
                        iconPath: 'healthcare',
                        onTap: () {
                          Get.toNamed(HealthcareScreen.routeName);
                        },
                      ),
                      ServiceItem(
                        label: 'Laboratory\nTests',
                        iconPath: 'lab-test',
                        onTap: () {
                          Get.toNamed(LabScreen.routeName);
                        },
                      ),
                      ServiceItem(
                        label: 'Ambulance/\nPatient Car',
                        iconPath: 'order-medicine',
                        onTap: () async {
                          AuthController.to.isAmulance == true;
                          storage.write("isAmulance", "yes");
                          storage.write('ambulanceRide', true);
                          AuthController authController = AuthController.to;

                          if (authController.getUserId.isEmpty) {
                            Get.to(() => LoginScreen());
                          } else if (authController.getUserId.isNotEmpty &&
                              authController.getIsVerified == false) {
                            print(
                                'kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk');
                            print(authController.getUserId);
                            print(authController.getIsVerified);
                            Get.to(() => VerifyScreen());
                          }
                          else {
                            await locationController.getCurrentLocation();
                            Get.to(()=>SearchLocationOnMap(
                                            initialCameraPosition: CameraPosition(
                                          target: LatLng(
                                              locationController.latitude.value,
                                              locationController.longitude.value),
                                        zoom: 15.0,
                                       )));
                          }
                         // else  {
                         //
                         //    await locationController.getCurrentLocation();
                         //    Get.to(() => SearchLocationOnMap(
                         //            initialCameraPosition: CameraPosition(
                         //          target: LatLng(
                         //              locationController.latitude.value,
                         //              locationController.longitude.value),
                         //          zoom: 15.0,
                         //        )));
                         //  }
                        },
                      ),
                    ],
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

class ServiceItem extends StatelessWidget {
  const ServiceItem({
    required this.label,
    required this.iconPath,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String label;
  final String iconPath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: Get.width,
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: TitleText(
                title: label,
                fontSize: 11,
                textAlign: TextAlign.center,
                color: Colors.white,
                textOverflow: TextOverflow.ellipsis,
              ),
              // Image.asset(
              //   'assets/icons/$iconPath.png',
              //   height: 20,
              // ),
            ),
            // space3C,
            // TitleText(
            //   title: label,
            //   fontSize: 12,
            //   textAlign: TextAlign.center,
            //   textOverflow: TextOverflow.ellipsis,
            // ),
          ],
        ),
      ),
    );
  }
}
