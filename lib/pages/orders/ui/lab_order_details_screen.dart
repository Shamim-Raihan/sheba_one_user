import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/models/lab_order_model.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class LabOrderDetails extends StatelessWidget {

  const LabOrderDetails({Key? key}) : super(key: key);

  static String routeName = '/LabOrderDetails';
  @override
  Widget build(BuildContext context) {
    LabOrderModel labOrder = Get.arguments;
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
      body: SingleChildScrollView(
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
                              title: 'Order ID: #${labOrder.orderNo}',
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
                              title: 'Status: ${labOrder.orderStatus!}',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            space3R,
                            TitleText(
                              title:
                                  'Order Date:  ${DateFormat('dd/MM/yyyy').format(DateTime.parse(labOrder.createdAt!))}',
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ],
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
                          title: '${labOrder.totalItem!} Total Items',
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
                      itemCount: labOrder.orderDetail!.length,
                      itemBuilder: (_, index) {
                        OrderDetail orderData = labOrder.orderDetail![index];
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // TitleText(
                                  //   title: HomeController
                                  //       .to
                                  //       .orderListType
                                  //       .value ==
                                  //       OrderType.healthcare
                                  //       ? '${orderData.!}x'
                                  //       : '${medicineData!.qty!}x',
                                  //   fontSize: 16,
                                  //   color: const Color(0xff205930),
                                  // ),
                                  // space2R,
                                  Expanded(
                                    child: TitleText(
                                      title: orderData.testName!,
                                      fontSize: 16,
                                      textOverflow: TextOverflow.ellipsis,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff205930).withOpacity(0.75),
                                    ),
                                  ),
                                  space2R,
                                  TitleText(
                                    title: double.parse(orderData.testPrice!).toStringAsFixed(2),
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
                        title: 'Total Price:  ${double.parse(labOrder.grandTotal!).toStringAsFixed(2)}',
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
      ),
    );
  }
}
