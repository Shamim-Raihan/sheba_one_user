import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../services/database.dart';

class PurchaseDoneScreen extends StatelessWidget {
  const PurchaseDoneScreen({Key? key}) : super(key: key);
  static String routeName = '/PurchaseDoneScreen';
  @override
  Widget build(BuildContext context) {
    globalLogger.d(Get.arguments);
    return WillPopScope(
      onWillPop: () async {
        if (Get.arguments['from'] == 'Healthcare') {
          if (HomeController.to.liveSearchType.value == LiveSearchType.healthcare) {
            Get.back();

            HomeController.to.liveSearchType(LiveSearchType.none);
            return true;
          } else {
            Get.back();
            Get.back();
            return true;
          }
        } else {
          Get.back();
          return true;
        }
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
                title: 'Thank You For Purchasing',
                textAlign: TextAlign.center,
                fontSize: 20,
              ),
              const TitleText(
                title: 'Your order has been accepted and is\non it’s way to being processed',
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
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                  text: HomeController.to.cartType.value == CartType.lab
                                                      ? LabController.to.orderSuccessData['order_no']
                                                      : Get.arguments['from'] == 'Healthcare'
                                                          ? HealthCareController.to.orderSuccessData['order_id']
                                                          : HomeController.to.liveSearchType.value ==
                                                                  LiveSearchType.medicine
                                                              ? MedicineController.to.orderSuccessData['order_id'] ??
                                                                  '-'
                                                              : PrescriptionController
                                                                      .to.orderSuccessData['order_id'] ??
                                                                  '-',
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
                                                    text: HomeController.to.cartType.value == CartType.lab
                                                        ? DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                                            LabController.to.orderSuccessData['created_at']))
                                                        : Get.arguments['from'] == 'Healthcare'
                                                            ? DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                                                HealthCareController.to.orderSuccessData['created_at']))
                                                            : DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                                                HomeController.to.liveSearchType.value ==
                                                                        LiveSearchType.medicine
                                                                    ? MedicineController
                                                                        .to.orderSuccessData['created_at']
                                                                    : PrescriptionController
                                                                        .to.orderSuccessData['created_at'])),
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  if (!(HomeController.to.cartType.value == CartType.lab) &&
                                      (Get.arguments['from'] == 'Healthcare' ||
                                          HomeController.to.liveSearchType.value == LiveSearchType.medicine))
                                    Obx(
                                          () => RichText(
                                        text: TextSpan(
                                          text: Get.arguments['from'] == 'Healthcare'
                                              ? 'Health Store Name: '
                                              : HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                              ? "Pharmacy Name: "
                                              : '',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: Get.arguments['from'] == 'Healthcare'
                                                  ? HealthCareController
                                                  .to.confirmationPharmacyData['pharmacy_name']
                                                  : HomeController.to.liveSearchType.value ==
                                                  LiveSearchType.medicine
                                                  ? MedicineController
                                                  .to.confirmationPharmacyData['pharmacy_name'] ??
                                                  '-'
                                                  : PrescriptionController
                                                  .to.confirmationPharmacyData['pharmacy_name'] ??
                                                  '-',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  space3C,
                                ],
                              ),
                            ),
                            space2C,
                            const TitleText(
                              title: 'Delivery Address',
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
                              title: HomeController.to.cartType.value == CartType.lab
                                  ? Get.arguments['info']['name']
                                  : Get.arguments['info']['user_name'],
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                            TitleText(
                              title: HomeController.to.cartType.value == CartType.lab
                                  ? Get.arguments['info']['mobile']
                                  : HomeController.to.cartType.value == CartType.healthcare
                                      ? HomeController.to.liveSearchType.value == LiveSearchType.healthcare
                                          ? Get.arguments['info']['user_phone']
                                          : Get.arguments['info']['user_mobile']
                                      : Get.arguments['info']['user_mobile'],
                              color: Colors.black,
                              fontSize: 11,
                              fontWeight: FontWeight.normal,
                            ),
                            TitleText(
                              title: HomeController.to.cartType.value == CartType.lab
                                  ? Get.arguments['info']['address']
                                  : Get.arguments['info']['user_address'],
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
                            Get.arguments['from'] == 'Healthcare'
                                ? HomeController.to.liveSearchType.value == LiveSearchType.none
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: jsonDecode(Get.arguments['info']['product_items']).length,
                                        itemBuilder: (_, index) {
                                          return InvoiceProductItem(
                                            from: Get.arguments['from'],
                                            info: jsonDecode(Get.arguments['info']['product_items'])[index],
                                            isLast:
                                                index + 1 == jsonDecode(Get.arguments['info']['product_items']).length,
                                          );
                                        },
                                      )
                                    : ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: Get.arguments['info']['order_info'].length,
                                        itemBuilder: (_, index) {
                                          globalLogger.d(Get.arguments['info']['order_info']);
                                          return InvoiceProductItem(
                                            from: Get.arguments['from'],
                                            info: Get.arguments['info']['order_info'][index],
                                            isLast: index + 1 == Get.arguments['info']['order_info'].length,
                                          );
                                        },
                                      )
                                // InvoiceProductItem(
                                //             from: Get.arguments['from'],
                                //             info: Get.arguments['info']['order_info'],
                                //             isLast: true,
                                //           )
                                : HomeController.to.cartType.value == CartType.lab
                                    ? ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        itemCount: jsonDecode(Get.arguments['info']['items']).length,
                                        itemBuilder: (_, index) {
                                          return InvoiceProductItem(
                                            from: Get.arguments['from'],
                                            info: jsonDecode(Get.arguments['info']['items'])[index],
                                            isLast: index + 1 == jsonDecode(Get.arguments['info']['items']).length,
                                          );
                                        },
                                      )
                                    : Obx(() {
                                        return ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemCount: HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                              ? MedicineController.to.confirmationPharmacyData['available'].length
                                              : PrescriptionController.to.confirmationPharmacyData['available'].length,
                                          itemBuilder: (_, index) {
                                            // globalLogger.d(
                                            //     MedicineController.to.confirmationPharmacyData['available'][index],
                                            //     'DEKH');
                                            return InvoiceProductItem(
                                              from: Get.arguments['from'],
                                              info: HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                                  ? MedicineController.to.confirmationPharmacyData['available'][index]
                                                  : PrescriptionController.to.confirmationPharmacyData['available']
                                                      [index],
                                              isLast: index + 1 ==
                                                  (HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                                      ? MedicineController
                                                          .to.confirmationPharmacyData['available'].length
                                                      : PrescriptionController
                                                          .to.confirmationPharmacyData['available'].length),
                                            );
                                          },
                                        );
                                      }),
                            // const InvoiceProductItem(),
                            // const InvoiceProductItem(isLast: true),
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
                                  flex: HomeController.to.cartType.value == CartType.lab ? 2 : 1,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                const Expanded(
                                                  child: TitleText(
                                                    title: 'Subtotal: ',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TitleText(
                                                    title: Get.arguments['from'] == 'Healthcare'
                                                        ? HomeController.to.liveSearchType.value == LiveSearchType.none
                                                            ? (double.parse(
                                                                    Get.arguments['info']['products_sell_price']))
                                                                .toStringAsFixed(2)
                                                            : Get.arguments['info']['order_amount']
                                                        : HomeController.to.cartType.value == CartType.lab
                                                            ? double.parse(Get.arguments['info']['total'])
                                                                .toStringAsFixed(2)
                                                            : double.parse(Get.arguments['actual_price'])
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
                                                Expanded(
                                                  child: TitleText(
                                                    title: HomeController.to.cartType.value == CartType.lab
                                                        ? 'Service Charge(Paid): '
                                                        : 'Delivery Fee: ',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.normal,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: TitleText(
                                                    title: HomeController.to.cartType.value == CartType.lab
                                                        ? double.parse(Get.arguments['info']['service_charge'])
                                                            .toStringAsFixed(2)
                                                        : Get.arguments['from'] == 'Healthcare'
                                                            ? "${HealthCareController.to.confirmationPharmacyData['delivery_charge']}"
                                                            : ' ${HomeController.to.liveSearchType.value == LiveSearchType.medicine ? MedicineController.to.confirmationPharmacyData['delivery_charge'] : PrescriptionController.to.confirmationPharmacyData['delivery_charge']}',
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    textAlign: TextAlign.right,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (!(HomeController.to.cartType.value == CartType.lab))
                                              Row(
                                                children: [
                                                  const Expanded(
                                                    child: TitleText(
                                                      title: 'Discount: ',
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.normal,
                                                      textAlign: TextAlign.right,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TitleText(
                                                      title:
                                                          '(-)${Get.arguments['from'] == 'Healthcare' ? double.parse(Get.arguments['info']['discount_amount']).toStringAsFixed(2) : double.parse(Get.arguments['discount'].toString()).toStringAsFixed(2).replaceAll(RegExp(r'-'), '')}',
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
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                children: [
                                  Spacer(
                                    flex: HomeController.to.cartType.value == CartType.lab ? 1 : 2,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TitleText(
                                      title: HomeController.to.cartType.value == CartType.lab
                                          ? 'Remaining Payable'
                                          : 'Total: ',
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: TitleText(
                                      title: HomeController.to.cartType.value == CartType.lab
                                          ? (double.parse(Get.arguments['info']['total']) -
                                                  double.parse(Get.arguments['info']['service_charge']))
                                              .toStringAsFixed(2)
                                          : Get.arguments['from'] == 'Healthcare'
                                              ? (double.parse(Get.arguments['info']['products_sell_price']) +
                                                      double.parse(HealthCareController
                                                          .to.confirmationPharmacyData['delivery_charge']
                                                          .toString()))
                                                  .toStringAsFixed(2)
                                              : (double.parse(Get.arguments['info']['order_amount']) +
                                                      double.parse(HomeController.to.liveSearchType.value ==
                                                              LiveSearchType.medicine
                                                          ? MedicineController
                                                              .to.confirmationPharmacyData['delivery_charge']
                                                              .toString()
                                                          : PrescriptionController
                                                              .to.confirmationPharmacyData['delivery_charge']
                                                              .toString()) -
                                                      double.parse(Get.arguments['discount'].toString()))
                                                  .toStringAsFixed(2),
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                child: Obx(() => TitleText(
                                      title:
                                          'Payment Status: ${HomeController.to.liveSearchType.value == LiveSearchType.medicine ? MedicineController.to.paymentMethod.value == PaymentMethod.cod || MedicineController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Unpaid' : 'Paid' : HomeController.to.liveSearchType.value == LiveSearchType.prescription ? PrescriptionController.to.paymentMethod.value == PaymentMethod.cod || PrescriptionController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Unpaid' : 'Paid' : HomeController.to.cartType.value == CartType.lab ? 'Unpaid' : HealthCareController.to.paymentMethod.value == PaymentMethod.cod || HealthCareController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Unpaid' : 'Paid'}',
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      textAlign: TextAlign.left,
                                    )),
                              ),
                            ),
                            Obx(
                              () => TitleText(
                                title:
                                    'Payment Method: ${HomeController.to.liveSearchType.value == LiveSearchType.medicine ? MedicineController.to.paymentMethod.value == PaymentMethod.cod ? 'COD (Cash on Delivery)' : MedicineController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Bkash/Nagad mercant number' : 'Online' : HomeController.to.liveSearchType.value == LiveSearchType.prescription ? PrescriptionController.to.paymentMethod.value == PaymentMethod.cod ? 'COD (Cash on Delivery)' : PrescriptionController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Bkash/Nagad mercant number' : 'Online' : HomeController.to.cartType.value == CartType.lab ? LabController.to.orderSuccessData['payment_method'] : HealthCareController.to.paymentMethod.value == PaymentMethod.cod ? 'COD (Cash on Delivery)' : HealthCareController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Bkash/Nagad mercant number' : 'Online'}',
                                color: Colors.black,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Obx(
                              () => (HomeController.to.liveSearchType.value == LiveSearchType.medicine &&
                                          MedicineController.to.paymentMethod.value == PaymentMethod.mobileBanking) ||
                                      (HomeController.to.cartType.value == CartType.lab &&
                                          LabController.to.paymentMethod.value == PaymentMethod.mobileBanking) ||
                                      (HealthCareController.to.paymentMethod.value == PaymentMethod.mobileBanking)
                                  ? const TitleText(
                                      title: 'Pay later to Shebaone merchant number(+88 0175 5660692)',
                                      color: Colors.black,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      textAlign: TextAlign.left,
                                    )
                                  : const SizedBox(),
                            ),

                            if (HomeController.to.cartType.value == CartType.lab)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TitleText(
                                  title:
                                      'You have paid ${Get.arguments['info']['service_charge']} tk of lab test fees as an service charge, and remaining ${(double.parse(Get.arguments['info']['total']) - double.parse(Get.arguments['info']['service_charge'])).toStringAsFixed(2)} tk to the lab.',
                                  color: Colors.black,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
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

                                        Get.to(() => const PdfPreviewPage(), arguments: Get.arguments);
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

                                        Get.to(() => const PdfPreviewPage(), arguments: Get.arguments);
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
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
    final font = await PdfGoogleFonts.nunitoExtraLight();
    List<dynamic> data = [];
    if (Get.arguments['from'] == 'Healthcare' && HomeController.to.liveSearchType.value == LiveSearchType.none) {
      data = jsonDecode(Get.arguments['info']['product_items']);
      globalLogger.d(data);
    }
    final healthcareImage = await networkImage('${Database.apiUrl}images/category_image/6rCsgiELuc4WVcna89Nv.png');
    final netImage = await networkImage('${Database.apiUrl}images/product_images/1_default_image.jpg');
    final labImage = await networkImage('${Database.apiUrl}frontend_assets/img/lab-instrument.png');
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
                  child: _text('Invoice', fontSize: 14, fontWeight: pw.FontWeight.bold),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 8),
                  child: _text('Sheba One', fontSize: 12, fontWeight: pw.FontWeight.bold),
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
                              text: HomeController.to.cartType.value == CartType.lab
                                  ? LabController.to.orderSuccessData['order_no']
                                  : Get.arguments['from'] == 'Healthcare'
                                      ? HealthCareController.to.orderSuccessData['order_id']
                                      : HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                          ? MedicineController.to.orderSuccessData['order_id'] ?? '-'
                                          : PrescriptionController.to.orderSuccessData['order_id'] ?? '-',
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
                              text: HomeController.to.cartType.value == CartType.lab
                                  ? DateFormat('dd-MM-yyyy')
                                      .format(DateTime.parse(LabController.to.orderSuccessData['created_at']))
                                  : Get.arguments['from'] == 'Healthcare'
                                      ? DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(HealthCareController.to.orderSuccessData['created_at']))
                                      : DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                          HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                              ? MedicineController.to.orderSuccessData['created_at']
                                              : PrescriptionController.to.orderSuccessData['created_at'])),
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
                if (!(HomeController.to.cartType.value == CartType.lab) &&
                    (Get.arguments['from'] == 'Healthcare' ||
                        HomeController.to.liveSearchType.value == LiveSearchType.medicine))
                  pw.RichText(
                    text: pw.TextSpan(
                      text: Get.arguments['from'] == 'Healthcare'
                          ? 'Health Store Name: '
                          : HomeController.to.liveSearchType.value == LiveSearchType.medicine
                          ? "Pharmacy Name: "
                          : '',
                      style: pw.TextStyle(
                        color: PdfColor.fromHex('#000000'),
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                      ),
                      children: [
                        pw.TextSpan(
                          text: Get.arguments['from'] == 'Healthcare'
                              ? HealthCareController.to.confirmationPharmacyData['pharmacy_name']
                              : HomeController.to.liveSearchType.value == LiveSearchType.medicine
                              ? MedicineController.to.confirmationPharmacyData['pharmacy_name'] ?? '-'
                              : PrescriptionController.to.confirmationPharmacyData['pharmacy_name'] ?? '-',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                _text('Delivery Address', fontSize: 12, fontWeight: pw.FontWeight.bold),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(
                    horizontal: Get.width * .25,
                  ),
                  child: _divider(),
                ),
                _text(
                    HomeController.to.cartType.value == CartType.lab
                        ? Get.arguments['info']['name']
                        : Get.arguments['info']['user_name'],
                    fontSize: 11),
                _text(
                    HomeController.to.cartType.value == CartType.lab
                        ? Get.arguments['info']['mobile']
                        : HomeController.to.liveSearchType.value == LiveSearchType.healthcare
                            ? Get.arguments['info']['user_phone']
                            : Get.arguments['info']['user_mobile'],
                    fontSize: 11),
                _text(
                    HomeController.to.cartType.value == CartType.lab
                        ? Get.arguments['info']['address']
                        : Get.arguments['info']['user_address'],
                    fontSize: 11),
                _divider(),
                _text('Total Summary', fontSize: 12, fontWeight: pw.FontWeight.bold),
                // if (HomeController.to.liveSearchType.value == LiveSearchType.healthcare)
                //   _productItems(
                //     healthcareImage,
                //     from: Get.arguments['from'],
                //     info: Get.arguments['info']['order_info'],
                //     isLast: true,
                //   ),
                // if (!(HomeController.to.liveSearchType.value == LiveSearchType.healthcare))
                for (int i = 0;
                    i <
                        (HomeController.to.cartType.value == CartType.lab
                            ? jsonDecode(Get.arguments['info']['items']).length
                            : Get.arguments['from'] == 'Healthcare'
                                ? HomeController.to.liveSearchType.value == LiveSearchType.none
                                    ? data.length
                                    : Get.arguments['info']['order_info'].length
                                : HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                    ? MedicineController.to.confirmationPharmacyData['available'].length
                                    : PrescriptionController.to.confirmationPharmacyData['available'].length);
                    i++)
                  _productItems(
                    Get.arguments['from'] == 'Healthcare'
                        ? healthcareImage
                        : HomeController.to.cartType.value == CartType.lab
                            ? labImage
                            : netImage,
                    from: Get.arguments['from'],
                    info: Get.arguments['from'] == 'Healthcare'
                        ? HomeController.to.liveSearchType.value == LiveSearchType.none
                            ? data[i]
                            : Get.arguments['info']['order_info'][i]
                        : HomeController.to.cartType.value == CartType.lab
                            ? jsonDecode(Get.arguments['info']['items'])[i]
                            : HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                ? MedicineController.to.confirmationPharmacyData['available'][i]
                                : PrescriptionController.to.confirmationPharmacyData['available'][i],
                    isLast: Get.arguments['from'] == 'Healthcare'
                        ? HomeController.to.liveSearchType.value == LiveSearchType.none
                            ? i + 1 == data.length
                            : i + 1 == Get.arguments['info']['order_info'].length
                        : HomeController.to.cartType.value == CartType.lab
                            ? i + 1 == jsonDecode(Get.arguments['info']['items']).length
                            : i + 1 ==
                                (HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                    ? MedicineController.to.confirmationPharmacyData['available'].length
                                    : PrescriptionController.to.confirmationPharmacyData['available'].length),
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
                      flex: HomeController.to.cartType.value == CartType.lab ? 2 : 1,
                      child: pw.Column(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.only(right: 10.0),
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: _text('Subtotal: ', fontSize: 12, textAlign: pw.TextAlign.right),
                                    ),
                                    pw.Expanded(
                                      child: _text(
                                          Get.arguments['from'] == 'Healthcare'
                                              ? HomeController.to.liveSearchType.value == LiveSearchType.none
                                                  ? (double.parse(Get.arguments['info']['products_sell_price']))
                                                      .toStringAsFixed(2)
                                                  : Get.arguments['info']['order_amount']
                                              : HomeController.to.cartType.value == CartType.lab
                                                  ? double.parse(Get.arguments['info']['total']).toStringAsFixed(2)
                                                  : double.parse(Get.arguments['actual_price']).toStringAsFixed(2),
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                  ],
                                ),
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                      child: _text(
                                          HomeController.to.cartType.value == CartType.lab
                                              ? 'Service Charge(Paid): '
                                              : 'Delivery Fee: ',
                                          fontSize: 12,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                    pw.Expanded(
                                      child: _text(
                                          HomeController.to.cartType.value == CartType.lab
                                              ? double.parse(Get.arguments['info']['service_charge']).toStringAsFixed(2)
                                              : Get.arguments['from'] == 'Healthcare'
                                                  ? "${HealthCareController.to.confirmationPharmacyData['delivery_charge']}"
                                                  : ' ${HomeController.to.liveSearchType.value == LiveSearchType.medicine ? MedicineController.to.confirmationPharmacyData['delivery_charge'] : PrescriptionController.to.confirmationPharmacyData['delivery_charge']}',
                                          fontSize: 12,
                                          fontWeight: pw.FontWeight.bold,
                                          textAlign: pw.TextAlign.right),
                                    ),
                                  ],
                                ),
                                if (!(HomeController.to.cartType.value == CartType.lab))
                                  pw.Row(
                                    children: [
                                      pw.Expanded(
                                        child: _text('Discount: ', fontSize: 12, textAlign: pw.TextAlign.right),
                                      ),
                                      pw.Expanded(
                                        child: _text(
                                            '(-)${HomeController.to.cartType.value == CartType.lab ? '0.00' : Get.arguments['from'] == 'Healthcare' ? double.parse(Get.arguments['info']['discount_amount']).toStringAsFixed(2) : double.parse(Get.arguments['discount'].toString()).toStringAsFixed(2).replaceAll(RegExp(r'-'), '')}',
                                            fontSize: 12,
                                            fontWeight: pw.FontWeight.bold,
                                            textAlign: pw.TextAlign.right),
                                      ),
                                    ],
                                  ),
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
                      flex: HomeController.to.cartType.value == CartType.lab ? 1 : 2,
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: _text(
                        HomeController.to.cartType.value == CartType.lab ? 'Remaining Payable: ' : 'Total: ',
                        fontSize: 12,
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: _text(
                        HomeController.to.cartType.value == CartType.lab
                            ? (double.parse(Get.arguments['info']['total']) -
                                    double.parse(Get.arguments['info']['service_charge']))
                                .toStringAsFixed(2)
                            : Get.arguments['from'] == 'Healthcare'
                                ? (double.parse(Get.arguments['info']['products_sell_price']) +
                                        double.parse(HealthCareController.to.confirmationPharmacyData['delivery_charge']
                                            .toString()))
                                    .toStringAsFixed(2)
                                : (double.parse(Get.arguments['info']['order_amount']) +
                                        double.parse(HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                            ? MedicineController.to.confirmationPharmacyData['delivery_charge']
                                                .toString()
                                            : PrescriptionController.to.confirmationPharmacyData['delivery_charge']
                                                .toString()) -
                                        double.parse(Get.arguments['discount'].toString()))
                                    .toStringAsFixed(2),
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
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: _text(
                        'Payment Status: ${HomeController.to.liveSearchType.value == LiveSearchType.medicine ? MedicineController.to.paymentMethod.value == PaymentMethod.cod || MedicineController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Unpaid' : 'Paid' : HomeController.to.liveSearchType.value == LiveSearchType.prescription ? PrescriptionController.to.paymentMethod.value == PaymentMethod.cod || PrescriptionController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Unpaid' : 'Paid' : HomeController.to.cartType.value == CartType.lab ? 'Unpaid' : HealthCareController.to.paymentMethod.value == PaymentMethod.cod || HealthCareController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Unpaid' : 'Paid'}',
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ),
                _text(
                    'Payment Method: ${HomeController.to.liveSearchType.value == LiveSearchType.medicine ? MedicineController.to.paymentMethod.value == PaymentMethod.cod ? 'COD (Cash on Delivery)' : MedicineController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Bkash/Nagad mercant number' : 'Online' : HomeController.to.liveSearchType.value == LiveSearchType.prescription ? PrescriptionController.to.paymentMethod.value == PaymentMethod.cod ? 'COD (Cash on Delivery)' : PrescriptionController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Bkash/Nagad mercant number' : 'Online' : HomeController.to.cartType.value == CartType.lab ? LabController.to.orderSuccessData['payment_method'] : HealthCareController.to.paymentMethod.value == PaymentMethod.cod ? 'COD (Cash on Delivery)' : HealthCareController.to.paymentMethod.value == PaymentMethod.mobileBanking ? 'Bkash/Nagad mercant number' : 'Online'}',
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold),
                pw.SizedBox(height: 8),
                (HomeController.to.liveSearchType.value == LiveSearchType.medicine &&
                            MedicineController.to.paymentMethod.value == PaymentMethod.mobileBanking) ||
                        (HomeController.to.cartType.value == CartType.lab &&
                            LabController.to.paymentMethod.value == PaymentMethod.mobileBanking) ||
                        (HealthCareController.to.paymentMethod.value == PaymentMethod.mobileBanking)
                    ? _text('Pay later to Shebaone merchant number(+88 0175 5660692)', fontSize: 10)
                    : pw.SizedBox(),
                if (HomeController.to.cartType.value == CartType.lab)
                  _text(
                      'You have paid ${Get.arguments['info']['service_charge']} tk of lab test fees as an service charge, and remaining ${(double.parse(Get.arguments['info']['total']) - double.parse(Get.arguments['info']['service_charge'])).toStringAsFixed(2)} tk to the lab.')
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

  pw.Column _productItems(pw.ImageProvider netImage, {dynamic info, String? from, bool isLast = false}) {
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
                border: pw.Border.all(color: PdfColor.fromHex('#0D6526'), width: 3),
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
            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _text(
                      from == 'Healthcare'
                          ? info['product_name']
                          : HomeController.to.cartType.value == CartType.lab
                              ? info['test_name']
                              : info['name'],
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold),
                  if (from == 'Medicine')
                    _text('Strength: ${info['strength'] ?? '-'}', fontSize: 11, fontWeight: pw.FontWeight.bold),
                  if (HomeController.to.cartType.value == CartType.lab)
                    _text('Lab Name: ${info['lab_name']}', fontSize: 11, fontWeight: pw.FontWeight.bold),
                ],
              ),
            ),
            pw.RichText(
              text: pw.TextSpan(
                text: from == 'Healthcare'
                    ? HomeController.to.liveSearchType.value == LiveSearchType.none
                        ? '${info['sell_price']} x ${info['qty']} = '
                        : '${info['product_price']} x ${info['qty']} = '
                    : HomeController.to.cartType.value == CartType.lab
                        ? '${info['test_price']} x 1 = '
                        : '${double.parse(info['price'].toString()).toStringAsFixed(2)} x ${info['count']} = ',
                style: pw.TextStyle(
                  color: PdfColor.fromHex('#000000'),
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                ),
                children: [
                  pw.TextSpan(
                    text: from == 'Healthcare'
                        ? HomeController.to.liveSearchType.value == LiveSearchType.none
                            ? (double.parse(info['subtotal'])).toStringAsFixed(2)
                            : (double.parse(info['product_price']) * int.parse(info['qty'])).toStringAsFixed(2)
                        : HomeController.to.cartType.value == CartType.lab
                            ? info['test_price'].toString()
                            : (double.parse(info['price'].toString()) * int.parse(info['count'].toString()))
                                .toStringAsFixed(2),
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
      if (!isLast) _divider()
    ]);
  }

  pw.Text _text(String title, {double? fontSize, pw.FontWeight? fontWeight, pw.TextAlign? textAlign}) {
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
          if (Get.arguments['from'] == 'Healthcare' && HomeController.to.liveSearchType.value == LiveSearchType.none) {
            Get.back();
            Get.back();
            Get.back();
          } else {
            Get.back();
            Get.back();
          }
          HomeController.to.liveSearchType(LiveSearchType.none);

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
    this.isLast = false,
  }) : super(key: key);
  final bool isLast;
  final dynamic info;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  color: Colors.white,
                  border: Border.all(color: kPrimaryColor, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Image.network(
                    from == 'Healthcare'
                        ? '${Database.apiUrl}images/category_image/6rCsgiELuc4WVcna89Nv.png'
                        : HomeController.to.cartType.value == CartType.lab
                            ? '${Database.apiUrl}frontend_assets/img/lab-instrument.png'
                            : info['img'],
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (context, exception, stackTrack) => Image.asset('assets/icons/error.gif'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              space2R,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleText(
                      title: from == 'Healthcare'
                          ? info['product_name']
                          : HomeController.to.cartType.value == CartType.lab
                              ? info['test_name']
                              : info['name'],
                      color: Colors.black,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      maxLines: from == 'Healthcare' ? 2 : null,
                    ),
                    if (from == 'Medicine')
                      TitleText(
                        title: 'Strength: ${info['strength'] ?? '-'}',
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    if (HomeController.to.cartType.value == CartType.lab)
                      TitleText(
                        title: 'Lab Name: ${info['lab_name']}',
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                  ],
                ),
              ),
              space2R,
              RichText(
                text: TextSpan(
                  text: from == 'Healthcare'
                      ? HomeController.to.liveSearchType.value == LiveSearchType.none
                          ? '${info['sell_price']} x ${info['qty']} = '
                          : '${info['product_price']} x ${info['qty']} = '
                      : HomeController.to.cartType.value == CartType.lab
                          ? '${info['test_price']} x 1 = '
                          : '${info['price']} x ${info['count']} = ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    TextSpan(
                      text: from == 'Healthcare'
                          ? HomeController.to.liveSearchType.value == LiveSearchType.none
                              ? (double.parse(info['subtotal'])).toStringAsFixed(2)
                              : (double.parse(info['product_price']) * int.parse(info['qty']))
                                  .toStringAsFixed(2) // info['total_price']
                          : HomeController.to.cartType.value == CartType.lab
                              ? info['test_price'].toString()
                              : (double.parse(info['price'].toString()) * int.parse(info['count'].toString()))
                                  .toStringAsFixed(2),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
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

