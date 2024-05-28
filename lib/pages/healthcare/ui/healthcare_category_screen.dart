import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/pages/dashboard/ui/dashboard_slider.dart';
import 'package:shebaone/pages/healthcare/ui/category_details_screen.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class HealthcareCategoryScreen extends StatelessWidget {
  const HealthcareCategoryScreen({Key? key}) : super(key: key);
  static String routeName = '/HealthcareCategoryScreen';

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          const AppBarWithSearch(
            hasStyle: false,
            moduleSearch: ModuleSearch.healthcare,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BgContainer(
                    imagePath: 'service-bg',
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: TitleText(
                                title: 'Get most popular & reliable',
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.normal,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            space1C,
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.0),
                              child: TitleText(
                                title: 'Healthcare Products Now',
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                            space4C,
                            const SizedBox(
                              height: 200,
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: DashboardSlider(
                                  margin: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          right: 40,
                          top: 0,
                          child: Image.asset(
                            'assets/images/style-bg-medium.png',
                            width: 97,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MainContainer(
                    color: kScaffoldColor,
                    borderColor: kScaffoldColor,
                    horizontalMargin: 0,
                    topBorderRadius: 30,
                    horizontalPadding: 0,
                    verticalPadding: 16,
                    child: Obx(
                      () => GridViewWithLabel(
                        label: 'Check out the most popular categories',
                        itemCount: HealthCareController
                            .to.healthcareCategoryList.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return ImageWithLabelBodyItem(
                            onTap: () {
                              Get.toNamed(
                                CategoryDetailsScreen.routeName,
                                arguments: {
                                  'id': HealthCareController
                                      .to.healthcareCategoryList[index].id!,
                                  'name': HealthCareController
                                      .to.healthcareCategoryList[index].name!
                                },
                              );
                            },
                            imagePath: HealthCareController
                                .to.healthcareCategoryList[index].imagePath,
                            label: HealthCareController
                                .to.healthcareCategoryList[index].name!,
                            body:
                                'Up to ${HealthCareController.to.healthcareCategoryList[index].discount}% Off',
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width,
                    height: 110,
                    color: kScaffoldColor,
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

class ImageWithLabelBodyItem extends StatelessWidget {
  const ImageWithLabelBodyItem({
    Key? key,
    required this.label,
    this.body,
    this.imagePath,
    this.from,
    this.onTap,
  }) : super(key: key);
  final String label;
  final String? body;
  final String? imagePath;
  final String? from;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        width: 150,
        decoration: BoxDecoration(
            color: const Color(0xff4A8B5C),
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 50,
              width: 65,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(.2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.white),
              ),
              child: Center(
                child: from == null
                    ? CustomNetworkImage(
                        networkImagePath: imagePath!,
                      )
                    : Image.asset(
                        'assets/images/${from == 'LAB-TEST' ? 'test' : 'lab-test'}.png',
                        fit: BoxFit.fill,
                      ),
              ),
            ),
            space2C,
            TitleText(
              title: label,
              fontSize: 13,
              fontFamily: 'Raleway',
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              textAlign: TextAlign.center,
            ),
            if (body != null) space1C,
            if (body != null)
              TitleText(
                title: body!,
                fontSize: 10,
                fontFamily: 'Raleway',
                fontWeight: FontWeight.normal,
                color: Colors.white,
              )
          ],
        ),
      ),
    );
  }
}

class GridViewWithLabel extends StatelessWidget {
  const GridViewWithLabel({
    Key? key,
    required this.label,
    required this.itemCount,
    // required this.child,
    required this.itemBuilder,
    this.isLoading = false,
  }) : super(key: key);
  final String label;
  final int itemCount;
  final bool isLoading;
  // final Widget child;
  final IndexedWidgetBuilder itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleText(
            title: label,
            fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        isLoading
            ? const Waiting()
            : GridView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    mainAxisExtent: 160,
                    maxCrossAxisExtent: 200,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
      ],
    );
  }
}
