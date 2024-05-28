import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/upload_prescription_controller.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/dashboard_slider.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_category_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/lab_health_checkup_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_test_category_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/get_dialogs.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/url_utils.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class LabScreen extends StatefulWidget {
  const LabScreen({Key? key}) : super(key: key);
  static String routeName = '/LabScreen';

  @override
  State<LabScreen> createState() => _LabScreenState();
}

class _LabScreenState extends State<LabScreen> {
  final ImagePicker _picker = ImagePicker();
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  bool isTapUpload = false;
  XFile? image;
  int fileNameIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    super.initState();
  }

  String? errorMobile;

  @override
  void dispose() {
    // TODO: implement dispose
    if (_phoneController != null) {
      _phoneController!.dispose();
    }
    if (_nameController != null) {
      _nameController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put<UploadPrescriptionController>(UploadPrescriptionController());

    return Scaffold(
      body: Stack(
        children: [
          ParentPageWithNav(
            child: Column(
              children: [
                AppBarWithSearch(
                  moduleSearch: ModuleSearch.lab,
                  onCartTapped: () {
                    Get.toNamed(LabCartScreen.routeName);
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const BgContainer(
                          horizontalPadding: 0,
                          verticalPadding: 0,
                          child: SizedBox(
                            height: 200,
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: DashboardSlider(
                                margin: 0,
                              ),
                            ),
                          ),
                        ),
                        const TopPackageService(),
                        GestureDetector(
                          onTap: () {
                            isTapUpload = true;
                            setState(() {});
                          },
                          child: Container(
                            margin: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24).copyWith(right: 8),
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
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              WidgetSpan(
                                                child: SizedBox(
                                                  height: 8,
                                                  width: 10,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '\nIf your are not sure about your lab test',
                                                style: TextStyle(
                                                    fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                        // space3C,
                                        // PrimaryButton(
                                        //   borderColor: Colors.white,
                                        //   onPressed: () {
                                        //     isTapUpload = true;
                                        //     setState(() {});
                                        //     // final UploadPrescriptionController
                                        //     //     controller =
                                        //     //     UploadPrescriptionController.to;
                                        //     // uploadImageDialoge(
                                        //     //   context,
                                        //     //   camera: () async {
                                        //     //     Get.back();
                                        //     //     await _picker
                                        //     //         .pickImage(
                                        //     //             source: ImageSource.camera)
                                        //     //         .then((value) {
                                        //     //       controller.setImageList([value!]);
                                        //     //     });
                                        //     //     getLoadingDialog();
                                        //     //   },
                                        //     //   upload: () async {
                                        //     //     Get.back();
                                        //     //     await _picker.pickMultiImage().then(
                                        //     //       (value) {
                                        //     //         controller.setImageList(value!);
                                        //     //       },
                                        //     //     );
                                        //     //     getLoadingDialog();
                                        //     //   },
                                        //     // );
                                        //   },
                                        //   label: 'Upload Now',
                                        //   fontSize: 10,
                                        //   borderRadiusAll: 4,
                                        //   fontWeight: FontWeight.w500,
                                        //   marginVertical: 0,
                                        //   marginHorizontal: 0,
                                        //   height: 30,
                                        //   width: 100,
                                        //   contentPadding: 0,
                                        // )
                                      ],
                                    ),
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
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF3EF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xff5FC502),
                            ),
                          ),
                          child: Column(
                            children: [
                              const TitleText(
                                title: 'Don’t Have Prescription ?',
                                color: Color(0xff343C44),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              HorizontalDivider(
                                color: kPrimaryColor,
                                thickness: 1,
                                horizontalMargin: Get.width * .2,
                              ),
                              // space2C,
                              // const TitleText(
                              //   title: '01745698404',
                              //   fontSize: 12,
                              // ),
                              space2C,
                              const TitleText(
                                title: 'Call Hotline for Enquiry',
                                color: Color(0xff343C44),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              space4C,
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () {
                                  Utils.makePhoneCall('tel:+8801755660692');
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(Icons.call),
                                      ),
                                      WidgetSpan(
                                        child: space2R,
                                      ),
                                      const TextSpan(text: 'Call On Hotline Number')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const CheckupSection(),
                        Obx(
                          () => GridViewWithLabel(
                            label: 'Certified Lab Partners',
                            itemCount: LabController.to.labList.length > 4 ? 4 : LabController.to.labList.length,
                            itemBuilder: (BuildContext ctx, index) {
                              return ImageWithLabelBodyItem(
                                from: 'LAB',
                                onTap: () {
                                  // Get.toNamed(CategoryDetailsScreen.routeName);
                                },
                                label: LabController.to.labList[index].labName!,
                              );
                            },
                          ),
                        ),
                        const DashboardInfoCard(
                          marginHorizontal: 24,
                          marginVertical: 8,
                          label: 'Trusted labs available for testing',
                          labelFontSize: 14,
                          labelFontWeight: FontWeight.w600,
                          content:
                              'We have trusted partner labs around your locations for any of your lab tests maintaining the highest quality',
                          contentFontSize: 8,
                          contentFontWeight: FontWeight.w300,
                          imagePath: 'dashboard-info-1',
                          textAlign: TextAlign.justify,
                          withLearnMore: false,
                          contentMaxLines: 3,
                          imageHeight: 40,
                        ),
                        const DashboardInfoCard(
                          marginHorizontal: 24,
                          marginVertical: 8,
                          label: 'Home sample collection available',
                          labelFontSize: 14,
                          labelFontWeight: FontWeight.w600,
                          content:
                              'For most of the Tests, there is scope of home sample collection by your nearby labs, so you can do many tests sitting right at your home',
                          contentFontSize: 8,
                          contentFontWeight: FontWeight.w300,
                          imagePath: 'dashboard-info-1',
                          textAlign: TextAlign.justify,
                          withLearnMore: false,
                          contentMaxLines: 3,
                          imageHeight: 40,
                        ),
                        const DashboardInfoCard(
                          marginHorizontal: 24,
                          marginVertical: 8,
                          label: 'Timely and accurately report',
                          labelFontSize: 14,
                          labelFontWeight: FontWeight.w600,
                          content: 'Our Partner labs are committed to you for the timely and accurate report delivery',
                          contentFontSize: 8,
                          contentFontWeight: FontWeight.w300,
                          imagePath: 'dashboard-info-1',
                          textAlign: TextAlign.justify,
                          withLearnMore: false,
                          contentMaxLines: 3,
                          imageHeight: 40,
                        ),
                        const DashboardInfoCard(
                          marginHorizontal: 24,
                          marginVertical: 8,
                          label: 'Upto 50% off for entire service',
                          labelFontSize: 14,
                          labelFontWeight: FontWeight.w600,
                          content:
                              "Generally we offer you a 10% discount for most of the tests, however, our partner labs may offer you further discounts up to 50% based on Test and Patient's financial conditions.",
                          contentFontSize: 8,
                          contentFontWeight: FontWeight.w300,
                          imagePath: 'dashboard-info-1',
                          textAlign: TextAlign.justify,
                          withLearnMore: false,
                          contentMaxLines: 3,
                          imageHeight: 40,
                        ),
                        const SizedBox(
                          height: 110,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          if (isTapUpload)
            Positioned(
              top: 0,
              left: 0,
              child: GestureDetector(
                onTap: () {
                  isTapUpload = false;
                  setState(() {});
                },
                child: Container(
                  height: Get.height,
                  width: Get.width,
                  color: Colors.black12,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        isTapUpload = true;
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                        width: Get.width * .8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                            )
                          ],
                          color: Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Upload your prescription, we will contact with you regarding prescribed test.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: kTextColor,
                              ),
                            ),
                            space4C,
                            CustomTextField(
                              controller: _nameController!,
                              labelText: 'Full Name',
                              hintText: 'Full Name',
                              isRequired: true,
                              fillColor: Colors.white,
                              hintTextStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kTextColorLite,
                              ),
                              horizontalPadding: 0,
                              verticalPadding: 0,
                              labelTextFontSize: 14,
                              isOuterBorderExist: true,
                              textFieldHorizontalContentPadding: 16,
                            ),
                            space2C,
                            CustomTextField(
                              controller: _phoneController!,
                              labelText: 'Phone Number',
                              hintText: 'Phone Number',
                              isRequired: true,
                              onChanged: (val) {
                                if (val.isEmpty) {
                                  errorMobile = 'Entered a phone number!';
                                } else if (val.isPhoneNumber) {
                                  errorMobile = null;
                                } else {
                                  errorMobile = 'Your Entered phone number is Not Valid!';
                                }
                                setState(() {});
                              },
                              fillColor: Colors.white,
                              horizontalPadding: 0,
                              labelTextFontSize: 14,
                              hintTextStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kTextColorLite,
                              ),
                              verticalPadding: 0,
                              isOuterBorderExist: true,
                              textFieldHorizontalContentPadding: 16,
                              keyboardType: TextInputType.number,
                            ),
                            if (errorMobile != null)
                              Row(
                                children: [
                                  Text(
                                    errorMobile!,
                                    style: TextStyle(
                                      color: const Color(0xffE01F25).withOpacity(0.80),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Inter',
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                            space2C,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Upload Test Reports',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                space2C,
                                GestureDetector(
                                  onTap: () {
                                    uploadImageDialoge(
                                      context,
                                      camera: () async {
                                        Get.back();
                                        await _picker.pickImage(source: ImageSource.camera).then((value) {
                                          image = value;

                                          fileNameIndex = value!.path.toString().indexOf('cache') + 6;
                                          setState(() {});
                                        });
                                      },
                                      upload: () async {
                                        Get.back();
                                        await _picker.pickImage(source: ImageSource.gallery).then(
                                          (value) {
                                            image = value!;
                                            fileNameIndex = image!.path.toString().indexOf('cache') + 6;
                                            setState(() {});
                                          },
                                        );
                                      },
                                    );
                                  },
                                  child: MainContainer(
                                    height: 30,
                                    horizontalMargin: 0,
                                    color: const Color(0xffD9D9D9).withOpacity(.4),
                                    borderRadius: 8,
                                    verticalPadding: 0,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            image != null
                                                ? image!.path.toString().substring(fileNameIndex)
                                                : 'No file chosen',
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: kTextColorLite,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                        Image.asset(
                                          'assets/icons/save.png',
                                          height: 13,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            space4C,
                            PrimaryButton(
                              label: 'Submit',
                              height: 40,
                              contentPadding: 0,
                              marginVertical: 0,
                              onPressed: () async {
                                if (_nameController!.text.isNotEmpty &&
                                    _phoneController!.text.isNotEmpty &&
                                    errorMobile == null) {
                                  await Database().uploadPrescription(
                                      File(image!.path), _nameController!.text, _phoneController!.text);
                                  image = null;
                                  _nameController!.text = '';
                                  _phoneController!.text = '';
                                  isTapUpload = false;
                                  setState(() {});
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final popularList = [
  {
    'name': 'Professional Health Checkup Package',
    'items': 30,
    'price': 8000,
    'info':
        '1. Chloride Blood\n2. Creatinine Conventional Blood\n3. Sodium Blood\n4. Bun / Serum Creatinine Ratio Calculated Blood Serum\n5. Apolipoprotein A1 Blood\n6. Apolipoprotein B Blood\n7. C Reactive Protein High Sensitivity Blood\n8. Lipoprotein Blood\n9. Glycosylated Haemoglobin Blood\n10. Average Blood Glucose (Abg) Calculated Blood\n11. Cholesterol Hdl Enzymatic Colorimetric Method Blood\n12. Cholesterol Ldl Enzymatic Colorimetric Method Blood\n13. Cholesterol Total Enzymatic Colorimetric Method Blood\n14. Triglycerides Blood\n15. Cholesterol Vldl Enzymatic Colorimetric Method Blood\n16. Hdl / Ldl Ratio Enzymatic Colorimetric Method Blood\n17. Non-Hdl Cholesterol Calculated Blood\n18. Total Cholesterol/ Hdl Cholesterol Ratio Calculated Blood Serum\n19. Bilirubin Direct Blood\n20. Bilirubin Total Blood\n21. Bilirubin Indirect Blood\n22. Thyroid Stimulating Hormone Blood\n23. Total Thyroxine Blood\n24. Total Triiodothyronine Blood\n25. Absolute Basophil Count Automated Blood\n26. Absolute Eosinophil Count Automated Blood\n27. Absolute Monocyte Count Automated Blood\n28. Absolute Neutrophil Count Automated Blood\n29. Mean Corpuscular Volume Automated Blood\n30. Haemoglobin Automated Blood',
  },
  {
    'name': 'Special Health Checkup Due to Pendamic',
    'items': 20,
    'price': 5000,
    'info':
        '1. Chloride Blood\n2. Creatinine Conventional Blood\n3. Sodium Blood\n4. Apolipoprotein A1 Blood\n5. Apolipoprotein B Blood\n6. C Reactive Protein High Sensitivity Blood\n7. Lipoprotein Blood\n8. Average Blood Glucose (Abg) Calculated Blood\n9. Cholesterol Hdl Enzymatic Colorimetric Method Blood\n10. Cholesterol Ldl Enzymatic Colorimetric Method Blood\n11. Total Cholesterol/ Hdl Cholesterol Ratio Calculated Blood Serum\n12. Bilirubin Direct Blood\n13. Bilirubin Total Blood\n14. Thyroid Stimulating Hormone Blood\n15. Total Triiodothyronine Blood\n16. Absolute Basophil Count Automated Blood\n17. Absolute Eosinophil Count Automated Blood\n18. Absolute Monocyte Count Automated Blood\n19. Absolute Neutrophil Count Automated Blood\n20. Haemoglobin Automated Blood',
  },
  {
    'name': 'Travel/Overseas Health Checkup ',
    'items': 3,
    'price': 2000,
    'info': '1. Covid -19 Virus Qualitative Pcr Throat Swab\n2. SARS CoV-2 (COVID-19)(Traveler)\n3. SARS_CoV-2',
  },
];

class CheckupSection extends StatelessWidget {
  const CheckupSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          label: 'Popular Health checkup packages',
          onTap: () {
            Get.toNamed(LabHealthCheckupScreen.routeName);
          },
        ),
        SizedBox(
          height: 240,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            itemCount: popularList.length,
            itemBuilder: (BuildContext ctx, index) {
              return CheckupItem(info: popularList[index]);
            },
          ),
        ),
      ],
    );
  }
}

class CheckupItem extends StatelessWidget {
  const CheckupItem({
    Key? key,
    this.marginAll,
    this.info,
  }) : super(key: key);
  final double? marginAll;
  final dynamic info;

  @override
  Widget build(BuildContext context) {
    globalLogger.d(info);
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
            title: '',
            content: SizedBox(
              height: Get.height * .6,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        info['info'],
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ),
                  space2C,
                  // ListView.builder(
                  //     physics: ScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: info['info'].length,
                  //     itemBuilder: (_, index) {
                  //       return Text(info['info'][index]);
                  //     }),
                  Container(
                    color: Color(0xfff3c589),
                    child: Text(
                      'Contact by our hotline number, whatsapp, messenger for ordering',
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: marginAll ?? 4, horizontal: marginAll ?? 4),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        width: 150,
        decoration: BoxDecoration(
            color: kPrimaryColor.withOpacity(.12),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kPrimaryColor,
              width: .5,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: 140,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: kPrimaryColor, width: .2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 3,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/lab-test.png',
                  fit: BoxFit.fill,
                  height: 76,
                  width: 76,
                ),
              ),
            ),
            space2C,
            TitleText(
              title: info['name'],
              fontSize: 12,
              textOverflow: TextOverflow.ellipsis,
              maxLines: 2,
              fontWeight: FontWeight.w500,
              color: kTextColor,
              textAlign: TextAlign.start,
            ),
            space1C,
            TitleText(
              title: 'Including ${info['items']} Tests',
              fontSize: 8,
              fontWeight: FontWeight.normal,
              color: kTextColor,
              textAlign: TextAlign.start,
            ),
            space1C,
            TitleText(
              title: '৳ ${info['price']}',
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

class TopPackageService extends StatelessWidget {
  const TopPackageService({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: const [
        BoxShadow(color: Colors.black12, blurRadius: 8),
      ]),
      child: Row(
        children: [
          PackageItem(
            onTap: () {
              Get.toNamed(LabTestCategoryScreen.routeName);
            },
            label: 'All Lab Test',
            imagePath: 'healthcare_primary',
          ),
          space3R,
          PackageItem(
            onTap: () {
              Get.toNamed(LabHealthCheckupScreen.routeName);
            },
            label: 'Health Package',
            imagePath: 'medicine_primary',
          ),
        ],
      ),
    );
  }
}

class PackageItem extends StatelessWidget {
  const PackageItem({
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
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.asset(
                  'assets/icons/$imagePath.png',
                  height: 33,
                ),
              ),
              space3R,
              Expanded(
                child: TitleText(
                  title: label,
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
