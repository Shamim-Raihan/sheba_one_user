import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shebaone/controllers/upload_prescription_controller.dart';
import 'package:shebaone/pages/cart/ui/medicine_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/top_selling_medicine_section.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/prescription/prescription_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/offer_section.dart';
import 'package:shebaone/pages/service/ui/service_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/constants.dart';

class MedicineScreen extends StatelessWidget {
  MedicineScreen({Key? key}) : super(key: key);

  static String routeName = '/MedicineScreen';
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    Get.put<UploadPrescriptionController>(UploadPrescriptionController());
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasStyle: false,
            moduleSearch: ModuleSearch.medicine,
            onCartTapped: () {
              Get.toNamed(MedicineCartScreen.routeName);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BgContainer(
                    imagePath: 'service-bg',
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    child: MainContainerWithTitle(
                      verticalPadding: 12,
                      horizontalPadding: 20,
                      mainContainerHorizontalMargin: 24,
                      firstText: 'Upload prescription to',
                      secondText: 'order Medicine Online',
                      borderColor: kPrimaryColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    style: TextStyle(color: kPrimaryColor),
                                    children: const [
                                      TextSpan(
                                        text: 'Upload prescription\n',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      WidgetSpan(
                                        child: SizedBox(
                                          height: 8,
                                          width: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\nIf your are not sure about your medicine',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                space3C,
                                PrimaryButton(
                                  onPressed: () {
                                    Get.toNamed(PrescriptionScreen.routeName);
                                    //
                                    // final UploadPrescriptionController
                                    //     controller =
                                    //     UploadPrescriptionController.to;
                                    // uploadImageDialoge(
                                    //   context,
                                    //   camera: () async {
                                    //     Get.back();
                                    //     await _picker
                                    //         .pickImage(
                                    //             source: ImageSource.camera)
                                    //         .then((value) {
                                    //       controller.setImageList([value!]);
                                    //     });
                                    //     getLoadingDialog();
                                    //   },
                                    //   upload: () async {
                                    //     Get.back();
                                    //     await _picker.pickMultiImage().then(
                                    //       (value) {
                                    //         controller.setImageList(value!);
                                    //       },
                                    //     );
                                    //     getLoadingDialog();
                                    //   },
                                    // );
                                  },
                                  label: 'Upload Now',
                                  fontSize: 10,
                                  borderRadiusAll: 4,
                                  fontWeight: FontWeight.w500,
                                  marginVertical: 0,
                                  marginHorizontal: 0,
                                  height: 30,
                                  width: 100,
                                  contentPadding: 0,
                                )
                              ],
                            ),
                          ),
                          Image.asset(
                            'assets/images/medicine-card.png',
                            height: 150,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const TopSellingMedicineSection(
                    itemCount: 4,
                  ),
                  const AllOfferSection(),
                  const BottomImageSection(),
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
