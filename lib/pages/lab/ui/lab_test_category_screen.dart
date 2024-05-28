import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/dashboard_slider.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_category_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/lab_test_category_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';

class LabTestCategoryScreen extends StatelessWidget {
  const LabTestCategoryScreen({Key? key}) : super(key: key);
  static String routeName = '/LabTestCategoryScreen';

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
                  const BgContainer(
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    child: SizedBox(
                      height: 200,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: DashboardSlider(
                          margin: 0,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => GridViewWithLabel(
                      label: 'Check out the Most Popular Tests',
                      isLoading: LabController.to.labTestCategoryLoading.value,
                      itemCount: LabController.to.labTestCategoryList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return ImageWithLabelBodyItem(
                          from: 'LAB-TEST',
                          onTap: () {
                            LabController.to.getLabListCategory(LabController
                                .to.labTestCategoryList[index].id!);
                            Get.toNamed(LabTestCategoryDetailsScreen.routeName,
                                arguments: LabController
                                    .to.labTestCategoryList[index].name!);
                          },
                          label:
                              LabController.to.labTestCategoryList[index].name!,
                          body:
                              'Up to ${LabController.to.labTestCategoryList[index].maxOffer}% Off',
                        );
                      },
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
