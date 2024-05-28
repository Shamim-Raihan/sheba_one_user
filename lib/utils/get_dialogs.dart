import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/pages/prescription/prescription_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

void getSnackbar(String title, String body, {Color? bgColor, Color? textColor}) {
  Get.snackbar(
    title,
    body,
    backgroundColor: bgColor ?? Colors.red,
    colorText: textColor ?? Colors.white,
  );
}

void getExitDialog() {
  Get.defaultDialog(
    title: 'Exit',
    content: const Text('Are you sure you want to exit?'),
    confirm: ElevatedButton(
      child: const Text('Yes'),
      onPressed: () {
        exit(0);
      },
    ),
    cancel: ElevatedButton(
      child: const Text('No'),
      onPressed: () {
        Get.back();
      },
    ),
  );
}

void getProgressDialog() {
  Get.defaultDialog(
    title: 'Please Wait',
    content: const Center(
      child: CircularProgressIndicator(),
    ),
  );
}

void getSimpleDialog(String title, String content, {Color? contentColor, FontWeight? contentFontWeight}) {
  Get.defaultDialog(
      titlePadding: const EdgeInsets.only(top: 16),
      title: title,
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: TextStyle(color: contentColor, fontWeight: contentFontWeight ?? FontWeight.normal),
      ),
      actions: [
        ElevatedButton(
          child: const Text('Okay'),
          onPressed: () {
            Get.back();
          },
        )
      ]);
}

void getLoadingDialog({String? title, String? content}) {
  Get.defaultDialog(
    title: '',
    content: Column(
      children: [
        Image.asset(
          'assets/icons/loading.gif',
          height: 125,
          width: 125,
        ),
        space5C,
        TitleText(
          title: title ?? 'Please wait...',
          fontSize: 16,
        ),
        space2C,
        TitleText(
          title: content ?? 'We will notify you once product is found',
          fontSize: 12,
        ),
        space5C,
      ],
    ),
  );
}

Future<void> uploadImageDialoge(BuildContext context, {required Function() camera, required Function() upload}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: kTextColor,
                ),
              ),
              space5C,
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  UploadButton(
                    onTap: camera,
                    imagePath: 'camera',
                    label: 'Use Camera',
                  ),
                  UploadButton(
                    onTap: upload,
                    imagePath: 'gallery',
                    label: 'From Gallery',
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Get.defaultDialog(
// contentPadding:
// EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 24),
// title: '',
// content: Column(
// children: [
// Image.asset(
// 'assets/images/book-appointment.png',
// height: 150,
// ),
// space3C,
// const TitleText(
// title: 'Congratulations!',
// fontSize: 18,
// ),
// space3C,
// const TitleText(
// title:
// 'Appoinment successfully Booked. You will receive a notification and the doctor you selected will contact you.!',
// fontSize: 14,
// color: Colors.black,
// fontWeight: FontWeight.normal,
// textAlign: TextAlign.center,
// )
// ],
// ),
// );
Future<void> congratsDialoge(
  BuildContext context, {
  String? iconPath,
  String? title,
  Color? titleColor,
  String? subTitle,
  bool isButtonExist = false,
  Function()? onTap,
  String? buttonLabel,
}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/${iconPath ?? 'book-appointment'}.png',
                height: 150,
              ),
              space3C,
              TitleText(
                title: title ?? 'Congratulations!',
                fontSize: 18,
                color: titleColor,
              ),
              space3C,
              TitleText(
                title: subTitle ??
                    'Appoinment successfully Booked. You will receive a notification and the doctor you selected will contact you.!',
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.normal,
                textAlign: TextAlign.center,
              ),
              if (isButtonExist)
                PrimaryButton(
                  label: buttonLabel ?? 'Try Again',
                  onPressed: onTap,
                  borderRadiusAll: 20,
                  height: 40,
                  contentPadding: 0,
                ),
            ],
          ),
        ),
      );
    },
  );
}
