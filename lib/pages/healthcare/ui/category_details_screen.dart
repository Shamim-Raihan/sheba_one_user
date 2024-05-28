import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_category_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class CategoryDetailsScreen extends StatefulWidget {
  const CategoryDetailsScreen({Key? key}) : super(key: key);
  static String routeName = '/CategoryDetailsScreen';

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  ScrollController controller = ScrollController();
  Map data = {};
  @override
  void initState() {
    super.initState();
    data = Get.arguments;
    HealthCareController.to.getSingleCategoryProduct(data['id']);
    controller.addListener(_scrollListener);
    print(Get.arguments);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    HealthCareController.to.healthcareCategoryProductList.value = [];
    HealthCareController.to.healthcareFilterList.value = [];
    HealthCareController.to.isApplyFilterInCategoryDetails(false);
    super.dispose();
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    // print(controller.position.pixels);
    // print(controller.position.maxScrollExtent);
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      //.5
      print("Listener Work");
      if (HealthCareController.to.isApplyFilterInCategoryDetails.value) {
        if (!HealthCareController.to.filterAddLoading.value) {
          await HealthCareController.to
              .getFilterProductList(paginateCall: true);
        }
      } else {
        if (!HealthCareController.to.addLoading.value) {
          await HealthCareController.to.getNextProduct();
        }
      }
      // Provider.of<HomeProvider>(context, listen: false)
      //     .loadMoreProgram(Storage.getUser().id);
    }
  }

  bool _isFilterOpen = false;
  final int item = 1;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isFilterOpen = false;
        setState(() {});
      },
      child: ParentPageWithNav(
        child: Column(
          children: [
            const AppBarWithSearch(
              hasStyle: false,
              moduleSearch: ModuleSearch.healthcare,
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
                        horizontalPadding: 12,
                        verticalPadding: 0,
                        color: kScaffoldColor,
                        topBorderRadius: 36,
                        horizontalMargin: 0,
                        borderColor: kScaffoldColor,
                        child: Column(
                          children: [
                            SectionWithViewAll(
                              label: data['name'],
                              iconPath: 'filter',
                              isIconButton: true,
                              buttonColor: kPrimaryColor,
                              horizontalPadding: 0,
                              onTap: () {
                                _isFilterOpen = !_isFilterOpen;
                                setState(() {});
                                // print(Get.previousRoute);
                              },
                            ),
                            Stack(
                              children: [
                                Obx(
                                  () => HealthCareController.to
                                          .isApplyFilterInCategoryDetails.value
                                      ? GridView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 12,
                                          ),
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  mainAxisExtent: 295,
                                                  maxCrossAxisExtent: 200,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20),
                                          itemCount: HealthCareController
                                              .to.healthcareFilterList.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return HealthCareItem(
                                              info: HealthCareController.to
                                                  .healthcareFilterList[index],
                                              onTap: () {
                                                HealthCareController.to
                                                    .getSingleProduct(
                                                        HealthCareController
                                                            .to
                                                            .healthcareFilterList[
                                                                index]
                                                            .id!);
                                                Get.toNamed(
                                                    HealthcareProductDetailsScreen
                                                        .routeName);
                                              },
                                            );
                                          },
                                        )
                                      : GridView.builder(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 12,
                                          ),
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  mainAxisExtent: 295,
                                                  maxCrossAxisExtent: 200,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20),
                                          itemCount: HealthCareController
                                              .to
                                              .healthcareCategoryProductList
                                              .length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return HealthCareItem(
                                              info: HealthCareController.to
                                                      .healthcareCategoryProductList[
                                                  index],
                                              onTap: () {
                                                HealthCareController.to
                                                    .getSingleProduct(
                                                        HealthCareController
                                                            .to
                                                            .healthcareCategoryProductList[
                                                                index]
                                                            .id!);
                                                Get.toNamed(
                                                    HealthcareProductDetailsScreen
                                                        .routeName);
                                              },
                                            );
                                          },
                                        ),
                                ),
                                Obx(
                                  () => HealthCareController
                                              .to.addLoading.value ||
                                          HealthCareController
                                              .to.filterAddLoading.value
                                      ? SizedBox(
                                          height: Get.height * .5,
                                          child: const Waiting(),
                                        )
                                      : HealthCareController
                                              .to
                                              .healthcareCategoryProductList
                                              .isEmpty
                                          ? SizedBox(
                                              height: Get.height * .5,
                                              child: const Center(
                                                child:
                                                    Text('No Product Found!'),
                                              ),
                                            )
                                          : HealthCareController
                                                      .to
                                                      .isApplyFilterInCategoryDetails
                                                      .value &&
                                                  HealthCareController
                                                      .to
                                                      .healthcareFilterList
                                                      .isEmpty
                                              ? SizedBox(
                                                  height: Get.height * .5,
                                                  child: const Center(
                                                    child: Text(
                                                        'No Product Found!'),
                                                  ),
                                                )
                                              : const SizedBox(),
                                ),
                                Obx(
                                  () => SizedBox(
                                    height: ((HealthCareController
                                                            .to
                                                            .healthcareFilterList
                                                            .length <
                                                        5 &&
                                                    HealthCareController
                                                        .to
                                                        .isApplyFilterInCategoryDetails
                                                        .value) ||
                                                HealthCareController
                                                        .to
                                                        .healthcareCategoryProductList
                                                        .length <
                                                    5) &&
                                            _isFilterOpen
                                        ? Get.height * .6
                                        : 0,
                                  ),
                                ),
                                AnimatedPositioned(
                                  right: _isFilterOpen ? 0 : -280,
                                  top: 0,
                                  duration: const Duration(milliseconds: 200),
                                  child: GestureDetector(
                                    onTap: () {
                                      _isFilterOpen = true;
                                      setState(() {});
                                    },
                                    child: FilterBox(
                                      withCategory: false,
                                      withSubCategory: false,
                                      height: Get.height * .6,
                                      from: 'SUB_CATEGORY',
                                      categoryId: data['id'],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Obx(
                              () => HealthCareController.to.addLoading.value &&
                                      HealthCareController
                                          .to
                                          .healthcareCategoryProductList
                                          .isNotEmpty
                                  ? Waiting()
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
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
  const CategorySection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          horizontalPadding: 0,
          label: 'Categories',
          buttonLabel: 'See All',
          labelFontSize: 20,
          onTap: () {
            Get.toNamed(HealthcareCategoryScreen.routeName);
          },
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const ScrollPhysics(),
            itemCount: 10,
            itemBuilder: (BuildContext ctx, index) {
              return const CategoryItem();
            },
          ),
        ),
      ],
    );
  }
}

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 60,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(60),
              color: kPrimaryColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                'assets/images/category.png',
                fit: BoxFit.fill,
              ),
            ),
          ),
          space1C,
          const TitleText(
            title: 'Health Device & Tools ',
            fontSize: 8,
            textOverflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            textAlign: TextAlign.center,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}
