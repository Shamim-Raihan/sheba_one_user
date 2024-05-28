import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/models/healthcare_cart_model.dart';
import 'package:shebaone/models/healthcare_product_model.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/healthcare/ui/category_details_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';

class HealthCareSection extends StatelessWidget {
  const HealthCareSection({
    this.label,
    this.buttonLabel,
    this.itemCount,
    this.categoryId,
    this.horizontalHeadingPadding,
    this.horizontalGridPadding,
    this.verticalGridPadding,
    this.isIconButton = false,
    this.buttonColor,
    this.iconPath,
    this.topMargin,
    this.elevation,
    this.labelFontSize,
    this.onFilterPressed,
    this.from,
    this.loadingIndex,
    Key? key,
  }) : super(key: key);
  final String? label;
  final String? buttonLabel;
  final String? iconPath;
  final String? categoryId;
  final int? itemCount;
  final int? loadingIndex;
  final double? horizontalHeadingPadding;
  final double? horizontalGridPadding;
  final double? verticalGridPadding;
  final double? topMargin;
  final double? elevation;
  final double? labelFontSize;
  final Color? buttonColor;
  final bool isIconButton;
  final Function()? onFilterPressed;
  final String? from;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        from == null
            ? Obx(() {
                final con = !(HealthCareController.to.getCategoryWiseData[loadingIndex!]['loading']) &&
                    HealthCareController
                        .to
                        .categoryWiseData[loadingIndex!]
                            [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]!
                        .isNotEmpty;
                return con
                    ? SectionWithViewAll(
                        label: label ?? 'Healthcare Products',
                        buttonLabel: buttonLabel,
                        topMargin: topMargin,
                        elevation: elevation,
                        buttonColor: buttonColor,
                        isIconButton: isIconButton,
                        labelFontSize: labelFontSize,
                        iconPath: iconPath,
                        horizontalPadding: horizontalHeadingPadding,
                        onTap: onFilterPressed ??
                            () {
                              Get.toNamed(CategoryDetailsScreen.routeName, arguments: {
                                'id': HealthCareController.to.healthcareCategoryList[loadingIndex!].id,
                                'name': label,
                              });
                            },
                      )
                    : const SizedBox();
              })
            : SectionWithViewAll(
                label: label ?? 'Healthcare Products',
                buttonLabel: buttonLabel,
                topMargin: topMargin,
                elevation: elevation,
                buttonColor: buttonColor,
                isIconButton: isIconButton,
                labelFontSize: labelFontSize,
                iconPath: iconPath,
                horizontalPadding: horizontalHeadingPadding,
                onTap: onFilterPressed ??
                    () {
                      Get.toNamed(HealthcareScreen.routeName, arguments: label ?? 'Healthcare Products');
                      // Get.toNamed(CategoryDetailsScreen.routeName,
                      //     arguments: label ?? 'Healthcare Products');
                    },
              ),
        from == null
            ? FutureBuilder(
                future: HealthCareController.to.getCategoryProduct(categoryId!, loadingIndex!),
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? Obx(
                          () => (HealthCareController.to.categoryWiseData[loadingIndex!]
                                                  [HealthCareController.to.healthcareCategoryList[loadingIndex!].id] ==
                                              null ||
                                          HealthCareController
                                              .to
                                              .categoryWiseData[loadingIndex!]
                                                  [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]!
                                              .isEmpty
                                      ? 0
                                      : HealthCareController
                                                  .to
                                                  .categoryWiseData[loadingIndex!]
                                                      [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]
                                                  .length >=
                                              4
                                          ? 4
                                          : HealthCareController
                                              .to
                                              .categoryWiseData[loadingIndex!]
                                                  [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]
                                              .length) ==
                                  0
                              ? const SizedBox()
                              : GridView.builder(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: horizontalGridPadding ?? 24.0, vertical: verticalGridPadding ?? 16),
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                      mainAxisExtent: 295,
                                      maxCrossAxisExtent: 200,
                                      crossAxisSpacing: 20,
                                      mainAxisSpacing: 20),
                                  itemCount: HealthCareController.to.categoryWiseData[loadingIndex!]
                                                  [HealthCareController.to.healthcareCategoryList[loadingIndex!].id] ==
                                              null ||
                                          HealthCareController
                                              .to
                                              .categoryWiseData[loadingIndex!]
                                                  [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]!
                                              .isEmpty
                                      ? 0
                                      : HealthCareController
                                                  .to
                                                  .categoryWiseData[loadingIndex!]
                                                      [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]
                                                  .length >=
                                              4
                                          ? 4
                                          : HealthCareController
                                              .to
                                              .categoryWiseData[loadingIndex!]
                                                  [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]
                                              .length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return HealthCareItem(
                                      info: HealthCareController.to.categoryWiseData[loadingIndex!]
                                          [HealthCareController.to.healthcareCategoryList[loadingIndex!].id]![index],
                                      onTap: () {
                                        HealthCareController.to.getSingleProduct(HealthCareController
                                            .to
                                            .categoryWiseData[loadingIndex!][HealthCareController
                                                .to.healthcareCategoryList[loadingIndex!].id]![index]
                                            .id!);
                                        Get.toNamed(HealthcareProductDetailsScreen.routeName);
                                      },
                                    );
                                  },
                                ),
                        )
                      : const Waiting();
                })
            : Obx(
                () => (HealthCareController.to.loading.value && from == 'HOME')
                    ? const Waiting()
                    : GridView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: horizontalGridPadding ?? 24.0, vertical: verticalGridPadding ?? 16),
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            mainAxisExtent: 295, maxCrossAxisExtent: 200, crossAxisSpacing: 20, mainAxisSpacing: 20),
                        itemCount: HealthCareController.to.getHealthcareProductList.isEmpty ? 0 : 6,
                        itemBuilder: (BuildContext ctx, index) {
                          return HealthCareItem(
                            info: HealthCareController.to.getHealthcareProductList[index],
                            onTap: () {
                              HealthCareController.to
                                  .getSingleProduct(HealthCareController.to.getHealthcareProductList[index].id!);
                              Get.toNamed(HealthcareProductDetailsScreen.routeName);
                            },
                          );
                        },
                      ),
              ),
      ],
    );
  }
}

