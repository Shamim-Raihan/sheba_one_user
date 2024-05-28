import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/lab_cart_model.dart';
import 'package:shebaone/pages/cart/ui/billing_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class LabCartScreen extends StatefulWidget {
  const LabCartScreen({Key? key}) : super(key: key);
  static String routeName = '/LabCartScreen';

  @override
  State<LabCartScreen> createState() => _LabCartScreenState();
}

class _LabCartScreenState extends State<LabCartScreen> {
  TextEditingController? _referController;
  @override
  void initState() {
    // TODO: implement initState
    _referController = TextEditingController();
    LabController.to.syncLabCartData();
    super.initState();
  }

  String location = 'Null, Press Button';
  String address = 'search';

  // Future<void> getAddressFromLatLong(Position position) async {
  //   List<Placemark> placemarks =
  //       await placemarkFromCoordinates(position.latitude, position.longitude);
  //   // globalLogger.d(placemarks);
  //   Placemark place = placemarks[0];
  //   address =
  //       '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   globalLogger.d(address);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        title: Container(
          height: 30,
          width: Get.width * .6,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
          child: const Center(
            child: TitleText(
              title: 'My Cart',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              debugPrint('Delete');
              LabController.to.deleteAllCart();
            },
            child: Container(
              height: 30,
              width: 40,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/delete.png',
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SizedBox(
            height: Get.height,
            child:
                // SingleChildScrollView(
                //   child: Column(
                //     children:  [
                Obx(
              () => LabController.to.getLabCartList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: LabController.to.getLabCartList.length,
                      itemBuilder: (_, index) {
                        return CartCard(
                          info: LabController.to.getLabCartList[index],
                          isLast: index == LabController.to.getLabCartList.length - 1,
                        );
                      })
                  : const Center(
                      child: Text('No Product in Your Cart'),
                    ),
            ),

            // SizedBox(
            //   height: 160,
            // ),
            //     ],
            //   ),
            // ),
          ),
          Obx(
            () => LabController.to.getLabCartList.isNotEmpty
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      // height: 150,
                      width: Get.width,
                      color: kScaffoldColor,
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black12,
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TitleText(
                                  title: 'Refer Code',
                                  fontSize: 14,
                                  color: Color(0xff363942),
                                ),
                                space2C,
                                CustomTextField(
                                  verticalMargin: 0,
                                  verticalPadding: 0,
                                  controller: _referController!,
                                  hintText: 'Refer Code (Optional)',
                                ),
                                space2C,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TitleText(
                                      title: 'Subtotal',
                                      color: Color(0xff363942),
                                      fontSize: 16,
                                    ),
                                    TitleText(
                                      title: '৳ ${LabController.to.getCartTotalPrice}',
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          space4C,
                          PrimaryButton(
                            label: 'Checkout',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            marginHorizontal: 24,
                            marginVertical: 0,
                            height: 50,
                            onPressed: () async {
                              LabController.to.refferCode(_referController!.text);

                              HomeController.to.cartType(CartType.lab);
                              Get.toNamed(BillingScreen.routeName);
                            },
                          ),
                          space4C,
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class CartCard extends StatelessWidget {
  const CartCard({
    this.isLast = false,
    required this.info,
    Key? key,
  }) : super(key: key);
  final bool isLast;
  final LabCartModel info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: kPrimaryColor.withOpacity(.04),
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          width: Get.width,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TitleText(
                            title: info.testName!,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            fontSize: 16,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Delete');
                              LabController.to.addUpdateDeleteCart(info, isDeleting: true);
                            },
                            child: SizedBox(
                              height: 24,
                              width: 24,
                              child: Center(
                                child: Image.asset(
                                  'assets/icons/delete.png',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const TitleText(
                          title: 'Lab Name: ',
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        TitleText(
                          title: info.labName!,
                          maxLines: 2,
                          textOverflow: TextOverflow.ellipsis,
                          fontSize: 14,
                        ),
                      ],
                    ),
                  ],
                ),
                space2C,
                Align(
                  alignment: Alignment.topRight,
                  child: TitleText(
                    title: '৳ ${double.parse(info.labPrice!).toStringAsFixed(2)}',
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),
        ),
        if (!isLast)
          HorizontalDivider(
            horizontalMargin: 24,
            color: kPrimaryColor.withOpacity(.5),
            height: 1,
          ),
      ],
    );
  }
}
