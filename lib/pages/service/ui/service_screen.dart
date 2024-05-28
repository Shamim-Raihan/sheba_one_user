import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/pages/dashboard/ui/book_doctor_appointment_section.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/doctor/ui/doctor_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/medicine/ui/medicine_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/offer_section.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../fitness/ui/fitness_screen.dart';
import '../../women_corner/women_corner_screen.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              const AppBarWithSearch(
                moduleSearch: ModuleSearch.none,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: const [
                      TopServicesForService(),
                      HealthCareSection(from: 'HOME'),
                      BookDocAppointmentSection(),

                      ///TODO: length null error. //Need to fix
                      AllOfferSection(),
                      BottomImageSection(),
                      SizedBox(
                        height: 110,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          // Positioned(
          //   bottom: 100,
          //   child: Obx(
          //     () => HealthCareController.to.getHealthcareLiveCartList.isNotEmpty
          //         ? GestureDetector(
          //             onTap: () {
          //               Get.toNamed(HealthcareLiveCartScreen.routeName);
          //             },
          //             child: Container(
          //               padding: const EdgeInsets.all(8),
          //               decoration: const BoxDecoration(
          //                   color: Color(0xff5FC502),
          //                   borderRadius: BorderRadius.horizontal(right: Radius.circular(50))),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Row(
          //                     children: [
          //                       space2R,
          //                       Image.asset(
          //                         'assets/icons/cart-green.png',
          //                         color: Colors.white,
          //                         height: 24,
          //                       ),
          //                     ],
          //                   ),
          //                   const Text(
          //                     'Healthcare\nLive Cart',
          //                     style: TextStyle(fontSize: 12, color: Colors.white),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           )
          //         : SizedBox(),
          //   ),
          // ),
        ],
      ),
      // floatingActionButton: Obx(
      //   () => HealthCareController.to.getHealthcareLiveCartList.isNotEmpty
      //       ? Padding(
      //           padding: const EdgeInsets.only(bottom: 80),
      //           child: FloatingActionButton(
      //             tooltip: 'Healthcare Live Cart',
      //             onPressed: () {
      //               Get.toNamed(HealthcareLiveCartScreen.routeName);
      //             },
      //             child: Image.asset(
      //               'assets/icons/cart-green.png',
      //               color: Colors.white,
      //             ),
      //           ),
      //         )
      //       : const SizedBox(),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class TopServicesForService extends StatelessWidget {
  const TopServicesForService({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BgContainer(
      imagePath: 'service-bg',
      horizontalPadding: 0,
      verticalPadding: 0,
      child: MainContainerWithTitle(
        firstText: 'Let’s Explore...',
        secondText: 'Our Top Services',
        child: Column(
          children: [
            Row(
              children: [
                TopServicesItem(
                  onTap: () {
                    Get.toNamed(FitnessScreen.routeName);
                  },
                  label: 'Fitness\nAppointment',
                  imagePath: 'doc-appointment',
                ),
                space3R,
                TopServicesItem(
                  onTap: () {
                    Get.toNamed(WomenCornerScreen.routeName);
                  },
                  label: 'Women\nCorner',
                  imagePath: 'healthcare_primary',
                ),
              ],
            ),
            space3C,
            Row(
              children: [
                TopServicesItem(
                  onTap: () {
                    Get.toNamed(DoctorScreen.routeName);
                  },
                  label: 'Doctor\nAppoinment',
                  imagePath: 'doc_primary',
                ),
                space3R,
                TopServicesItem(
                  onTap: () {
                    Get.toNamed(HealthcareScreen.routeName);
                  },
                  label: 'Healthcare\nProducts',
                  imagePath: 'healthcare_primary',
                ),
              ],
            ),
            space3C,
            Row(
              children: [
                TopServicesItem(
                  onTap: () {
                    Get.toNamed(LabScreen.routeName);
                  },
                  label: 'Laboratory\nTests',
                  imagePath: 'lab_test_primary',
                ),
                space3R,
                TopServicesItem(
                  onTap: () {
                   // Get.to(() => LocationSearch());
                  },
                  label: 'Ambulance/\nPatient Car',
                  imagePath: 'order-medicine',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MainContainerWithTitle extends StatelessWidget {
  const MainContainerWithTitle({
    Key? key,
    this.firstText,
    this.secondText,
    this.horizontalPadding,
    this.verticalPadding,
    this.borderColor,
    this.mainContainerHorizontalMargin,
    this.mainContainerVerticalMargin,
    this.child,
  }) : super(key: key);
  final String? firstText, secondText;
  final Widget? child;
  final Color? borderColor;
  final double? horizontalPadding, mainContainerHorizontalMargin;
  final double? verticalPadding, mainContainerVerticalMargin;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TitleText(
                title: firstText!,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.normal,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            space1C,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: TitleText(
                title: secondText!,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            space6C,
            MainContainer(
              color: kScaffoldColor,
              borderRadius: 12,
              verticalPadding: verticalPadding ?? 24,
              horizontalPadding: horizontalPadding ?? 16,
              borderColor: borderColor ?? Colors.transparent,
              horizontalMargin: mainContainerHorizontalMargin ?? 0,
              verticalMargin: mainContainerVerticalMargin ?? 0,
              child: child,
            ),
          ],
        ),
        Positioned(
          right: 40,
          top: 0,
          child: Image.asset(
            'assets/images/style-bg-medium.png',
            width: 97,
          ),
        ),
      ],
    );
  }
}

class TopServicesItem extends StatelessWidget {
  const TopServicesItem({
    Key? key,
    required this.imagePath,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String label, imagePath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: 80,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/icons/$imagePath.png',
                  height: 33,
                ),
              ),
              space3C,
              TitleText(
                title: label,
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
