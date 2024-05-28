import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bkash/flutter_bkash.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/controllers/upload_prescription_controller.dart';
import 'package:shebaone/pages/cart/ui/purchase_done_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/webview/webview_screen.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/ssl.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({Key? key}) : super(key: key);
  static String routeName = '/PlaceOrderScreen';

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  bool _isCheck = false;
  dynamic info;
  @override
  void initState() {
    // TODO: implement initState
    info = Get.arguments;
    setState(() {});
    super.initState();
    //socketForDeliveryManAlert();
  }

  //-------socket for  delivery man alert-----------
  socketForDeliveryManAlert() async {
    try {
      socket = IO.io('https://worker.shebaone.com', <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
      });
      socket.connect();
      socket.emit('sendDeliveryManAlert', {"data": info});
      print('ssssuuuuuuuuuuuuuuuuuuuccccceeeessssssssssssssssss $info');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('iiiiiii------------->>>>${info}');
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
              title: 'Checkout',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!(HomeController.to.cartType.value == CartType.lab))
                    Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.0),
                          child: TitleText(
                            title: 'Payment',
                            fontSize: 20,
                            color: Color(0xff3c3c3c),
                          ),
                        ),
                        space3C,
                        HorizontalDivider(
                          horizontalMargin: 24,
                          color: kPrimaryColor,
                          height: 1,
                        ),
                        space7C,
                        InfoRow(
                          withIcon: false,
                          label: 'Subtotal',
                          number: HomeController.to.liveSearchType.value ==
                                      LiveSearchType.medicine ||
                                  HomeController.to.liveSearchType.value ==
                                      LiveSearchType.prescription
                              ? double.parse(info!['actual_price'])
                                  .toStringAsFixed(2)
                              : info!['products_sell_price'].toString(),
                          withUnderline: true,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          underlineThickness: .6,
                          underlineColor: const Color(0xffcccccc),
                          horizontalMargin: 24,
                          verticalMargin: 4,
                        ),
                        InfoRow(
                          withIcon: false,
                          label: 'Discount',
                          number: HomeController.to.liveSearchType.value ==
                                      LiveSearchType.medicine ||
                                  HomeController.to.liveSearchType.value ==
                                      LiveSearchType.prescription ||
                                  HomeController.to.liveSearchType.value ==
                                      LiveSearchType.healthcare
                              ? double.parse(info!['discount'] ?? '0')
                                  .toStringAsFixed(2)
                              : double.parse(
                                      info!['discount_amount'].toString())
                                  .toStringAsFixed(2),
                          withUnderline: true,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          underlineThickness: .6,
                          underlineColor: const Color(0xffcccccc),
                          horizontalMargin: 24,
                          verticalMargin: 4,
                        ),
                        InfoRow(
                          withIcon: false,
                          label: 'Delivery Charge',
                          number: HomeController.to.liveSearchType.value ==
                                  LiveSearchType.medicine
                              ? MedicineController.to
                                  .confirmationPharmacyData['delivery_charge']
                                  .toString()
                              : HomeController.to.liveSearchType.value ==
                                      LiveSearchType.prescription
                                  ? PrescriptionController
                                      .to
                                      .confirmationPharmacyData[
                                          'delivery_charge']
                                      .toString()
                                  : HealthCareController
                                      .to
                                      .confirmationPharmacyData[
                                          'delivery_charge']
                                      .toString(),
                          withUnderline: true,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          underlineThickness: .6,
                          underlineColor: const Color(0xffcccccc),
                          horizontalMargin: 24,
                          verticalMargin: 4,
                        ),
                        InfoRow(
                          withIcon: false,
                          label: 'Total',
                          number: HomeController.to.liveSearchType.value ==
                                      LiveSearchType.medicine ||
                                  HomeController.to.liveSearchType.value ==
                                      LiveSearchType.prescription
                              ? (double.parse(info!['info']['order_amount']) -
                                      double.parse(info!['discount'] ?? '0') +
                                      double.parse(HomeController.to.liveSearchType.value ==
                                              LiveSearchType.medicine
                                          ? MedicineController
                                              .to
                                              .confirmationPharmacyData[
                                                  'delivery_charge']
                                              .toString()
                                          : HomeController.to.liveSearchType.value ==
                                                  LiveSearchType.prescription
                                              ? PrescriptionController
                                                  .to
                                                  .confirmationPharmacyData[
                                                      'delivery_charge']
                                                  .toString()
                                              : HealthCareController.to
                                                  .confirmationPharmacyData['delivery_charge']
                                                  .toString()))
                                  .toStringAsFixed(2)
                              : info!['collected_amount'].toString(),
                          withUnderline: true,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          underlineThickness: .6,
                          underlineColor: const Color(0xffcccccc),
                          horizontalMargin: 24,
                          verticalMargin: 4,
                        ),
                      ],
                    ),
                  space1C,
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
                        CustomRadio(
                          label: 'Cash on Delivery',
                          group: _paymentMethod,
                          value: PaymentMethod.cod,
                          onChanged: (dynamic value) {
                            setState(() {
                              _paymentMethod = value;
                              print(value.toString());
                            });
                          },
                        ),
                        CustomRadio(
                          label: 'Bkash',
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
                  // if (_paymentMethod == PaymentMethod.mobileBanking)
                  //   Container(
                  //     padding: const EdgeInsets.all(8),
                  //     margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  //     width: Get.width - 52,
                  //     decoration:
                  //         BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4), boxShadow: const [
                  //       BoxShadow(
                  //         color: Colors.black12,
                  //         blurRadius: 4,
                  //       )
                  //     ]),
                  //     child: TitleText(
                  //         title:
                  //             'Your need to pay directly to this merchant Bkash/Nagad (+88 0175 5660692) from any Bkash/Nagad personal number by selecting payment option and putting invoice number. After payment you need to send the transaction number & invoice number to ShebaOne Ltd. through whatsapp(+88 0175 5660692)/messenger.',
                  //         fontSize: 11,
                  //         fontWeight: FontWeight.normal,
                  //         color: kTextColor),
                  //   ),
                  if (HomeController.to.cartType.value == CartType.lab)
                    SizedBox(
                      width: Get.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          space4C,
                          const TitleText(
                            title: '*By adding payment method your agree to',
                            fontSize: 11,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                          const TitleText(
                            title: 'pay 300 tk as the service charge fee.',
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          )
                        ],
                      ),
                    ),
                  space3C,
                  // CheckboxListTile(
                  //   title: RichText(
                  //     text: TextSpan(
                  //         text: 'By clicking  the check box, I am agree with the ',
                  //         style: const TextStyle(color: Colors.black, fontSize: 16),
                  //         children: [
                  //           WidgetSpan(
                  //             child: GestureDetector(
                  //                 onTap: () {
                  //                   Get.toNamed(WebViewPage.routeName,
                  //                       arguments: 'https://www.shebaone.com/terms-condition');
                  //                 },
                  //                 child: const Text(
                  //                   'terms and conditions',
                  //                   style: TextStyle(
                  //                       color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
                  //                 )),
                  //           ),
                  //           const TextSpan(text: ' ,'),
                  //           WidgetSpan(
                  //             child: GestureDetector(
                  //               onTap: () {
                  //                 Get.toNamed(WebViewPage.routeName,
                  //                     arguments: 'https://www.shebaone.com/privacy-policy');
                  //               },
                  //               child: Text(
                  //                 'Privacy Policy',
                  //                 style:
                  //                     TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
                  //               ),
                  //             ),
                  //           ),
                  //           const TextSpan(text: ' ,'),
                  //           WidgetSpan(
                  //             child: GestureDetector(
                  //               onTap: () {
                  //                 Get.toNamed(WebViewPage.routeName,
                  //                     arguments: 'https://www.shebaone.com/return-policy');
                  //               },
                  //               child: Text(
                  //                 'Return Policy',
                  //                 style:
                  //                     TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
                  //               ),
                  //             ),
                  //           ),
                  //           const TextSpan(text: '.')
                  //         ]),
                  //   ),
                  //
                  //   // Text(
                  //   //   "By clicking  the check box, I am agree with the terms and conditions. Privacy Policy & Return Policy.",
                  //   //   style: TextStyle(
                  //   //     fontSize: 11,
                  //   //     fontWeight: FontWeight.w500,
                  //   //     color: kTextColor,
                  //   //   ),
                  //   // ),
                  //   value: _isCheck,
                  //   activeColor: kPrimaryColor,
                  //   onChanged: (newValue) {
                  //     setState(() {
                  //       _isCheck = newValue!;
                  //     });
                  //   },
                  //   controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
                  // ),
                  const SizedBox(
                    height: 160,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              color: kScaffoldColor,
              child: Column(
                children: [
                  SizedBox(
                    width: Get.width,
                    child: CheckboxListTile(
                      title: RichText(
                        text: TextSpan(
                            text:
                                'By clicking  the check box, I am agree with the ',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            children: [
                              WidgetSpan(
                                child: GestureDetector(
                                    onTap: () {
                                      Get.toNamed(WebViewPage.routeName,
                                          arguments:
                                              '${Database.apiUrl}terms-condition');
                                    },
                                    child: const Text(
                                      'terms and conditions',
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 16,
                                          decoration: TextDecoration.underline),
                                    )),
                              ),
                              const TextSpan(text: ' ,'),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(WebViewPage.routeName,
                                        arguments:
                                            '${Database.apiUrl}privacy-policy');
                                  },
                                  child: Text(
                                    'Privacy Policy',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              const TextSpan(text: ' ,'),
                              WidgetSpan(
                                child: GestureDetector(
                                  onTap: () {
                                    Get.toNamed(WebViewPage.routeName,
                                        arguments:
                                            '${Database.apiUrl}return-policy');
                                  },
                                  child: Text(
                                    'Return Policy',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ),
                              const TextSpan(text: '.')
                            ]),
                      ),

                      // Text(
                      //   "By clicking  the check box, I am agree with the terms and conditions. Privacy Policy & Return Policy.",
                      //   style: TextStyle(
                      //     fontSize: 11,
                      //     fontWeight: FontWeight.w500,
                      //     color: kTextColor,
                      //   ),
                      // ),
                      value: _isCheck,
                      activeColor: kPrimaryColor,
                      onChanged: (newValue) {
                        setState(() {
                          _isCheck = newValue!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                  Container(
                    height: 80,
                    width: Get.width,
                    color: kScaffoldColor,
                    child: PrimaryButton(
                      label: 'Place Order',
                      isDisable: !_isCheck,
                      marginHorizontal: 24,
                      marginVertical: 15,
                      height: 50,
                      onPressed: () async {
                        socketForDeliveryManAlert();
                        // getLoadingDialog();
                        if (HomeController.to.liveSearchType.value ==
                            LiveSearchType.prescription) {
                          globalLogger.d('Medicine Product');
                          PrescriptionController.to
                              .paymentMethod(_paymentMethod);
                          String jsonStringMap = json.encode(
                              PrescriptionController
                                  .to.confirmationPharmacyData['available']);
                          // globalLogger.d(confirm);
                          if (_paymentMethod == PaymentMethod.cod) {
                            info['info']['payment_method'] = 'COD';
                            info['info']['payment_transaction_id'] = uuid.v4();
                            // globalLogger.d(info['info']);
                            final res = await PrescriptionController.to
                                .orderMedicine(info['info']);
                            if (res) {
                              PrescriptionController.to
                                  .confirmOrderStatus(true);
                              UploadPrescriptionController.to.imagePath('');
                              PrescriptionController.to.syncDataFromPharmacy();
                              Get.offAndToNamed(
                                PurchaseDoneScreen.routeName,
                                arguments: info,
                              );
                            }
                          } else if (_paymentMethod ==
                              PaymentMethod.mobileBanking) {
                            ///TODO: Bkash
                            info['info']['payment_method'] =
                                'Bkash/Nagad Merchant';
                            info['info']['payment_transaction_id'] = uuid.v4();
                            globalLogger.d(info['info']);
                            final res = await PrescriptionController.to
                                .orderMedicine(info['info']);
                            if (res) {
                              PrescriptionController.to
                                  .confirmOrderStatus(true);
                              UploadPrescriptionController.to.imagePath('');

                              PrescriptionController.to.syncDataFromPharmacy();
                              Get.offAndToNamed(
                                PurchaseDoneScreen.routeName,
                                arguments: info,
                              );
                            }
                          } else if (_paymentMethod == PaymentMethod.online) {
                            info['info']['payment_method'] = 'Online';
                            SSLCTransactionInfoModel res =
                                await sslCommerzGeneralCallTest(
                                    (double.parse(
                                            info!['info']['order_amount']) +
                                        50),
                                    'Medicine');
                            if (res.status!.toLowerCase() == 'valid') {
                              globalLogger.d(info['info']);
                              info['info']['bank_transaction_id'] =
                                  res.bankTranId;
                              info['info']['payment_transaction_id'] =
                                  res.tranId;
                              final resp = await PrescriptionController.to
                                  .orderMedicine(info['info']);
                              if (resp) {
                                PrescriptionController.to
                                    .confirmOrderStatus(true);
                                UploadPrescriptionController.to.imagePath('');

                                PrescriptionController.to
                                    .syncDataFromPharmacy();
                                Get.offAndToNamed(
                                  PurchaseDoneScreen.routeName,
                                  arguments: info,
                                );
                              }
                            }
                          }
                        } else if (HomeController.to.liveSearchType.value ==
                            LiveSearchType.medicine) {
                          globalLogger.d('Medicine Product');
                          MedicineController.to.paymentMethod(_paymentMethod);
                          String jsonStringMap = json.encode(MedicineController
                              .to.confirmationPharmacyData['available']);
                          // globalLogger.d(confirm);
                          if (_paymentMethod == PaymentMethod.cod) {
                            info['info']['payment_method'] = 'COD';
                            info['info']['payment_transaction_id'] = uuid.v4();
                            // globalLogger.d(info['info']);
                            final res = await MedicineController.to
                                .orderMedicine(info['info']);
                            if (res) {
                              MedicineController.to.confirmOrderStatus(true);
                              MedicineController.to.syncDataFromPharmacy();
                              MedicineController.to.deleteAllCart();
                              Get.offAndToNamed(
                                PurchaseDoneScreen.routeName,
                                arguments: info,
                              );
                            }
                          } else if (_paymentMethod ==
                              PaymentMethod.mobileBanking) {
                            ///TODO: Bkash
                            info['info']['payment_method'] =
                                'Bkash/Nagad Merchant';
                            info['info']['payment_transaction_id'] = uuid.v4();
                            globalLogger.d(info['info']);
                            final res = await MedicineController.to
                                .orderMedicine(info['info']);
                            if (res) {
                              MedicineController.to.confirmOrderStatus(true);
                              MedicineController.to.syncDataFromPharmacy();
                              MedicineController.to.deleteAllCart();
                              Get.offAndToNamed(
                                PurchaseDoneScreen.routeName,
                                arguments: info,
                              );
                            }
                          } else if (_paymentMethod == PaymentMethod.online) {
                            info['info']['payment_method'] = 'Online';
                            SSLCTransactionInfoModel res =
                                await sslCommerzGeneralCallTest(
                                    (double.parse(
                                            info!['info']['order_amount']) +
                                        50),
                                    'Medicine');
                            if (res.status!.toLowerCase() == 'valid') {
                              globalLogger.d(info['info']);
                              info['info']['bank_transaction_id'] =
                                  res.bankTranId;
                              info['info']['payment_transaction_id'] =
                                  res.tranId;
                              final resp = await MedicineController.to
                                  .orderMedicine(info['info']);
                              if (resp) {
                                MedicineController.to.confirmOrderStatus(true);
                                MedicineController.to.syncDataFromPharmacy();
                                MedicineController.to.deleteAllCart();
                                Get.offAndToNamed(
                                  PurchaseDoneScreen.routeName,
                                  arguments: info,
                                );
                              }
                            }
                          }
                        }
                        // else if (HomeController.to.cartType.value == CartType.lab) {
                        //   LabController.to.paymentMethod(_paymentMethod);
                        //   globalLogger.d('Lab Test');
                        //
                        //   if (_paymentMethod == PaymentMethod.cod) {
                        //     info['payment_method'] = 'COD';
                        //     info['payment_id'] = uuid.v4();
                        //     globalLogger.d(info);
                        //     final res = await LabController.to.orderLabTests(info);
                        //
                        //     if (res) {
                        //       LabController.to.deleteAllCart();
                        //
                        //       Get.offAndToNamed(
                        //         PurchaseDoneScreen.routeName,
                        //         arguments: {
                        //           'from': 'Lab',
                        //           'info': info,
                        //         },
                        //       );
                        //     }
                        //   } else if (_paymentMethod == PaymentMethod.mobileBanking) {
                        //     info['payment_method'] = 'Bkash/Nagad Merchant';
                        //     info['payment_id'] = uuid.v4();
                        //     globalLogger.d(info);
                        //     final res = await LabController.to.orderLabTests(info);
                        //
                        //     if (res) {
                        //       LabController.to.deleteAllCart();
                        //
                        //       Get.offAndToNamed(
                        //         PurchaseDoneScreen.routeName,
                        //         arguments: {
                        //           'from': 'Lab',
                        //           'info': info,
                        //         },
                        //       );
                        //     }
                        //   } else if (_paymentMethod == PaymentMethod.online) {
                        //     info['payment_method'] = 'Online';
                        //     SSLCTransactionInfoModel res =
                        //         await sslCommerzGeneralCallTest(
                        //             double.parse(
                        //                 info!['collected_amount'].toString()),
                        //             'Healthcare Product');
                        //     if (res.status!.toLowerCase() == 'valid') {
                        //       globalLogger.d(info);
                        //       info['bank_transaction_id'] = res.bankTranId;
                        //       info['payment_id'] = res.tranId;
                        //       final resp = await LabController.to.orderLabTests(info);
                        //
                        //       if (resp) {
                        //         LabController.to.deleteAllCart();
                        //
                        //         Get.offAndToNamed(
                        //           PurchaseDoneScreen.routeName,
                        //           arguments: {
                        //             'from': 'Lab',
                        //             'info': info,
                        //           },
                        //         );
                        //       }
                        //     }
                        //   }
                        // }
                        else {
                          HealthCareController.to.paymentMethod(_paymentMethod);
                          globalLogger.d('Healthcare Product');
                          if (_paymentMethod == PaymentMethod.cod) {
                            info['payment_method'] = 'COD';
                            info['payment_id'] = uuid.v4();
                            globalLogger.d(info);
                            final res = await HealthCareController.to
                                .orderHealthcareProduct(info,
                                    HomeController.to.liveSearchType.value);

                            if (res) {
                              if (HomeController.to.liveSearchType.value ==
                                  LiveSearchType.healthcare) {
                                HealthCareController.to
                                    .confirmOrderStatus(true);
                                HealthCareController.to.syncDataFromPharmacy();
                                HealthCareController.to.deleteAllLiveCart();
                              } else {
                                HealthCareController.to.deleteAllCart();
                              }
                              Get.offAndToNamed(
                                PurchaseDoneScreen.routeName,
                                arguments: {
                                  'from': 'Healthcare',
                                  'info': info,
                                },
                              );
                            }
                          } else if (_paymentMethod ==
                              PaymentMethod.mobileBanking) {
                            ///TODO: Bkash
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BkashPayment(
                                      /// depend isSandbox (true/false)
                                      isSandbox: false,

                                      /// amount of your bkash payment
                                      amount: '10',

                                      /// intent would be (sale / authorization)
                                      intent: 'authorization',
                                      // accessToken: '', /// if the user have own access token for verify payment
                                      currency: 'BDT',

                                      /// bkash url for create payment, when you implement on you project then it be change as your production create url, [when you send it on sandbox mode, send it as empty string '' or anything]
                                      createBKashUrl:
                                          // 'https://merchantserver.sandbox.bka.sh/api/checkout/v1.2.0-beta/payment/create',
                                          'https://tokenized.pay.bka.sh/v1.2.0-beta/payment/create',

                                      /// bkash url for execute payment, , when you implement on you project then it be change as your production create url, [when you send it on sandbox mode, send it as empty string '' or anything]
                                      executeBKashUrl:
                                          // 'https://merchantserver.sandbox.bka.sh/api/checkout/v1.2.0-beta/payment/execute',
                                          'https://tokenized.pay.bka.sh/v1.2.0-beta/payment/execute',

                                      /// for script url, when you implement on production the set it live script js (https://scripts.pay.bka.sh/versions/1.2.0-beta/checkout/bKash-checkout-pay.js)
                                      scriptUrl:
                                          // 'https://scripts.sandbox.bka.sh/versions/1.2.0-beta/checkout/bKash-checkout-sandbox.js',
                                          'https://tokenized.pay.bka.sh/v1.2.0-beta/checkout/bKash-checkout-sandbox.js',

                                      /// the return value from the package
                                      /// status => 'paymentSuccess', 'paymentFailed', 'paymentError', 'paymentClose'
                                      /// data => return value of response
                                      paymentStatus: (status, data) {
                                        globalLogger
                                            .d('return status => $status');
                                        globalLogger.d('return data => $data');

                                        /// when payment success
                                        if (status == 'paymentSuccess') {
                                          if (data['transactionStatus'] ==
                                              'Completed') {
                                            Fluttertoast.showToast(
                                                msg: 'Payment Success');
                                          }
                                        }

                                        /// when payment failed
                                        else if (status == 'paymentFailed') {
                                          if (data.isEmpty) {
                                            Fluttertoast.showToast(
                                                msg: 'Payment Failed');
                                          } else if (data[0]['errorMessage']
                                                  .toString() !=
                                              'null') {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Payment Failed ${data[0]['errorMessage']}");
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Payment Failed");
                                          }
                                        }

                                        // when payment on error
                                        else if (status == 'paymentError') {
                                          Fluttertoast.showToast(
                                              msg: jsonDecode(
                                                      data['responseText'])[
                                                  'error']);
                                        }

                                        // when payment close on demand closed the windows
                                        else if (status == 'paymentClose') {
                                          if (data == 'closedWindow') {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Failed to payment, closed screen');
                                          } else if (data ==
                                              'scriptLoadedFailed') {
                                            Fluttertoast.showToast(
                                                msg:
                                                    'Payment screen loading failed');
                                          }
                                        }
                                        // back to screen to pop()
                                        Navigator.of(context).pop();
                                      },
                                    )));
                            if (false) {
                              info['payment_method'] = 'Bkash/Nagad Merchant';
                              info['payment_id'] = uuid.v4();
                              globalLogger.d(info);
                              final res = await HealthCareController.to
                                  .orderHealthcareProduct(info,
                                      HomeController.to.liveSearchType.value);
                              if (res) {
                                if (HomeController.to.liveSearchType.value ==
                                    LiveSearchType.healthcare) {
                                  HealthCareController.to
                                      .confirmOrderStatus(true);
                                  HealthCareController.to
                                      .syncDataFromPharmacy();
                                } else {
                                  HealthCareController.to.deleteAllCart();
                                }
                                Get.offAndToNamed(
                                  PurchaseDoneScreen.routeName,
                                  arguments: {
                                    'from': 'Healthcare',
                                    'info': info,
                                  },
                                );
                              }
                            }
                          } else if (_paymentMethod == PaymentMethod.online) {
                            info['payment_method'] = 'Online';
                            SSLCTransactionInfoModel res =
                                await sslCommerzGeneralCallTest(
                                    double.parse(
                                        info!['collected_amount'].toString()),
                                    'Healthcare Product');
                            globalLogger.d(res);
                            if (res.status!.toLowerCase() == 'valid') {
                              globalLogger.d(info);
                              info['bank_transaction_id'] = res.bankTranId;
                              info['payment_id'] = res.tranId;
                              final resp = await HealthCareController.to
                                  .orderHealthcareProduct(info,
                                      HomeController.to.liveSearchType.value);
                              if (resp) {
                                if (HomeController.to.liveSearchType.value ==
                                    LiveSearchType.healthcare) {
                                  HealthCareController.to
                                      .confirmOrderStatus(true);
                                  HealthCareController.to
                                      .syncDataFromPharmacy();
                                } else {
                                  HealthCareController.to.deleteAllCart();
                                }
                                //--------socket for delivery alert---------------------

                                Get.offAndToNamed(
                                  PurchaseDoneScreen.routeName,
                                  arguments: {
                                    'from': 'Healthcare',
                                    'info': info,
                                  },
                                );
                              }
                            }
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // if (_paymentMethod == PaymentMethod.mobileBanking)
          //   Positioned(
          //     bottom: Get.height * .4,
          //     left: 26,
          //     child: Container(
          //       padding: const EdgeInsets.all(8),
          //       width: Get.width - 52,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(4),
          //           boxShadow: const [
          //             BoxShadow(
          //               color: Colors.black12,
          //               blurRadius: 4,
          //             )
          //           ]),
          //       child: TitleText(
          //           title:
          //               'Your need to pay directly to this merchant Bkash/Nagad (+88 0175 5660692) from any Bkash/Nagad personal number by selecting payment option and putting invoice number. After payment you need to send the transaction number & invoice number to ShebaOne Ltd. through whatsapp(+88 0175 5660692)/messenger.',
          //           fontSize: 11,
          //           fontWeight: FontWeight.normal,
          //           color: kTextColor),
          //     ),
          //   )
        ],
      ),
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
      height: 54,
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
