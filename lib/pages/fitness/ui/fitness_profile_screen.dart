import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_appointment_controller.dart';
import 'package:shebaone/pages/fitness/ui/fitness_book_appointment_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/get_dialogs.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../models/fitness_appointment_slot_model.dart';
import '../../../utils/widgets/network_image/network_image.dart';

class FitnessProfileScreen extends StatefulWidget {
  const FitnessProfileScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessProfileScreen';

  @override
  State<FitnessProfileScreen> createState() => _FitnessProfileScreenState();
}

class _FitnessProfileScreenState extends State<FitnessProfileScreen> {
  // TextEditingController? _controller;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _controller = TextEditingController();
  //   super.initState();
  // }
  int _activeIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    // if (DoctorAppointmentController.to.getUniqueAppointmentList.isEmpty) {
    //   Fluttertoast.showToast(msg: 'No booking Slot available for booking');
    // } else {
    //   Fluttertoast.showToast(msg: 'Please select  booking date first from above');
    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kScaffoldColor,
          title: Container(
            height: 30,
            width: Get.width * .6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
            child: const Center(
              child: TitleText(
                title: 'Fitness Center Details',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
        body: Obx(
          () => FitnessAppointmentController.to.singleDoctorLoading.value
              ? const Center(
                  child: Waiting(),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 16),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: .3,
                                  color: kPrimaryColor.withOpacity(.2),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Obx(
                                      () => SizedBox(
                                        height: 100,
                                        child: CustomNetworkImage(
                                          networkImagePath:
                                              FitnessAppointmentController
                                                  .to
                                                  .getSingleDoctorDetails
                                                  .imagePath!,
                                          errorImagePath:
                                              'assets/images/doctor-pp.png',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Obx(
                                            () {
                                              return TitleText(
                                                title:
                                                    FitnessAppointmentController
                                                        .to
                                                        .getSingleDoctorDetails
                                                        .name!,
                                                fontSize: 18,
                                                color: Colors.black,
                                              );
                                            },
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.call_rounded,
                                                size: 18,
                                                color: kTextColor,
                                              ),
                                              space2R,
                                              Obx(
                                                () {
                                                  return TitleText(
                                                    title: FitnessAppointmentController
                                                        .to
                                                        .getSingleDoctorDetails
                                                        .contactNo!,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Colors.black54,
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                          Obx(
                                            () {
                                              return TitleText(
                                                title:
                                                    FitnessAppointmentController
                                                        .to
                                                        .getSingleDoctorDetails
                                                        .address!,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black54,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0)
                                      .copyWith(top: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TitleText(
                                    title: 'About Fitness Center',
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  space4C,
                                  Obx(
                                    () => TitleText(
                                      title:
                                          '${FitnessAppointmentController.to.getSingleDoctorDetails.name!} is one of the best fitness center.',
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.normal,
                                      height: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0)
                                      .copyWith(top: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TitleText(
                                    title: 'Working Time',
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  space4C,
                                  const TitleText(
                                    title: '08:00 AM - 12:00 AM',
                                    color: Colors.black,
                                    fontSize: 11,
                                    fontWeight: FontWeight.normal,
                                    height: 2,
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0, vertical: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: const [
                                  Text.rich(
                                    textAlign: TextAlign.center,
                                    TextSpan(
                                      text: 'Reviews',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black87,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '(4.9',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Align(
                                            alignment: Alignment.topCenter,
                                            child: Icon(
                                              Icons.star,
                                              color: Color(0xffF0A422),
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                        TextSpan(
                                          text: ')',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Text(
                                    'See Reviews',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const TitleText(
                                    title: 'Make Appointment',
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                  Row(
                                    children: [
                                      DirectionItem(
                                        label: 'Empty',
                                        fillColor: Colors.white,
                                        borderColor: kPrimaryColor,
                                      ),
                                      space2R,
                                      DirectionItem(
                                        label: 'Select Slot',
                                        fillColor: kPrimaryColor,
                                        borderColor: Colors.white,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 24,
                              ),
                              child: Obx(() => FitnessAppointmentController
                                      .to.getUniqueAppointmentList.isEmpty
                                  ? const Text('No Slot Available')
                                  : SizedBox(
                                      height: 90,
                                      child: ListView.builder(
                                          itemCount:
                                              FitnessAppointmentController
                                                  .to
                                                  .getUniqueAppointmentList
                                                  .length,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (_, index) {
                                            return AppointmentDateCard(
                                                info: FitnessAppointmentController
                                                        .to
                                                        .getUniqueAppointmentList[
                                                    index],
                                                isActive: index == _activeIndex,
                                                onTap: () {
                                                  _activeIndex = index;
                                                  setState(() {});
                                                });
                                          }),
                                    )),
                            )
                          ],
                        ),
                      ),
                    ),
                    PrimaryButton(
                      marginHorizontal: 24,
                      marginVertical: 16,
                      label: 'Book Appointment',
                      // isDisable: _activeIndex >= 0 ? false : true,
                      borderColor: Colors.transparent,
                      onPressed: () {
                        if (FitnessAppointmentController
                            .to.getUniqueAppointmentList.isEmpty) {
                          getSimpleDialog('Message',
                              'No Booking Slot Available for Booking');
                          // Fluttertoast.showToast(msg: 'No Booking Slot Available for Booking');
                        } else if (_activeIndex < 0) {
                          Fluttertoast.showToast(
                              msg:
                                  'Please Select Booking Date First from Above!');
                        } else {
                          FitnessAppointmentController.to
                              .setSelectedAppointmentSlot2(
                            FitnessAppointmentController.to.mapAppointmentList[
                                FitnessAppointmentController.to
                                    .uniqueAppointmentList2[_activeIndex].date]!,
                          );
                          Get.toNamed(FitnessBookAppointmentScreen.routeName);
                        }
                      },
                    ),
                  ],
                ),
        ));
  }
}

class DirectionItem extends StatelessWidget {
  const DirectionItem({
    Key? key,
    required this.label,
    this.fillColor,
    this.borderColor,
  }) : super(key: key);
  final String label;
  final Color? fillColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: fillColor!,
            border: Border.all(
              color: borderColor!,
              width: .8,
            ),
          ),
        ),
        space1R,
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

class AppointmentDateCard extends StatelessWidget {
  const AppointmentDateCard({
    Key? key,
    required this.onTap,
    this.isActive = false,
    this.info,
  }) : super(key: key);
  final Function() onTap;
  final bool? isActive;
  final GenericAppointmentSlotModel? info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isActive! ? kPrimaryColor : Colors.white,
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleText(
                    title: info!.day!,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: isActive! ? Colors.white : kPrimaryColor,
                  ),
                  TitleText(
                    title: info!.date!,
                    fontSize: 18,
                    color: isActive! ? Colors.white : kPrimaryColor,
                  ),
                ],
              ),
            ),
            if (!isActive!)
              Container(
                decoration: BoxDecoration(
                  color: isActive! ? Colors.white : kPrimaryColor,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(7),
                  ),
                ),
                child: TitleText(
                  title: 'Book Now +',
                  fontSize: 12,
                  color: isActive! ? kPrimaryColor : Colors.white,
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ShortInfo extends StatelessWidget {
  const ShortInfo({
    Key? key,
    this.position = 0,
    required this.imagePath,
    required this.title,
    required this.label,
  }) : super(key: key);
  final String imagePath, title, label;
  final int? position;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: position! < 0
            ? MainAxisAlignment.start
            : position! > 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/$imagePath.png',
            height: 11,
          ),
          space2R,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Tooltip(
                  message: title,
                  child: TitleText(
                    title: title,
                    color: Colors.black,
                    fontSize: 13,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                TitleText(
                  title: label,
                  color: Colors.black54,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdaptableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final ui.TextDirection textDirection;
  final double minimumFontScale;
  final TextOverflow textOverflow;

  const AdaptableText(this.text,
      {this.style,
      this.textAlign = TextAlign.left,
      this.textDirection = ui.TextDirection.ltr,
      this.minimumFontScale = 0.5,
      this.textOverflow = TextOverflow.ellipsis,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextPainter _painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: textAlign,
        textScaleFactor: 1,
        maxLines: 100,
        textDirection: textDirection);

    return LayoutBuilder(
      builder: (context, constraints) {
        _painter.layout(maxWidth: constraints.maxWidth);
        double textScaleFactor = 1;

        if (_painter.height > constraints.maxHeight) {
          //
          print('${_painter.size}');
          _painter.textScaleFactor = minimumFontScale;
          _painter.layout(maxWidth: constraints.maxWidth);
          print('${_painter.size}');

          if (_painter.height > constraints.maxHeight) {
            //
            //even minimum does not fit render it with minimum size
            print("Using minimum set font");
            textScaleFactor = minimumFontScale;
          } else if (minimumFontScale < 1) {
            //binary search for valid Scale factor
            int h = 100;
            int l = (minimumFontScale * 100).toInt();
            while (h > l) {
              int mid = (l + (h - l) / 2).toInt();
              double newScale = mid.toDouble() / 100.0;
              _painter.textScaleFactor = newScale;
              _painter.layout(maxWidth: constraints.maxWidth);

              if (_painter.height > constraints.maxHeight) {
                //
                h = mid - 1;
              } else {
                l = mid + 1;
              }
              if (h <= l) {
                print('${_painter.size}');
                textScaleFactor = newScale - 0.01;
                _painter.textScaleFactor = newScale;
                _painter.layout(maxWidth: constraints.maxWidth);
                break;
              }
            }
          }
        }

        return Text(
          this.text,
          style: this.style,
          textAlign: this.textAlign,
          textDirection: this.textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: 100,
          overflow: textOverflow,
        );
      },
    );
  }
}

///
///AdaptableText(
//                                 path.isEmpty
//                                     ? "face_text_1".tr().toString()
//                                     : "face_text_2".tr().toString(),
//                                 textAlign: TextAlign.center,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                     ),
//                               ),
