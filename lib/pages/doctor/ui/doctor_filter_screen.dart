import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/doctor/ui/doctor_by_category_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_profile_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class DoctorFilterScreen extends StatefulWidget {
  const DoctorFilterScreen({Key? key}) : super(key: key);
  static String routeName = '/DoctorFilterScreen';

  @override
  State<DoctorFilterScreen> createState() => _DoctorFilterScreenState();
}

class _DoctorFilterScreenState extends State<DoctorFilterScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    DoctorController.to.doctorSearchList.value = [];
    DoctorController.to.doctorFilterList.value = [];
    super.dispose();
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      if (DoctorController.to.headline.value == 'Search Results') {
        if (!DoctorController.to.searchListLoading.value) {
          print("Doctor Listener Work");
          DoctorController.to.getSearchList('', paginateCall: true);
        }
      } else {
        ///TODO: Implement Filter
        globalLogger.d('else call');
        if (!DoctorController.to.filterAddLoading.value) {
          print("Doctor Listener Work");
          DoctorController.to.getFilterDoctorList(paginateCall: true);
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
            title: DoctorController.to.headline.value,
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
              () => DoctorController.to.headline.value == 'Search Results'
                  ? DoctorController.to.searchLoading.value
                      ? const Waiting()
                      : DoctorController.to.doctorSearchList.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Your selected category doctors are not available, we are unable to book doctor in this category for you. You may try other category/area.',
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
                                  DoctorController.to.doctorSearchList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return DoctorCard(
                                    info: DoctorController
                                        .to.doctorSearchList[index],
                                    onTap: () {
                                      DoctorAppointmentController.to
                                          .getSingleDoctor(DoctorController
                                              .to.doctorSearchList[index].id!);
                                      Get.toNamed(
                                          DoctorProfileScreen.routeName);
                                    });
                              },
                            )
                  : DoctorController.to.filterLoading.value
                      ? const Waiting()
                      : DoctorController.to.doctorFilterList.isEmpty
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'Your selected category doctors are not available, we are unable to book doctor in this category for you. You may try other category/area.',
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
                                  DoctorController.to.doctorFilterList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return DoctorCard(
                                    info: DoctorController
                                        .to.doctorFilterList[index],
                                    onTap: () {
                                      DoctorAppointmentController.to
                                          .getSingleDoctor(DoctorController
                                              .to.doctorFilterList[index].id!);
                                      Get.toNamed(
                                          DoctorProfileScreen.routeName);
                                    });
                              },
                            ),
            ),
          ),
          if ((DoctorController.to.headline.value == 'Search Results' &&
                  DoctorController.to.searchListLoading.value) ||
              DoctorController.to.filterAddLoading.value)
            const Waiting(),
        ],
      ),
    );
  }
}
