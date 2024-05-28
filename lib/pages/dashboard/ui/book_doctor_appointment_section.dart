import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/models/doctor_model.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/doctor/ui/doctor_explore_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class BookDocAppointmentSection extends StatefulWidget {
  const BookDocAppointmentSection({
    Key? key,
  }) : super(key: key);

  @override
  State<BookDocAppointmentSection> createState() =>
      _BookDocAppointmentSectionState();
}

class _BookDocAppointmentSectionState extends State<BookDocAppointmentSection> {
  int page = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          label: 'Book Doctor Appointment',
          onTap: () {
            print('see all');
            DoctorAppointmentController.to.doctorViewAll(DoctorViewAll.generic);
            Get.toNamed(DoctorExploreScreen.routeName);
          },
        ),
        Stack(
          children: [
            Obx(
              () => GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 215,
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount:
                    DoctorAppointmentController.to.specialityDoctorList.length >
                            4
                        // && page == 0
                        ? 4
                        : DoctorAppointmentController
                            .to.specialityDoctorList.length,
                // > (page + 1) * 4
                //     ? 4
                //     : DoctorAppointmentController.to.doctorSpecialityList.length - page * 4,
                itemBuilder: (BuildContext ctx, index) {
                  return BookDoctorItem(
                    info: DoctorAppointmentController
                        .to.specialityDoctorList[index],
                    onTap: () {
                      DoctorAppointmentController.to.getSingleDoctor(
                          DoctorAppointmentController
                              .to.specialityDoctorList[index].id!);
                      Get.toNamed(DoctorProfileScreen.routeName);
                      // locationDialog(
                      //     context,
                      //     DoctorAppointmentController.to.doctorSpecialityList[(page * 4) + index].specialization!,
                      //     DoctorByEnum.speciality);
                    },
                  );
                },
              ),
            ),
            // if (DoctorAppointmentController.to.doctorSpecialityList.length > (page + 1) * 4)
            //   Positioned(
            //     right: 10,
            //     bottom: 227,
            //     child: ArrowButton(
            //       color: Colors.white,
            //       iconColor: kAssentColor,
            //       iconData: Icons.arrow_forward_ios_rounded,
            //       onPressed: () {
            //         setState(() {
            //           page = page + 1;
            //         });
            //         print(page);
            //       },
            //     ),
            //   ),
            // if (page != 0)
            //   Positioned(
            //     left: 10,
            //     bottom: 227,
            //     child: ArrowButton(
            //       color: Colors.white,
            //       iconColor: kAssentColor,
            //       iconData: Icons.arrow_back_ios_rounded,
            //       onPressed: () {
            //         page = page - 1;
            //         setState(() {});
            //         print(page);
            //       },
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }
}

class BookDoctorItem extends StatelessWidget {
  const BookDoctorItem({
    Key? key,
    required this.info,
    this.onTap,
  }) : super(key: key);
  final DoctorModel info;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 88,
              width: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(88),
                border: Border.all(color: kAssentColor),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(76),
                  child: CustomNetworkImage(
                    networkImagePath: info.imagePath!,
                    borderRadius: 5,
                    width: 76,
                    height: 76,
                  ),
                ),
              ),
            ),
            space2C,
            TitleText(
              title: info.name!,
              fontSize: 14,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
            space1C,
            Obx(() {
              return TitleText(
                title: DoctorAppointmentController.to
                    .getSpecializationName(info.specialization!),
                fontSize: 8,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              );
            }),
            space3C,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kAssentColor),
              ),
              child: const TitleText(
                title: 'View Profile',
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
