import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/upload_prescription_controller.dart';
import 'package:shebaone/pages/cart/ui/medicine_cart_screen.dart';
import 'package:shebaone/pages/dashboard/ui/top_selling_medicine_section.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/service_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/constants.dart';

class AllMedicineScreen extends StatefulWidget {
  AllMedicineScreen({Key? key}) : super(key: key);

  static String routeName = '/AllMedicineScreen';

  @override
  State<AllMedicineScreen> createState() => _AllMedicineScreenState();
}

class _AllMedicineScreenState extends State<AllMedicineScreen> {
  final ImagePicker _picker = ImagePicker();

  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(_scrollListener);
  }

  Future<void> _scrollListener() async {
    print("Listener Active");
    // print(controller.position.pixels);
    // print(controller.position.maxScrollExtent);
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      //.5
      print("Listener Work");
      if (!MedicineController.to.addLoading.value) {
        await MedicineController.to.getMedicine();
      }
      // Provider.of<HomeProvider>(context, listen: false)
      //     .loadMoreProgram(Storage.getUser().id);
    }
  }

  @override
  Widget build(BuildContext context) {
    Get.put<UploadPrescriptionController>(UploadPrescriptionController());
    return ParentPageWithNav(
      child: Column(
        children: [
          AppBarWithSearch(
            hasStyle: false,
            moduleSearch: ModuleSearch.medicine,
            onCartTapped: () {
              Get.toNamed(MedicineCartScreen.routeName);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: controller,
              child: Column(
                children: [
                  BgContainer(
                    imagePath: 'service-bg',
                    horizontalPadding: 0,
                    verticalPadding: 0,
                    child: MainContainerWithTitle(
                        verticalPadding: 12,
                        mainContainerHorizontalMargin: 0,
                        horizontalPadding: 0,
                        firstText: 'Upload prescription to',
                        secondText: 'order Medicine Online',
                        borderColor: kScaffoldColor,
                        child: Column(
                          children: [
                            const SectionWithViewAll(
                              label: 'All Medicine',
                              withSeeAll: false,
                            ),
                            Obx(
                              () => GridView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                                shrinkWrap: true,
                                physics: const ScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: 250,
                                    maxCrossAxisExtent: 200,
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20),
                                itemCount: MedicineController.to.getMedicineList.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return TopSellingMedicineItem(
                                    info: MedicineController.to.getMedicineList[index],
                                  );
                                },
                              ),
                            ),
                            Obx(
                              () => MedicineController.to.addLoading.value
                                  ? SizedBox(
                                      height: Get.height * .5,
                                      child: const Waiting(),
                                    )
                                  : MedicineController.to.medicineList.isEmpty
                                      ? SizedBox(
                                          height: Get.height * .5,
                                          child: const Center(
                                            child: Text('No Product Found!'),
                                          ),
                                        )
                                      : const SizedBox(),
                            ),
                          ],
                        )

                        // const TopSellingMedicineSection(
                        //   label: 'All Medicine',
                        //   withSeeAll: false,
                        //   itemCount: 12,
                        // ),
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
