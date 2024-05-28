import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../controllers/fitness_appointment_controller.dart';
import 'fitness_by_category_screen.dart';
import 'fitness_profile_screen.dart';

class FitnessFilterScreen extends StatefulWidget {
  const FitnessFilterScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessFilterScreen';

  @override
  State<FitnessFilterScreen> createState() => _DoctorFilterScreenState();
}

class _DoctorFilterScreenState extends State<FitnessFilterScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    FitnessController.to.doctorSearchList.value = [];
    FitnessController.to.doctorFilterList.value = [];
    super.dispose();
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      if (FitnessController.to.headline.value == 'Search Results') {
        if (!FitnessController.to.searchListLoading.value) {
          print("Doctor Listener Work");
          FitnessController.to.getSearchList('', paginateCall: true);
        }
      } else {
        ///TODO: Implement Filter
        globalLogger.d('else call');
        if (!FitnessController.to.filterAddLoading.value) {
          print("Doctor Listener Work");
          FitnessController.to.getFilterDoctorList(false, paginateCall: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        foregroundColor: kTextColor,
        title: Obx(() {
          return TitleText(
            title: FitnessController.to.headline.value,
            color: const Color(0xff363942),
            fontSize: 16,
          );
        }),
        centerTitle: true,
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(12),
            child: CustomTextButton(
              onTap: () {
                // Get.toNamed(HealthcareCartScreen.routeName);
                Get.toNamed(HealthcareLiveCartScreen.routeName);
              },
              isIconButton: true,
              buttonColor: Colors.white,
              elevation: 3,
              iconPath: 'cart-green',
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => FitnessController.to.headline.value == 'Search Results'
                  ? FitnessController.to.searchLoading.value
                      ? const Waiting()
                      : FitnessController.to.doctorSearchList.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Your selected category fitness center are not available, we are unable to book fitness center in this category for you. You may try other category/area.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: controller,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ).copyWith(
                                bottom: 110,
                              ),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount:
                                  FitnessController.to.doctorSearchList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return FitnessCard(
                                    info: FitnessController
                                        .to.doctorSearchList[index],
                                    onTap: () {
                                      FitnessAppointmentController.to
                                          .getSingleDoctor(FitnessController
                                              .to.doctorSearchList[index].id!);
                                      Get.toNamed(
                                          FitnessProfileScreen.routeName);
                                    });
                              },
                            )
                  : FitnessController.to.filterLoading.value
                      ? const Waiting()
                      : FitnessController.to.doctorFilterList.isEmpty
                          ? const Center(
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Your selected category fitness center are not available, we are unable to book fitness center in this category for you. You may try other category/area.',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          : Obx(
                              () => ListView.builder(
                                controller: controller,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ).copyWith(
                                  bottom: 110,
                                ),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: FitnessController
                                    .to.doctorFilterList.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return FitnessCard(
                                      info: FitnessController
                                          .to.doctorFilterList[index],
                                      onTap: () {
                                        FitnessAppointmentController.to
                                            .getSingleDoctor(FitnessController
                                                .to
                                                .doctorFilterList[index]
                                                .id!);
                                        Get.toNamed(
                                            FitnessProfileScreen.routeName);
                                      });
                                },
                              ),
                            ),
            ),
          ),
          if ((FitnessController.to.headline.value == 'Search Results' &&
                  FitnessController.to.searchListLoading.value) ||
              FitnessController.to.filterAddLoading.value)
            const Waiting(),
        ],
      ),
    );
  }
}
