import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/models/healthcare_category_model.dart';
import 'package:shebaone/pages/dashboard/ui/healthcare_section.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/healthcare/ui/category_details_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_category_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/service_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class HealthcareScreen extends StatefulWidget {
  const HealthcareScreen({Key? key}) : super(key: key);
  static String routeName = '/HealthcareScreen';

  @override
  State<HealthcareScreen> createState() => _HealthcareScreenState();
}

class _HealthcareScreenState extends State<HealthcareScreen> {
  bool _isFilterOpen = false;
  bool _isApplyFilter = false;
  @override
  void initState() {
    // TODO: implement initState
    HealthCareController.to.isApplyFilter(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            if (_isFilterOpen) {
              _isFilterOpen = false;
              setState(() {});
            }
          },
          child: ParentPageWithNav(
            // floatingActionButton: Obx(
            //   () => HealthCareController.to.getHealthcareLiveCartList.isNotEmpty
            //       ? Padding(
            //           padding: const EdgeInsets.only(bottom: 80),
            //           child: FloatingActionButton(
            //             tooltip: 'Healthcare Live Cart',
            //             onPressed: () {
            //               Get.toNamed(HealthcareLiveCartScreen.routeName);
            //             },
            //             child: Image.asset(
            //               'assets/icons/cart-green.png',
            //               color: Colors.white,
            //             ),
            //           ),
            //         )
            //       : const SizedBox(),
            // ),
            // floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
            child: Column(
              children: [
                const AppBarWithSearch(
                  hasStyle: false,
                  moduleSearch: ModuleSearch.healthcare,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const BgContainer(
                          imagePath: 'service-bg',
                          horizontalPadding: 0,
                          verticalPadding: 0,
                          child: MainContainerWithTitle(
                            horizontalPadding: 12,
                            verticalPadding: 0,
                            firstText: 'Get most popular & reliable',
                            secondText: 'Healthcare Products Now',
                            child: CategorySection(),
                          ),
                        ),
                        SectionWithViewAll(
                          label: 'Healthcare Products',
                          topMargin: 0,
                          buttonColor: kPrimaryColor,
                          elevation: 3,
                          iconPath: 'filter',
                          isIconButton: true,
                          labelFontSize: 20,
                          onTap: () {
                            _isFilterOpen = !_isFilterOpen;
                            setState(() {});
                          },
                        ),
                        Stack(
                          children: [
                            Obx(
                              () => HealthCareController.to.categoryLoading.value
                                  ? const Waiting()
                                  : HealthCareController.to.isApplyFilter.value
                                      ? ListView.builder(
                                          shrinkWrap: true,
                                          itemCount:
                                              HealthCareController.to.categoryCheckList.where((i) => i).toList().length,
                                          physics: const ScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (_, index) {
                                            List _list = [];
                                            List _indexList = [];

                                            for (int k = 0;
                                                k < HealthCareController.to.healthcareCategoryList.length;
                                                k++) {
                                              if (HealthCareController.to.categoryCheckList[k]) {
                                                _list.add(HealthCareController.to.healthcareCategoryList[k]);
                                                _indexList.add(k);
                                              }
                                            }
                                            // for(int k=0; k<HealthCareController
                                            //     .to.categoryCheckList
                                            //     .where((i) => i)
                                            //     .toList()
                                            //     .length; k++){
                                            //
                                            // }
                                            return HealthCareSection(
                                              loadingIndex: _indexList[index],
                                              categoryId: _list[index].id,
                                              label: _list[index].name,
                                              buttonLabel: 'See All',
                                              itemCount: HealthCareController.to.categoryWiseData[index][
                                                              HealthCareController
                                                                  .to.healthcareCategoryList[index].id] ==
                                                          null ||
                                                      HealthCareController
                                                          .to
                                                          .categoryWiseData[index][
                                                              HealthCareController.to.healthcareCategoryList[index].id]!
                                                          .isEmpty
                                                  ? 0
                                                  : HealthCareController
                                                              .to
                                                              .categoryWiseData[index][HealthCareController
                                                                  .to.healthcareCategoryList[index].id]
                                                              .length >=
                                                          4
                                                      ? 4
                                                      : HealthCareController
                                                          .to
                                                          .categoryWiseData[index]
                                                              [HealthCareController.to.healthcareCategoryList[index].id]
                                                          .length,
                                            );
                                          },
                                        )
                                      : ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: HealthCareController.to.healthcareCategoryList.length,
                                          physics: const ScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (_, index) {
                                            return HealthCareSection(
                                              loadingIndex: index,
                                              categoryId: HealthCareController.to.healthcareCategoryList[index].id,
                                              label: HealthCareController.to.healthcareCategoryList[index].name,
                                              buttonLabel: 'See All',
                                              itemCount: HealthCareController.to.categoryWiseData[index][
                                                              HealthCareController
                                                                  .to.healthcareCategoryList[index].id] ==
                                                          null ||
                                                      HealthCareController
                                                          .to
                                                          .categoryWiseData[index][
                                                              HealthCareController.to.healthcareCategoryList[index].id]!
                                                          .isEmpty
                                                  ? 0
                                                  : HealthCareController
                                                              .to
                                                              .categoryWiseData[index][HealthCareController
                                                                  .to.healthcareCategoryList[index].id]
                                                              .length >=
                                                          4
                                                      ? 4
                                                      : HealthCareController
                                                          .to
                                                          .categoryWiseData[index]
                                                              [HealthCareController.to.healthcareCategoryList[index].id]
                                                          .length,
                                            );
                                          },
                                        ),
                            ),
                            Obx(
                              () => SizedBox(
                                height: HealthCareController.to.isApplyFilter.value &&
                                        HealthCareController.to.categoryCheckList.where((i) => i).toList().length < 4 &&
                                        _isFilterOpen
                                    ? Get.height * .6
                                    : 0,
                              ),
                            ),
                            AnimatedPositioned(
                              right: _isFilterOpen ? 16 : -280,
                              top: 0,
                              duration: const Duration(milliseconds: 200),
                              child: GestureDetector(
                                onTap: () {
                                  if (!_isFilterOpen) {
                                    _isFilterOpen = true;
                                    setState(() {});
                                  }
                                },
                                child: const FilterBox(
                                  from: 'CATEGORY',
                                ),
                              ),
                            ),
                          ],
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
        ),
        // Positioned(
        //   bottom: 100,
        //   child: Obx(
        //     () => HealthCareController.to.getHealthcareLiveCartList.isNotEmpty
        //         ? GestureDetector(
        //             onTap: () {
        //               Get.toNamed(HealthcareLiveCartScreen.routeName);
        //             },
        //             child: Container(
        //               padding: const EdgeInsets.all(8),
        //               decoration: const BoxDecoration(
        //                   color: Color(0xff5FC502), borderRadius: BorderRadius.horizontal(right: Radius.circular(50))),
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     children: [
        //                       space2R,
        //                       Image.asset(
        //                         'assets/icons/cart-green.png',
        //                         color: Colors.white,
        //                         height: 24,
        //                       ),
        //                     ],
        //                   ),
        //                   const Text(
        //                     'Healthcare\nLive Cart',
        //                     style: TextStyle(
        //                         fontSize: 12,
        //                         color: Colors.white,
        //                         decoration: TextDecoration.none,
        //                         fontFamily: 'Poppins',
        //                         fontWeight: FontWeight.w500),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           )
        //         : SizedBox(),
        //   ),
        // ),
      ],
    );
  }
}

class FilterBox extends StatefulWidget {
  const FilterBox({
    Key? key,
    this.withCategory = true,
    this.withSubCategory = true,
    this.height,
    this.from,
    this.categoryId,
  }) : super(key: key);
  final bool withCategory, withSubCategory;
  final double? height;
  final String? from;
  final String? categoryId;

  @override
  State<FilterBox> createState() => _FilterBoxState();
}

class _FilterBoxState extends State<FilterBox> {
  bool _isCheck = false;
  // List<bool> _categoryCheckList = [];
  // List<bool> _subCategoryCheckList = [];
  List<bool> _brandCheckList = [];
  int categorySelected = 0;

  @override
  void initState() {
    // TODO: implement initState
    globalLogger.d(widget.from);
    if (!(widget.from == 'CATEGORY')) {
      HealthCareController.to.getSubCategory(widget.categoryId!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 270,
      height: widget.height ?? Get.height * .6,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(-2, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.from == 'CATEGORY')
                    FilterCheckWithLabel(
                      label: 'Category',
                      child: Obx(() => ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: HealthCareController.to.getHealthcareCategoryList.length,
                            itemBuilder: (_, index) {
                              return CustomCheckBox(
                                height: 30,
                                label: HealthCareController.to.getHealthcareCategoryList[index].name!,
                                value: HealthCareController.to.categoryCheckList[index],
                                onChanged: (newValue) {
                                  HealthCareController.to.categoryCheckList[index] = newValue!;
                                  setState(() {});
                                },
                              );
                            },
                          )),
                    ),
                  if (widget.from == 'SUB_CATEGORY')
                    FilterCheckWithLabel(
                      label: 'Sub Category',
                      child: Obx(
                        () => ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: HealthCareController.to.subCategoryCheckList.length,
                          itemBuilder: (_, index) {
                            return CustomCheckBox(
                              height: 30,
                              label: HealthCareController.to.getHealthcareSubCategoryList[index].name!,
                              value: HealthCareController.to.subCategoryCheckList[index],
                              onChanged: (newValue) {
                                HealthCareController.to.subCategoryCheckList[index] = newValue!;
                                setState(() {});
                                // setState(() {
                                //   _isCheck = newValue!;
                                // });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  if (widget.from == 'SUB_CATEGORY')
                    FilterCheckWithLabel(
                      label: 'Brands',
                      child: Obx(
                        () => ListView.builder(
                          padding: EdgeInsets.zero,
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: HealthCareController.to.brandCheckList.length,
                          itemBuilder: (_, index) {
                            return CustomCheckBox(
                              height: 30,
                              label: HealthCareController.to.healthcareBrandList[index]['name'],
                              value: HealthCareController.to.brandCheckList[index],
                              onChanged: (newValue) {
                                HealthCareController.to.brandCheckList[index] = newValue!;
                                setState(() {});
                                // setState(() {
                                //   _isCheck = newValue!;
                                // });
                              },
                            );
                          },
                        ),
                      ),
                    ),

                  ///Brand Delete
                  // if (widget.from == HealthcareScreen.routeName)
                  // FilterCheckWithLabel(
                  //   label: 'Brands',
                  //   child: Column(
                  //     children: [
                  //       CustomCheckBox(
                  //         height: 30,
                  //         label: 'ACCU-CHEK(1)',
                  //         value: _isCheck,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _isCheck = newValue!;
                  //           });
                  //         },
                  //       ),
                  //       CustomCheckBox(
                  //         height: 30,
                  //         label: 'ACCU-CHEK(1)',
                  //         value: _isCheck,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _isCheck = newValue!;
                  //           });
                  //         },
                  //       ),
                  //       CustomCheckBox(
                  //         height: 30,
                  //         label: 'ACCU-CHEK(1)',
                  //         value: _isCheck,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _isCheck = newValue!;
                  //           });
                  //         },
                  //       ),
                  //       CustomCheckBox(
                  //         height: 30,
                  //         label: 'ACCU-CHEK(1)',
                  //         value: _isCheck,
                  //         onChanged: (newValue) {
                  //           setState(() {
                  //             _isCheck = newValue!;
                  //           });
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  if (!(widget.from == 'CATEGORY'))
                    FilterCheckWithLabel(
                      label: 'Price Range',
                      child: Column(
                        children: [
                          Obx(
                            () => CustomCheckBox(
                              height: 30,
                              label: '1-250',
                              value: HealthCareController.to.priceType.value == PriceType.two_50,
                              onChanged: (newValue) {
                                if (newValue!) {
                                  HealthCareController.to.priceType(PriceType.two_50);
                                }
                                setState(() {
                                  // _isCheck = newValue!;
                                });
                              },
                            ),
                          ),
                          Obx(
                            () => CustomCheckBox(
                              height: 30,
                              label: '1-500',
                              value: HealthCareController.to.priceType.value == PriceType.five_100,
                              onChanged: (newValue) {
                                if (newValue!) {
                                  HealthCareController.to.priceType(PriceType.five_100);
                                }
                                setState(() {
                                  // _isCheck = newValue!;
                                });
                              },
                            ),
                          ),
                          Obx(
                            () => CustomCheckBox(
                              height: 30,
                              label: '500+',
                              value: HealthCareController.to.priceType.value == PriceType.five_100Plus,
                              onChanged: (newValue) {
                                if (newValue!) {
                                  HealthCareController.to.priceType(PriceType.five_100Plus);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                  ///TODO: UNCOMMENT IF CLIENT REQUIRED
                  // if (!(widget.from == 'CATEGORY'))
                  //   SizedBox(
                  //     width: 155,
                  //     child: HorizontalDivider(
                  //       thickness: .5,
                  //       color: kPrimaryColor,
                  //     ),
                  //   ),
                  // if (!(widget.from == 'CATEGORY'))
                  //   CustomCheckBox(
                  //     label: 'Show only products on sale',
                  //     value: _isCheck,
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         _isCheck = newValue!;
                  //       });
                  //     },
                  //   ),
                ],
              ),
            ),
          ),
          space3C,
          Center(
            child: PrimaryButton(
              onPressed: () {
                if (widget.from == 'CATEGORY') {
                  HealthCareController.to.isApplyFilter(true);
                } else {
                  HealthCareController.to.getFilterProductList();
                  HealthCareController.to.isApplyFilterInCategoryDetails(true);
                }
              },
              marginVertical: 0,
              height: 30,
              width: 100,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              primary: const Color(0xff4A8B5C),
              label: 'Apply Filter',
            ),
          ),
        ],
      ),
    );
  }
}

class FilterCheckWithLabel extends StatelessWidget {
  const FilterCheckWithLabel({
    Key? key,
    required this.label,
    this.child,
  }) : super(key: key);
  final String label;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          title: label,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway',
          color: Colors.black,
        ),
        SizedBox(
          width: 155,
          child: HorizontalDivider(
            thickness: .5,
            color: kPrimaryColor,
          ),
        ),
        child ?? const SizedBox(),
        space3C,
      ],
    );
  }
}

class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    Key? key,
    required this.label,
    this.onChanged,
    this.height,
    required this.value,
  }) : super(key: key);
  final String label;
  final ValueChanged<bool?>? onChanged;
  final bool value;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        side: const BorderSide(
          width: 1,
        ),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: kTextColor,
          ),
        ),
        value: value,
        activeColor: kPrimaryColor,
        onChanged: onChanged!,
        visualDensity: const VisualDensity(vertical: -2, horizontal: -4),
        controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
      ),
    );
  }
}

