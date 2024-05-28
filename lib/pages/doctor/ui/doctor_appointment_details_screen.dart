import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/appointment_slot_model.dart';
import 'package:shebaone/pages/doctor/ui/doctor_appointment_done_screen.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/ssl.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/get_dialogs.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class DoctorAppointmentDetailsScreen extends StatefulWidget {
  const DoctorAppointmentDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/DoctorAppointmentDetailsScreen';
  @override
  State<DoctorAppointmentDetailsScreen> createState() => _DoctorAppointmentDetailsScreenState();
}

class _DoctorAppointmentDetailsScreenState extends State<DoctorAppointmentDetailsScreen> {
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  TextEditingController? _addressController;
  TextEditingController? _referController;
  TextEditingController? _problemController;
  GenericAppointmentSlotModel? data;
  @override
  void initState() {
    // TODO: implement initState
    _nameController = TextEditingController();
    _phoneController = TextEditingController(text: UserController.to.getUserInfo.mobile!);
    _addressController = TextEditingController();
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
    return Obx(
      () => AuthController.to.getUserId.isEmpty
          ? LoginScreen(
              from: DoctorAppointmentDetailsScreen.routeName,
            )
          : AuthController.to.getUserId.isNotEmpty && AuthController.to.getIsVerified == false
              ? VerifyScreen(
                  from: DoctorAppointmentDetailsScreen.routeName,
                )
              : Stack(
                  children: [
                    Scaffold(
                      appBar: AppBar(
                        backgroundColor: kScaffoldColor,
                        title: Container(
                          height: 30,
                          width: Get.width * .6,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
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
                                    height: data!.type == AppointmentType.home ? 142 : 110,
                                    margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                              DoctorAppointmentController.to.getSingleDoctorDetails.imagePath!,
                                              height: data!.type == AppointmentType.home ? 142 : 110,
                                              width: 110,
                                              fit: BoxFit.fill,
                                              loadingBuilder: (BuildContext context, Widget child,
                                                  ImageChunkEvent? loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return Center(
                                                  child: CircularProgressIndicator(
                                                    value: loadingProgress.expectedTotalBytes != null
                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                            loadingProgress.expectedTotalBytes!
                                                        : null,
                                                  ),
                                                );
                                              },
                                              errorBuilder: (context, exception, stackTrack) => Image.asset(
                                                'assets/images/doctor-pp.png',
                                                height: data!.type == AppointmentType.home ? 142 : 110,
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
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                                                .copyWith(right: 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Obx(
                                                  () {
                                                    return TitleText(
                                                      title:
                                                          DoctorAppointmentController.to.getSingleDoctorDetails.name!,
                                                      fontSize: 18,
                                                      color: Colors.black,
                                                    );
                                                  },
                                                ),
                                                Obx(
                                                  () {
                                                    return TitleText(
                                                      title: DoctorAppointmentController.to.getSpecializationName(
                                                          DoctorAppointmentController
                                                              .to.getSingleDoctorDetails.specialization!),
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
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
                                                        title: data!.type == AppointmentType.online
                                                            ? DoctorAppointmentController.to.onlinePackageType.value ==
                                                                    OnlinePackageType.audio
                                                                ? DoctorAppointmentController
                                                                    .to.getSingleDoctorDetails.audioConsultFee!
                                                                : DoctorAppointmentController
                                                                    .to.getSingleDoctorDetails.videoConsultFee!
                                                            : data!.type == AppointmentType.home
                                                                ? DoctorAppointmentController
                                                                    .to.getSingleDoctorDetails.homeConsultFee!
                                                                : DoctorAppointmentController
                                                                    .to.getSingleDoctorDetails.consultFee!,
                                                        fontSize: 13,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                if (data!.type == AppointmentType.home)
                                                  Row(
                                                    children: [
                                                      Image.asset('assets/icons/calender.png'),
                                                      space2R,
                                                      Expanded(
                                                        child: TitleText(
                                                          title: data!.dmy!,
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                      space4R,
                                                      Image.asset(
                                                        'assets/icons/clock.png',
                                                        height: 18,
                                                      ),
                                                      space1R,
                                                      Expanded(
                                                        child: TitleText(
                                                          title: data!.startTime!,
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (data!.type == AppointmentType.online || data!.type == AppointmentType.clinic)
                                    Container(
                                      height: 80,
                                      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                                                data!.type == AppointmentType.clinic
                                                    ? 'assets/icons/medical.png'
                                                    : 'assets/icons/online-appointment.png',
                                                height: 54,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8)
                                                  .copyWith(right: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Obx(
                                                    () => TitleText(
                                                      title: DoctorAppointmentController
                                                          .to.getSingleDoctorDetails.chamber!,
                                                      fontSize: 14,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Image.asset('assets/icons/calender.png'),
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
                                        if (data!.type == AppointmentType.home)
                                          CustomTextField(
                                            controller: _addressController!,
                                            labelText: 'Address',
                                            hintText: 'Address',
                                            isRequired: true,
                                            hintTextStyle: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: kTextColorLite,
                                            ),
                                            fillColor: Colors.white,
                                            horizontalPadding: 0,
                                            labelTextFontSize: 14,
                                            verticalPadding: 0,
                                            isOuterBorderExist: true,
                                            textFieldHorizontalContentPadding: 16,
                                          ),
                                        if (data!.type == AppointmentType.online)
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
                                                        images = [];
                                                        images.add(value!);
                                                        image = value;

                                                        fileNameIndex = value.path.toString().indexOf('cache') + 6;
                                                        setState(() {});
                                                      });
                                                    },
                                                    upload: () async {
                                                      Get.back();
                                                      await _picker.pickMultiImage().then(
                                                        (value) {
                                                          images = value!;
                                                          image = images[0];
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
                                              space2C,
                                              const Text(
                                                'Write your problem',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              space2C,
                                              MainContainer(
                                                horizontalMargin: 0,
                                                horizontalPadding: 0,
                                                withBoxShadow: true,
                                                borderColor: Colors.transparent,
                                                borderRadius: 12,
                                                child: CustomTextField(
                                                  textFieldHeight: 100,
                                                  controller: _problemController!,
                                                  hintTextStyle: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w500,
                                                    color: kTextColorLite,
                                                  ),
                                                  hintText: 'Type here....',
                                                  fillColor: Colors.white,
                                                  horizontalPadding: 0,
                                                  horizontalMargin: 0,
                                                  verticalMargin: 0,
                                                  labelTextFontSize: 14,
                                                  verticalPadding: 0,
                                                  keyboardType: TextInputType.multiline,
                                                  textFieldHorizontalContentPadding: 16,
                                                  maxLines: 10,
                                                ),
                                              ),

                                            ],
                                          ),

                                        if (data!.type == AppointmentType.online)
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
                                          onChanged: (val){
                                            DoctorAppointmentController.to.refferCode(val);
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
                                            Fluttertoast.showToast(msg: 'Please select  online  payment option, once you select  mobile  banking,  you will find Bikash or Nogad payment option there');
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
                                            Fluttertoast.showToast(msg: 'Please select  online  payment option, once you select  mobile  banking,  you will find Bikash or Nogad payment option there');

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
                              textAlign:TextAlign.center,
                              TextSpan(
                                text: '*',
                                style:  TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                ),

                                children: [
                                  TextSpan(
                                    text: data!.type == AppointmentType.online
                                        ? "You will have to make full payment of doctor fees (${double.parse(DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee!)} Taka) before confirming this appointment"
                                        : 'Pay ${(double.parse(data!.type == AppointmentType.online ? DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee! : data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) * HomeController.to.commission['doctor_commission'] / 100).toStringAsFixed(2)}  Taka Service charge now, remaining ${(double.parse(data!.type == AppointmentType.online ? DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee! : data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) - (double.parse(data!.type == AppointmentType.online ? DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee! : data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) * 5 / 100)).toStringAsFixed(2)} Taka pay to doctor.',
                                    style:TextStyle(
                                        color: kPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          PrimaryButton(
                            marginHorizontal: 24,
                            marginVertical: 16,
                            label:data!.type == AppointmentType.online? "Pay ${double.parse(DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee!).toStringAsFixed(2)} Taka": 'Pay ${(double.parse(data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) * HomeController.to.commission['doctor_commission'] / 100).toStringAsFixed(2)} Taka Service charge now',
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
                                final double fee = data!.type == AppointmentType.online
                                    ? double.parse(DoctorAppointmentController.to.onlinePackageType.value ==
                                            OnlinePackageType.audio
                                        ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee!
                                        : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee!)
                                    : double.parse(data!.type == AppointmentType.clinic
                                            ? DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!
                                            : DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee!) *
                                        (HomeController.to.commission['doctor_commission'] ?? 5) /
                                        100;
                                SSLCTransactionInfoModel res = await sslCommerzGeneralCallTest(
                                  fee,
                                  'Doctor Appointment',
                                );
                                if (res.status!.toLowerCase() == 'valid') {
                                  ///CLINIC APPOINTMENT
                                  if (data!.type == AppointmentType.clinic) {
                                    DoctorAppointmentController.to.appointmentType(AppointmentType.clinic);
                                    final info = {
                                      "doctor_info_id": data!.doctorId!,
                                      "appointment_slot_id": data!.slotId!,
                                      "patient_name": _nameController!.text,
                                      "patient_phone": _phoneController!.text,
                                      "city": DoctorAppointmentController.to.getSingleDoctorDetails.city!,
                                      "user_id": UserController.to.getUserInfo.id,
                                      "fees": DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!,
                                      "refer_code": DoctorAppointmentController.to.refferCode.value,
                                      "service_charge": (double.parse(data!.type == AppointmentType.online ? DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee! : data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) * HomeController.to.commission['doctor_commission'] / 100).toStringAsFixed(2),
                                      "payment_type": res.cardIssuer!,
                                      "payment_transaction_id": res.tranId,
                                      "bank_transaction_id": res.bankTranId,
                                      "appointment_type": 'Regular',
                                    };
                                    globalLogger.d(info, "APPOINTMENT INFO");

                                    final postAppointment =
                                        await DoctorAppointmentController.to.doctorAppointment(info);
                                    if (postAppointment) {
                                      // globalLogger.d('Success');
                                      // congratsDialoge(
                                      //   context,
                                      // );

                                      DoctorAppointmentController.to
                                          .getSingleDoctor(DoctorAppointmentController.to.getSingleDoctorDetails.id!);
                                      Get.toNamed(
                                        DoctorAppointmentDoneScreen.routeName,
                                        arguments: {
                                          'info': info,
                                          'data': data!.toJson(),
                                          'ssl_res': res.toJson(),
                                        },
                                      );
                                    }
                                  }

                                  ///ONLINE APPOINTMENT
                                  else if (data!.type == AppointmentType.online) {
                                    DoctorAppointmentController.to.appointmentType(AppointmentType.online);

                                    List<String> imageList = [];
                                    for (var element in images) {
                                      final path = element.path;
                                      final base64 = base64Encode(File(path).readAsBytesSync());
                                      imageList.add(base64);
                                    }
                                    globalLogger.d(imageList);
                                    String jsonStringMap = json.encode(imageList);
                                    final info = {
                                      "doctor_info_id": data!.doctorId!,
                                      "appointment_slot_id": data!.slotId!,
                                      "patient_name": _nameController!.text,
                                      "patient_phone": _phoneController!.text,
                                      "city": DoctorAppointmentController.to.getSingleDoctorDetails.city!,
                                      "user_id": UserController.to.getUserInfo.id,
                                      "fees": DoctorAppointmentController.to.onlinePackageType.value ==
                                              OnlinePackageType.audio
                                          ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee!
                                          : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee!,
                                      "refer_code": DoctorAppointmentController.to.refferCode.value,
                                      "service_charge": (double.parse(data!.type == AppointmentType.online ? DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee! : data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) * HomeController.to.commission['doctor_commission'] / 100).toStringAsFixed(2),
                                      "payment_type": res.cardIssuer!,
                                      "payment_transaction_id": res.tranId,
                                      "bank_transaction_id": res.bankTranId,
                                      "appointment_type": 'Online',
                                      "online_type": DoctorAppointmentController.to.onlinePackageType.value ==
                                              OnlinePackageType.audio
                                          ? 'Audio'
                                          : 'Video',
                                      "patient_problem": _problemController!.text,
                                      "report_upload": jsonStringMap,
                                    };
                                    globalLogger.d(info, "APPOINTMENT INFO");


                                    final postAppointment =
                                        await DoctorAppointmentController.to.doctorAppointment(info);
                                    if (postAppointment) {
                                      // globalLogger.d('Success');
                                      // congratsDialoge(
                                      //   context,
                                      // );
                                      DoctorAppointmentController.to
                                          .getSingleDoctor(DoctorAppointmentController.to.getSingleDoctorDetails.id!);
                                      Get.toNamed(
                                        DoctorAppointmentDoneScreen.routeName,
                                        arguments: {
                                          'info': info,
                                          'data': data!.toJson(),
                                          'ssl_res': res.toJson(),
                                        },
                                      );
                                    }
                                  }

                                  ///HOME APPOINTMENT
                                  else {
                                    DoctorAppointmentController.to.appointmentType(AppointmentType.home);

                                    final info = {
                                      "doctor_info_id": data!.doctorId!,
                                      "appointment_slot_id": data!.slotId!,
                                      "patient_name": _nameController!.text,
                                      "patient_phone": _phoneController!.text,
                                      "patient_address": _addressController!.text,
                                      "city": DoctorAppointmentController.to.getSingleDoctorDetails.city!,
                                      "user_id": UserController.to.getUserInfo.id,
                                      "fees": DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee!,
                                      "refer_code": DoctorAppointmentController.to.refferCode.value,
                                      "service_charge": (double.parse(data!.type == AppointmentType.online ? DoctorAppointmentController.to.onlinePackageType.value == OnlinePackageType.audio ? DoctorAppointmentController.to.getSingleDoctorDetails.audioConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.videoConsultFee! : data!.type == AppointmentType.home ? DoctorAppointmentController.to.getSingleDoctorDetails.homeConsultFee! : DoctorAppointmentController.to.getSingleDoctorDetails.consultFee!) * HomeController.to.commission['doctor_commission'] / 100).toStringAsFixed(2),
                                      "payment_type": res.cardIssuer!,
                                      "payment_transaction_id": res.tranId,
                                      "bank_transaction_id": res.bankTranId,
                                      "appointment_type": 'Home',
                                    };
                                    globalLogger.d(info, "APPOINTMENT INFO");


                                    final postAppointment =
                                        await DoctorAppointmentController.to.doctorAppointment(info);
                                    if (postAppointment) {
                                      // globalLogger.d('Success');
                                      // congratsDialoge(
                                      //   context,
                                      // );

                                      DoctorAppointmentController.to
                                          .getSingleDoctor(DoctorAppointmentController.to.getSingleDoctorDetails.id!);
                                      Get.toNamed(
                                        DoctorAppointmentDoneScreen.routeName,
                                        arguments: {
                                          'info': info,
                                          'data': data!.toJson(),
                                          'ssl_res': res.toJson(),
                                        },
                                      );
                                    }
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
                    if (DoctorAppointmentController.to.appointmentLoading.value)
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
                              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 4)],
                              color: Colors.white,
                            ),
                            child: const Waiting(),
                          ),
                        ),
                      ),
                  ],
                ),
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
