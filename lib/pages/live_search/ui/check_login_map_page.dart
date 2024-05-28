import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/pages/cart/ui/billing_screen.dart';
import 'package:shebaone/pages/live_search/ui/healthcare_map_page.dart';
import 'package:shebaone/pages/live_search/ui/medicine_map_page.dart';
import 'package:shebaone/pages/live_search/ui/prescription_map_page.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/services/enums.dart';

class LogInCheckLiveMapPage extends StatelessWidget {
  const LogInCheckLiveMapPage({Key? key}) : super(key: key);
  static String routeName = '/LogInCheckLiveMapPage';
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AuthController.to.getUserId.isEmpty
          ? LoginScreen(
              from: Get.previousRoute,
            )
          : AuthController.to.getUserId.isNotEmpty &&
                  AuthController.to.getIsVerified == false
              ? VerifyScreen(
                  from: BillingScreen.routeName,
                )
              : HomeController.to.liveSearchType.value ==
                      LiveSearchType.medicine
                  ? const MedicineLiveMapPage()
                  : HomeController.to.liveSearchType.value ==
                          LiveSearchType.prescription
                      ? const PrescriptionLiveMapPage()
                      : const HealthcareLiveMapPage(),
    );
  }
}
