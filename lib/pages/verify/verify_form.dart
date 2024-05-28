import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/view/search_location_on_map.dart';
import 'package:shebaone/pages/home/home_page.dart';
import 'package:shebaone/pages/verify/verify_intro.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class VerifyForm extends StatefulWidget {
  const VerifyForm({Key? key}) : super(key: key);

  @override
  State<VerifyForm> createState() => _VerifyFormState();
}

class _VerifyFormState extends State<VerifyForm> {
  final AmbulanceServiceController locationController =
  Get.find<AmbulanceServiceController>();
  final _formKey = GlobalKey<FormState>();
  late FocusNode text1, text2, text3, text4, text5, text6;
  late String text1Value,
      text2Value,
      text3Value,
      text4Value,
      text5Value,
      text6Value;

  @override
  void initState() {
    text1 = FocusNode();
    text2 = FocusNode();
    text3 = FocusNode();
    text4 = FocusNode();
    text5 = FocusNode();
    text6 = FocusNode();
    text1.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    text1.dispose();
    text2.dispose();
    text3.dispose();
    text4.dispose();
    text5.dispose();
    text6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            space5C,
            space5C,
            const VerifyIntro(),
            space5C,
            space5C,
            space5C,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: size.width * .12,
                  height: size.width * .12,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: const Color(0xffD4F0DD).withOpacity(.5),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    focusNode: text1,
                    onChanged: (value) {
                      if (value.length == 1) {
                        text1Value = value;
                        FocusScope.of(context).requestFocus(text2);
                      }
                      if (value.isEmpty) {
                        text1Value = value;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * .12,
                  height: size.width * .12,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: const Color(0xffD4F0DD).withOpacity(.5),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    focusNode: text2,
                    onChanged: (value) {
                      if (value.length == 1) {
                        text2Value = value;
                        FocusScope.of(context).requestFocus(text3);
                      }
                      if (value.isEmpty) {
                        text2Value = value;
                        FocusScope.of(context).requestFocus(text1);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * .12,
                  height: size.width * .12,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: const Color(0xffD4F0DD).withOpacity(.5),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    focusNode: text3,
                    onChanged: (value) {
                      if (value.length == 1) {
                        text3Value = value;
                        FocusScope.of(context).requestFocus(text4);
                      }
                      if (value.isEmpty) {
                        text3Value = value;
                        FocusScope.of(context).requestFocus(text2);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * .12,
                  height: size.width * .12,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: const Color(0xffD4F0DD).withOpacity(.5),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    focusNode: text4,
                    onChanged: (value) {
                      if (value.length == 1) {
                        text4Value = value;
                        FocusScope.of(context).requestFocus(text5);
                      }
                      if (value.isEmpty) {
                        text4Value = value;
                        FocusScope.of(context).requestFocus(text3);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * .12,
                  height: size.width * .12,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: const Color(0xffD4F0DD).withOpacity(.5),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    focusNode: text5,
                    onChanged: (value) {
                      if (value.length == 1) {
                        text5Value = value;
                        FocusScope.of(context).requestFocus(text6);
                      }

                      if (value.isEmpty) {
                        text5Value = value;
                        FocusScope.of(context).requestFocus(text4);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: size.width * .12,
                  height: size.width * .12,
                  child: TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      fillColor: const Color(0xffD4F0DD).withOpacity(.5),
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    focusNode: text6,
                    onChanged: (value) {
                      if (value.length == 1) {
                        text6Value = value;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }
                      if (value.isEmpty) {
                        text6Value = value;
                        FocusScope.of(context).requestFocus(text5);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "Didn't Receive any Code?",
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.black),
                children: [
                  TextSpan(
                    text: ' Re-Send',
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () async => {
                          Get.defaultDialog(
                          title: 'Resend OTP',
                          content: const Center(child: CircularProgressIndicator()),
                          ),
                     await AuthController.to.setUserId(),

                          Get.back(),},
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  )
                ],
              ),
            ),
            space8C,
            PrimaryButton(
              label: 'Verify and Proceed',
              onPressed: ()async {
                if (_formKey.currentState!.validate()) {
                  //showing progress indicator
                  Get.defaultDialog(
                    title: 'Verifying Code',
                    content: const Center(child: CircularProgressIndicator()),
                  );
                  //Checking verification code
                  String code = text1Value +
                      text2Value +
                      text3Value +
                      text4Value +
                      text5Value +
                      text6Value;
                  AuthController.to.verifyVerificationCode(code,false);
                  //  if(AuthController.to.isAmulance == true){        //added by mahbub
                  // await locationController.getCurrentLocation();
                  // Get.to(() => SearchLocationOnMap(
                  //     initialCameraPosition: CameraPosition(
                  //       target: LatLng(
                  //           locationController.latitude.value,
                  //           locationController.longitude.value),
                  //       zoom: 15.0,
                  //     )));
                  //  }
                }
              },
              marginHorizontal: 8,
              borderRadiusAll: 10,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
