import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/fitness_appointment_controller.dart';
import 'package:shebaone/models/fitness_appointment_slot_model.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import 'fitness_appointment_details_screen.dart';

class FitnessOnlinePackagePackageScreen extends StatefulWidget {
  const FitnessOnlinePackagePackageScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessOnlinePackagePackageScreen';

  @override
  State<FitnessOnlinePackagePackageScreen> createState() =>
      _FitnessOnlinePackagePackageScreenState();
}

class _FitnessOnlinePackagePackageScreenState
    extends State<FitnessOnlinePackagePackageScreen> {
  // TextEditingController? _controller;
  GenericAppointmentSlotModel? _genericAppointmentSlotModel;

  @override
  void initState() {
    // TODO: implement initState
    _genericAppointmentSlotModel = Get.arguments;
    super.initState();
  }

  int _activeIndex = -1;
  String _time = '';
  OnlinePackageType? _packageType;
  List<String> _timeList = [
    '15',
    '30',
    '45',
    '60',
  ];

  String _selectedText = '15';

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
              title: 'Select Package',
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24.0)
                  //       .copyWith(top: 24),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       const TitleText(
                  //         title: 'Select Duration',
                  //         color: Colors.black,
                  //         fontSize: 14,
                  //       ),
                  //       space4C,
                  //       CustomDropDownMenu(
                  //         hintText: 'Minutes',
                  //         extension: 'minutes',
                  //         list: _timeList,
                  //         leftPadding: 16,
                  //         onChange: (val) {
                  //           _selectedText = val;
                  //           setState(() {});
                  //         },
                  //         selectedOption: _selectedText,
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: TitleText(
                      title: 'Choose Package',
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                  Obx(
                    () => PackageTypeCard(
                      isActive: _packageType != null &&
                          _packageType == OnlinePackageType.video,
                      imagePath: 'online-video',
                      title: 'Video Call',
                      subtitle: 'Video call with fitness center',
                      price:
                          '৳ ${_genericAppointmentSlotModel?.type == FitnessAppointmentType.wellness ? FitnessAppointmentController.to.getSingleDoctorDetails.wellnessFee : _genericAppointmentSlotModel?.type == FitnessAppointmentType.yoga ? FitnessAppointmentController.to.getSingleDoctorDetails.yogaFee : FitnessAppointmentController.to.getSingleDoctorDetails.gymFee}',
                      // '৳ ${(300 * (int.parse(_selectedText) / 15)).floor()}',
                      // minutes: '/$_selectedText mins',
                      onTap: () {
                        _packageType = OnlinePackageType.video;
                        setState(() {});
                      },
                    ),
                  ),
                  Obx(
                    () => PackageTypeCard(
                      isActive: _packageType != null &&
                          _packageType == OnlinePackageType.audio,
                      imagePath: 'online-audio',
                      title: 'Voice Call',
                      subtitle: 'Voice call with fitness center',
                      price:
                          '৳ ${_genericAppointmentSlotModel?.type == FitnessAppointmentType.wellness ? FitnessAppointmentController.to.getSingleDoctorDetails.wellnessFee : _genericAppointmentSlotModel?.type == FitnessAppointmentType.yoga ? FitnessAppointmentController.to.getSingleDoctorDetails.yogaFee : FitnessAppointmentController.to.getSingleDoctorDetails.gymFee}',
                      onTap: () {
                        _packageType = OnlinePackageType.audio;
                        setState(() {});
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          PrimaryButton(
            marginHorizontal: 24,
            marginVertical: 16,
            label: 'Book Package',
            isDisable: _packageType != null ? false : true,
            borderColor: Colors.transparent,
            onPressed: () {
              // final Map<String, dynamic> data = {
              //   'time': Get.arguments['time'],
              //   'appointment_type': Get.arguments['appointment_type'],
              //   'Package_type': _packageType,
              // };
              FitnessAppointmentController.to
                  .setOnlinePackageType(_packageType!);
              Get.toNamed(FitnessAppointmentDetailsScreen.routeName,
                  arguments: _genericAppointmentSlotModel);
            },
          ),
        ],
      ),
    );
  }
}

class PackageTypeCard extends StatelessWidget {
  const PackageTypeCard({
    Key? key,
    required this.onTap,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.price,
    this.minutes,
    this.isActive = false,
  }) : super(key: key);
  final Function() onTap;
  final bool? isActive;
  final String imagePath, title, subtitle, price;
  final String? minutes;

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
                color: isActive!
                    ? const Color(0xffD6E5DE)
                    : kPrimaryColor.withOpacity(.15),
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
            const Spacer(),
            Column(
              children: [
                TitleText(
                  title: price,
                  fontSize: 14,
                  color: isActive! ? Colors.white : kPrimaryColor,
                ),
                if (minutes != null)
                  TitleText(
                    title: minutes!,
                    fontSize: 9,
                    color: isActive! ? Colors.white : Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
              ],
            ),
            space3R,
            Icon(
              isActive!
                  ? Icons.radio_button_checked_outlined
                  : Icons.radio_button_off_outlined,
              color: isActive! ? Colors.white : kTextColor,
            )
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
