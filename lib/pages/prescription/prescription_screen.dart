import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/controllers/upload_prescription_controller.dart';
import 'package:shebaone/models/medicine_model.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/live_search/ui/check_login_map_page.dart';
import 'package:shebaone/pages/medicine/ui/all_medicine_screen.dart';
import 'package:shebaone/pages/product/ui/medicine_product_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/get_dialogs.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class PrescriptionScreen extends StatelessWidget {
  const PrescriptionScreen({Key? key}) : super(key: key);
  static String routeName = '/PrescriptionScreen';

  @override
  Widget build(BuildContext context) {
    Get.put<UploadPrescriptionController>(UploadPrescriptionController());
    return ParentPageWithNav(
      child: Column(
        children: [
          const AppBarWithSearch(
            moduleSearch: ModuleSearch.medicine,
            title: TitleText(
              title: 'Upload Prescription',
              fontSize: 18,
              color: Colors.white,
            ),
            hasStyle: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BgContainer(
                    child: Stack(
                      children: [
                        MainContainer(
                          verticalPadding: 30,
                          horizontalPadding: 20,
                          borderColor: kAssentColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(color: kPrimaryColor),
                                    children: const [
                                      TextSpan(
                                        text: 'Please upload images\n',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'of your ',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'prescription',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Image.asset(
                                'assets/icons/prescription.png',
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: 26,
                          top: 0,
                          child: Image.asset(
                            'assets/images/style-bg.png',
                            width: 120,
                          ),
                        ),
                      ],
                    ),
                  ),
                  space5C,
                  UploadPrescription(),
                  Obx(() {
                    UploadPrescriptionController controller =
                        UploadPrescriptionController.to;
                    return PrimaryButton(
                      marginHorizontal: 50,
                      height: 36,
                      contentPadding: 0,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      primary: kPrimaryColor,
                      isDisable: controller.imagePath.isEmpty,
                      label: 'Search Medicine',
                      onPressed: () async {
                        if (HealthCareController.to.confirmOrderStatus.value ||
                            MedicineController.to.confirmOrderStatus.value ||
                            PrescriptionController
                                .to.confirmOrderStatus.value) {
                          Fluttertoast.showToast(
                              msg: "Already You have one live search running!",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.redAccent,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          globalLogger.d('data');
                          final data = await HomeController.to.getPosition();
                          globalLogger.d(data);
                          if (data) {
                            // MedicineController.to
                            //     .confirmOrderStatus(false);
                            // MedicineController.to
                            //     .syncConfirmOrderStatusToLocal();
                            HomeController.to
                                .liveSearchType(LiveSearchType.prescription);
                            final dataL = await Get.toNamed(
                                LogInCheckLiveMapPage.routeName);
                            if (dataL == null) {
                              HomeController.to
                                  .liveSearchType(LiveSearchType.none);
                            }
                          }
                        }
                        // getLoadingDialog();
                        // controller.setImageList([]);
                      },
                    );
                  }),
                  if (MedicineController.to.getMedicineList.isNotEmpty)
                    const TopSellingMedicine(),
                  const SizedBox(
                    height: 110,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UploadPrescription extends StatelessWidget {
  UploadPrescription({Key? key}) : super(key: key);
  final ImagePicker _picker = ImagePicker();

  final UploadPrescriptionController controller =
      UploadPrescriptionController.to;

  @override
  Widget build(BuildContext context) {
    Get.put<UploadPrescriptionController>(UploadPrescriptionController());
    return GestureDetector(
      onTap: () {
        uploadImageDialoge(
          context,
          camera: () async {
            Get.back();
            await _picker.pickImage(source: ImageSource.camera).then((value) {
              controller.setImagePath(value!.path);
            });
          },
          upload: () async {
            Get.back();
            await _picker.pickImage(source: ImageSource.gallery).then(
              (value) {
                controller.setImagePath(value!.path);
              },
            );
          },
        );
        // final List<XFile>? images = await _picker.pickMultiImage();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(12),
          padding: const EdgeInsets.all(6),
          color: kPrimaryColor,
          strokeWidth: 1,
          dashPattern: const [1, 0, 3],
          child: Obx(() {
            UploadPrescriptionController controller =
                UploadPrescriptionController.to;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: controller.getImagePath.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/prescription.png',
                          height: 50,
                        ),
                        space2C,
                        const TitleText(
                          title: 'Upload Prescription',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    )
                  : Image.file(
                      File(controller.getImagePath),
                      fit: BoxFit.cover,
                      height: 150,
                      width: MediaQuery.of(context).size.width - 112,
                    ),

              // : Stack(
              //     children: [
              //       Row(
              //         children: [
              //           Image.file(
              //             File(controller.getImagePath[0].path),
              //             fit: BoxFit.cover,
              //             height: 150,
              //             width: controller.getImagePath.length > 1
              //                 ? (MediaQuery.of(context).size.width - 100) /
              //                     2
              //                 : MediaQuery.of(context).size.width - 112,
              //           ),
              //           if (controller.getImagePath.length > 1)
              //             Column(
              //               children: [
              //                 Image.file(
              //                   File(controller.getImagePath[1].path),
              //                   fit: controller.getImagePath.length > 2
              //                       ? BoxFit.cover
              //                       : BoxFit.fitWidth,
              //                   height: controller.getImagePath.length > 2
              //                       ? 75
              //                       : 150,
              //                   width: (MediaQuery.of(context).size.width -
              //                           112) -
              //                       (MediaQuery.of(context).size.width -
              //                               100) /
              //                           2,
              //                 ),
              //                 if (controller.getImagePath.length > 2)
              //                   Image.file(
              //                     File(controller.getImagePath[2].path),
              //                     fit: controller.getImagePath.length > 2
              //                         ? BoxFit.cover
              //                         : BoxFit.fitWidth,
              //                     height: controller.getImagePath.length > 2
              //                         ? 75
              //                         : 150,
              //                     width: (MediaQuery.of(context)
              //                                 .size
              //                                 .width -
              //                             112) -
              //                         (MediaQuery.of(context).size.width -
              //                                 100) /
              //                             2,
              //                   ),
              //               ],
              //             ),
              //         ],
              //       ),
              //       if (controller.getImagePath.length > 1)
              //         Positioned(
              //           top: 0,
              //           left: (MediaQuery.of(context).size.width - 100) / 2,
              //           child: Container(
              //             height: 150,
              //             width: controller.getImagePath.length > 1
              //                 ? (MediaQuery.of(context).size.width - 110) -
              //                     (MediaQuery.of(context).size.width -
              //                             100) /
              //                         2
              //                 : MediaQuery.of(context).size.width - 110,
              //             decoration: const BoxDecoration(
              //               color: Colors.black45,
              //             ),
              //             child: Center(
              //               child: TitleText(
              //                   title:
              //                       '+${(controller.getImagePath.length - 1).toString()}',
              //                   color: Colors.white),
              //             ),
              //           ),
              //         )
              //     ],
              //   ),
            );
          }),
        ),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  const UploadButton({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final String imagePath;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: kPrimaryColor,
                width: .5,
              ),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/$imagePath.png',
                width: 20,
              ),
            ),
          ),
          space3C,
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14, color: kTextColor),
          )
        ],
      ),
    );
  }
}

class TopSellingMedicine extends StatelessWidget {
  const TopSellingMedicine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          topMargin: 0,
          label: 'Top Selling Medicine',
          onTap: () {
            Get.toNamed(AllMedicineScreen.routeName);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              if (MedicineController.to.getMedicineList.length == 1)
                SellingMedicine(info: MedicineController.to.getMedicineList[0]),
              if (MedicineController.to.getMedicineList.length > 1)
                Expanded(
                  flex: 1,
                  child: SellingMedicine(
                      info: MedicineController.to.getMedicineList[0]),
                ),
              if (MedicineController.to.getMedicineList.length >= 2)
                Expanded(
                  flex: 1,
                  child: SellingMedicine(
                      info: MedicineController.to.getMedicineList[1]),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SellingMedicine extends StatelessWidget {
  const SellingMedicine({
    Key? key,
    this.info,
  }) : super(key: key);
  final MedicineModel? info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MedicineController.to.getSingleMedicine(info!.id!);
        Get.toNamed(MedicineProductDetailsScreen.routeName);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(color: Colors.black12, blurRadius: 4),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Stack(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/medicine.png',
                      height: 51,
                    ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffE31F29),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      '-${info!.offerPercentage}%',
                      style: const TextStyle(
                        fontSize: 6,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            space2R,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: info!.name!,
                    fontSize: 10,
                    textOverflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  TitleText(
                    title: '৳ ${info!.offerPrice}',
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ],
              ),
            ),
            space2R,
          ],
        ),
      ),
    );
  }
}
