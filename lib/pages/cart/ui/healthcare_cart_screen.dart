import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/models/healthcare_cart_model.dart';
import 'package:shebaone/pages/cart/ui/billing_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';

class HealthcareCartScreen extends StatefulWidget {
  const HealthcareCartScreen({Key? key}) : super(key: key);
  static String routeName = '/HealthcareCartScreen';

  @override
  State<HealthcareCartScreen> createState() => _HealthcareCartScreenState();
}

class _HealthcareCartScreenState extends State<HealthcareCartScreen> {
  TextEditingController? _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    HealthCareController.to.syncHealthcareCartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        title: Container(
          height: 30,
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
              HealthCareController.to.deleteAllCart();
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
            child: Obx(
              () => HealthCareController.to.getHealthcareCartList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.only(bottom: 210),
                      itemCount: HealthCareController.to.getHealthcareCartList.length,
                      itemBuilder: (_, index) {
                        return CartCard(
                          info: HealthCareController.to.getHealthcareCartList[index],
                          isLast: index == HealthCareController.to.getHealthcareCartList.length - 1,
                        );
                      })
                  : const Center(
                      child: Text('Your Cart is Empty!'),
                    ),
            ),
          ),
          Obx(
            () => HealthCareController.to.getHealthcareCartList.isNotEmpty
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      height: 200,
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
                                  title: 'Reffeal Code',
                                  fontSize: 14,
                                  color: const Color(0xff363942),
                                ),
                                space2C,
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomTextField(
                                        verticalMargin: 0,
                                        verticalPadding: 0,
                                        controller: _controller!,
                                        borderRadius: const BorderRadius.horizontal(
                                          left: Radius.circular(5),
                                        ),
                                      ),
                                    ),
                                    CustomTextButton(
                                      height: 30,
                                      buttonLabel: 'Apply',
                                      onTap: () {},
                                      buttonColor: const Color(0xff4A8B5C),
                                      labelColor: Colors.white,
                                    )
                                  ],
                                ),
                                space3C,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const TitleText(
                                      title: 'Subtotal',
                                      color: Color(0xff363942),
                                      fontSize: 16,
                                    ),
                                    TitleText(
                                      title: '৳ ${HealthCareController.to.getCartTotalPrice}',
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          space4C,
                          PrimaryButton(
                            label: 'Continue to Checkout',
                            marginHorizontal: 24,
                            marginVertical: 0,
                            height: 50,
                            onPressed: () {
                              HomeController.to.cartType(CartType.healthcare);
                              HomeController.to.liveSearchType(LiveSearchType.none);
                              Get.toNamed(BillingScreen.routeName);
                            },
                          ),
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
  final HealthCareCartModel info;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
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
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(.04),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CustomNetworkImage(
                        networkImagePath: info.images!.isNotEmpty ? info.images![0].imagePath! : '',
                        borderRadius: 5,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleText(
                            title: info.name!,
                            maxLines: 2,
                            color: Colors.black,
                            textOverflow: TextOverflow.ellipsis,
                            fontSize: 12,
                          ),
                          Row(
                            children: [
                              TitleText(
                                title: '৳ ${info.offerPrice!}',
                                fontSize: 16,
                              ),
                              space2R,
                              TitleText(
                                title: '৳ ${info.mrp}',
                                fontSize: 10,
                                textDecoration: TextDecoration.lineThrough,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff939393),
                              ),
                            ],
                          ),
                          space2C,
                          AddRemoveButtons(
                            height: 20,
                            width: 75,
                            iconSize: 16,
                            addPressed: () {
                              HealthCareController.to.addUpdateDeleteCart(info);
                            },
                            quantity: info.userQuantity!,
                            removePressed: () {
                              HealthCareController.to.addUpdateDeleteCart(info, isReducing: true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              right: 24,
              child: GestureDetector(
                onTap: () {
                  debugPrint('Delete');
                  HealthCareController.to.addUpdateDeleteCart(info, isDeleting: true);
                },
                child: Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: kPrimaryColor.withOpacity(.08),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icons/delete.png',
                      width: 14,
                      height: 14,
                    ),
                  ),
                ),
              ),
            ),
          ],
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
