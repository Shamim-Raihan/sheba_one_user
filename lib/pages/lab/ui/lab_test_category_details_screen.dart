import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/models/lab_model.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/single_test_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class LabTestCategoryDetailsScreen extends StatelessWidget {
  const LabTestCategoryDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/LabTestCategoryDetailsScreen';

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
                      horizontalPadding: 16,
                      verticalPadding: 0,
                      color: kScaffoldColor,
                      topBorderRadius: 36,
                      horizontalMargin: 0,
                      borderColor: kScaffoldColor,
                      child: Column(
                        children: [
                          SectionWithViewAll(
                            label: Get.arguments,
                            withSeeAll: false,
                            horizontalPadding: 0,
                          ),
                          Obx(
                            () => LabController.to.labTestLoading.value
                                ? const Waiting()
                                : ListView.builder(
                                    itemCount:
                                        LabController.to.labTestList.length,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      return LabTestItem(
                                        onTap: () {
                                          LabController.to.singleLabTest(
                                              LabController
                                                  .to.labTestList[index]);
                                          LabController.to.getFilterLabData(
                                              LabController
                                                  .to.labTestList[index].id!);
                                          Get.toNamed(SingleTestDetailsScreen
                                              .routeName);
                                        },
                                        info:
                                            LabController.to.labTestList[index],
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 110,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class LabTestItem extends StatelessWidget {
  const LabTestItem({
    this.onTap,
    required this.info,
    Key? key,
  }) : super(key: key);
  final Function()? onTap;
  final LabTestModel info;

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
                        TitleText(
                          title: info.testName!,
                          fontSize: 14,
                        ),
                        space2C,
                        TitleText(
                          title: info.about!,
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
