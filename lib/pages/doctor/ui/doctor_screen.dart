import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/doctor/ui/doctor_by_category_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_explore_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/service_screen.dart';
import 'package:shebaone/pages/webview/webview_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';

import '../../../utils/constants.dart';

Future<void> locationDialog(
    BuildContext context, String categoryName, DoctorByEnum doctorByEnum) {
  String selectedOOption = '';
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SizedBox(
          height: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleText(
                title: 'Select your city',
                color: Colors.black,
                fontSize: 18,
              ),
              Obx(() {
                return CustomDropDownMenu(
                  leftPadding: 16,
                  list: DoctorAppointmentController.to.cityList,
                  selectedOption: DoctorController.to.city.value.isEmpty ||
                          !DoctorAppointmentController.to.cityList
                              .contains(DoctorController.to.city.value)
                      ? 'Dhaka'
                      : DoctorController.to.city.value,
                  onChange: (val) {
                    DoctorController.to.changeCity(val!);
                  },
                  hintText: 'City',
                );
              }),
              PrimaryButton(
                label: 'Continue',
                fontSize: 14,
                height: 35,
                contentPadding: 0,
                onPressed: () {
                  Get.back();
                  DoctorController.to.changeDoctorByActivity(doctorByEnum);
                  DoctorAppointmentController.to.getDoctorListByCategory(
                      categoryName,
                      doctorByEnum,
                      DoctorAppointmentController.to
                          .getCityId(DoctorController.to.city.value));
                  DoctorController.to.useCity(true);
                  Get.toNamed(DoctorByCategoryScreen.routeName,
                      arguments: true);
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

class DoctorScreen extends StatelessWidget {
  DoctorScreen({Key? key}) : super(key: key);
  static String routeName = '/DoctorScreen';
  final List<Map> _cityList = [
    {
      'label': 'Dhaka',
      'imagePath': 'dhaka',
    },
    {
      'label': 'Chottogram',
      'imagePath': 'ctg',
    },
    {
      'label': 'Khulna',
      'imagePath': 'khulna',
    },
    {
      'label': 'Rajshahi',
      'imagePath': 'rajshahi',
    },
    {
      'label': 'Rangpur',
      'imagePath': 'rangpur',
    },
    {
      'label': 'Sylhet',
      'imagePath': 'sylhet',
    },
  ];
  final List<Map> _organList = [
    {
      'label': 'Head',
      'imagePath': 'brain',
    },
    {
      'label': 'Eye',
      'imagePath': 'eye',
    },
    {
      'label': 'Heart',
      'imagePath': 'heart-o',
    },
    {
      'label': 'Stomach',
      'imagePath': 'stomach',
    },
    {
      'label': 'Dentist',
      'imagePath': 'dentist',
    },
    {
      'label': 'Kidney',
      'imagePath': 'kidney',
    },
  ];

  @override
  Widget build(BuildContext context) {
    DoctorAppointmentController.to.getDoctorSpeciality(0);
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasStyle: false,
            moduleSearch: ModuleSearch.doctor,
            onCartTapped: () {
              // Get.toNamed(HealthcareCartScreen.routeName);
              Get.toNamed(HealthcareLiveCartScreen.routeName);
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
                      verticalPadding: 0,
                      horizontalPadding: 0,
                      mainContainerHorizontalMargin: 24,
                      firstText: 'Find your desired',
                      secondText: 'Doctor Right Now!',
                      borderColor: kPrimaryColor,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            left: 0,
                            child: Image.asset(
                              'assets/images/style-bg.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SectionWithViewAll(
                                  topMargin: 0,
                                  horizontalPadding: 0,
                                  label: 'Doctors by Speciality',
                                  buttonLabel: 'See All',
                                  onTap: () {
                                    print('object');
                                    DoctorController.to
                                        .changeDoctorByActivityWithLabel(
                                      DoctorByEnum.speciality,
                                      'Doctors by Speciality',
                                    );
                                    DoctorAppointmentController.to
                                        .getAllDoctor();

                                    Get.toNamed(
                                        DoctorByCategoryScreen.routeName,
                                        arguments: false);
                                  },
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Obx(
                                    () => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: DoctorAppointmentController
                                          .to.doctorSpecialityList
                                          .map(
                                            (element) => GestureDetector(
                                              onTap: () {
                                                locationDialog(
                                                    context,
                                                    element.id!,
                                                    DoctorByEnum.speciality);
                                              },
                                              child: SpecialityItem(
                                                label: element.specialization!,
                                                imagePath:
                                                    'images/category_image/${element.imagePath ?? ''}',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                                space3C,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  space3C,

                  ExploreNowCard(
                    label: 'Online Consultation',
                    content: '\nsupport from our\nspecialized doctors \n\n',
                    imagePath: 'explore-call',
                    onTap: () {
                      DoctorAppointmentController.to
                          .doctorViewAll(DoctorViewAll.online);
                      Get.toNamed(DoctorExploreScreen.routeName);
                    },
                  ),

                  SectionWithViewAll(
                    topMargin: 0,
                    label: 'Doctors by City',
                    buttonLabel: 'See All',
                    onTap: () {
                      DoctorController.to.changeDoctorByActivityWithLabel(
                        DoctorByEnum.city,
                        'Doctors by City',
                      );

                      DoctorAppointmentController.to.getAllDoctor();
                      Get.toNamed(DoctorByCategoryScreen.routeName,
                          arguments: false);
                    },
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          DoctorAppointmentController.to.doctorCityList.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            DoctorController.to
                                .changeDoctorByActivity(DoctorByEnum.city);
                            DoctorAppointmentController.to
                                .getDoctorListByCategory(
                                    DoctorAppointmentController
                                        .to.doctorCityList[index].id!,
                                    DoctorByEnum.city,
                                    DoctorAppointmentController
                                        .to.doctorCityList[index].id!);

                            DoctorController.to.useCity(true);
                            Get.toNamed(DoctorByCategoryScreen.routeName,
                                arguments: true);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xffC3C3C3),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: kPrimaryColor,
                                width: .5,
                              ),
                            ),
                            child: Row(
                              children: [
                                CustomNetworkImage(
                                  networkImagePath: DoctorAppointmentController
                                          .to.doctorCityList[index].imagePath ??
                                      '',
                                  height: 33,
                                  width: 33,
                                ),
                                // Image.asset(
                                //   'assets/images/${_cityList[index]['imagePath']}.png',
                                //   height: 33,
                                // ),
                                space3R,
                                TitleText(
                                  title: DoctorAppointmentController
                                      .to.doctorCityList[index].city!,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SectionWithViewAll(
                    topMargin: 16,
                    label: 'Doctors by Body Organs',
                    buttonLabel: 'See All',
                    onTap: () {
                      DoctorController.to.changeDoctorByActivityWithLabel(
                        DoctorByEnum.organ,
                        'Doctors by Body Organs',
                      );
                      DoctorAppointmentController.to.getAllDoctor();

                      Get.toNamed(DoctorByCategoryScreen.routeName,
                          arguments: false);
                    },
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount:
                          DoctorAppointmentController.to.doctorOrganList.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            locationDialog(
                                context,
                                DoctorAppointmentController
                                    .to.doctorOrganList[index].id!,
                                DoctorByEnum.organ);
                            // DoctorController.to
                            //     .changeDoctorByActivity(DoctorByEnum.organ);
                            // DoctorAppointmentController.to
                            //     .getDoctorListByCategory(
                            //         _organList[index]['label'],
                            //         DoctorByEnum.organ);
                            //
                            // Get.toNamed(DoctorByCategoryScreen.routeName);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xffABFF81).withOpacity(.4),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: kPrimaryColor,
                                width: .5,
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor.withOpacity(.21),
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 4,
                                        offset: Offset(1, 3),
                                      )
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomNetworkImage(
                                      networkImagePath:
                                          DoctorAppointmentController
                                                  .to
                                                  .doctorOrganList[index]
                                                  .imagePath ??
                                              '',
                                    ),

                                    // Image.asset(
                                    //   'assets/icons/${_organList[index]['imagePath']}.png',
                                    //   height: 33,
                                    // ),
                                  ),
                                ),
                                space3C,
                                TitleText(
                                  title: DoctorAppointmentController
                                      .to.doctorOrganList[index].specialOrgan!,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Raleway',
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(WebViewPage.routeName,
                          arguments:
                              'https://www.shebaone.com/plus_membership');
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      height: 66,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffC3C3C3).withOpacity(.21),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 66,
                                width: 132,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/custom-shape.png'),
                                  ),
                                ),
                                child: Center(
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    height: 36,
                                    width: 97,
                                  ),
                                ),
                              ),
                              space6R,
                              Expanded(
                                child: Text.rich(
                                  TextSpan(
                                    style: TextStyle(
                                      color: kPrimaryColor,
                                      fontFamily: 'Raleway',
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: 'Save upto ',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '50% ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'extra and enjoy ',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Free ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'delivery with Sheba ',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Plus ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'membership',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              space6R,
                            ],
                          ),
                          Positioned(
                            right: 8,
                            bottom: 4,
                            child: Image.asset(
                              'assets/icons/percent-lite.png',
                              height: 47,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: 'Consult top doctor 24/7',
                          imagePath: 'support',
                        ),
                        space2R,
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: 'Convenient and easy',
                          imagePath: 'easy',
                        ),
                      ],
                    ),
                  ),
                  space4C,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: '100% reliable consultation',
                          imagePath: 'sheild',
                        ),
                        space2R,
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: 'Free follow up',
                          imagePath: 'reuse',
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 24),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: const Color(0xffAED1BA),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset(
                              'assets/images/product.png',
                            ),
                          ),
                        ),
                        Container(
                          height: 74,
                          width: Get.width * .6,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image:
                                  AssetImage('assets/images/chat-shape-1.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0)
                                    .copyWith(left: 40, top: 12),
                            child: Text(
                              'I have booked doctor through Sheba One, and found it to be very much efficient and and helpful.',
                              style: TextStyle(
                                color: kTextColor,
                                fontFamily: 'Raleway',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 59,
                          width: Get.width * .55,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.centerLeft,
                              image:
                                  AssetImage('assets/images/chat-shape-2.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0)
                                    .copyWith(right: 18, top: 12),
                            child: Text(
                              'I have booked doctor through Sheba One,and its very helpful.',
                              style: TextStyle(
                                color: kTextColor,
                                fontFamily: 'Raleway',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            color: const Color(0xffAED1BA),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(35),
                            child: Image.asset(
                              'assets/images/product.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const TopSellingMedicineSection(
                  //   itemCount: 4,
                  // ),
                  // const AllOfferSection(),
                  // const BottomImageSection(),
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

class SpecialityItem extends StatelessWidget {
  const SpecialityItem({
    Key? key,
    required this.imagePath,
    required this.label,
  }) : super(key: key);
  final String label, imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.width * .22,
      width: Get.width * .22,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor, width: 2),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomNetworkImage(
            networkImagePath: imagePath,
            height: 30,
            width: 30,
          ),
          // Image.asset(
          //   'assets/icons/$imagePath.png',
          //   height: 30,
          //   width: 30,
          //   fit: imagePath == 'heart' ? BoxFit.cover : BoxFit.contain,
          // ),
          space2C,
          TitleText(
            title: label,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            fontFamily: 'Raleway',
            color: kTextColor,
          ),
        ],
      ),
    );
  }
}
