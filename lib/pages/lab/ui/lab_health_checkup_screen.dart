import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class LabHealthCheckupScreen extends StatelessWidget {
  const LabHealthCheckupScreen({Key? key}) : super(key: key);
  static String routeName = '/LabHealthCheckupScreen';

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
                          const SectionWithViewAll(
                            label: 'Popular Health checkup packages',
                            withSeeAll: false,
                            horizontalPadding: 0,
                          ),
                          Obx(
                            () => LabController.to.labTestLoading.value
                                ? const Waiting()
                                : GridView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 16),
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            mainAxisExtent: 200,
                                            maxCrossAxisExtent: 200,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8),
                                    itemCount: popularList.length,
                                    itemBuilder: (_, index) {
                                      return CheckupItem(
                                        marginAll: 0,
                                        info: popularList[index],
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