class CategorySection extends StatefulWidget {
  const CategorySection({
    Key? key,
  }) : super(key: key);

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  @override
  void initState() {
    // TODO: implement initState
    HealthCareController.to.getCategory(0,0);
    super.initState();
  }

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
          child: Obx(
            () {
              // if (!HealthCareController.to.categoryLoading.value &&
              //     HealthCareController.to.healthcareCategoryList.isEmpty) {
              //   HealthCareController.to.getCategory();
              // }
              return HealthCareController.to.categoryLoading.value
                  ? const Waiting()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemCount: HealthCareController.to.healthcareCategoryList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return CategoryItem(
                          info: HealthCareController.to.healthcareCategoryList[index],
                          onTap: () {
                            Get.toNamed(CategoryDetailsScreen.routeName, arguments: {
                              'id': HealthCareController.to.healthcareCategoryList[index].id,
                              'name': HealthCareController.to.healthcareCategoryList[index].name,
                            });
                          },
                        );
                      },
                    );
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
    this.onTap,
    required this.info,
  }) : super(key: key);
  final Function()? onTap;
  final HealthCareCategoryModel info;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 60,
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                color: Colors.white,
                border: Border.all(color: kPrimaryColor, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: CustomNetworkImage(
                  networkImagePath: info.imagePath!,
                ),
              ),
            ),
            space1C,
            TitleText(
              title: info.name!,
              fontSize: 8,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              textAlign: TextAlign.center,
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
