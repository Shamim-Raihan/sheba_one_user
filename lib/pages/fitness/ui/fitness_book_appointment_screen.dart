import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_appointment_controller.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../models/fitness_appointment_slot_model.dart';
import 'fitness_online_appointment_package_screen.dart';
import 'fitness_profile_screen.dart';

class FitnessBookAppointmentScreen extends StatefulWidget {
  const FitnessBookAppointmentScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessBookAppointmentScreen';

  @override
  State<FitnessBookAppointmentScreen> createState() => _FitnessBookAppointmentScreenState();
}

class _FitnessBookAppointmentScreenState extends State<FitnessBookAppointmentScreen> {
  // TextEditingController? _controller;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   _controller = TextEditingController();
  //   super.initState();
  // }
  String _time = '';
  FitnessAppointmentType? _type;
  FitnessAppointmentType? _appointmentType;
  GenericAppointmentSlotModel? _genericAppointmentSlotModel;

  @override
  void initState() {
    // TODO: implement initState
    Fluttertoast.showToast(
        msg: 'Select Time from Choose the time section!',
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER);
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
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
          child: const Center(
            child: TitleText(
              title: 'Book Appointment',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(
                          title: 'Appointment Date',
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        space4C,
                        Obx(() => TitleText(
                              title: FitnessAppointmentController.to.selectedAppointmentListByDate[0].fullDay!,
                              color: Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              height: 2,
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const TitleText(
                              title: 'Choose the time',
                              color: Colors.black,
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
                        space4C,
                        Obx(
                          () => Wrap(
                            children: FitnessAppointmentController.to.getSelectedAppointmentListByDate.map((e) {
                              return AppointmentTimeCard(
                                  time: e.startTime!,
                                  isActive: _time == e.startTime!,
                                  onTap: () {
                                    _time = e.startTime!;
                                    _appointmentType = e.type!;
                                    _genericAppointmentSlotModel = e;
                                    setState(() {});
                                  });
                            }).toList(),
                          ),
                        ),
                        space4C,
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: TitleText(
                      title: 'Fee Information',
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  Obx(() {
                    bool isExist = false;
                    for (var element in FitnessAppointmentController.to.getSelectedAppointmentListByDate) {
                      if (element.type == FitnessAppointmentType.gym) {
                        isExist = true;
                        break;
                      }
                    }
                    return isExist && (_appointmentType == null || _appointmentType == FitnessAppointmentType.gym)
                        ? AppointmentTypeCard(
                            isActive: _appointmentType != null && _appointmentType == FitnessAppointmentType.gym,
                            imagePath: 'online',
                            title: 'Gym Fee',
                            subtitle: 'Gym Fee',
                            price: '৳ ${FitnessAppointmentController.to.getSingleDoctorDetails.gymFee}',
                            onTap: () {
                              _appointmentType = FitnessAppointmentType.gym;
                              setState(() {});
                            },
                          )
                        : const SizedBox();
                  }),
                  Obx(() {
                    bool isExist = false;
                    for (var element in FitnessAppointmentController.to.getSelectedAppointmentListByDate) {
                      if (element.type == FitnessAppointmentType.yoga) {
                        isExist = true;
                        break;
                      }
                    }
                    return isExist && (_appointmentType == null || _appointmentType == FitnessAppointmentType.yoga)
                        ? AppointmentTypeCard(
                            isActive: _appointmentType != null && _appointmentType == FitnessAppointmentType.yoga,
                            imagePath: 'online',
                            title: 'Yoga Fee',
                            subtitle: 'Yoga Fee',
                            price: '৳ ${FitnessAppointmentController.to.getSingleDoctorDetails.yogaFee}',
                            onTap: () {
                              _appointmentType = FitnessAppointmentType.yoga;
                              setState(() {});
                            },
                          )
                        : const SizedBox();
                  }),
                  Obx(() {
                    bool isExist = false;
                    for (var element in FitnessAppointmentController.to.getSelectedAppointmentListByDate) {
                      if (element.type == FitnessAppointmentType.wellness) {
                        isExist = true;
                        break;
                      }
                    }
                    return isExist && (_appointmentType == null || _appointmentType == FitnessAppointmentType.wellness)
                        ? AppointmentTypeCard(
                            isActive: _appointmentType != null && _appointmentType == FitnessAppointmentType.wellness,
                            imagePath: 'online',
                            title: 'Wellness Fee',
                            subtitle: 'Wellness Fee',
                            price: '৳ ${FitnessAppointmentController.to.getSingleDoctorDetails.wellnessFee}',
                            onTap: () {
                              _appointmentType = FitnessAppointmentType.wellness;
                              setState(() {});
                            },
                          )
                        : const SizedBox();
                  }),
                ],
              ),
            ),
          ),
          PrimaryButton(
            marginHorizontal: 24,
            marginVertical: 16,
            label: 'Book Appointment',
            isDisable: _time.isNotEmpty && _appointmentType != null ? false : true,
            borderColor: Colors.transparent,
            onPressed: () {
              Get.toNamed(FitnessOnlinePackagePackageScreen.routeName, arguments: _genericAppointmentSlotModel);
            },
          ),
        ],
      ),
    );
  }
}

class AppointmentTimeCard extends StatelessWidget {
  const AppointmentTimeCard({
    Key? key,
    required this.onTap,
    required this.time,
    this.isActive = false,
  }) : super(key: key);
  final Function() onTap;
  final bool? isActive;
  final String time;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: isActive! ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10) : EdgeInsets.zero,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: isActive! ? kPrimaryColor : Colors.white,
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            TitleText(
              title: time,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive! ? Colors.white : kPrimaryColor,
            ),
            if (!isActive!)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isActive! ? Colors.white : kPrimaryColor,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(4),
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

class AppointmentTypeCard extends StatelessWidget {
  const AppointmentTypeCard({
    Key? key,
    required this.onTap,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    this.isActive = false,
  }) : super(key: key);
  final Function() onTap;
  final bool? isActive;
  final String imagePath, title, subtitle, price;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isActive! ? kPrimaryColor : Colors.white,
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: isActive! ? const Color(0xffD6E5DE) : kPrimaryColor.withOpacity(.15),
              ),
              child: Image.asset(
                'assets/icons/$imagePath.png',
                height: 20,
                width: 20,
                color: isActive! ? kPrimaryColor : Colors.white,
              ),
            ),
            space4R,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  title: title,
                  fontSize: 14,
                  color: isActive! ? Colors.white : Colors.black87,
                ),
                TitleText(
                  title: subtitle,
                  fontSize: 9,
                  color: isActive! ? Colors.white : Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
            Spacer(),
            TitleText(
              title: price,
              fontSize: 14,
              color: isActive! ? Colors.white : kPrimaryColor,
            ),
          ],
        ),
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
