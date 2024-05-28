import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/pages/lab/ui/lab_test_category_screen.dart';
import 'package:shebaone/pages/lab/ui/single_test_details_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class TopOrderLabTestSection extends StatelessWidget {
  const TopOrderLabTestSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          label: 'Top Ordered Lab Tests',
          onTap: () {
            Get.toNamed(LabTestCategoryScreen.routeName);
          },
        ),
        SizedBox(
          height: 200,
          child: Obx(() {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemCount: LabController.to.categoryWiseLabTestList.length > 4
                  ? 4
                  : LabController.to.categoryWiseLabTestList.length,
              itemBuilder: (BuildContext ctx, index) {
                return TopOrderLabTestItem(info: LabController.to.categoryWiseLabTestList[index]);
              },
            );
          }),
        ),
      ],
    );
  }
}

class TopOrderLabTestItem extends StatelessWidget {
  const TopOrderLabTestItem({
    Key? key,
    this.info,
  }) : super(key: key);
  final dynamic info;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await LabController.to.getSingleLabTest(info['id'].toString());
        Get.toNamed(SingleTestDetailsScreen.routeName);
      },
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            width: 150,
            decoration: BoxDecoration(color: kPrimaryColor, borderRadius: BorderRadius.circular(8), boxShadow: const [
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
                  height: 73,
                  width: 73,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/images/lab-test.png',
                      fit: BoxFit.fill,
                      height: 76,
                      width: 76,
                    ),
                  ),
                ),
                space2C,
                TitleText(
                  title: info['test_name'],
                  fontSize: 10,
                  textOverflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
                space1C,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/reward.png',
                      width: 10,
                    ),
                    space2R,
                    const TitleText(
                      title: 'Certified Lab',
                      fontSize: 8,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
              top: 12,
              right: 12,
              child: info['max_offer'] == null
                  ? SizedBox()
                  : Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: const Color(0xff5FC502),
                      ),
                      child: TitleText(
                        title: '-${info['max_offer']}%',
                        fontSize: 7,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ))
        ],
      ),
    );
  }
}
