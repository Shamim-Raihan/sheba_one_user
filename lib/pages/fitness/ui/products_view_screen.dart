import 'package:flutter/material.dart';
import 'package:shebaone/utils/widgets/appbar.dart';

import '../../../controllers/healthcare_controller.dart';
import '../../../services/enums.dart';
import '../../dashboard/ui/healthcare_section.dart';
import '../../home/parent_with_navbar.dart';
import '../../profile/ui/profile_screen.dart';

class FitnessProductsViewScreen extends StatelessWidget {
  const FitnessProductsViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasStyle: false,
            moduleSearch: ModuleSearch.healthcare,
          ),
          Expanded(
            child: ListView.builder(
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
        ],
      ),
    );
  }
}
