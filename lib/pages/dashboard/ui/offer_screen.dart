import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/pages/dashboard/ui/offer_section.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class OfferScreen extends StatelessWidget {
  const OfferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppBarWithSearch(
          moduleSearch: ModuleSearch.none,
          isSearchShow: false,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
          child: TitleText(
            title: 'All Offer',
            fontSize: 20,
          ),
        ),
        Obx(
          () => GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8),
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisExtent: 70, maxCrossAxisExtent: 200, crossAxisSpacing: 5, mainAxisSpacing: 10),
            itemCount: HomeController.to.offer.value['slider'].length,
            itemBuilder: (BuildContext ctx, index) {
              return OfferItem(
                info: HomeController.to.offer.value['slider'][index],
                path: HomeController.to.offer.value['path'],
              );
            },
          ),
        ),
      ],
    ));
  }
}
