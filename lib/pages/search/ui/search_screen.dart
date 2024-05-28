import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/cart/ui/medicine_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/dashboard/ui/top_selling_medicine_section.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static String routeName = '/SearchScreen';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    HealthCareController.to.healthcareSearchList.value = [];
    MedicineController.to.medicineSearchList.value = [];
    super.dispose();
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      if (HomeController.to.searchListType.value == SearchType.healthcare &&
          !HealthCareController.to.searchListLoading.value) {
        print("Healthcare Listener Work");
        HomeController.to.getPaginationSearchList();
        // await HealthCareController.to.getNextSearchList();
      } else if (HomeController.to.searchListType.value == SearchType.medicine &&
          !MedicineController.to.searchListLoading.value) {
        print("Medicine Listener Work");
        HomeController.to.getPaginationSearchList();
        // await HealthCareController.to.getNextSearchList();
      }
      // Provider.of<HomeProvider>(context, listen: false)
      //     .loadMoreProgram(Storage.getUser().id);
    }
  }

  final int item = 1;
  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            isSearchShow: false,
            moduleSearch: ModuleSearch.none,
            hasStyle: false,
            onCartTapped: () {
              if (HomeController.to.searchListType.value == SearchType.healthcare) {
                // Get.toNamed(HealthcareCartScreen.routeName);
                Get.toNamed(HealthcareLiveCartScreen.routeName);
              } else {
                Get.toNamed(MedicineCartScreen.routeName);
              }
            },
          ),
          BgContainer(
            horizontalPadding: 0,
            verticalPadding: 0,
            child: MainContainer(
              horizontalMargin: 0,
              verticalMargin: 0,
              verticalPadding: 0,
              borderColor: kScaffoldColor,
              bottomBorderRadius: 0,
              topBorderRadius: 15,
              color: kScaffoldColor,
              child: HomeController.to.moduleSearchType.value == ModuleSearch.none
                  ? Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Obx(
                            () => PrimaryButton(
                              contentPadding: 0,
                              height: 36,
                              elevation: .5,
                              marginHorizontal: 0,
                              marginVertical: 20,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              labelColor: HomeController.to.searchListType.value == SearchType.healthcare
                                  ? Colors.white
                                  : const Color(0xff363942),
                              primary:
                                  HomeController.to.searchListType.value == SearchType.healthcare ? null : Colors.white,
                              label: 'Healthcare',
                              onPressed: () {
                                HomeController.to.searchListType(SearchType.healthcare);
                              },
                            ),
                          ),
                        ),
                        space5R,
                        Expanded(
                          flex: 1,
                          child: Obx(
                            () => PrimaryButton(
                              contentPadding: 0,
                              elevation: .5,
                              height: 36,
                              marginHorizontal: 0,
                              marginVertical: 0,
                              labelColor: HomeController.to.searchListType.value == SearchType.medicine
                                  ? Colors.white
                                  : const Color(0xff363942),
                              fontSize: 12,
                              primary:
                                  HomeController.to.searchListType.value == SearchType.medicine ? null : Colors.white,
                              fontWeight: FontWeight.w500,
                              label: 'Medicine',
                              onPressed: () {
                                HomeController.to.searchListType(SearchType.medicine);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TitleText(
                        title:
                            'Search ${HomeController.to.moduleSearchType.value == ModuleSearch.healthcare ? 'Healthcare Products' : 'Medicine Products'}',
                        fontSize: 20,
                      ),
                    ),
            ),
          ),
          Expanded(
            child: Obx(
              () => HomeController.to.searchLoading.value
                  ? const Center(
                      child: Waiting(),
                    )
                  : HomeController.to.searchListType.value == SearchType.healthcare
                      ? HealthCareController.to.healthcareSearchList.isNotEmpty
                          ? GridView.builder(
                              controller: controller,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16)
                                  .copyWith(bottom: HealthCareController.to.searchListLoading.value ? 0 : 120),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisExtent: 295,
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                              itemCount: HealthCareController.to.healthcareSearchList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return HealthCareItem(
                                  info: HealthCareController.to.healthcareSearchList[index],
                                  onTap: () {
                                    HealthCareController.to
                                        .getSingleProduct(HealthCareController.to.healthcareSearchList[index].id!);
                                    Get.toNamed(HealthcareProductDetailsScreen.routeName);
                                  },
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Item Found'),
                            )
                      : HomeController.to.searchListType.value == SearchType.medicine &&
                              MedicineController.to.medicineSearchList.isNotEmpty
                          ? GridView.builder(
                              controller: controller,
                              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16)
                                  .copyWith(bottom: MedicineController.to.searchListLoading.value ? 0 : 120),
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                  mainAxisExtent: 250,
                                  maxCrossAxisExtent: 200,
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20),
                              itemCount: MedicineController.to.medicineSearchList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return TopSellingMedicineItem(
                                  info: MedicineController.to.medicineSearchList[index],
                                );
                              },
                            )
                          : const Center(
                              child: Text('No Item Found'),
                            ),
            ),
          ),
          Obx(
            () => (HomeController.to.searchListType.value == SearchType.healthcare &&
                    HealthCareController.to.searchListLoading.value)
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 120.0),
                    child: Waiting(),
                  )
                : const SizedBox(),
          ),
          Obx(
            () => (HomeController.to.searchListType.value == SearchType.medicine &&
                    MedicineController.to.searchListLoading.value)
                ? const Padding(
                    padding: EdgeInsets.only(bottom: 120.0),
                    child: Waiting(),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
