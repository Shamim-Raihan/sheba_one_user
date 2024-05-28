import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/models/healthcare_order_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/pages/orders/ui/current_orders_screen.dart';
import 'package:shebaone/pages/orders/ui/previous_orders_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({Key? key}) : super(key: key);

  static String routeName = '/OrderDetails';

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String previousRoute = '';

  MedicineOrderModel healthcareData = MedicineOrderModel();
  MedicineOrderModel medicineData = MedicineOrderModel();
  @override
  void initState() {
    // TODO: implement initState
    previousRoute=  Get.previousRoute;
    globalLogger.d(previousRoute);
    globalLogger.d(HomeController.to.currentOrderListType.value);
    globalLogger.d(HomeController.to.previousOrderListType.value);
    if (previousRoute == CurrentOrdersScreen.routeName) {
      if (HomeController.to.currentOrderListType.value == OrderType.healthcare) {
        healthcareData = Get.arguments;
      } else {
        medicineData = Get.arguments;
      }
    } else if (previousRoute == PreviousOrdersScreen.routeName) {
      if (HomeController.to.previousOrderListType.value == OrderType.healthcare) {
        healthcareData = Get.arguments;
      } else {
        medicineData = Get.arguments;
      }
    } else {
      if (HomeController.to.orderListType.value == OrderType.healthcare) {
        healthcareData = Get.arguments;
      } else {
        medicineData = Get.arguments;
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppbarBgColor,
        foregroundColor: Colors.white,
        title: const TitleText(
          title: 'Details',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      body: Obx(
        () {
          ///TODO: Problem
          if (previousRoute == CurrentOrdersScreen.routeName) {
            if (HomeController.to.currentOrderListType.value == OrderType.healthcare) {
              healthcareData = Get.arguments;
            } else {
              medicineData = Get.arguments;
            }
          } else if (previousRoute == PreviousOrdersScreen.routeName) {
            if (HomeController.to.previousOrderListType.value == OrderType.healthcare) {
              healthcareData = Get.arguments;
            } else {
              medicineData = Get.arguments;
            }
          } else {
            if (HomeController.to.orderListType.value == OrderType.healthcare) {
              healthcareData = Get.arguments;
            } else {
              medicineData = Get.arguments;
            }
          }
          return HomeController.to.orderDetailsLoading.value
              ? const Center(
                  child: Waiting(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      BgContainer(
                        horizontalPadding: 0,
                        child: Stack(
                          children: [
                            MainContainer(
                              horizontalMargin: 30,
                              verticalPadding: 16,
                              borderColor: kAssentColor,
                              child: Column(
                                children: [
                                  const TitleText(
                                    title: 'Order Details',
                                    fontSize: 20,
                                  ),
                                  space4C,
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/gift.png',
                                        width: 27,
                                      ),
                                      space3R,
                                      TitleText(
                                        title:
                                            'Order ID: #${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? healthcareData.orderId : medicineData.orderId! : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? healthcareData.orderId : medicineData.orderId! : HomeController.to.orderListType.value == OrderType.healthcare ? healthcareData.orderId : medicineData.orderId!}',
                                        fontSize: 16,
                                      ),
                                    ],
                                  ),
                                  space4C,
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TitleText(
                                        title:
                                            'Status: ${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? healthcareData.orderStatus! : medicineData.orderStatus! : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? healthcareData.orderStatus! : medicineData.orderStatus! : HomeController.to.orderListType.value == OrderType.healthcare ? healthcareData.orderStatus! : medicineData.orderStatus!}',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      space3R,
                                      TitleText(
                                        title:
                                            'Order Date:  ${DateFormat('dd/MM/yyyy').format(DateTime.parse(previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? healthcareData.createdAt! : medicineData.createdAt! : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? healthcareData.createdAt! : medicineData.createdAt! : HomeController.to.orderListType.value == OrderType.healthcare ? healthcareData.createdAt! : medicineData.createdAt!))}',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                  space4C,
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TitleText(
                                        title:
                                            '${
                                                previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? 'Health Store' : 'Pharmacy' : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? 'Health Store' : 'Pharmacy' : HomeController.to.orderListType.value == OrderType.healthcare ? 'Health Store' : 'Pharmacy'
                                            } Name: ${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? healthcareData.pharmacy!=null? healthcareData.pharmacy!.pharmacyName!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.pharmacyName: ''  : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? healthcareData.pharmacy!=null? healthcareData.pharmacy!.pharmacyName!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.pharmacyName: ''   : HomeController.to.orderListType.value == OrderType.healthcare ? healthcareData.pharmacy!=null? healthcareData.pharmacy!.pharmacyName!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.pharmacyName: ''  }',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      space3R,
                                      TitleText(
                                        title:
                                            'Contact:  ${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ?  healthcareData.pharmacy!=null? healthcareData.pharmacy!.contactNo!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.contactNo: ''  : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ?  healthcareData.pharmacy!=null? healthcareData.pharmacy!.contactNo!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.contactNo: ''   : HomeController.to.orderListType.value == OrderType.healthcare ?  healthcareData.pharmacy!=null? healthcareData.pharmacy!.contactNo!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.contactNo: ''  }',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ],
                                  ),
                                  space4C,
                                  TitleText(
                                    title:
                                    '${
                                        previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? 'Health Store' : 'Pharmacy' : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? 'Health Store' : 'Pharmacy' : HomeController.to.orderListType.value == OrderType.healthcare ? 'Health Store' : 'Pharmacy'
                                    } Address: ${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? healthcareData.pharmacy!=null? healthcareData.pharmacy!.address!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.address: ''  : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? healthcareData.pharmacy!=null? healthcareData.pharmacy!.address!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.address: ''   : HomeController.to.orderListType.value == OrderType.healthcare ? healthcareData.pharmacy!=null? healthcareData.pharmacy!.address!: '' : MedicineController.to.medicineSingleOrderItemList.isNotEmpty?MedicineController.to.medicineSingleOrderItemList[0].pharmacy!.address: ''  }',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 30,
                              top: 1,
                              child: Image.asset(
                                'assets/images/style-bg.png',
                                width: 120,
                              ),
                            ),
                          ],
                        ),
                      ),
                      space8C,
                      Container(
                        width: Get.width,
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xff205930).withOpacity(.15),
                          border: Border.symmetric(
                            horizontal: BorderSide(
                              color: const Color(0xff205930).withOpacity(.4),
                            ),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const TitleText(
                                    title: 'Order Summary',
                                    fontSize: 20,
                                    color: Color(0xff205930),
                                  ),
                                  TitleText(
                                    title:
                                        '${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ?HealthCareController.to.healthcareSingleOrderDetailsList.length : MedicineController.to.medicineSingleOrderItemList.length : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? HealthCareController.to.healthcareSingleOrderDetailsList.length : MedicineController.to.medicineSingleOrderItemList.length : HomeController.to.orderListType.value == OrderType.healthcare ? HealthCareController.to.healthcareSingleOrderDetailsList.length : MedicineController.to.medicineSingleOrderItemList.length} Total Items',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff38443E),
                                  ),
                                ],
                              ),
                            ),
                            HorizontalDivider(
                              thickness: 1,
                              color: const Color(0xff205930).withOpacity(.5),
                            ),
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                itemCount: previousRoute == CurrentOrdersScreen.routeName
                                    ? HomeController.to.currentOrderListType.value == OrderType.healthcare
                                        ? HealthCareController.to.healthcareSingleOrderDetailsList.length
                                        : MedicineController.to.medicineSingleOrderItemList.length
                                    : previousRoute == PreviousOrdersScreen.routeName
                                        ? HomeController.to.previousOrderListType.value == OrderType.healthcare
                                            ? HealthCareController.to.healthcareSingleOrderDetailsList.length
                                            : MedicineController.to.medicineSingleOrderItemList.length
                                        : HomeController.to.orderListType.value == OrderType.healthcare
                                            ? HealthCareController.to.healthcareSingleOrderDetailsList.length
                                            : MedicineController.to.medicineSingleOrderItemList.length,
                                itemBuilder: (_, index) {
                                  HealthcareSingleOrderModel? healthcareData;
                                  MedicineSingleOrderItemModel? medicineData;

                                  if (previousRoute == CurrentOrdersScreen.routeName) {
                                    globalLogger.d('1');
                                    if (HomeController.to.currentOrderListType.value == OrderType.healthcare) {
                                      globalLogger.d('2');
                                      healthcareData = HealthCareController.to.healthcareSingleOrderDetailsList[index];
                                    } else {
                                      globalLogger.d('3');
                                      medicineData = MedicineController.to.medicineSingleOrderItemList[index];
                                    }
                                  } else if (previousRoute == PreviousOrdersScreen.routeName) {
                                    if (HomeController.to.previousOrderListType.value == OrderType.healthcare) {
                                      healthcareData = HealthCareController.to.healthcareSingleOrderDetailsList[index];
                                    } else {
                                      medicineData = MedicineController.to.medicineSingleOrderItemList[index];
                                    }
                                  } else {
                                    if (HomeController.to.orderListType.value == OrderType.healthcare) {
                                      healthcareData = HealthCareController.to.healthcareSingleOrderDetailsList[index];
                                    } else {
                                      medicineData = MedicineController.to.medicineSingleOrderItemList[index];
                                    }
                                  }

                                  // final item = HealthCareController.to
                                  //     .healthcareSingleOrderDetailsList[index];
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            TitleText(
                                              title: previousRoute == CurrentOrdersScreen.routeName
                                                  ? HomeController.to.currentOrderListType.value == OrderType.healthcare
                                                      ? '${healthcareData!.qty!}x'
                                                      : '${medicineData!.qty!}x'
                                                  : previousRoute == PreviousOrdersScreen.routeName
                                                      ? HomeController.to.previousOrderListType.value ==
                                                              OrderType.healthcare
                                                          ? '${healthcareData!.qty!}x'
                                                          : '${medicineData!.qty!}x'
                                                      : HomeController.to.orderListType.value == OrderType.healthcare
                                                          ? '${healthcareData!.qty!}x'
                                                          : '${medicineData!.qty!}x',
                                              fontSize: 16,
                                              color: const Color(0xff205930),
                                            ),
                                            space2R,
                                            Expanded(
                                              child: TitleText(
                                                title: previousRoute == CurrentOrdersScreen.routeName
                                                    ? HomeController.to.currentOrderListType.value ==
                                                            OrderType.healthcare
                                                        ? healthcareData!.productName!
                                                        : medicineData!.medicineName!
                                                    : previousRoute == PreviousOrdersScreen.routeName
                                                        ? HomeController.to.previousOrderListType.value ==
                                                                OrderType.healthcare
                                                            ? healthcareData!.productName!
                                                            : medicineData!.medicineName!
                                                        : HomeController.to.orderListType.value == OrderType.healthcare
                                                            ? healthcareData!.productName!
                                                            : medicineData!.medicineName!,
                                                fontSize: 16,
                                                textOverflow: TextOverflow.ellipsis,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xff205930).withOpacity(0.75),
                                              ),
                                            ),
                                            space2R,
                                            TitleText(
                                              title: previousRoute == CurrentOrdersScreen.routeName
                                                  ? HomeController.to.currentOrderListType.value == OrderType.healthcare
                                                      ? (double.parse(healthcareData!.productPrice!)*int.parse(healthcareData.qty!)).toStringAsFixed(2)
                                                      : (double.parse(medicineData!.medicine!.offerPrice!) *
                                                              int.parse(
                                                                  medicineData.qty!.isEmpty ? '0' : medicineData.qty!))
                                                          .toStringAsFixed(2)
                                                  : previousRoute == PreviousOrdersScreen.routeName
                                                      ? HomeController.to.previousOrderListType.value ==
                                                              OrderType.healthcare
                                                          ? (double.parse(healthcareData!.productPrice!)*int.parse(healthcareData.qty!)).toStringAsFixed(2)
                                                          : (double.parse(medicineData!.medicine!.offerPrice!) *
                                                                  int.parse(medicineData.qty!))
                                                              .toStringAsFixed(2)
                                                      : HomeController.to.orderListType.value == OrderType.healthcare
                                                          ? (double.parse(healthcareData!.productPrice!)*int.parse(healthcareData.qty!)).toStringAsFixed(2)
                                                          : (double.parse(medicineData!.medicine!.offerPrice!) *
                                                                  int.parse(medicineData.qty!))
                                                              .toStringAsFixed(2),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xff205930).withOpacity(0.75),
                                            ),
                                          ],
                                        ),
                                      ),
                                      HorizontalDivider(
                                        thickness: 1,
                                        color: const Color(0xff205930).withOpacity(.5),
                                      ),
                                    ],
                                  );
                                }),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TitleText(
                                  title:
                                      'Total Price:  ${previousRoute == CurrentOrdersScreen.routeName ? HomeController.to.currentOrderListType.value == OrderType.healthcare ? double.parse(healthcareData.orderAmount!).toStringAsFixed(2) : double.parse(medicineData.orderAmount!).toStringAsFixed(2) : previousRoute == PreviousOrdersScreen.routeName ? HomeController.to.previousOrderListType.value == OrderType.healthcare ? double.parse(healthcareData.orderAmount!).toStringAsFixed(2) : double.parse(medicineData.orderAmount!).toStringAsFixed(2) : HomeController.to.orderListType.value == OrderType.healthcare ? double.parse(healthcareData.orderAmount!).toStringAsFixed(2) : double.parse(medicineData.orderAmount!).toStringAsFixed(2)}',
                                  fontSize: 16,
                                  color: const Color(0xff205930),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
