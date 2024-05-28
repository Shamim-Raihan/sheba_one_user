import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/models/medicine_cart_model.dart';
import 'package:shebaone/pages/live_search/ui/check_login_map_page.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class MedicineCartScreen extends StatefulWidget {
  const MedicineCartScreen({Key? key}) : super(key: key);
  static String routeName = '/MedicineCartScreen';

  @override
  State<MedicineCartScreen> createState() => _MedicineCartScreenState();
}

class _MedicineCartScreenState extends State<MedicineCartScreen> {
  TextEditingController? _referController;
  @override
  void initState() {
    // TODO: implement initState
    _referController = TextEditingController();

    MedicineController.to.syncMedicineCartData();
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
              MedicineController.to.deleteAllCart();
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
              () => MedicineController.to.getMedicineCartList.isNotEmpty
                  ? ListView.builder(
                      padding: const EdgeInsets.only(bottom: 160),
                      itemCount: MedicineController.to.getMedicineCartList.length,
                      itemBuilder: (_, index) {
                        return CartCard(
                          info: MedicineController.to.getMedicineCartList[index],
                          isLast: index == MedicineController.to.getMedicineCartList.length - 1,
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
            () => MedicineController.to.getMedicineCartList.isNotEmpty
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
                                      title: '৳ ${MedicineController.to.getCartTotalPrice}',
                                      fontSize: 20,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          space4C,
                          PrimaryButton(
                            label: 'Search Medicines from near by pharmacies',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            marginHorizontal: 24,
                            marginVertical: 0,
                            height: 50,
                            onPressed: () async {
                              MedicineController.to.refferCode(_referController!.text);
                              HomeController.to.cartType(CartType.none);

                              if (HealthCareController.to.confirmOrderStatus.value ||
                                  MedicineController.to.confirmOrderStatus.value) {
                                Fluttertoast.showToast(
                                    msg: "Already You have one live search running!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.redAccent,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              } else {
                                MedicineController.to.refferCode(_referController!.text);

                                globalLogger.d(HealthCareController.to.confirmOrderStatus.value ||
                                    MedicineController.to.confirmOrderStatus.value);
                                final data = await HomeController.to.getPosition();
                                globalLogger.d(data);
                                if (data) {
                                  // MedicineController.to
                                  //     .confirmOrderStatus(false);
                                  // MedicineController.to
                                  //     .syncConfirmOrderStatusToLocal();
                                  HomeController.to.liveSearchType(LiveSearchType.medicine);
                                  final dataL = await Get.toNamed(LogInCheckLiveMapPage.routeName);
                                  if (dataL == null) {
                                    HomeController.to.liveSearchType(LiveSearchType.none);
                                  }
                                }
                              }
                              // location =
                              //     'Lat: ${position.latitude} , Long: ${position.longitude}';
                              // globalLogger.d(location);
                              // getAddressFromLatLong(position);
                              // getLoadingDialog();
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
  final MedicineCartModel info;

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
          child: Row(
            children: [
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: kPrimaryColor.withOpacity(.04),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: info.images!.isEmpty
                      ? Image.asset(
                          'assets/images/medicine-item.png',
                          width: 100,
                        )
                      : CustomNetworkImage(
                          networkImagePath: info.images![0].imagePath!,
                          height: 100,
                          width: 100,
                        ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              debugPrint('Delete');
                              MedicineController.to.addUpdateDeleteCart(info, isDeleting: true);
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TitleText(
                              title: info.name!,
                              maxLines: 2,
                              color: const Color(0xff3c3c3c),
                              textOverflow: TextOverflow.ellipsis,
                              fontSize: 16,
                            ),
                            TitleText(
                              title: '৳ ${double.parse(info.offerPrice!).toStringAsFixed(2)}',
                              fontSize: 16,
                            ),
                          ],
                        ),
                        space2C,
                        Align(
                          alignment: Alignment.topRight,
                          child: AddRemoveButtons(
                            height: 20,
                            width: 75,
                            iconSize: 16,
                            addPressed: () {
                              MedicineController.to.addUpdateDeleteCart(info);
                            },
                            quantity: info.userQuantity!,
                            removePressed: () {
                              MedicineController.to.addUpdateDeleteCart(info, isReducing: true);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
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
