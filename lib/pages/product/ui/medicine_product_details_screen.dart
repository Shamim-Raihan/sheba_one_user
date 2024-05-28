import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/models/medicine_cart_model.dart';
import 'package:shebaone/pages/cart/ui/medicine_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';

class MedicineProductDetailsScreen extends StatefulWidget {
  const MedicineProductDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/MedicineProductDetailsScreen';

  @override
  State<MedicineProductDetailsScreen> createState() =>
      _MedicineProductDetailsScreenState();
}

class _MedicineProductDetailsScreenState
    extends State<MedicineProductDetailsScreen> {
  int _quantity = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        title: Container(
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
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
                Get.toNamed(MedicineCartScreen.routeName);
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
        () => MedicineController.to.productLoading.value
            ? SizedBox(
                height: Get.height * .5,
                child: const Waiting(),
              )
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
                              border:
                                  Border.all(color: kPrimaryColor, width: 1),
                            ),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 8,
                            ),
                            height: 230,
                            width: Get.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: MedicineController
                                      .to.getSingleMedicineInfo.images!.isEmpty
                                  ? Image.asset(
                                      'assets/images/medicine-item.png',
                                      fit: BoxFit.fill,
                                    )
                                  : CustomNetworkImage(
                                      networkImagePath: MedicineController
                                          .to
                                          .getSingleMedicineInfo
                                          .images![0]
                                          .imagePath!,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24.0,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TitleText(
                                    title: MedicineController
                                        .to.getSingleMedicineInfo.name!,
                                    maxLines: 2,
                                    textOverflow: TextOverflow.ellipsis,
                                    fontSize: 20,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 8.0, left: 8.0),
                                  child: Text.rich(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
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
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 16,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    DesRow(
                                      label: 'SKU',
                                      info: MedicineController
                                          .to.getSingleMedicineInfo.id!,
                                    ),
                                    DesRow(
                                      label: 'Generic',
                                      info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .generic ==
                                              null
                                          ? '-'
                                          : MedicineController
                                              .to
                                              .getSingleMedicineInfo
                                              .generic!
                                              .name!,
                                    ),
                                    DesRow(
                                      label: 'Strength',
                                      info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .strength ==
                                              null
                                          ? '-'
                                          : MedicineController
                                              .to
                                              .getSingleMedicineInfo
                                              .strength!
                                              .name!,
                                    ),
                                  ],
                                ),
                                space2C,
                                Text.rich(
                                  TextSpan(
                                    text: 'Manufacturer: ',
                                    children: [
                                      TextSpan(
                                        text:
                                            ' ${MedicineController.to.getSingleMedicineInfo.company == null ? '-' : MedicineController.to.getSingleMedicineInfo.company!.name!}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff363942),
                                  ),
                                ),
                                space2C,
                                const TitleText(
                                  title: 'Specification',
                                  textOverflow: TextOverflow.ellipsis,
                                  fontSize: 12,
                                  color: Color(0xff363942),
                                ),
                                space2C,
                                Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor.withOpacity(.04),
                                          borderRadius:
                                              const BorderRadius.horizontal(
                                            left: Radius.circular(8),
                                          ),
                                        ),
                                        width: 110,
                                        height: 120,
                                      ),
                                    ),
                                    Container(
                                      height: 120,
                                      padding: const EdgeInsets.symmetric(
                                              vertical: 8)
                                          .copyWith(
                                        left: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: kPrimaryColor.withOpacity(.04),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            SpecificationInfoItem(
                                              label: 'Pack Size',
                                              info: MedicineController
                                                          .to
                                                          .getSingleMedicineInfo
                                                          .packsizes ==
                                                      null
                                                  ? '-'
                                                  : MedicineController
                                                      .to
                                                      .getSingleMedicineInfo
                                                      .packsizes!
                                                      .name!,
                                            ),
                                            SpecificationInfoItem(
                                              label: 'Unit Count',
                                              info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .unitCount!,
                                            ),
                                            SpecificationInfoItem(
                                              label: 'Ingredients',
                                              info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .ingredients!,
                                            ),
                                            SpecificationInfoItem(
                                              label: 'Contradictions',
                                              info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .contradictions!,
                                            ),
                                            SpecificationInfoItem(
                                              label: 'Side Effects',
                                              info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .sideEffects!,
                                            ),
                                            SpecificationInfoItem(
                                              label: 'Precautions & warnings',
                                              info: MedicineController
                                                  .to
                                                  .getSingleMedicineInfo
                                                  .precautions!,
                                            ),
                                            const SpecificationInfoItem(
                                              label: 'Storage & disposal',
                                              info: '-',
                                              withHorizontalBar: false,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24.0, vertical: 8),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Row(
                                children: [
                                  Text(
                                      'Available Qty: ${MedicineController.to.getSingleMedicineInfo.quantity}'),
                                ],
                              ),
                            ),
                          ),
                          TitleText(
                            title: 'Buy this from your nearest pharmacies',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff363942).withOpacity(.65),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 24.0),
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: TitleText(
                                      title:
                                          '৳ ${double.parse(MedicineController.to.getSingleMedicineInfo.offerPrice!).toStringAsFixed(2)}',
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                if (int.parse(MedicineController
                                        .to
                                        .getSingleMedicineInfo
                                        .offerPercentage!) >
                                    0)
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TitleText(
                                        title:
                                            '৳ ${double.parse(MedicineController.to.getSingleMedicineInfo.mrp!).toStringAsFixed(2)}',
                                        fontSize: 14,
                                        color: const Color(0xff939393),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      space1R,
                                      LessBox(
                                          less: MedicineController
                                              .to
                                              .getSingleMedicineInfo
                                              .offerPercentage!),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                          space2R,
                          Expanded(
                            flex: 5,
                            child: PrimaryButton(
                              label: 'Add to Cart for Search',
                              marginHorizontal: 24,
                              marginVertical: 0,
                              height: 50,
                              onPressed: () {
                                MedicineCartModel cart = MedicineCartModel();
                                cart.id = MedicineController
                                    .to.getSingleMedicineInfo.id;
                                cart.name = MedicineController
                                    .to.getSingleMedicineInfo.name;
                                cart.quantity = MedicineController
                                    .to.getSingleMedicineInfo.quantity;
                                cart.offerPrice = MedicineController
                                    .to.getSingleMedicineInfo.offerPrice;
                                cart.images = MedicineController
                                    .to.getSingleMedicineInfo.images;
                                cart.userQuantity = _quantity.toString();
                                MedicineController.to.addUpdateDeleteCart(cart,
                                    quantity: _quantity);
                              },
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

class SpecificationInfoItem extends StatelessWidget {
  const SpecificationInfoItem({
    Key? key,
    required this.label,
    required this.info,
    this.withHorizontalBar = true,
  }) : super(key: key);
  final String label, info;
  final bool withHorizontalBar;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 102,
          child: TitleText(
            title: label,
            fontSize: 8,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ),
                child: TitleText(
                  title: info,
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xff363942),
                ),
              ),
              if (withHorizontalBar)
                HorizontalDivider(
                  color: kPrimaryColor.withOpacity(.5),
                  thickness: .3,
                  height: 2.8,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class DesRow extends StatelessWidget {
  const DesRow({
    Key? key,
    required this.label,
    required this.info,
  }) : super(key: key);
  final String label, info;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          TitleText(
            title: label,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xff363942).withOpacity(.65),
          ),
          TitleText(
            title: info,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xff363942),
          ),
        ],
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
    Key? key,
  }) : super(key: key);
  final String label, body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
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
              color: const Color(0xff363942).withOpacity(.65),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
