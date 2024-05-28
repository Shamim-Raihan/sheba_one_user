import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_appointment_controller.dart';
import 'package:shebaone/controllers/fitness_controller.dart';
import 'package:shebaone/pages/fitness/ui/fitness_profile_screen.dart';

import '../../controllers/doctor_appointment_controller.dart';
import '../../controllers/doctor_controller.dart';
import '../../controllers/healthcare_controller.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/lab_controller.dart';
import '../../controllers/medicine_controller.dart';
import '../../services/enums.dart';
import '../../utils/constants.dart';
import '../../utils/widgets/network_image/network_image.dart';
import '../doctor/ui/doctor_profile_screen.dart';
import '../lab/ui/single_test_details_screen.dart';
import '../product/ui/healthcare_product_details_screen.dart';
import '../product/ui/medicine_product_details_screen.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + kToolbarHeight + 70),
          width: Get.width,
          height: Get.height * .3,
          color: Colors.white,
          child: HomeController.to.moduleSearchType.value ==
                  ModuleSearch.healthcare
              ? HealthCareController.to.healthcareSearchList.isEmpty
                  ? const Center(
                      child: Text('No Result Found!'),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: HealthCareController.to.healthcareSearchList
                            .map(
                              (e) => GestureDetector(
                                onTap: () {
                                  HealthCareController.to
                                      .getSingleProduct(e.id!);
                                  Get.toNamed(
                                      HealthcareProductDetailsScreen.routeName);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 8,
                                  ),
                                  width: Get.width,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CustomNetworkImage(
                                            networkImagePath:
                                                e.images != null &&
                                                        e.images!.isNotEmpty
                                                    ? e.images![0].imagePath!
                                                    : '',
                                            errorImagePath:
                                                'assets/icons/healthcare_primary.png',
                                            height: 25,
                                            width: 25,
                                          ),
                                          space2R,
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                text: e.name!
                                                    .toString()
                                                    .substring(
                                                        0,
                                                        HomeController.to.search
                                                            .value.length),
                                                style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: e.name!
                                                        .toString()
                                                        .substring(
                                                            HomeController
                                                                .to
                                                                .search
                                                                .value
                                                                .length),
                                                    style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Text(
                                            //   e.name!,
                                            //   style: TextStyle(
                                            //     color: kPrimaryColor,
                                            //     fontSize: 16,
                                            //     fontWeight: FontWeight.w500,
                                            //   ),
                                            // ),
                                          ),
                                          Icon(Icons.chevron_right_rounded),
                                        ],
                                      ),

                                      // Text(
                                      //   e['type'] == 'health_cares'
                                      //       ? 'HealthCare Product'
                                      //       : 'Medicine Product',
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    )
              : HomeController.to.moduleSearchType.value ==
                      ModuleSearch.medicine
                  ? MedicineController.to.medicineSearchList.isEmpty
                      ? const Center(
                          child: Text('No Result Found!'),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: MedicineController.to.medicineSearchList
                                .map(
                                  (e) => GestureDetector(
                                    onTap: () {
                                      MedicineController.to
                                          .getSingleMedicine(e.id!);
                                      Get.toNamed(MedicineProductDetailsScreen
                                          .routeName);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 8,
                                      ),
                                      width: Get.width,
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              CustomNetworkImage(
                                                networkImagePath: e.images !=
                                                            null &&
                                                        e.images!.isNotEmpty
                                                    ? e.images![0].imagePath!
                                                    : '',
                                                errorImagePath:
                                                    'assets/icons/medicine.jpg',
                                                height: 25,
                                                width: 25,
                                              ),
                                              space2R,
                                              Expanded(
                                                child: RichText(
                                                  text: TextSpan(
                                                    text: e.name!
                                                        .toString()
                                                        .substring(
                                                            0,
                                                            HomeController
                                                                .to
                                                                .search
                                                                .value
                                                                .length),
                                                    style: TextStyle(
                                                      color: kPrimaryColor,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text: e.name!
                                                            .toString()
                                                            .substring(
                                                                HomeController
                                                                    .to
                                                                    .search
                                                                    .value
                                                                    .length),
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                //   Text(
                                                //     e.name!,
                                                //     style: TextStyle(
                                                //       color: kPrimaryColor,
                                                //       fontSize: 16,
                                                //       fontWeight: FontWeight.w500,
                                                //     ),
                                                //   ),
                                              ),
                                              Icon(Icons.chevron_right_rounded),
                                            ],
                                          ),
                                          // Text(
                                          //   e['type'] == 'health_cares'
                                          //       ? 'HealthCare Product'
                                          //       : 'Medicine Product',
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                  : HomeController.to.moduleSearchType.value == ModuleSearch.lab
                      ? LabController.to.labSearchListByKey.isEmpty
                          ? const Center(
                              child: Text('No Result Found!'),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: LabController.to.labSearchListByKey
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          LabController.to.singleLabTest(e);
                                          LabController.to
                                              .getFilterLabData(e.id!);
                                          Get.toNamed(SingleTestDetailsScreen
                                              .routeName);
                                          HomeController.to.search('');
                                          LabController.to
                                              .labSearchListByKey([]);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 8,
                                          ),
                                          width: Get.width,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/test.png',
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  space2R,
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: e.testName!
                                                            .toString()
                                                            .substring(
                                                                0,
                                                                HomeController
                                                                    .to
                                                                    .search
                                                                    .value
                                                                    .length),
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: e.testName!
                                                                .toString()
                                                                .substring(
                                                                    HomeController
                                                                        .to
                                                                        .search
                                                                        .value
                                                                        .length),
                                                            style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    // Text(
                                                    //   e.testName!,
                                                    //   style: TextStyle(
                                                    //     color: kPrimaryColor,
                                                    //     fontSize: 16,
                                                    //     fontWeight: FontWeight.w500,
                                                    //   ),
                                                    // ),
                                                  ),
                                                  Icon(Icons
                                                      .chevron_right_rounded),
                                                ],
                                              ),

                                              // Text(
                                              //   e['type'] == 'health_cares'
                                              //       ? 'HealthCare Product'
                                              //       : 'Medicine Product',
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            )
                      : HomeController.to.moduleSearchType.value ==
                              ModuleSearch.doctor
                          ? DoctorController.to.doctorSearchListByKey.isEmpty
                              ? const Center(
                                  child: Text('No Result Found!'),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: DoctorController
                                        .to.doctorSearchListByKey
                                        .map(
                                          (e) => GestureDetector(
                                            onTap: () {
                                              DoctorAppointmentController.to
                                                  .getSingleDoctor(e.id!);
                                              Get.toNamed(DoctorProfileScreen
                                                  .routeName);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 24,
                                                vertical: 8,
                                              ),
                                              width: Get.width,
                                              color: Colors.white,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  RichText(
                                                    text: TextSpan(
                                                      text: e.name!
                                                          .toString()
                                                          .substring(
                                                              0,
                                                              HomeController
                                                                  .to
                                                                  .search
                                                                  .value
                                                                  .length),
                                                      style: TextStyle(
                                                        color: kPrimaryColor,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      children: [
                                                        TextSpan(
                                                          text: e.name!
                                                              .toString()
                                                              .substring(
                                                                  HomeController
                                                                      .to
                                                                      .search
                                                                      .value
                                                                      .length),
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                          : HomeController.to.moduleSearchType.value ==
                                  ModuleSearch.fitness
                              ? FitnessController
                                      .to.doctorSearchListByKey.isEmpty
                                  ? const Center(
                                      child: Text('No Result Found!'),
                                    )
                                  : SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: FitnessController
                                            .to.doctorSearchListByKey
                                            .map(
                                              (e) => GestureDetector(
                                                onTap: () {
                                                  FitnessAppointmentController
                                                      .to
                                                      .getSingleDoctor(e.id!);
                                                  Get.toNamed(
                                                      FitnessProfileScreen
                                                          .routeName);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 24,
                                                    vertical: 8,
                                                  ),
                                                  width: Get.width,
                                                  color: Colors.white,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      RichText(
                                                        text: TextSpan(
                                                          text: e.name!
                                                              .toString()
                                                              .substring(
                                                                  0,
                                                                  HomeController
                                                                      .to
                                                                      .search
                                                                      .value
                                                                      .length),
                                                          style: TextStyle(
                                                            color:
                                                                kPrimaryColor,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                          children: [
                                                            TextSpan(
                                                              text: e.name!
                                                                  .toString()
                                                                  .substring(
                                                                      HomeController
                                                                          .to
                                                                          .search
                                                                          .value
                                                                          .length),
                                                              style: TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    )
                              : const SizedBox(),
        ));
  }
}
