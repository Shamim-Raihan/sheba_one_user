import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/pages/dashboard/ui/offer_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class OfferSection extends StatelessWidget {
  const OfferSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          label: 'Offers Just for you',
          onTap: () {
            Get.to(const OfferScreen());
          },
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Obx(() {
                return Row(
                  children: [
                    if (HomeController.to.offer.value['slider'] != null &&
                        HomeController.to.offer.value['slider'].isNotEmpty)
                      Expanded(
                        child: OfferItem(
                            info: HomeController.to.offer.value['slider'][0],
                            path: HomeController.to.offer.value['path']),
                      ),
                    (HomeController.to.offer.value['slider'] != null &&
                            HomeController.to.offer.value['slider'].length > 1)
                        ? Expanded(
                            child: OfferItem(
                                info: HomeController.to.offer.value['slider']
                                    [1],
                                path: HomeController.to.offer.value['path']),
                          )
                        : const Spacer(),
                  ],
                );
              }),
            ),
            // Positioned(
            //   left: 10,
            //   bottom: 35,
            //   child: ArrowButton(
            //     onPressed: () {},
            //   ),
            // ),
            // Positioned(
            //   right: 10,
            //   bottom: 35,
            //   child: ArrowButton(
            //     iconData: Icons.arrow_forward_ios_rounded,
            //     onPressed: () {},
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}

class OfferItem extends StatelessWidget {
  const OfferItem({
    this.info,
    this.path,
    Key? key,
  }) : super(key: key);
  final dynamic info;
  final String? path;
  @override
  Widget build(BuildContext context) {
    // globalLogger.d('${Database().apiUrl.replaceAll('/api', '')}$path${info['image']}');
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      padding: const EdgeInsets.all(4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomNetworkImage(
              networkImagePath:
                  '$path${info['image']}',
              borderRadius: 5,
              width: 51,
              height: 51,
            ),
          ),
          space2R,
          Expanded(
            child: TitleText(
              title: info['title'],
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          space2R,
        ],
      ),
    );
  }
}
