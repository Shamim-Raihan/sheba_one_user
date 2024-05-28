import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../controllers/fitness_appointment_controller.dart';
import '../../../utils/widgets/network_image/network_image.dart';

class FitnessAppointmentDoneScreen extends StatelessWidget {
  const FitnessAppointmentDoneScreen({Key? key}) : super(key: key);
  static String routeName = '/FitnessAppointmentDoneScreen';

  @override
  Widget build(BuildContext context) {
    final double paidFee = double.parse(
      FitnessAppointmentController.to.appointmentType.value ==
              FitnessAppointmentType.wellness
          ? FitnessAppointmentController
                  .to.getSingleDoctorDetails.wellnessFee ??
              "0"
          : FitnessAppointmentController.to.appointmentType.value ==
                  FitnessAppointmentType.yoga
              ? FitnessAppointmentController
                      .to.getSingleDoctorDetails.yogaFee ??
                  "0"
              : FitnessAppointmentController.to.getSingleDoctorDetails.gymFee ??
                  "0",
    );

    return WillPopScope(
      onWillPop: () async {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
        return true;
      },
      child: Scaffold(
        body: SizedBox(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.top,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: const SizedBox(
                        width: 20,
                        height: 40,
                        child: Center(
                          child: Icon(
                            Icons.keyboard_backspace,
                          ),
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/done.png',
                      height: Get.width * .3,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              const TitleText(
                title: 'Congratulations!',
                textAlign: TextAlign.center,
                fontSize: 20,
              ),
              const TitleText(
                title:
                    'Appoinment successfully Booked. You will receive a\nnotification and the fitness center you selected will contact you.',
                color: Color(0xff3c3c3c),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              space4C,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      MainContainer(
                        borderColor: kPrimaryColor.withOpacity(.2),
                        withBoxShadow: true,
                        width: Get.width,
                        verticalPadding: 0,
                        horizontalPadding: 0,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xffDADADA).withOpacity(.3),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: TitleText(
                                      title: 'Invoice',
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 8),
                                    child: TitleText(
                                      title: 'Sheba One',
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  HorizontalDivider(
                                    color: kPrimaryColor.withOpacity(.4),
                                    thickness: 1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(
                                          () => RichText(
                                            text: TextSpan(
                                              text: 'Order ID: ',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.normal,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: (FitnessAppointmentController
                                                                  .to
                                                                  .appointmentSuccessInfo[
                                                              'id'] ??
                                                          '-')
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Obx(() => RichText(
                                              text: TextSpan(
                                                text: 'Placed on: ',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: DateFormat(
                                                            'dd-MM-yyyy')
                                                        .format(DateTime.parse(
                                                            FitnessAppointmentController
                                                                    .to
                                                                    .appointmentSuccessInfo[
                                                                'created_at'])),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            space2C,
                            const TitleText(
                              title: 'Patient Details',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            HorizontalDivider(
                              color: kPrimaryColor.withOpacity(.3),
                              thickness: .6,
                              horizontalMargin: Get.width * .25,
                            ),
                            TitleText(
                              title: Get.arguments['info']['patient_name'],
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                            TitleText(
                              title: Get.arguments['info']['patient_phone'],
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                            HorizontalDivider(
                              color: kPrimaryColor.withOpacity(.2),
                              thickness: .3,
                            ),
                            const TitleText(
                              title: 'Total Summary',
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                            InvoiceProductItem(
                              info: FitnessAppointmentController
                                  .to.getSingleDoctorDetails,
                            ),
                            // const InvoiceProductItem(),
                            ///TODO: Implement In PDF
                            InvoiceProductItem(
                              from: 'consultation',
                              info: {
                                'type': 'Online Consultation',
                                'date': Get.arguments['data']['dmy'],
                                'time': Get.arguments['data']['start_time'],
                              },
                              imagePath: 'online',
                              isLast: true,
                            ),
                            HorizontalDivider(
                              color: kPrimaryColor.withOpacity(.6),
                              thickness: 1,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: TitleText(
                                      title: '(Vat Included)',
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Expanded(
                                                  child: TitleText(
                                                    title:
                                                        'Fitness Center Fees (Paid) ',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TitleText(
                                                    title: (paidFee -
                                                            (paidFee * 5 / 100))
                                                        .toStringAsFixed(2),
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Expanded(
                                                  child: TitleText(
                                                    title:
                                                        'Service Charge (paid): ',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TitleText(
                                                    title: (paidFee * 5 / 100)
                                                        .toStringAsFixed(2),
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      HorizontalDivider(
                                        color: kPrimaryColor,
                                        thickness: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: const [
                                  Spacer(
                                    flex: 1,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TitleText(
                                      title: 'Remaining Fees: ',
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TitleText(
                                      title: '0.00',
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: TitleText(
                                  title: 'Payment Status: Paid',
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            TitleText(
                              title:
                                  'Payment Method: ${Get.arguments['ssl_res']['card_issuer']}',
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.left,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: TitleText(
                                title:
                                    'You have paid ${paidFee * 5 / 100} tk of fitness center fees as an service charge before confirming this appointment, and remaining ${paidFee - (paidFee * 5 / 100)} tk to fitness center.',
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * .5,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: PrimaryButton(
                                      height: 32,
                                      contentPadding: 0,
                                      borderRadiusAll: 4,
                                      borderColor: Colors.transparent,
                                      marginHorizontal: 6,
                                      marginVertical: 12,
                                      label: 'Save',
                                      onPressed: () {
                                        globalLogger.d('Save');

                                        ///TODO: Condition ADD for track map

                                        Get.to(() => const PdfPreviewPage(),
                                            arguments: Get.arguments);
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: PrimaryButton(
                                      height: 32,
                                      contentPadding: 0,
                                      borderRadiusAll: 4,
                                      borderColor: Colors.transparent,
                                      marginHorizontal: 6,
                                      marginVertical: 12,
                                      label: 'Print',
                                      onPressed: () async {
                                        globalLogger.d('print');

                                        ///TODO: Condition ADD for track map

                                        Get.to(() => const PdfPreviewPage(),
                                            arguments: Get.arguments);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      space3C,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PdfPreviewPage extends StatelessWidget {
  const PdfPreviewPage({Key? key}) : super(key: key);

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final double paidFee = double.parse(
      FitnessAppointmentController.to.appointmentType.value ==
              FitnessAppointmentType.wellness
          ? FitnessAppointmentController
                  .to.getSingleDoctorDetails.wellnessFee ??
              "0"
          : FitnessAppointmentController.to.appointmentType.value ==
                  FitnessAppointmentType.yoga
              ? FitnessAppointmentController
                      .to.getSingleDoctorDetails.yogaFee ??
                  "0"
              : FitnessAppointmentController.to.getSingleDoctorDetails.gymFee ??
                  "0",
    );
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    List<dynamic> data = [];
    if (Get.arguments['from'] == 'Healthcare') {
      data = jsonDecode(Get.arguments['info']['product_items']);
      globalLogger.d(data);
    }
    final consultationImage = await networkImage(
        'https://shebaone.com/frontend_assets/img/icon/appointment.png');
    final netImage = await networkImage(
        // DoctorAppointmentController.to.getSingleDoctorDetails.imagePath!
        'https://shebaone.com/frontend_assets/img/icon/appointment.png');
    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        margin: const pw.EdgeInsets.symmetric(horizontal: 64, vertical: 96),
        build: (context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 8),
                  child: _text('Invoice',
                      fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 8),
                  child: _text('Sheba One',
                      fontSize: 12, fontWeight: pw.FontWeight.bold),
                ),
                _divider(),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(8.0),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.RichText(
                        text: pw.TextSpan(
                          text: 'Order ID: ',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#000000'),
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                          children: [
                            pw.TextSpan(
                              text: (FitnessAppointmentController
                                          .to.appointmentSuccessInfo['id'] ??
                                      '-')
                                  .toString(),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      pw.RichText(
                        text: pw.TextSpan(
                          text: 'Placed on: ',
                          style: pw.TextStyle(
                            color: PdfColor.fromHex('#000000'),
                            fontSize: 12,
                            fontWeight: pw.FontWeight.normal,
                          ),
                          children: [
                            pw.TextSpan(
                              text: DateFormat('dd-MM-yyyy').format(
                                  DateTime.parse(FitnessAppointmentController.to
                                      .appointmentSuccessInfo['created_at'])),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _text('Patient Details',
                    fontSize: 12, fontWeight: pw.FontWeight.bold),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                    horizontal: Get.width * .25,
                  ),
                  child: _divider(),
                ),
                _text(Get.arguments['info']['patient_name'], fontSize: 11),
                _text(Get.arguments['info']['patient_phone'], fontSize: 11),
                _divider(),
                _text('Total Summary',
                    fontSize: 12, fontWeight: pw.FontWeight.bold),
                _productItems(
                  netImage,
                  info: FitnessAppointmentController.to.getSingleDoctorDetails,
                ),
                _productItems(
                  consultationImage,
                  from: 'consultation',
                  info: {
                    'type': 'Online Consultation',
                    'date': Get.arguments['data']['dmy'],
                    'time': Get.arguments['data']['start_time'],
                  },
                  isLast: true,
                ),
                _divider(),
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Expanded(
                      flex: 1,
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10.0),
                        child: _text('(Vat Included)', fontSize: 10),
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Column(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(right: 10.0),
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: _text('Fitness Center Fees (Paid)',
                                          fontSize: 12,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                    pw.Expanded(
                                      child: _text(
                                          (paidFee - (paidFee * 5 / 100))
                                              .toStringAsFixed(2),
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: _text('Service Charge (paid): ',
                                          fontSize: 12,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                    pw.Expanded(
                                      child: _text(
                                          (paidFee * 5 / 100)
                                              .toStringAsFixed(2),
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                  ],
                                ),
                                // pw.Row(
                                //   children: [
                                //     pw.Expanded(
                                //       child: _text('Discount: ',
                                //           fontSize: 12,
                                //           textAlign: pw.TextAlign.right),
                                //     ),
                                //     pw.Expanded(
                                //       child: _text(
                                //           '-${Get.arguments['from'] == null ? '' : Get.arguments['from'] == 'Healthcare' ? Get.arguments['info']['discount_amount'] : double.parse(Get.arguments['discount'].toString()).toStringAsFixed(2).replaceAll(RegExp(r'-'), '')}',
                                //           fontSize: 12,
                                //           fontWeight: pw.FontWeight.bold,
                                //           textAlign: pw.TextAlign.right),
                                //     ),
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          _divider()
                        ],
                      ),
                    ),
                  ],
                ),
                pw.Row(
                  children: [
                    pw.Spacer(
                      flex: 1,
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: _text(
                        'Remaining Fees: ',
                        fontSize: 12,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: _text(
                        '0.00',
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                pw.Align(
                  alignment: pw.Alignment.centerLeft,
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    child: _text('Payment Status: Paid',
                        fontSize: 12, fontWeight: pw.FontWeight.bold),
                  ),
                ),
                _text(
                    'Payment Method: ${Get.arguments['ssl_res']['card_issuer']}',
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold),
                pw.SizedBox(height: 16),
                _text(
                  'You have paid ${paidFee * 5 / 100} tk of fitness center fees as an service charge before confirming this appointment, and remaining ${paidFee - (paidFee * 5 / 100)} tk to fitness center.',
                  fontSize: 12,
                ),
              ],
            )
            // pw.SizedBox(
            //   width: double.infinity,
            //   child: pw.FittedBox(
            //     child: pw.Text(title, style: pw.TextStyle(font: font)),
            //   ),
            // ),
            // pw.SizedBox(height: 20),
            // pw.Flexible(child: pw.FlutterLogo())
          ];
        },
      ),
    );

    return pdf.save();
  }

  pw.Column _productItems(pw.ImageProvider netImage,
      {dynamic info, String? from, bool isLast = false}) {
    return pw.Column(children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              height: 35,
              width: 35,
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(17.5),
                color: PdfColor.fromHex('#FFFFFF'),
                border:
                    pw.Border.all(color: PdfColor.fromHex('#0D6526'), width: 3),
              ),
              child: pw.ClipRRect(
                horizontalRadius: 18,
                verticalRadius: 18,
                child: pw.Image(
                  netImage,
                  fit: pw.BoxFit.fill,
                ),
              ),
            ),
            pw.SizedBox(width: 8),
            // pw.Expanded(
            //   child: pw.Column(
            //     crossAxisAlignment: pw.CrossAxisAlignment.start,
            //     children: [
            //       _text(from == 'consultation' ? info['type'] : info.name!,
            //           fontSize: 11, fontWeight: pw.FontWeight.bold),
            //       _text(
            //           from == 'consultation'
            //               ? "Date: ${info['date']}"
            //               : DoctorAppointmentController.to
            //               .getSpecializationName(info.specialization!),
            //           fontSize: 11,
            //           fontWeight: pw.FontWeight.bold),
            //       if (from == 'consultation')
            //         _text("Time: ${info['time']}",
            //             fontSize: 11, fontWeight: pw.FontWeight.bold),
            //     ],
            //   ),
            // ),
            // pw.RichText(
            //   text: pw.TextSpan(
            //     text: from == 'Healthcare'
            //         ? '${info['org_sell_price']} x ${info['qty']} = '
            //         : '${double.parse(info['sell_price']).toStringAsFixed(2)} x ${info['count']} = ',
            //     style: pw.TextStyle(
            //       color: PdfColor.fromHex('#000000'),
            //       fontSize: 12,
            //       fontWeight: pw.FontWeight.normal,
            //     ),
            //     children: [
            //       pw.TextSpan(
            //         text: from == 'Healthcare'
            //             ? info['subtotal']
            //             : (double.parse(info['sell_price']) *
            //                     int.parse(info['count']))
            //                 .toStringAsFixed(2),
            //         style: pw.TextStyle(
            //           fontWeight: pw.FontWeight.bold,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      if (!isLast) _divider()
    ]);
  }

  pw.Text _text(String title,
      {double? fontSize, pw.FontWeight? fontWeight, pw.TextAlign? textAlign}) {
    return pw.Text(
      title,
      style: pw.TextStyle(
        color: PdfColor.fromHex('#000000'),
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight ?? pw.FontWeight.normal,
      ),
      textAlign: textAlign ?? pw.TextAlign.left,
    );
  }

  pw.Row _divider() {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Divider(
            // color: PdfColor(13, 101, 38),
            color: PdfColor.fromHex('#0D6526'),
            thickness: 1,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Preview'),
      ),
      body: PdfPreview(
        allowPrinting: true,
        canDebug: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        onPrinted: (context) {
          globalLogger.d('Hello');

          Get.back();
          Get.back();
          Get.back();
          Get.back();
          Get.back();

          ///TODO: Condition ADD for track map
        },
        build: (format) => _generatePdf(format, 'title'),
      ),
    );
  }
}

class InvoiceProductItem extends StatelessWidget {
  const InvoiceProductItem({
    Key? key,
    this.from,
    this.info,
    this.imagePath,
    this.isLast = false,
  }) : super(key: key);
  final bool isLast;
  final dynamic info;
  final String? from;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              from == 'consultation'
                  ? Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kPrimaryColor.withOpacity(.15),
                      ),
                      child: Image.asset(
                        'assets/icons/$imagePath.png',
                        height: 20,
                        width: 20,
                        color: Colors.white,
                      ),
                    )
                  : Container(
                      height: 35,
                      width: 35,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: Colors.white,
                        border: Border.all(color: kPrimaryColor, width: 3),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: CustomNetworkImage(
                          networkImagePath: info.imagePath!,
                        ),
                      ),
                    ),
              space2R,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      title: from == 'consultation' ? info['type'] : info.name!,
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    // TitleText(
                    //   title: from == 'consultation'
                    //       ? "Date: ${info['date']}"
                    //       : DoctorAppointmentController.to
                    //       .getSpecializationName(info.specialization!),
                    //   color: Colors.black,
                    //   fontSize: 11,
                    //   fontWeight: FontWeight.w500,
                    // ),
                    if (from == 'consultation')
                      TitleText(
                        title: "Time: ${info['time']}",
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          HorizontalDivider(
            color: kPrimaryColor.withOpacity(.3),
            thickness: .6,
            horizontalMargin: 10,
            height: 1,
          ),
      ],
    );
  }
}

class CustomRadio extends StatelessWidget {
  const CustomRadio({
    Key? key,
    required dynamic group,
    required this.value,
    required this.label,
    required this.onChanged,
  })  : _group = group,
        super(key: key);

  final dynamic _group;
  final dynamic value;
  final String label;
  final ValueChanged<dynamic>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: kScaffoldColor,
        border: Border.all(
          color: kPrimaryColor.withOpacity(.2),
          width: .3,
        ),
      ),
      child: RadioListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        title: Text(label),
        value: value,
        groupValue: _group,
        onChanged: onChanged,
        activeColor: kPrimaryColor,

        ///Radio Horizontal position change
        controlAffinity: ListTileControlAffinity.trailing,

        ///Radio vertical position change
        visualDensity: const VisualDensity(vertical: -1.5, horizontal: 2.5),
      ),
    );
  }
}
