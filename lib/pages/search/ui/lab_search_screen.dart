import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/lab/ui/lab_test_category_details_screen.dart'
    as LI;
import 'package:shebaone/pages/lab/ui/single_test_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class LabSearchScreen extends StatefulWidget {
  const LabSearchScreen({Key? key}) : super(key: key);
  static String routeName = '/LabSearchScreen';

  @override
  State<LabSearchScreen> createState() => _LabSearchScreenState();
}

class _LabSearchScreenState extends State<LabSearchScreen> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    LabController.to.labSearchList.value = [];
    super.dispose();
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      if (!LabController.to.searchListLoading.value) {
        print("Healthcare Listener Work");
        LabController.to.getSearchList('', paginateCall: true);
      }
      // Provider.of<HomeProvider>(context, listen: false)
      //     .loadMoreProgram(Storage.getUser().id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasBackArrow: true,
            moduleSearch: ModuleSearch.lab,
            isSearchShow: false,
            onCartTapped: () {
              Get.toNamed(LabCartScreen.routeName);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
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
                            label: 'Lab Search Results',
                            withSeeAll: false,
                            horizontalPadding: 0,
                          ),
                          Obx(
                            () => LabController.to.searchLoading.value
                                ? const Waiting()
                                : ListView.builder(
                                    itemCount:
                                        LabController.to.labSearchList.length,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder: (_, index) {
                                      return LI.LabTestItem(
                                        onTap: () {
                                          LabController.to.singleLabTest(
                                              LabController
                                                  .to.labSearchList[index]);
                                          LabController.to.getFilterLabData(
                                              LabController
                                                  .to.labSearchList[index].id!);
                                          Get.toNamed(SingleTestDetailsScreen
                                              .routeName);
                                        },
                                        info: LabController
                                            .to.labSearchList[index],
                                      );
                                    },
                                  ),
                          ),
                          Obx(
                            () => LabController.to.searchListLoading.value
                                ? const Waiting()
                                : const SizedBox(),
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
