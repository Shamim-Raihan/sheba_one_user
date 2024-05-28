import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/ssl.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/get_dialogs.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../controllers/fitness_appointment_controller.dart';
import '../../../models/fitness_appointment_slot_model.dart';
import 'fitness_appointment_done_screen.dart';

class FitnessAppointmentDetailsScreen extends StatefulWidget {
  const FitnessAppointmentDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessAppointmentDetailsScreen';

  @override
  State<FitnessAppointmentDetailsScreen> createState() =>
      _FitnessAppointmentDetailsScreenState();
}

class _FitnessAppointmentDetailsScreenState
    extends State<FitnessAppointmentDetailsScreen> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _referController;
  TextEditingController? _problemController;
  GenericAppointmentSlotModel? data;

  @override
  void initState() {
    FitnessAppointmentController.to.appointmentLoading.value = false;
    // TODO: implement initState
    _nameController = TextEditingController();
    _phoneController =
        TextEditingController(text: UserController.to.getUserInfo.mobile!);
    _problemController = TextEditingController();
    _referController = TextEditingController();
    data = Get.arguments;

    super.initState();
  }

  PaymentMethod _paymentMethod = PaymentMethod.online;

  final ImagePicker _picker = ImagePicker();
  XFile? image;
  List<XFile> images = [];
  int fileNameIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: kScaffoldColor,
            title: Container(
              height: 30,
              width: Get.width * .6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
              child: const Center(
                child: TitleText(
                  title: 'Appointment Details',
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
                      Container(
                        height: data!.type == FitnessAppointmentType.gym
                            ? 142
                            : 110,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: .3,
                            color: kPrimaryColor.withOpacity(.2),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(1, 3),
                            )
                          ],
                          color: kScaffoldColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Obx(
                                () => Image.network(
                                  FitnessAppointmentController
                                      .to.getSingleDoctorDetails.imagePath!,
                                  height:
                                      data!.type == FitnessAppointmentType.gym
                                          ? 142
                                          : 110,
                                  width: 110,
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, exception, stackTrack) =>
                                          Image.asset(
                                    'assets/images/doctor-pp.png',
                                    height:
                                        data!.type == FitnessAppointmentType.gym
                                            ? 142
                                            : 110,
                                    width: 110,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),

                              // Image.asset(
                              //   'assets/images/doc.png',
                              //   height: data!.type ==
                              //           AppointmentType.home
                              //       ? 142
                              //       : 110,
                              //   width: 110,
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8)
                                    .copyWith(right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () {
                                        return TitleText(
                                          title: FitnessAppointmentController
                                              .to.getSingleDoctorDetails.name!,
                                          fontSize: 18,
                                          color: Colors.black,
                                        );
                                      },
                                    ),
                                    Row(
                                      children: [
                                        const TitleText(
                                          title: 'Fees: ',
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        space2R,
                                        Obx(
                                          () => TitleText(
                                            title: data!.type ==
                                                    FitnessAppointmentType
                                                        .wellness
                                                ? FitnessAppointmentController
                                                        .to
                                                        .getSingleDoctorDetails
                                                        .wellnessFee ??
                                                    "0"
                                                : data!.type ==
                                                        FitnessAppointmentType
                                                            .yoga
                                                    ? FitnessAppointmentController
                                                            .to
                                                            .getSingleDoctorDetails
                                                            .yogaFee ??
                                                        "0"
                                                    : FitnessAppointmentController
                                                            .to
                                                            .getSingleDoctorDetails
                                                            .gymFee ??
                                                        "0",
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // if (data!.type ==
                                    //     FitnessAppointmentType.gym)
                                    //   Row(
                                    //     children: [
                                    //       Image.asset(
                                    //           'assets/icons/calender.png'),
                                    //       space2R,
                                    //       Expanded(
                                    //         child: TitleText(
                                    //           title: data!.dmy!,
                                    //           fontSize: 12,
                                    //           color: Colors.black,
                                    //         ),
                                    //       ),
                                    //       space4R,
                                    //       Image.asset(
                                    //         'assets/icons/clock.png',
                                    //         height: 18,
                                    //       ),
                                    //       space1R,
                                    //       Expanded(
                                    //         child: TitleText(
                                    //           title:
                                    //               data!.startTime!,
                                    //           fontSize: 12,
                                    //           color: Colors.black,
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // if (data!.type == AppointmentType.online ||
                      //     data!.type == AppointmentType.clinic)
                      Container(
                        height: 80,
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
                            Container(
                              width: 110,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: kPrimaryColor.withOpacity(.2),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/online-appointment.png',
                                  height: 54,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 8)
                                    .copyWith(right: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Obx(
                                      () => TitleText(
                                        title: FitnessAppointmentController
                                            .to.getSingleDoctorDetails.address!,
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                            'assets/icons/calender.png'),
                                        space2R,
                                        TitleText(
                                          title: data!.dmy!,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                        space4R,
                                        Image.asset(
                                          'assets/icons/clock.png',
                                          height: 18,
                                        ),
                                        space1R,
                                        TitleText(
                                          title: data!.startTime!,
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MainContainer(
                        color: Colors.white,
                        borderColor: kPrimaryColor.withOpacity(.2),
                        verticalPadding: 24,
                        child: Column(
                          children: [
                            const TitleText(
                              title: 'Enter your information',
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
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
                              fillColor: Colors.white,
                              keyboardType: TextInputType.number,
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
                            ),
                            space2C,
                            CustomTextField(
                              controller: _referController!,
                              labelText: 'Refer Code',
                              hintText: 'Refer Code (Optional)',
                              hintTextStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: kTextColorLite,
                              ),
                              onChanged: (val) {
                                FitnessAppointmentController.to.refferCode(val);
                              },
                              fillColor: Colors.white,
                              horizontalPadding: 0,
                              labelTextFontSize: 14,
                              verticalPadding: 0,
                              isOuterBorderExist: true,
                              textFieldHorizontalContentPadding: 16,
                            ),
                          ],
                        ),
                      ),
                      space5C,
                      MainContainer(
                        borderColor: Colors.transparent,
                        withBoxShadow: true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TitleText(
                              title: 'Choose Payment Method',
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            space3C,
                            // CustomRadio(
                            //   label: 'Cash on Delivery',
                            //   group: _paymentMethod,
                            //   value: PaymentMethod.cod,
                            //   onChanged: (dynamic value) {
                            //     setState(() {
                            //       _paymentMethod = value;
                            //       print(value.toString());
                            //     });
                            //   },
                            // ),
                            CustomRadio(
                              label: 'Bkash',
                              group: _paymentMethod,
                              value: PaymentMethod.mobileBanking,
                              onChanged: (dynamic value) {
                                Fluttertoast.showToast(
                                    msg:
                                        'Please select  online  payment option, once you select  mobile  banking,  you will find Bikash or Nagad payment option there');
                                // setState(() {
                                //   _paymentMethod = value;
                                //   print(value.toString());
                                // });
                              },
                            ),
                            CustomRadio(
                              label: 'Nagad',
                              group: _paymentMethod,
                              value: PaymentMethod.mobileBanking,
                              onChanged: (dynamic value) {
                                Fluttertoast.showToast(
                                    msg:
                                        'Please select  online  payment option, once you select  mobile  banking,  you will find Bikash or Nogad payment option there');

                                // setState(() {
                                //   _paymentMethod = value;
                                //   print(value.toString());
                                // });
                              },
                            ),
                            CustomRadio(
                              label: 'Online Payment',
                              group: _paymentMethod,
                              value: PaymentMethod.online,
                              onChanged: (dynamic value) {
                                setState(() {
                                  _paymentMethod = value;
                                  print(value.toString());
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      space5C,
                    ],
                  ),
                ),
              ),
              space2C,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text.rich(
                  textAlign: TextAlign.center,
                  TextSpan(
                    text: '*',
                    style: TextStyle(
                        color: kPrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                    children: [
                      TextSpan(
                        text:
                            "You will have to make full payment of fitness center fees (${double.parse(
                          data!.type == FitnessAppointmentType.wellness
                              ? FitnessAppointmentController
                                      .to.getSingleDoctorDetails.wellnessFee ??
                                  "0"
                              : data!.type == FitnessAppointmentType.yoga
                                  ? FitnessAppointmentController
                                          .to.getSingleDoctorDetails.yogaFee ??
                                      "0"
                                  : FitnessAppointmentController
                                          .to.getSingleDoctorDetails.gymFee ??
                                      "0",
                        )} Taka) before confirming this appointment",
                        style: TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              PrimaryButton(
                marginHorizontal: 24,
                marginVertical: 16,
                label: "Pay ${double.parse(
                  data!.type == FitnessAppointmentType.wellness
                      ? FitnessAppointmentController
                              .to.getSingleDoctorDetails.wellnessFee ??
                          "0"
                      : data!.type == FitnessAppointmentType.yoga
                          ? FitnessAppointmentController
                                  .to.getSingleDoctorDetails.yogaFee ??
                              "0"
                          : FitnessAppointmentController
                                  .to.getSingleDoctorDetails.gymFee ??
                              "0",
                )} Taka",
                borderColor: Colors.transparent,
                onPressed: () async {
                  if (_nameController!.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Enter Patient Name!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (_phoneController!.text.isEmpty) {
                    Fluttertoast.showToast(
                        msg: "Enter Patient Mobile No!",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.redAccent,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    final double fee = double.parse(
                            data!.type == FitnessAppointmentType.wellness
                                ? FitnessAppointmentController.to
                                        .getSingleDoctorDetails.wellnessFee ??
                                    "0"
                                : data!.type == FitnessAppointmentType.yoga
                                    ? FitnessAppointmentController.to
                                            .getSingleDoctorDetails.yogaFee ??
                                        "0"
                                    : FitnessAppointmentController
                                            .to.getSingleDoctorDetails.gymFee ??
                                        "0");
                    SSLCTransactionInfoModel res =
                        await sslCommerzGeneralCallTest(
                      fee,
                      'Fitness Appointment',
                    );

                    print(res.toJson());

                    if (res.status!.toLowerCase() == 'valid') {
                      FitnessAppointmentController.to
                          .appointmentType(data!.type);

                      final info = {
                        "fitness_info_id": data!.doctorId!,
                        "fitness_appointment_slot_id": data!.slotId!,
                        "patient_name": _nameController!.text,
                        "patient_phone": _phoneController!.text,
                        "city": FitnessAppointmentController
                            .to.getSingleDoctorDetails.city!,
                        "user_id": UserController.to.getUserInfo.id,
                        "fees": data!.type == FitnessAppointmentType.wellness
                            ? FitnessAppointmentController
                                .to.getSingleDoctorDetails.wellnessFee!
                            : data!.type == FitnessAppointmentType.yoga
                                ? FitnessAppointmentController
                                    .to.getSingleDoctorDetails.yogaFee!
                                : FitnessAppointmentController
                                    .to.getSingleDoctorDetails.gymFee!,
                        "refer_code":
                            FitnessAppointmentController.to.refferCode.value,
                        "service_charge": (double.parse(
                                  data!.type == FitnessAppointmentType.wellness
                                      ? FitnessAppointmentController.to
                                          .getSingleDoctorDetails.wellnessFee!
                                      : data!.type ==
                                              FitnessAppointmentType.yoga
                                          ? FitnessAppointmentController.to
                                              .getSingleDoctorDetails.yogaFee!
                                          : FitnessAppointmentController.to
                                              .getSingleDoctorDetails.gymFee!,
                                ) *
                                HomeController
                                    .to.commission['fitness_commission'] /
                                100)
                            .toStringAsFixed(2),
                        "payment_type": res.cardIssuer!,
                        "payment_transaction_id": res.tranId,
                        "bank_transaction_id": res.bankTranId,
                        "appointment_type": data!.type ==
                                FitnessAppointmentType.wellness
                            ? 'Wellness'
                            : data!.type == FitnessAppointmentType.yoga
                                ? 'Yoga'
                                : 'Gym',
                        "online_type": FitnessAppointmentController
                                    .to.onlinePackageType.value ==
                                OnlinePackageType.audio
                            ? 'Audio'
                            : 'Video',
                        "patient_problem": _problemController!.text,
                      };
                      globalLogger.d(info, "APPOINTMENT INFO");

                      final postAppointment = await FitnessAppointmentController
                          .to
                          .doctorAppointment(info);
                      globalLogger.d(postAppointment, "APPOINTMENT INFO");
                      if (postAppointment) {
                        // globalLogger.d('Success');
                        // congratsDialoge(
                        //   context,
                        // );
                        FitnessAppointmentController.to.getSingleDoctor(
                            FitnessAppointmentController
                                .to.getSingleDoctorDetails.id!);
                        Get.toNamed(
                          FitnessAppointmentDoneScreen.routeName,
                          arguments: {
                            'info': info,
                            'data': data!.toJson(),
                            'ssl_res': res.toJson(),
                          },
                        );
                      }
                    }
                  }

                  ///TODO: DIALOG OPEN
                  // congratsDialoge(
                  //   context,
                  //   iconPath: 'book-appointment-failed',
                  //   title: 'Oops, Failed!',
                  //   titleColor: const Color(0xffFF7B8E),
                  //   subTitle:
                  //       'Appoinment failed because of session expired. Please check your internet then try again.',
                  //   isButtonExist: true,
                  //   onTap: () {
                  //     Get.back();
                  //     Get.toNamed(DoctorReviewScreen.routeName);
                  //   },
                  // );
                },
              ),
            ],
          ),
        ),
        if (FitnessAppointmentController.to.appointmentLoading.value)
          Container(
            height: Get.height,
            width: Get.width,
            color: Colors.black26,
            child: Center(
              child: Container(
                height: Get.width * .5,
                width: Get.width * .5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 4)
                  ],
                  color: Colors.white,
                ),
                child: const Waiting(),
              ),
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
  }) : super(key: key);
  final Function() onTap;
  final bool? isActive;

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
            TitleText(
              title: 'Mon',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: isActive! ? Colors.white : kPrimaryColor,
            ),
            space2C,
            TitleText(
              title: '02',
              fontSize: 18,
              color: isActive! ? Colors.white : kPrimaryColor,
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
    return Flexible(
      child: Row(
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: title, color: Colors.black, fontSize: 13),
              TitleText(
                title: label,
                color: Colors.black54,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ],
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