class HealthCareItem extends StatelessWidget {
  const HealthCareItem({
    Key? key,
    required this.info,
    required this.onTap,
  }) : super(key: key);
  final Function() onTap;
  final HealthCareProductModel info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: kPrimaryColor,
                width: .5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: CustomNetworkImage(
                          networkImagePath: info.images!=null && info.images!.isNotEmpty ? info.images![0].imagePath! : '',
                          borderRadius: 2,
                          errorImagePath: 'assets/images/not_found.jpg',
                        ),
                      ),
                      if (info.offerPercentage != '0')
                        Positioned(
                          top: 8,
                          left: 8,
                          child: LessBox(less: info.offerPercentage!),
                        ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      info.name!,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0).copyWith(bottom: 0),
                  child: Row(
                    children: [
                      TitleText(
                        title: '৳ ${info.offerPrice}',
                        fontSize: 14,
                      ),
                      if (info.offerPercentage != '0') space1R,
                      if (info.offerPercentage != '0')
                        TitleText(
                          title: '৳ ${info.mrp}',
                          fontSize: 10,
                          textDecoration: TextDecoration.lineThrough,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff939393),
                        ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8),
                    child: TitleText(
                      title: 'Qty ${info.quantity}',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff939393),
                    ),
                  ),
                ),
                PrimaryButton(
                  height: 30,
                  label: int.parse(info.quantity!) > 0 ? 'Add To Card' : 'Add to Cart for Search',
                  fontSize: 11,
                  contentPadding: 0,
                  marginVertical: 0,
                  borderRadiusAll: 4,
                  marginHorizontal: 8.0,
                  onPressed: () async {
                    if (int.parse(info.quantity!) > 0) {
                      print('Add to cart');

                      HealthCareCartModel cartModel = HealthCareCartModel.fromJson(info.toJson());
                      cartModel.userQuantity = '1';
                      print('ok');
                      HealthCareController.to.addUpdateDeleteCart(cartModel);
                    } else {
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
                      //     HealthCareController.to.getSingleProduct(info.id!);
                      //     // HealthCareController.to.confirmOrderStatus(false);
                      //     // HealthCareController.to
                      //     //     .syncConfirmOrderStatusToLocal();
                      //
                      //     HomeController.to
                      //         .liveSearchType(LiveSearchType.healthcare);
                      //     final dataL = await Get.toNamed(
                      //         LogInCheckLiveMapPage.routeName);
                      //     if (dataL == null) {
                      //       HomeController.to
                      //           .liveSearchType(LiveSearchType.none);
                      //     }
                      //   }
                      // }
                      print('Add to cart');

                      HealthCareCartModel cartModel = HealthCareCartModel.fromJson(info.toJson());
                      cartModel.userQuantity = '1';
                      print('ok');
                      HealthCareController.to.addUpdateDeleteLiveCart(cartModel);
                    }
                  },
                ),
              ],
            ),
          ),
          // if (int.parse(info.quantity!) > 0)
          //   Positioned(
          //     bottom: 0,
          //     right: 0,
          //     child: GestureDetector(
          //       onTap: () {
          //         print('Add to cart');
          //
          //         HealthCareCartModel cartModel = HealthCareCartModel();
          //         cartModel.id = info.id!;
          //         cartModel.name = info.name!;
          //         cartModel.offerPrice = info.offerPrice!;
          //         cartModel.quantity = info.quantity!;
          //         cartModel.images = info.images!;
          //         cartModel.userQuantity = '1';
          //         print('ok');
          //         HealthCareController.to.addUpdateDeleteCart(cartModel);
          //       },
          //       child: Container(
          //         height: 30,
          //         width: 40,
          //         decoration: BoxDecoration(
          //           color: kPrimaryColor.withOpacity(.12),
          //           borderRadius: const BorderRadius.only(
          //             topLeft: Radius.circular(3),
          //             bottomRight: Radius.circular(6),
          //           ),
          //         ),
          //         child: Center(
          //           child: Image.asset(
          //             'assets/icons/cart-green.png',
          //             width: 14,
          //             height: 14,
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}

class LessBox extends StatelessWidget {
  const LessBox({
    required this.less,
    Key? key,
  }) : super(key: key);
  final String less;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 5),
      height: 20,
      width: 60,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/discount-bg.png'),
        ),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: TitleText(
          title: '$less% Off',
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: Colors.white,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
