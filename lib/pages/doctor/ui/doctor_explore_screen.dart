import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/doctor/ui/doctor_by_category_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class DoctorExploreScreen extends StatefulWidget {
  const DoctorExploreScreen({Key? key}) : super(key: key);
  static String routeName = '/DoctorExploreScreen';

  @override
  State<DoctorExploreScreen> createState() => _DoctorExploreScreenState();
}

class _DoctorExploreScreenState extends State<DoctorExploreScreen> {
  int _activeIndex = 0;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    if (_activeIndex == 0) {
      print('called!');
      if (DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic) {
        DoctorAppointmentController.to.getAllDoctor();
      } else {
        DoctorAppointmentController.to.getAllOnlineDoctor('All');
      }

      controller.addListener(_scrollListener);
    }
    super.initState();
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    // print(controller.position.pixels);
    // print(controller.position.maxScrollExtent);
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      //.5
      if (DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic) {
        if (!DoctorAppointmentController.to.addDoctorLoading.value) {
          print("Condition Work");
          await DoctorAppointmentController.to.getAllDoctor(true);
        }
      } else {
        if (!DoctorAppointmentController.to.addOnlineDoctorLoading.value) {
          print("Condition Work");
          await DoctorAppointmentController.to
              .getAllOnlineDoctor(DoctorAppointmentController.to.onlineSpeciality[_activeIndex], true);
        }
      }
      // Provider.of<HomeProvider>(context, listen: false)
      //     .loadMoreProgram(Storage.getUser().id);
    }
  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   DoctorAppointmentController.to.getDoctorListByCategory(
  //       DoctorAppointmentController
  //           .to.getDoctorSpecialityList[0].specialization!,
  //       DoctorByEnum.speciality,
  //       '');
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        foregroundColor: kTextColor,
        title: Obx(
          () => TitleText(
            title: DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic
                ? "Doctors by Speciality"
                : 'Online Doctors',
            color: const Color(0xff363942),
            fontSize: 16,
          ),
        ),
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
          SizedBox(
            height: 34,
            child: Obx(
              () => ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                scrollDirection: Axis.horizontal,
                itemCount: DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic
                    ? DoctorAppointmentController.to.doctorSpecialityStringList.length
                    : DoctorAppointmentController.to.onlineSpeciality.length,
                itemBuilder: (BuildContext ctx, index) {
                  return ToggleButton(
                    ///TODO: ALL Filter ADD
                    // label: DoctorAppointmentController
                    //     .to.getDoctorSpecialityList[index].specialization!,
                    label: DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic
                        ? DoctorAppointmentController.to.doctorSpecialityStringList[index]
                        : index == 0
                            ? DoctorAppointmentController.to.onlineSpeciality[index]
                            : DoctorAppointmentController.to
                                .getSpecializationName(DoctorAppointmentController.to.onlineSpeciality[index]),
                    isActive: index == _activeIndex,
                    onTap: () {
                      _activeIndex = index;
                      setState(() {});
                      if (DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic) {
                        globalLogger.d(DoctorAppointmentController.to.doctorSpecialityStringList);
                        if (_activeIndex != 0) {
                          DoctorAppointmentController.to.getDoctorListByCategory(
                              DoctorAppointmentController.to.getSpecializationId(
                                  DoctorAppointmentController.to.doctorSpecialityStringList[index]),
                              DoctorByEnum.speciality,
                              '');
                        }
                      } else {
                        DoctorAppointmentController.to
                            .getOnlineDoctorBySpeciality(DoctorAppointmentController.to.onlineSpeciality[index]);
                      }
                      // if (_activeIndex != 0) {
                      //   DoctorAppointmentController.to.getDoctorListByCategory(
                      //       DoctorAppointmentController
                      //           .to.doctorSpecialityStringList[index],
                      //       DoctorByEnum.speciality,
                      //       '');
                      // }
                    },
                  );
                },
              ),
            ),
          ),
          space3C,
          Expanded(
            child: Obx(
              () => DoctorAppointmentController.to.doctorViewAll.value == DoctorViewAll.generic
                  ? (_activeIndex != 0
                      ? (DoctorAppointmentController.to.doctorByCategoryLoading.value
                          ? const Waiting()
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: DoctorAppointmentController.to.getDoctorByCategoryList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return DoctorCard(
                                  info: DoctorAppointmentController.to.getDoctorByCategoryList[index],
                                  onTap: () {
                                    DoctorAppointmentController.to.getSingleDoctor(
                                        DoctorAppointmentController.to.getDoctorByCategoryList[index].id!);
                                    Get.toNamed(DoctorProfileScreen.routeName);
                                  },
                                );
                              },
                            ))
                      : DoctorAppointmentController.to.doctorLoading.value
                          ? const Waiting()
                          : ListView.builder(
                              controller: controller,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemCount: DoctorAppointmentController.to.getDoctorList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return DoctorCard(
                                  info: DoctorAppointmentController.to.getDoctorList[index],
                                  onTap: () async {
                                    await DoctorAppointmentController.to
                                        .getSingleDoctor(DoctorAppointmentController.to.getDoctorList[index].id!);
                                    Get.toNamed(DoctorProfileScreen.routeName);
                                  },
                                );
                              },
                            ))
                  : DoctorAppointmentController.to.onlineDoctorLoading.value
                      ? const Waiting()
                      : ListView.builder(
                          controller: controller,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemCount: DoctorAppointmentController.to.onlineDoctorList.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return DoctorCard(
                              info: DoctorAppointmentController.to.onlineDoctorList[index],
                              onTap: () async {
                                await DoctorAppointmentController.to
                                    .getSingleDoctor(DoctorAppointmentController.to.onlineDoctorList[index].id!);
                                Get.toNamed(DoctorProfileScreen.routeName);
                              },
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}

class ToggleButton extends StatelessWidget {
  const ToggleButton({
    Key? key,
    this.isActive = false,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final bool isActive;
  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: isActive ? kPrimaryColor : Colors.white,
          border: Border.all(color: kPrimaryColor),
        ),
        child: Center(
          child: TitleText(
            title: label,
            color: isActive ? Colors.white : kPrimaryColor,
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
