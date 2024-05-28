import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_controller.dart';
import 'package:shebaone/models/fitness_model.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/fitness/ui/fitness_profile_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_category_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../controllers/fitness_appointment_controller.dart';

class FitnessByCategoryScreen extends StatefulWidget {
  const FitnessByCategoryScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessByCategoryScreen';

  @override
  State<FitnessByCategoryScreen> createState() =>
      _FitnessByCategoryScreenState();
}

class _FitnessByCategoryScreenState extends State<FitnessByCategoryScreen> {
  bool _isFilterOpen = false;
  final int item = 3;
  bool arg = false;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    arg = Get.arguments;
    if (!arg) {
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
      if (!FitnessAppointmentController.to.addDoctorLoading.value) {
        print("Condition Work");
        await FitnessAppointmentController.to.getAllDoctor(true);
      }
      // Provider.of<HomeProvider>(context, listen: false)
      //     .loadMoreProgram(Storage.getUser().id);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (FitnessController.to.useCity.value) FitnessController.to.useCity(false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasStyle: false,
            withLocation: !arg,
            moduleSearch: ModuleSearch.fitness,
            title: arg
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const TitleText(
                        title: 'current Location',
                        fontSize: 11,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                      Obx(() => TitleText(
                            title: FitnessAppointmentController.to
                                .getCityName(FitnessController.to.city.value),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          )),
                    ],
                  )
                : const SizedBox(),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  BgContainer(
                    imagePath: 'dashboard-bg',
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    child: MainContainer(
                      horizontalPadding: 12,
                      verticalPadding: 0,
                      color: kScaffoldColor,
                      topBorderRadius: 36,
                      horizontalMargin: 0,
                      borderColor: kScaffoldColor,
                      child: Column(
                        children: [
                          Obx(() {
                            return SectionWithViewAll(
                              label: FitnessController.to.headline.value,
                              iconPath: 'filter',
                              isIconButton: true,
                              buttonColor: kPrimaryColor,
                              horizontalPadding: 0,
                              onTap: () {
                                _isFilterOpen = !_isFilterOpen;
                                setState(() {});
                              },
                            );
                          }),
                          Stack(
                            children: [
                              Obx(
                                () => arg
                                    ? (FitnessAppointmentController
                                            .to.doctorByCategoryLoading.value
                                        ? const Waiting()
                                        : Obx(() => ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 12,
                                              ),
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemCount:
                                                  FitnessAppointmentController
                                                      .to
                                                      .getDoctorByCategoryList
                                                      .length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return FitnessCard(
                                                  info: FitnessAppointmentController
                                                          .to
                                                          .getDoctorByCategoryList[
                                                      index],
                                                  onTap: () {
                                                    FitnessAppointmentController
                                                        .to
                                                        .getSingleDoctor(
                                                            FitnessAppointmentController
                                                                .to
                                                                .getDoctorByCategoryList[
                                                                    index]
                                                                .id!);
                                                    Get.toNamed(
                                                        FitnessProfileScreen
                                                            .routeName);
                                                  },
                                                );
                                              },
                                            )))
                                    : FitnessAppointmentController
                                            .to.doctorLoading.value
                                        ? const Waiting()
                                        : Obx(() => ListView.builder(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 12,
                                              ),
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              itemCount:
                                                  FitnessAppointmentController
                                                      .to.getDoctorList.length,
                                              itemBuilder:
                                                  (BuildContext ctx, index) {
                                                return FitnessCard(
                                                    info:
                                                        FitnessAppointmentController
                                                                .to
                                                                .getDoctorList[
                                                            index],
                                                    onTap: () {
                                                      FitnessAppointmentController
                                                          .to
                                                          .getSingleDoctor(
                                                        FitnessAppointmentController
                                                            .to
                                                            .getDoctorList[
                                                                index]
                                                            .id!,
                                                      );
                                                      Get.toNamed(
                                                          FitnessProfileScreen
                                                              .routeName);
                                                    });
                                              },
                                            )),
                              ),

                              Obx(
                                () => FitnessAppointmentController
                                        .to.addDoctorLoading.value
                                    ? SizedBox(
                                        height: Get.height * .5,
                                        child: const Waiting(),
                                      )
                                    : FitnessAppointmentController
                                                .to.getDoctorList.isEmpty &&
                                            FitnessAppointmentController.to
                                                .getDoctorByCategoryList.isEmpty
                                        ? SizedBox(
                                            height: Get.height * .5,
                                            child: const Center(
                                              child: Text(
                                                  'No Fitness Center Found!'),
                                            ),
                                          )
                                        : const SizedBox(),
                              ),
                              Obx(
                                () => arg
                                    ? SizedBox(
                                        height: FitnessAppointmentController
                                                        .to
                                                        .getDoctorByCategoryList
                                                        .length <
                                                    5 &&
                                                _isFilterOpen
                                            ? Get.height * .6
                                            : 0,
                                      )
                                    : SizedBox(
                                        height: FitnessAppointmentController.to
                                                        .getDoctorList.length <
                                                    5 &&
                                                _isFilterOpen
                                            ? Get.height * .6
                                            : 0,
                                      ),
                              ),
                              // SizedBox(
                              //   height: item < 5 && _isFilterOpen
                              //       ? Get.height * .6
                              //       : 0,
                              // ),
                              AnimatedPositioned(
                                right: _isFilterOpen ? 0 : -350,
                                top: 0,
                                duration: const Duration(milliseconds: 200),
                                child: DoctorFilterBox(
                                  height: Get.height * .6,
                                  isShowCategory: !arg,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
    );
  }
}

class DoctorFilterBox extends StatefulWidget {
  const DoctorFilterBox({
    Key? key,
    this.height,
    this.isShowCategory = false,
  }) : super(key: key);
  final double? height;
  final bool isShowCategory;

  @override
  State<DoctorFilterBox> createState() => _DoctorFilterBoxState();
}

class _DoctorFilterBoxState extends State<DoctorFilterBox> {
  bool _isCheck = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * .7,
      height: widget.height ?? Get.height * .6,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(-2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.isShowCategory)
                    FilterCheckWithLabel(
                      label: 'category',
                      child: Obx(
                        () => ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: FitnessAppointmentController
                              .to.getDoctorSpecialityList.length,
                          itemBuilder: (_, index) {
                            return CustomCheckBox(
                              height: 30,
                              label: FitnessAppointmentController
                                  .to.getDoctorSpecialityList[index],
                              value: FitnessController
                                  .to.specialityCheckList[index],
                              onChanged: (newValue) {
                                FitnessController
                                    .to.specialityCheckList[index] = newValue!;
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  FilterCheckWithLabel(
                    label: 'Gender',
                    child: Column(
                      children: [
                        Obx(
                          () => CustomCheckBox(
                            height: 30,
                            label: 'Male Center',
                            value: FitnessController.to.genderType.value ==
                                FitnessGender.male,
                            onChanged: (newValue) {
                              if (newValue!) {
                                FitnessController.to
                                    .genderType(FitnessGender.male);
                              }
                              setState(() {
                                // _isCheck = newValue!;
                              });
                            },
                          ),
                        ),
                        Obx(
                          () => CustomCheckBox(
                            height: 30,
                            label: 'Female Center',
                            value: FitnessController.to.genderType.value ==
                                FitnessGender.female,
                            onChanged: (newValue) {
                              if (newValue!) {
                                FitnessController.to
                                    .genderType(FitnessGender.female);
                              }
                              setState(() {
                                // _isCheck = newValue!;
                              });
                            },
                          ),
                        ),
                        Obx(
                          () => CustomCheckBox(
                            height: 30,
                            label: 'Any',
                            value: FitnessController.to.genderType.value ==
                                FitnessGender.both,
                            onChanged: (newValue) {
                              if (newValue!) {
                                FitnessController.to
                                    .genderType(FitnessGender.both);
                              }
                              setState(() {
                                // _isCheck = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilterCheckWithLabel(
                    label: 'Service Fee',
                    child: Column(
                      children: [
                        Obx(
                          () => CustomCheckBox(
                            height: 30,
                            label: '1-250',
                            value: FitnessController.to.priceType.value ==
                                PriceType.two_50,
                            onChanged: (newValue) {
                              if (newValue!) {
                                FitnessController.to
                                    .priceType(PriceType.two_50);
                              }
                              setState(() {
                                // _isCheck = newValue!;
                              });
                            },
                          ),
                        ),
                        Obx(
                          () => CustomCheckBox(
                            height: 30,
                            label: '1-500',
                            value: FitnessController.to.priceType.value ==
                                PriceType.five_100,
                            onChanged: (newValue) {
                              if (newValue!) {
                                FitnessController.to
                                    .priceType(PriceType.five_100);
                              }
                              setState(() {
                                // _isCheck = newValue!;
                              });
                            },
                          ),
                        ),
                        Obx(
                          () => CustomCheckBox(
                            height: 30,
                            label: '500+',
                            value: FitnessController.to.priceType.value ==
                                PriceType.five_100Plus,
                            onChanged: (newValue) {
                              if (newValue!) {
                                FitnessController.to
                                    .priceType(PriceType.five_100Plus);
                              }
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          space3C,
          Center(
            child: PrimaryButton(
              onPressed: () {
                if (widget.isShowCategory) {
                  FitnessController.to.getFilterDoctorList(true);
                } else {
                  FitnessController.to.getFilterDoctorList(false);
                }
              },
              marginVertical: 0,
              height: 30,
              width: 100,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              primary: const Color(0xff4A8B5C),
              label: 'Apply Filter',
            ),
          ),
        ],
      ),
    );
  }
}

class FitnessCard extends StatelessWidget {
  const FitnessCard({
    Key? key,
    this.onTap,
    required this.info,
  }) : super(key: key);
  final Function()? onTap;
  final FitnessModel info;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 3),
          ),
        ],
        color: Colors.white,
      ),
      child: Stack(
        children: [
          Positioned(
            right: Get.width * .25,
            bottom: 80,
            top: 20,
            child: Image.asset(
              'assets/images/card-shape-2.png',
            ),
          ),
          Positioned(
            right: -20,
            bottom: -17,
            child: Image.asset(
              'assets/images/card-shape-1.png',
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10,
            ),
            child: Row(
              children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        info.imagePath!,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, exception, stackTrack) =>
                            Image.asset('assets/images/doctor-pp.png'),
                        fit: BoxFit.fill,
                      )

                      // Image.asset(
                      //   'assets/images/doc.png',
                      //   fit: BoxFit.fill,
                      // ),
                      ),
                ),
                space3R,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleText(
                        title: info.name ?? '',
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          right: 20.0,
                          bottom: 4,
                        ),
                        child: HorizontalDivider(
                          color: Color(0xff4A8B5C),
                          thickness: .5,
                          horizontalMargin: 0,
                          height: 4,
                        ),
                      ),
                      TitleText(
                        title: info.address ?? '',
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.black54,
                      ),
                      Row(
                        children: [
                          const TitleText(
                            title: 'Consultation fee :',
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: Colors.black54,
                          ),
                          TitleText(
                            title: ' ${info.gymFee ?? '-'}',
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ],
                      ),
                      space3C,
                      Row(
                        children: [
                          Flexible(
                            child: PrimaryButton(
                              label: 'View Profile',
                              primary: Colors.white,
                              borderWidth: .5,
                              labelColor: Colors.black54,
                              borderColor: kPrimaryColor,
                              height: 26,
                              borderRadiusAll: 6,
                              contentPadding: 0,
                              marginVertical: 0,
                              marginHorizontal: 0,
                              fontSize: 10,
                              width: 100,
                              onPressed: onTap,
                            ),
                          ),
                          space2R,
                          Flexible(
                            child: PrimaryButton(
                              label: 'Book Now',
                              height: 26,
                              borderRadiusAll: 6,
                              contentPadding: 0,
                              marginVertical: 0,
                              marginHorizontal: 0,
                              fontSize: 10,
                              width: 100,
                              onPressed: onTap,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          horizontalPadding: 0,
          label: 'Categories',
          buttonLabel: 'See All',
          labelFontSize: 20,
          onTap: () {
            Get.toNamed(HealthcareCategoryScreen.routeName);
          },
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext ctx, index) {
              return const CategoryItem();
            },
          ),
        ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 60,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: kPrimaryColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                'assets/images/category.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          space1C,
          const TitleText(
            title: 'Health Device & Tools ',
            fontSize: 8,
            textOverflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            textAlign: TextAlign.center,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
