import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/models/medicine_cart_model.dart';
import 'package:shebaone/models/medicine_model.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/medicine/ui/all_medicine_screen.dart';
import 'package:shebaone/pages/product/ui/medicine_product_details_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class TopSellingMedicineSection extends StatelessWidget {
  const TopSellingMedicineSection({
    Key? key,
    this.itemCount,
    this.label,
    this.withSeeAll = true,
  }) : super(key: key);
  final int? itemCount;
  final String? label;
  final bool withSeeAll;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          label: label ?? 'Top Selling Medicine',
          withSeeAll: withSeeAll,
          onTap: () {
            Get.toNamed(AllMedicineScreen.routeName);
          },
        ),
        Obx(
          () => MedicineController.to.loading.value
              ? const Waiting()
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 16),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisExtent: 250,
                      maxCrossAxisExtent: 200,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: itemCount ??
                      (MedicineController.to.getMedicineList.isNotEmpty
                          ? 2
                          : 0),
                  itemBuilder: (BuildContext ctx, index) {
                    return TopSellingMedicineItem(
                      info: MedicineController.to.getMedicineList[index],
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class TopSellingMedicineItem extends StatelessWidget {
  const TopSellingMedicineItem({
    Key? key,
    required this.info,
  }) : super(key: key);
  final MedicineModel info;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        MedicineController.to.getSingleMedicine(info.id!);
        Get.toNamed(MedicineProductDetailsScreen.routeName);
      },
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: const Color(0xffE5E5E5),
                width: .5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: info.images!.isEmpty
                      ? Image.asset(
                          'assets/images/medicine-item.png',
                          fit: BoxFit.fill,
                        )
                      : Image.network(
                          info.images![0].imagePath!,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, exception, stackTrack) =>
                              Image.asset('assets/icons/error.gif'),
                          fit: BoxFit.fill,
                        ),
                ),
                Container(
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
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      TitleText(
                        title:
                            '${double.parse(info.offerPrice!).toStringAsFixed(2)} TK',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      space3R,
                      if (int.parse(info.offerPercentage!) > 0)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: const Color(0xffE31F29),
                          ),
                          child: TitleText(
                            title: '-${info.offerPercentage}%',
                            fontSize: 7,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 8),
                    child: TitleText(
                      title: 'Qty ${info.quantity}',
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xff939393),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                MedicineCartModel cartModel =
                    MedicineCartModel.fromJson(info.toJson());
                // cartModel.id = info.id!;
                // cartModel.name = info.name!;
                // cartModel.offerPrice = info.offerPrice!;
                // cartModel.quantity = info.quantity!;
                // cartModel.images = info.images!;
                cartModel.userQuantity = '1';
                MedicineController.to.addUpdateDeleteCart(cartModel);
              },
              child: Container(
                height: 30,
                width: 40,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(.12),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(3),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/cart-green.png',
                    width: 14,
                    height: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
