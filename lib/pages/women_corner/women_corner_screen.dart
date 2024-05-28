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
import '../fitness/ui/products_view_screen.dart';
import 'healthcare_category.dart';

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

class WomenCornerScreen extends StatelessWidget {
  const WomenCornerScreen({Key? key}) : super(key: key);
  static String routeName = '/WomenCornerScreen';

  @override
  Widget build(BuildContext context) {
    DoctorAppointmentController.to.getDoctorSpeciality(1);
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
                      secondText: 'Health and Beautification  specialists!',
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
                                  label: 'Health/Beauty Experts',
                                  buttonLabel: 'See All',
                                  onTap: () {
                                    DoctorController.to
                                        .changeDoctorByActivityWithLabel(
                                      DoctorByEnum.speciality,
                                      'Health/Beauty Experts',
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
                    content:
                        '\nwith  Women Health Doctors\nBeautification Experts \n\n',
                    imagePath: 'explore-call',
                    onTap: () {
                      DoctorAppointmentController.to
                          .doctorViewAll(DoctorViewAll.online);
                      Get.toNamed(DoctorExploreScreen.routeName);
                    },
                  ),

                  SectionWithViewAll(
                    topMargin: 0,
                    label: 'Health/Beauty Experts by City',
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

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: WomenCategorySection(),
                  ),

                  GestureDetector(
                    onTap: () {
                      // As this is same i am using the same screen
                      Get.to(const FitnessProductsViewScreen());
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      height: 66,
                      width: Get.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xffFFFFFF),
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
                                        'assets/images/women.jpg'),
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
                                        text: 'Enjoy ',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '10 to 20% ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'discount on all ',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'women ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'products ',
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                      /*TextSpan(
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
                                      ),*/
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
                          label: 'Ask women question 24/7',
                          imagePath: 'support',
                        ),
                        space2R,
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: 'Health/Beauty Experts',
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
                          label: 'Women products, up to 20%',
                          imagePath: 'sheild',
                        ),
                        space2R,
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: 'Quality, Reliable services',
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
                          height: 80,
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
                                const EdgeInsets.symmetric(horizontal: 10.0)
                                    .copyWith(left: 40, top: 8),
                            child: Text(
                              'I have  got instant answer from sheba one live chat, also got excellent Health/Beauty consultation from Sheba one Experts.',
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
                          height: 80,
                          width: Get.width * .6,
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
                                const EdgeInsets.symmetric(horizontal: 10.0)
                                    .copyWith(right: 20, top: 12),
                            child: Text(
                              'I have purchased products from Sheba one Women Shop, they are quality and reliable products with affordable price.',
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
