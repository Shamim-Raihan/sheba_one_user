import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/models/lab_cart_model.dart';
import 'package:shebaone/models/lab_model.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_profile_screen.dart';
import 'package:shebaone/pages/home/home_page.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/url_utils.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class SingleTestDetailsScreen extends StatefulWidget {
  const SingleTestDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/SingleTestDetailsScreen';

  @override
  State<SingleTestDetailsScreen> createState() => _SingleTestDetailsScreenState();
}

class _SingleTestDetailsScreenState extends State<SingleTestDetailsScreen> {
  int _activeIndex = -1;
  LabModel _labModel = LabModel();
  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasBackArrow: true,
            moduleSearch: ModuleSearch.lab,
            onCartTapped: () {
              Get.toNamed(LabCartScreen.routeName);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BgContainer(
                    imagePath: 'dashboard-bg',
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    child: MainContainer(
                      horizontalPadding: 0,
                      verticalPadding: 0,
                      color: kScaffoldColor,
                      borderColor: const Color(0xff5FC502),
                      borderWidth: 1,
                      borderRadius: 15,
                      withBoxShadow: true,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 24,
                            top: 0,
                            child: Image.asset(
                              'assets/images/style-bg.png',
                              width: Get.width * .6,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 24),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      TitleText(
                                        title: LabController.to.singleLabTest.value.testName!,
                                        fontSize: 16,
                                      ),
                                      const SizedBox(
                                        width: 120,
                                        child: HorizontalDivider(
                                          color: Color(0xff4A8B5C),
                                          height: 3,
                                          thickness: .5,
                                        ),
                                      ),
                                      space3C,
                                      Row(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/reward-green.png',
                                                width: 10,
                                              ),
                                              space2R,
                                              TitleText(
                                                title: 'Certified Lab',
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: kTextColor,
                                              ),
                                            ],
                                          ),
                                          const Spacer(),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle,
                                                color: kPrimaryColor,
                                                size: 13,
                                              ),
                                              space2R,
                                              TitleText(
                                                title: 'E-Reports in 2 days',
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                                color: kTextColor,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      space6C,
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const TitleText(
                                            title: 'Choose a Lab',
                                            fontSize: 14,
                                          ),
                                          Row(
                                            children: [
                                              DirectionItem(
                                                label: 'Empty',
                                                fillColor: Colors.white,
                                                borderColor: kPrimaryColor,
                                              ),
                                              space2R,
                                              DirectionItem(
                                                label: 'Select Lab',
                                                fillColor: kPrimaryColor,
                                                borderColor: Colors.white,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                HorizontalDivider(
                                  color: kPrimaryColor,
                                  thickness: .5,
                                ),
                                Obx(
                                  () => LabController.to.labLoadingForSingleLabTest.value
                                      ? const Waiting()
                                      : LabController.to.labListForSingleLab.isNotEmpty
                                          ? SizedBox(
                                              height: 80,
                                              child: ListView.builder(
                                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: LabController.to.labListForSingleLab.length,
                                                itemBuilder: (_, index) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      _activeIndex = index;
                                                      _labModel = LabController.to.labListForSingleLab[index];
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      width: 120,
                                                      margin: const EdgeInsets.all(4),
                                                      // padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                      decoration: BoxDecoration(
                                                        color: _activeIndex == index ? kPrimaryColor : Colors.white,
                                                        borderRadius: BorderRadius.circular(2),
                                                        border: Border.all(
                                                          color: kPrimaryColor,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Column(
                                                        mainAxisAlignment: _activeIndex == index
                                                            ? MainAxisAlignment.center
                                                            : MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets.symmetric(
                                                                      horizontal: 8.0, vertical: 2.5),
                                                                  child: Text(
                                                                    LabController
                                                                        .to.labListForSingleLab[index].labName!,
                                                                    style: TextStyle(
                                                                      color: _activeIndex == index
                                                                          ? Colors.white
                                                                          : kPrimaryColor,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                    maxLines: 2,
                                                                    overflow: TextOverflow.ellipsis,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          if (!(_activeIndex == index))
                                                            Container(
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 8, vertical: 2),
                                                              decoration: BoxDecoration(
                                                                color: _activeIndex == index
                                                                    ? Colors.white
                                                                    : kPrimaryColor,
                                                                borderRadius: const BorderRadius.vertical(
                                                                  bottom: Radius.circular(1),
                                                                ),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  TitleText(
                                                                    title: 'Select Now +',
                                                                    fontSize: 12,
                                                                    color: _activeIndex == index
                                                                        ? kPrimaryColor
                                                                        : Colors.white,
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                                              child: Text(
                                                'Our partner labs are not offering this test in your area, we are unable to book this test for you. You may try other test.',
                                                style: TextStyle(
                                                    fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                ),
                                HorizontalDivider(
                                  color: kPrimaryColor,
                                  thickness: .5,
                                ),
                                ExpandableItem(
                                  label: 'What is this Test?',
                                  childHorizontalPadding: 0,
                                  parentHorizontalPadding: 0,
                                  labelFontWeight: FontWeight.w500,
                                  labelColor: kTextColor,
                                  child: TitleText(
                                    title: LabController.to.singleLabTest.value.about!,
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                ExpandableItem(
                                  label: 'Test Preparation',
                                  parentHorizontalPadding: 0,
                                  childHorizontalPadding: 0,
                                  labelFontWeight: FontWeight.w500,
                                  labelColor: kTextColor,
                                  child: TitleText(
                                    title: LabController.to.singleLabTest.value.preparation!,
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                ExpandableItem(
                                  label: 'Understanding your test results',
                                  childHorizontalPadding: 0,
                                  parentHorizontalPadding: 0,
                                  labelFontWeight: FontWeight.w500,
                                  labelColor: kTextColor,
                                  child: TitleText(
                                    title: LabController.to.singleLabTest.value.result!,
                                    color: Colors.black87,
                                    fontSize: 10,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                space4C,
                                PrimaryButton(
                                  label: 'Add To Cart',
                                  marginVertical: 0,
                                  marginHorizontal: 0,
                                  width: Get.width * .6,
                                  onPressed: () {
                                    ///TODO: ADD TO CART IMPLEMENT
                                    if (LabController.to.labListForSingleLab.isEmpty) {
                                      Fluttertoast.showToast(
                                        msg: "Unavailable lab for this test!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else if (_activeIndex < 0) {
                                      Fluttertoast.showToast(
                                        msg: "You haven't select any lab for this test!\nPlease Select one!",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    } else {
                                      LabCartModel cartModel =
                                          LabCartModel.fromJson(LabController.to.singleLabTest.value.toJson());
                                      cartModel.labId = _labModel.id;
                                      cartModel.labName = _labModel.labName;
                                      cartModel.labPrice = _labModel.fees!.isEmpty ? '0' : _labModel.fees;
                                      LabController.to.addUpdateDeleteCart(cartModel);
                                      // LabController.to.deleteAllCart();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  MainContainer(
                    horizontalMargin: 0,
                    topBorderRadius: 25,
                    borderColor: Colors.white,
                    verticalPadding: 0,
                    horizontalPadding: 0,
                    color: kScaffoldColor,
                    child: Column(
                      children: [
                        space8C,
                        Container(
                          padding: const EdgeInsets.all(24),
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            color: const Color(0xffEDF3EF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xff5FC502),
                            ),
                          ),
                          child: Column(
                            children: [
                              const TitleText(
                                title: 'Need help with booking your test?',
                                color: Color(0xff343C44),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              HorizontalDivider(
                                color: kPrimaryColor,
                                thickness: 1,
                                horizontalMargin: Get.width * .2,
                              ),
                              space2C,
                              const TitleText(
                                title: 'Our experts are here to help you',
                                color: Color(0xff343C44),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              space4C,
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                onPressed: () {
                                  Utils.makePhoneCall('tel:+8801745698404');
                                },
                                child: Text.rich(
                                  TextSpan(
                                    children: [
                                      const WidgetSpan(
                                        child: Icon(Icons.call),
                                      ),
                                      WidgetSpan(
                                        child: space2R,
                                      ),
                                      const TextSpan(text: 'Call On Hotline Number')
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4).copyWith(top: 24),
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
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          child: Column(
                            children: [
                              const RowItem(
                                label: 'Get digital report within 2 days',
                                body: 'Our labs ensure turn-around-time of 48 hours from specimen pickup',
                              ),
                              space2C,
                              const RowItem(
                                imagePath: 'percent',
                                label: 'Offers and affordable prices',
                                body: 'Get great discounts and offers on tests and packages.',
                              ),
                            ],
                          ),
                        ),
                        space1hC,
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 110,
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  const RowItem({
    required this.label,
    required this.body,
    this.imagePath,
    Key? key,
  }) : super(key: key);
  final String label;
  final String body;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 3,
              ),
            ],
          ),
          child: Center(
            child: Image.asset(
              'assets/icons/${imagePath ?? 'report'}.png',
              height: 30,
            ),
          ),
        ),
        space3R,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: label,
                fontSize: 12,
              ),
              TitleText(
                title: body,
                fontSize: 10,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LabTestItem extends StatelessWidget {
  const LabTestItem({
    this.onTap,
    Key? key,
  }) : super(key: key);
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TitleText(
                          title: 'Blood for ADA',
                          fontSize: 14,
                        ),
                        space2C,
                        const TitleText(
                          title:
                              'Adenosine deaminase (ADA) is a protein that is produced by cells throughout the body and the body and',
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  space3R,
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: kPrimaryColor,
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: Image.asset(
                'assets/images/style-bg-medium.png',
                width: 50,
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Image.asset(
                'assets/images/style-bg.png',
                width: 97,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
