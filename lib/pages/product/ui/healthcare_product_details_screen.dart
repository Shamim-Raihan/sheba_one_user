import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/models/healthcare_cart_model.dart';
import 'package:shebaone/models/healthcare_product_model.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';

class HealthcareProductDetailsScreen extends StatefulWidget {
  const HealthcareProductDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/HealthcareProductDetailsScreen';

  @override
  State<HealthcareProductDetailsScreen> createState() => _HealthcareProductDetailsScreenState();
}

class _HealthcareProductDetailsScreenState extends State<HealthcareProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  @override
  void initState() {
    // TODO: implement initState
    _tabController = TabController(length: 2, vsync: this);
    _tabController?.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {});
    }
  }

  int _quantity = 1;
  int _activeImage = 0;
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
              title: 'Product Details',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        actions: [
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.all(12),
            child: CustomTextButton(
              onTap: () {
                // Get.toNamed(HealthcareCartScreen.routeName);
                Get.toNamed(HealthcareLiveCartScreen.routeName);
              },
              isIconButton: true,
              buttonColor: Colors.white,
              elevation: 3,
              iconPath: 'cart-green',
            ),
          ),
        ],
      ),
      body: Obx(
        () => HealthCareController.to.productLoading.value
            ? const Waiting()
            : Stack(
                children: [
                  SizedBox(
                    height: Get.height,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: kPrimaryColor, width: .5),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            height: 230,
                            width: Get.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Obx(
                                () => CustomNetworkImage(
                                  networkImagePath: HealthCareController.to.getSingleProductInfo.images!.isNotEmpty?
                                      HealthCareController.to.getSingleProductInfo.images![_activeImage].imagePath!:
                                  '',
                                  errorImagePath: 'assets/images/not_found.jpg',
                                ),
                              ),
                            ),
                          ),
                          Obx(
                            () => SizedBox(
                              height: 56,
                              child: HealthCareController.to.getSingleProductInfo.images == null
                                  ? const SizedBox()
                                  : ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                      itemCount: HealthCareController.to.getSingleProductInfo.images == null
                                          ? 0
                                          : HealthCareController.to.getSingleProductInfo.images!.length,
                                      itemBuilder: (_, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            _activeImage = index;
                                            setState(() {});
                                          },
                                          child: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              color: _activeImage == index ? kPrimaryColor : Colors.transparent,
                                              width: 2,
                                            )),
                                            child: CustomNetworkImage(
                                              networkImagePath: HealthCareController
                                                  .to.getSingleProductInfo.images![index].imagePath!,
                                              height: 50,
                                              width: 50,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                                vertical: 8,
                              ),
                              child: Obx(
                                () => TitleText(
                                  title: HealthCareController.to.getSingleProductInfo.name!,
                                  maxLines: 2,
                                  textOverflow: TextOverflow.ellipsis,
                                  fontSize: 16,
                                  color: Colors.black,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                          ),
                          Container(
                              width: Get.width,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xffF5F9F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TitleText(
                                    title: 'Description',
                                    textOverflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    textAlign: TextAlign.left,
                                  ),
                                  Obx(
                                    () => HealthCareController.to.productLoading.value
                                        ? Center(
                                            child: Image.asset(
                                              'assets/icons/color-loading.gif',
                                              height: 40,
                                              width: 100,
                                              fit: BoxFit.fitHeight,
                                            ),
                                          )
                                        : HealthCareController.to.getSingleProductInfo.description != 'null'
                                            ? Html(
                                                data: HealthCareController.to.getSingleProductInfo.description!,
                                                style: {
                                                  'body': Style(
                                                    margin: Margins.zero,
                                                  ),
                                                },
                                              )
                                            : const Text('No Description available!'),
                                  ),
                                  const TitleText(
                                    title: 'Delivery',
                                    textOverflow: TextOverflow.ellipsis,
                                    fontSize: 16,
                                    color: Colors.black,
                                    textAlign: TextAlign.left,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (HealthCareController.to.getSingleProductInfo.preOrder == '1')
                                        const DesItem(
                                          label: 'Store Location',
                                          body: 'Overseas',
                                        ),
                                      const DesItem(
                                        label: 'Home Delivery',
                                        body: '80 TK',
                                      ),
                                      DesItem(
                                        label: 'Delivery Time',
                                        body: HealthCareController.to.getSingleProductInfo.preOrder == '1'
                                            ? " As the product will be delivered from overseas it will take minimum 21 days"
                                            : 'Around 06 Hours ',
                                      ),
                                      if (HealthCareController.to.getSingleProductInfo.preOrder != '1')
                                        const DesItem(
                                          label: 'Cash on Delivery',
                                          body: 'Available',
                                        ),
                                      if (HealthCareController.to.getSingleProductInfo.preOrder == '1')
                                        DesItem(
                                          label: 'Pre Order',
                                          body:
                                              'As this product will be delivered from overseas, full Pre- payment is required',
                                          bodyColor: kPrimaryColor,
                                        ),
                                      Obx(() => DesItem(
                                            label: 'Warranty',
                                            body: HealthCareController.to.getSingleProductInfo.warranty!.isEmpty
                                                ? 'Not Specified'
                                                : HealthCareController.to.getSingleProductInfo.warranty!,
                                          )),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: const [
                                Text.rich(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                                  TextSpan(
                                    text: 'Reviews(4.9',
                                    children: [
                                      WidgetSpan(
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Icon(
                                            Icons.star,
                                            color: Color(0xffF0A422),
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                      TextSpan(text: ')')
                                    ],
                                  ),
                                ),
                                Text(
                                  '72 Reviews',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const TitleText(
                                  title: 'Quantity',
                                  color: Color(0xff363942),
                                  fontSize: 16,
                                ),
                                AddRemoveButtons(
                                  addPressed: () {
                                    debugPrint('add');
                                    _quantity++;
                                    setState(() {});
                                  },
                                  quantity: '$_quantity',
                                  removePressed: () {
                                    if (_quantity > 1) {
                                      _quantity--;
                                    }
                                    setState(() {});
                                    debugPrint('remove');
                                  },
                                )
                              ],
                            ),
                          ),
                          Obx(
                            () => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: [
                                  Text('Available Qty: ${HealthCareController.to.getSingleProductInfo.quantity}'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 80,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      height: 80,
                      width: Get.width,
                      color: kScaffoldColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Obx(
                              () => HealthCareController.to.productLoading.value
                                  ? Center(
                                      child: Image.asset(
                                        'assets/icons/color-loading.gif',
                                        height: 40,
                                        width: 100,
                                        fit: BoxFit.fitHeight,
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 24.0),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: TitleText(
                                              title:
                                                  '৳ ${double.parse(HealthCareController.to.getSingleProductInfo.offerPrice!).toStringAsFixed(2)}',
                                              fontSize: 24,
                                            ),
                                          ),
                                        ),
                                        if (HealthCareController.to.getSingleProductInfo.offerPercentage != '0')
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              TitleText(
                                                title:
                                                    '৳ ${double.parse(HealthCareController.to.getSingleProductInfo.mrp!).toStringAsFixed(2)}',
                                                fontSize: 14,
                                                color: const Color(0xff939393),
                                                fontWeight: FontWeight.w500,
                                              ),
                                              LessBox(
                                                  less: HealthCareController.to.getSingleProductInfo.offerPercentage!),
                                            ],
                                          ),
                                      ],
                                    ),
                            ),
                          ),
                          space2R,
                          Expanded(
                            flex: 5,
                            child: Obx(
                              () => PrimaryButton(
                                label: HealthCareController.to.getSingleProductInfo.quantity != null &&
                                        int.parse(HealthCareController.to.getSingleProductInfo.quantity!) > 0
                                    ? 'Add To cart'
                                    : 'Add to Cart for Search',
                                marginHorizontal: 24,
                                marginVertical: 0,
                                contentHorizontalPadding: 8,
                                contentVerticalPadding: 0,
                                height: 50,
                                fontSize: 14,
                                onPressed: () async {
                                  globalLogger.d('product live search');
                                  if (int.parse(HealthCareController.to.getSingleProductInfo.quantity!) > 0) {
                                    HealthCareProductModel _product = HealthCareController.to.getSingleProductInfo;
                                    if (_quantity > int.parse(_product.quantity!)) {
                                      Get.defaultDialog(
                                          content: const Text(
                                            'This product is not available at ShebaOne store. If you need more then go for live search.',
                                            textAlign: TextAlign.center,
                                          ),
                                          actions: [
                                            PrimaryButton(
                                              label: 'Add to Cart for Search',
                                              marginVertical: 16,
                                              onPressed: () async {
                                                print('Add to cart');

                                                HealthCareCartModel cartModel =
                                                    HealthCareCartModel.fromJson(_product.toJson());
                                                cartModel.userQuantity = '1';
                                                print('ok');
                                                HealthCareController.to.addUpdateDeleteLiveCart(cartModel);
                                                // Get.back();
                                                // if (HealthCareController.to.confirmOrderStatus.value ||
                                                //     MedicineController.to.confirmOrderStatus.value) {
                                                //   Fluttertoast.showToast(
                                                //       msg: "Already You have one live search running!",
                                                //       toastLength: Toast.LENGTH_SHORT,
                                                //       gravity: ToastGravity.CENTER,
                                                //       timeInSecForIosWeb: 1,
                                                //       backgroundColor: Colors.redAccent,
                                                //       textColor: Colors.white,
                                                //       fontSize: 16.0);
                                                // } else {
                                                //   globalLogger.d('hhhh');
                                                //   HomeController.to.cartType(CartType.healthcare);
                                                //   final data = await HomeController.to.getPosition();
                                                //   globalLogger.d(data);
                                                //   if (data) {
                                                //     HomeController.to.liveSearchType(LiveSearchType.healthcare);
                                                //     final dataL = await Get.toNamed(LogInCheckLiveMapPage.routeName);
                                                //     if (dataL == null) {
                                                //       HomeController.to.liveSearchType(LiveSearchType.none);
                                                //     }
                                                //   }
                                                // }
                                              },
                                            ),
                                          ]);
                                    } else {
                                      HealthCareCartModel cartModel = HealthCareCartModel.fromJson(_product.toJson());
                                      cartModel.userQuantity = _quantity.toString();
                                      print('ok');
                                      HealthCareController.to.addUpdateDeleteCart(cartModel, quantity: _quantity);
                                    }
                                  } else {
                                    HealthCareCartModel cartModel = HealthCareCartModel.fromJson(
                                        HealthCareController.to.getSingleProductInfo.toJson());
                                    cartModel.userQuantity = '1';
                                    print('ok');
                                    HealthCareController.to.addUpdateDeleteLiveCart(cartModel);
                                    // if (HealthCareController.to.confirmOrderStatus.value ||
                                    //     MedicineController.to.confirmOrderStatus.value) {
                                    //   Fluttertoast.showToast(
                                    //       msg: "Already You have one live search running!",
                                    //       toastLength: Toast.LENGTH_SHORT,
                                    //       gravity: ToastGravity.CENTER,
                                    //       timeInSecForIosWeb: 1,
                                    //       backgroundColor: Colors.redAccent,
                                    //       textColor: Colors.white,
                                    //       fontSize: 16.0);
                                    // } else {
                                    //   HomeController.to.cartType(CartType.healthcare);
                                    //   final data = await HomeController.to.getPosition();
                                    //   globalLogger.d(data);
                                    //   if (data) {
                                    //     // HealthCareController.to
                                    //     //     .confirmOrderStatus(false);
                                    //     // HealthCareController.to
                                    //     //     .syncConfirmOrderStatusToLocal();
                                    //
                                    //     HomeController.to.liveSearchType(LiveSearchType.healthcare);
                                    //     final dataL = await Get.toNamed(LogInCheckLiveMapPage.routeName);
                                    //     if (dataL == null) {
                                    //       HomeController.to.liveSearchType(LiveSearchType.none);
                                    //     }
                                    //   }
                                    // }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class AddRemoveButtons extends StatelessWidget {
  const AddRemoveButtons({
    Key? key,
    required this.addPressed,
    required this.removePressed,
    required this.quantity,
    this.height,
    this.width,
    this.iconSize,
  }) : super(key: key);
  final Function() addPressed, removePressed;
  final String quantity;
  final double? height, width;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 30,
      width: width ?? 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: kPrimaryColor, width: .5),
      ),
      child: Row(
        children: [
          QuantityButton(
            iconSize: iconSize,
            onTap: removePressed,
            iconData: Icons.remove,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: const Color(0xff5FC502),
              child: Center(
                child: TitleText(
                  title: quantity,
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          QuantityButton(
            iconSize: iconSize,
            onTap: addPressed,
            iconData: Icons.add,
          ),
        ],
      ),
    );
  }
}

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    required this.iconData,
    required this.onTap,
    this.iconSize,
    Key? key,
  }) : super(key: key);
  final IconData iconData;
  final double? iconSize;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Icon(
            iconData,
            color: kPrimaryColor,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class DesItem extends StatelessWidget {
  const DesItem({
    required this.label,
    required this.body,
    this.bodyColor,
    Key? key,
  }) : super(key: key);
  final String label, body;
  final Color? bodyColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: TitleText(
              title: label,
              color: const Color(0xff363942).withOpacity(.65),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          TitleText(
            title: ':',
            color: const Color(0xff363942).withOpacity(.65),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          space1R,
          Expanded(
            flex: 5,
            child: TitleText(
              title: body,
              color: bodyColor ?? const Color(0xff363942).withOpacity(.65),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
