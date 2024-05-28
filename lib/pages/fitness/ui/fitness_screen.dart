import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/fitness/ui/products_view_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/service_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';

import '../../../controllers/fitness_appointment_controller.dart';
import '../../../utils/constants.dart';
import '../../webview/webview_screen.dart';
import 'fitness_by_category_screen.dart';
import 'healthcare_category.dart';

Future<void> locationDialog(
    BuildContext context, String categoryName, FitnessByEnum doctorByEnum) {
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
                  list: FitnessAppointmentController.to.cityList,
                  selectedOption: FitnessController.to.city.value.isEmpty ||
                          !FitnessAppointmentController.to.cityList
                              .contains(FitnessController.to.city.value)
                      ? 'Dhaka'
                      : FitnessController.to.city.value,
                  onChange: (val) {
                    FitnessController.to.changeCity(val!);
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
                  FitnessController.to.changeDoctorByActivity(doctorByEnum);
                  FitnessAppointmentController.to.getDoctorListByCategory(
                      categoryName,
                      doctorByEnum,
                      FitnessAppointmentController.to
                          .getCityId(FitnessController.to.city.value));
                  FitnessController.to.useCity(true);
                  Get.toNamed(FitnessByCategoryScreen.routeName,
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

class FitnessScreen extends StatelessWidget {
  const FitnessScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessScreen';

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasStyle: false,
            moduleSearch: ModuleSearch.fitness,
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
                      firstText: 'Book your online',
                      secondText: 'Fitness Class Right Now!',
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
                                  label: 'Fitness Center by Category',
                                  buttonLabel: 'See All',
                                  onTap: () {
                                    FitnessController.to
                                        .changeDoctorByActivityWithLabel(
                                      FitnessByEnum.category,
                                      'Fitness Center by Category',
                                    );
                                    FitnessAppointmentController.to
                                        .getAllDoctor();

                                    Get.toNamed(
                                        FitnessByCategoryScreen.routeName,
                                        arguments: false);
                                  },
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: FitnessAppointmentController
                                        .to.doctorSpecialityList
                                        .map(
                                          (element) => GestureDetector(
                                            onTap: () {
                                              locationDialog(
                                                context,
                                                element,
                                                FitnessByEnum.category,
                                              );
                                            },
                                            child: SpecialityItem(
                                              label: element,
                                              imagePath:
                                                  'images/category_image/${element ?? ''}',
                                            ),
                                          ),
                                        )
                                        .toList(),
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
                    label: 'Explore Demo  Online Fitness Classes',
                    content: '\nsupport from our\nFitness centers \n\n',
                    imagePath: 'explore-call',
                    onTap: () {
                      Get.toNamed(WebViewPage.routeName, arguments: "https://www.shebaone.com/coming-soon");
                    },
                  ),

                  SectionWithViewAll(
                    topMargin: 0,
                    label: 'Fitness Center by City',
                    buttonLabel: 'See All',
                    onTap: () {
                      FitnessController.to.changeDoctorByActivityWithLabel(
                        FitnessByEnum.city,
                        'Fitness Center by City',
                      );

                      FitnessAppointmentController.to.getAllDoctor();
                      Get.toNamed(FitnessByCategoryScreen.routeName,
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
                          FitnessAppointmentController.to.doctorCityList.length,
                      itemBuilder: (_, index) {
                        return GestureDetector(
                          onTap: () {
                            FitnessController.to
                                .changeDoctorByActivity(FitnessByEnum.city);
                            FitnessAppointmentController.to
                                .getDoctorListByCategory(
                                    FitnessAppointmentController
                                        .to.doctorCityList[index].id!,
                                    FitnessByEnum.city,
                                    FitnessAppointmentController
                                        .to.doctorCityList[index].id!);

                            FitnessController.to.useCity(true);
                            Get.toNamed(FitnessByCategoryScreen.routeName,
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
                                  networkImagePath: FitnessAppointmentController
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
                                  title: FitnessAppointmentController
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
                    child: HealthCareCategorySection(),
                  ),

                  GestureDetector(
                    onTap: () {
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
                                        'assets/images/fitness.jpg'),
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
                                        text: 'Fitness & Wellness ',
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
                                      TextSpan(
                                        text: ' ',
                                        style: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '',
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
                          label: 'Join online Fitness Classes',
                          imagePath: 'support',
                        ),
                        space2R,
                        PackageItem(
                          onTap: () {
                            // Get.toNamed(MedicineScreen.routeName);
                          },
                          label: 'Consult Expert instantly',
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
                          label: 'Products upto 20% discounts',
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
                              'I have  participated online Fitness & Wellbeing through Sheba One, after these classes,my Fitness & Wellness  have improved a lot.',
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
                              'I have purchased products from Sheba one Fitness & Wellness Shop, they are quality and reliable products with affordable price.',
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
