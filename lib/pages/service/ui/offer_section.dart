import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/pages/dashboard/ui/offer_screen.dart';
import 'package:shebaone/pages/dashboard/widgets/common_widget.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class AllOfferSection extends StatelessWidget {
  const AllOfferSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionWithViewAll(
          label: 'All Offer',
          onTap: () {
            Get.to(const OfferScreen());
          },
        ),
        Obx(
          () => SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemCount: HomeController.to.offer.value['slider'] != null
                  ? HomeController.to.offer.value['slider'].length > 4
                      ? 4
                      : HomeController.to.offer.value['slider'].length
                  : 0,
              itemBuilder: (BuildContext ctx, index) {
                return AllOfferItem(
                    info: HomeController.to.offer.value['slider'][index], path: HomeController.to.offer.value['path']);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class AllOfferItem extends StatelessWidget {
  const AllOfferItem({
    Key? key,
    this.info,
    this.path,
  }) : super(key: key);
  final dynamic info;
  final String? path;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomNetworkImage(
            networkImagePath: '$path${info['image']}',
            height: 100,
            width: 100,
          ),
          space2C,
          SizedBox(
            width: 215,
            height: 50,
            child: TitleText(
              title: info['title'],
              fontSize: 16,
              maxLines: 2,
              textOverflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.normal,
              color: Color(0xff272728),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomImageSection extends StatelessWidget {
  const BottomImageSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          SizedBox(
            height: 215,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16),
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const ScrollPhysics(),
              itemCount: HomeController.to.medicineSliderList == null ? 0 : HomeController.to.medicineSliderList.length,
              itemBuilder: (BuildContext ctx, index) {
                return BottomImageItem(info: HomeController.to.medicineSliderList[index]);
              },
            ),
          ),
        ],
      );
    });
  }
}

class BottomImageItem extends StatelessWidget {
  const BottomImageItem({
    Key? key,
    this.info,
  }) : super(key: key);
  final dynamic info;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CustomNetworkImage(
        networkImagePath: 'https://shebaone.com/images/campaign_images/' + info['image'],
        borderRadius: 5,
      ),
    );



    //   Stack(
    //   children: [
    //     Positioned(
    //       child: Padding(
    //         padding: const EdgeInsets.all(4),
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(10),
    //           child: CustomNetworkImage(
    //             networkImagePath: 'https://shebaone.com//images/campaign_images/' + info['image'],
    //             borderRadius: 5,
    //           ),
    //         ),
    //       ),
    //     ),
    //     Container(
    //       alignment: Alignment.centerLeft,
    //       margin: const EdgeInsets.all(4),
    //       width: 315,
    //       height: 215,
    //       decoration: const BoxDecoration(
    //         color: Colors.transparent,
    //         borderRadius: BorderRadius.horizontal(
    //           right: Radius.circular(10),
    //         ),
    //         // image: DecorationImage(
    //         //   fit: BoxFit.fitHeight,
    //         //   alignment: Alignment.centerRight,
    //         //   image: NetworkImage(
    //         //     info['image'],
    //         //   ),
    //         // ),
    //       ),
    //       child: Container(
    //         width: 200,
    //         height: 215,
    //         decoration: BoxDecoration(
    //           color: kPrimaryColor,
    //           borderRadius: const BorderRadius.horizontal(
    //             right: Radius.circular(100),
    //             left: Radius.circular(10),
    //           ),
    //         ),
    //         child: Padding(
    //           padding: const EdgeInsets.only(left: 16.0),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               TitleText(
    //                 title: '50 lakh+\ncustomers',
    //                 fontSize: 20,
    //                 fontWeight: FontWeight.bold,
    //                 color: Colors.white,
    //               ),
    //               space5C,
    //               TitleText(
    //                 title: 'Across 1000+ cities',
    //                 fontSize: 10,
    //                 fontWeight: FontWeight.normal,
    //                 color: Colors.white,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ],
    // );
  }
}
