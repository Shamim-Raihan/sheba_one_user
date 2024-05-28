import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/healthcare_controller.dart';
import '../../../models/healthcare_category_model.dart';
import '../../../utils/constants.dart';
import '../../../utils/widgets/common_widget.dart';
import '../../../utils/widgets/network_image/network_image.dart';
import '../dashboard/widgets/common_widget.dart';
import '../healthcare/ui/category_details_screen.dart';
import '../healthcare/ui/healthcare_category_screen.dart';

class WomenCategorySection extends StatefulWidget {
  const WomenCategorySection({
    Key? key,
  }) : super(key: key);

  @override
  State<WomenCategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<WomenCategorySection> {
  @override
  void initState() {
    // TODO: implement initState
    HealthCareController.to.getCategory(1,0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionWithViewAll(
          horizontalPadding: 0,
          label: 'Health/Beauty Products for Woman',
          buttonLabel: 'See All',
          labelFontSize: 16,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 12),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      physics: const ScrollPhysics(),
                      itemCount:
                          HealthCareController.to.healthcareCategoryList.length,
                      itemBuilder: (BuildContext ctx, index) {
                        return CategoryItem(
                          info: HealthCareController
                              .to.healthcareCategoryList[index],
                          onTap: () {
                            Get.toNamed(CategoryDetailsScreen.routeName,
                                arguments: {
                                  'id': HealthCareController
                                      .to.healthcareCategoryList[index].id,
                                  'name': HealthCareController
                                      .to.healthcareCategoryList[index].name,
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
