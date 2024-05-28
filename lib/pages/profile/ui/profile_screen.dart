import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/pages/orders/ui/current_orders_screen.dart';
import 'package:shebaone/pages/orders/ui/previous_orders_screen.dart';
import 'package:shebaone/pages/profile/ui/update_profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppBarWithSearch(
            moduleSearch: ModuleSearch.none,
            isSearchShow: false,
            hasStyle: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BgContainer(
                    child: MainContainer(
                      verticalPadding: 30,
                      horizontalMargin: 0,
                      child: Column(
                        children: [
                          TitleText(
                            title: 'Profile Details',
                            fontSize: 16,
                            color: kTextColor,
                          ),
                          space5C,
                          Obx(
                            () => ProfileInfoItem(
                              label: 'Full Name',
                              data: UserController.to.userInfo.value.name ?? '',
                            ),
                          ),
                          Obx(
                            () => ProfileInfoItem(
                              label: 'Mobile',
                              data: UserController.to.userInfo.value.mobile ?? '',
                            ),
                          ),
                          Obx(
                            () => ProfileInfoItem(
                              label: 'Address',
                              data: UserController.to.userInfo.value.address ?? '',
                            ),
                          ),
                          // const ProfileInfoItem(
                          //   label: 'Email',
                          //   data: 'test@mail.com',
                          // ),

                          // Row(
                          //   children: [
                          //     const Expanded(
                          //       flex: 1,
                          //       child: ProfileInfoItem(
                          //         label: 'City',
                          //         data: 'Dhaka',
                          //       ),
                          //     ),
                          //     space5R,
                          //     const Expanded(
                          //       flex: 1,
                          //       child: ProfileInfoItem(
                          //         label: 'Area',
                          //         data: 'Dhanmondi',
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          space5C,
                          PrimaryButton(
                            label: 'Update Personal Information',
                            height: 32,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            marginHorizontal: 12,
                            marginVertical: 0,
                            contentPadding: 0,
                            onPressed: () {
                              Get.toNamed(UpdateProfile.routeName);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  MainContainer(
                    borderRadius: 6,
                    child: Obx(
                      () => InfoRow(
                        onTap: () {
                          HomeController.to.currentOrderListType(OrderType.healthcare);
                          HealthCareController.to.getCurrentOrderList();
                          Get.toNamed(CurrentOrdersScreen.routeName);
                        },
                        label: 'Current Orders',
                        number: (MedicineController.to.currentOrders.value +
                                HealthCareController.to.currentOrders.value +
                                LabController.to.currentOrders.value +
                                DoctorAppointmentController.to.currentOrders.value)
                            .toString(),
                      ),
                    ),
                  ),
                  space5C,
                  MainContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(
                          title: 'Previous Order History',
                          color: Color(0xff3C3C3C),
                          fontSize: 16,
                        ),
                        space3C,
                        Obx(
                          () => InfoRow(
                            onTap: () {
                              HomeController.to.previousOrderListType(OrderType.healthcare);
                              HealthCareController.to.getPreviousOrderList();
                              Get.toNamed(PreviousOrdersScreen.routeName);
                              // HomeController.to.changeMenuItemActivity(MenuItemEnum.orders);
                            },
                            label: 'Healthcare Orders',
                            number: (HealthCareController.to.totalOrders.value -
                                    HealthCareController.to.currentOrders.value)
                                .toString(),
                          ),
                        ),
                        space3C,
                        Obx(
                          () => InfoRow(
                            onTap: () {
                              HomeController.to.previousOrderListType(OrderType.medicine);
                              MedicineController.to.getPreviousOrderList();
                              Get.toNamed(PreviousOrdersScreen.routeName);
                            },
                            label: 'Medicine Orders',
                            number:
                                (MedicineController.to.totalOrders.value - MedicineController.to.currentOrders.value)
                                    .toString(),
                          ),
                        ),
                        space3C,
                        Obx(
                          () => InfoRow(
                            onTap: () {
                              HomeController.to.previousOrderListType(OrderType.lab);
                              LabController.to.getPreviousOrderList();
                              Get.toNamed(PreviousOrdersScreen.routeName);
                            },
                            label: 'Lab Tests Orders',
                            number:
                                (LabController.to.totalOrders.value - LabController.to.currentOrders.value).toString(),
                          ),
                        ),
                        space3C,
                        Obx(
                          () => InfoRow(
                            onTap: () {
                              HomeController.to.previousOrderListType(OrderType.doctor);
                              DoctorAppointmentController.to.getPreviousOrderList();
                              Get.toNamed(PreviousOrdersScreen.routeName);
                            },
                            label: 'Appointment Orders',
                            number: (DoctorAppointmentController.to.totalOrders.value -
                                    DoctorAppointmentController.to.currentOrders.value)
                                .toString(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  space5C,
                  MainContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => InfoRow(
                            withIcon: false,
                            label: 'Refer Code',
                            number: UserController.to.getUserInfo.referCode ?? '',
                          ),
                        ),
                        space3C,
                        Obx(
                          () => InfoRow(
                            withIcon: false,
                            label: 'Points Earn',
                            number: UserController.to.getUserInfo.wallet ?? '0',
                          ),
                        ),
                        space3C,
                        Obx(
                          () => InfoRow(
                            withIcon: false,
                            label: 'Point Value',
                            number:
                                '${int.parse(UserController.to.getUserInfo.wallet?? '0') * (int.parse(HomeController.to.commission['point_equal_taka'].toString() ?? '0'))} TK',
                          ),
                        ),
                      ],
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

class BgContainer extends StatelessWidget {
  const BgContainer({
    this.child,
    this.imagePath,
    this.boxFit,
    this.alignment,
    this.horizontalPadding,
    this.verticalPadding,
    Key? key,
  }) : super(key: key);
  final Widget? child;
  final String? imagePath;
  final BoxFit? boxFit;
  final AlignmentGeometry? alignment;
  final double? horizontalPadding;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 24, vertical: verticalPadding ?? 16),
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: alignment ?? Alignment.topCenter,
          fit: boxFit ?? BoxFit.fitWidth,
          image: AssetImage('assets/images/${imagePath ?? 'dashboard-bg'}.png'),
        ),
      ),
      child: child,
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({
    this.child,
    this.color,
    this.borderColor,
    this.horizontalPadding,
    this.horizontalMargin,
    this.verticalPadding,
    this.verticalMargin,
    this.borderRadius,
    this.topBorderRadius,
    this.bottomBorderRadius,
    this.width,
    this.height,
    this.borderWidth,
    this.withBoxShadow = false,
    Key? key,
  }) : super(key: key);
  final Widget? child;
  final Color? color;
  final Color? borderColor;
  final double? horizontalMargin;
  final double? verticalMargin;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? borderRadius;
  final double? topBorderRadius;
  final double? bottomBorderRadius, height, width, borderWidth;
  final bool withBoxShadow;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 24, vertical: verticalMargin ?? 0),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16, vertical: verticalPadding ?? 10),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: topBorderRadius != null || bottomBorderRadius != null
            ? BorderRadius.vertical(
                top: Radius.circular(topBorderRadius ?? 0),
                bottom: Radius.circular(bottomBorderRadius ?? 0),
              )
            : BorderRadius.circular(borderRadius ?? 15),
        border: Border.all(
          color: borderColor ?? kPrimaryColor,
          width: borderWidth ?? .5,
        ),
        boxShadow: [
          if (withBoxShadow)
            const BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
            )
        ],
      ),
      child: child,
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    Key? key,
    required this.label,
    required this.number,
    this.withIcon = true,
    this.withUnderline = false,
    this.underlineHeight,
    this.underlineThickness,
    this.underlineColor,
    this.fontWeight,
    this.textColor,
    this.fontSize,
    this.horizontalMargin,
    this.verticalMargin,
    this.onTap,
  }) : super(key: key);
  final String label, number;
  final bool withIcon;
  final bool withUnderline;
  final Color? underlineColor, textColor;
  final double? underlineHeight, underlineThickness, fontSize, horizontalMargin, verticalMargin;
  final FontWeight? fontWeight;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 0, vertical: verticalMargin ?? 0),
        child: Column(
          children: [
            Row(
              children: [
                withIcon
                    ? Container(
                        height: 19,
                        width: 19,
                        decoration: BoxDecoration(
                            color: const Color(0xff4A8B5C).withOpacity(.1),
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(color: kPrimaryColor, width: .5)),
                        child: Center(
                          child: Image.asset(
                            'assets/icons/gift.png',
                            height: 11,
                          ),
                        ),
                      )
                    : const SizedBox(),
                withIcon ? space4R : const SizedBox(),
                TitleText(
                  title: label,
                  color: textColor ?? const Color(0xff3C3C3C),
                  fontSize: fontSize ?? 12,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
                const Spacer(),
                TitleText(
                  title: number,
                  color: textColor ?? const Color(0xff3C3C3C),
                  fontSize: fontSize ?? 12,
                  fontWeight: fontWeight,
                )
              ],
            ),
            if (withUnderline)
              HorizontalDivider(
                color: underlineColor,
                thickness: underlineThickness,
                height: underlineHeight,
              ),
          ],
        ),
      ),
    );
  }
}

class SeeAllOrderHistoryCard extends StatelessWidget {
  const SeeAllOrderHistoryCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Positioned(
            left: -11,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width - 10,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 47,
                  width: 47,
                  decoration: BoxDecoration(
                      color: const Color(0xff4A8B5C).withOpacity(.1),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: kPrimaryColor, width: .5)),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/gift.png',
                      height: 27,
                    ),
                  ),
                ),
                space4R,
                const TitleText(
                  title: 'See All Order History',
                  fontSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoItem extends StatelessWidget {
  const ProfileInfoItem({
    required this.label,
    required this.data,
    Key? key,
  }) : super(key: key);
  final String label, data;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          title: label,
          color: const Color(0xff3C3C3C),
          fontSize: 12,
          fontWeight: FontWeight.normal,
        ),
        space1C,
        TitleText(
          title: data,
          color: const Color(0xff3C3C3C),
          fontSize: 14,
        ),
        space1C,
        const HorizontalDivider(
          height: 1,
          color: Color(0xffCCCCCC),
        ),
        space3C,
      ],
    );
  }
}
