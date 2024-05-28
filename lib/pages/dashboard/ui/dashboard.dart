import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/pages/dashboard/ui/book_doctor_appointment_section.dart';
import 'package:shebaone/pages/dashboard/ui/dashboard_slider.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/dashboard/ui/offer_section.dart';
import 'package:shebaone/pages/dashboard/ui/top_order_lab_test_section.dart';
import 'package:shebaone/pages/dashboard/ui/top_selling_medicine_section.dart';
import 'package:shebaone/pages/dashboard/ui/top_services.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/doctor/ui/doctor_explore_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static String routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
 // print("User data=======>>${UserController.to.userInfo.value.name} ?? ''");
    Size size = MediaQuery.of(context).size;
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
                  children: [
                     TopServices(),//const remove by mahbub
                    // DashboardSlider(),
                    const SizedBox(
                      height: 200,
                      child: DashboardSlider(),
                    ),
                    const HealthCareSection(from: 'HOME'),

                    ExploreNowCard(
                      label: 'Live Search',
                      content: 'Product\nFrom Nearby Store\n\n',
                      imagePath: 'search_map',
                      onTap: () {
                        Get.toNamed(HealthcareScreen.routeName);
                      },
                    ),

                    const BookDocAppointmentSection(),
                    const TopSellingMedicineSection(),

                    ExploreNowCard(
                      label: 'Online Consultation',
                      content: '\nsupport from our\nspecialized doctors \n\n',
                      imagePath: 'online_doctor',
                      onTap: () {
                        DoctorAppointmentController.to.doctorViewAll(DoctorViewAll.online);
                        Get.toNamed(DoctorExploreScreen.routeName);
                      },
                    ),
                    const TopOrderLabTestSection(),

                    const DashboardInfoCard(
                      label: '1 Lakh+ Products',
                      content: 'We have large volume of\nmedicines for you...',
                      imagePath: 'dashboard-info-1',
                    ),
                    const DashboardInfoCard(
                      label: 'Secure Payment',
                      content: 'We have most secure\nonline payment for our...',
                      imagePath: 'dashboard-info-2',
                    ),
                    const DashboardInfoCard(
                      label: 'Easy Returns',
                      content: 'We ensure most efficient\nreturn policy for our...',
                      imagePath: 'dashboard-info-3',
                    ),

                    const OfferSection(),

                    const SizedBox(
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
        //                   color: Color(0xff5FC502), borderRadius: BorderRadius.horizontal(right: Radius.circular(50))),
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
    )
        // floatingActionButton: Obx(
        //   () => HealthCareController.to.getHealthcareLiveCartList.isNotEmpty
        //       ? Padding(
        //           padding: const EdgeInsets.only(bottom: 80),
        //           child: Container(
        //             color: Colors.red,
        //             height: 40,
        //             width: 40,
        //           )
        //
        //           // FloatingActionButton(
        //           //   tooltip: 'Healthcare Live Cart',
        //           //   onPressed: () {
        //           //     Get.toNamed(HealthcareLiveCartScreen.routeName);
        //           //   },
        //           //   child: Image.asset(
        //           //     'assets/icons/cart-green.png',
        //           //     color: Colors.white,
        //           //   ),
        //           // ),
        //           )
        //       : const SizedBox(),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        );
  }
}

///Call Triangle
///CustomPaint(
///                           painter: TrianglePainter(
///                             strokeColor: Colors.blue,
///                             strokeWidth: 10,
///                             paintingStyle: PaintingStyle.fill,
///                           ),
///                           child: Container(
///                             height: 10,
///                             width: 10,
///                           ),
///                         )

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor = Colors.black, this.strokeWidth = 3, this.paintingStyle = PaintingStyle.stroke});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth
      ..style = paintingStyle;

    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
