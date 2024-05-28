import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/utils/constants.dart';

import '../../../utils/widgets/network_image/network_image.dart';

class DashboardSlider extends StatefulWidget {
  const DashboardSlider({this.margin, Key? key}) : super(key: key);
  final double? margin;

  @override
  State<DashboardSlider> createState() => _DashboardSliderState();
}

class _DashboardSliderState extends State<DashboardSlider> with SingleTickerProviderStateMixin {
  PageController? _controller;
  int nextPage = 0;
  // List<Widget>? _list;

  @override
  void initState() {
    _controller = PageController();
    Future.delayed(Duration.zero, () {
      WidgetsBinding.instance.addPostFrameCallback((_) => _animateSlider());
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller!.dispose();
    super.dispose();
  }

  void _animateSlider() {
    Future.delayed(const Duration(seconds: 2)).then((_) {
      nextPage = _controller!.page!.round() + 1;
      if (nextPage == HomeController.to.sliderList.length) {
        nextPage = 0;
      }

      _controller!
          .animateToPage(nextPage, duration: const Duration(seconds: 1), curve: Curves.linearToEaseOut)
          .then((_) => _animateSlider());

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Obx(() {
              return PageView.builder(
                allowImplicitScrolling: true,
                controller: _controller!,
                itemCount: HomeController.to.sliderList.length,
                itemBuilder: (_, i) {
                  return SliderBox(
                    margin: widget.margin,
                    child: CustomNetworkImage(
                      networkImagePath: HomeController.to.sliderList[i]['image_path'],
                    ),
                  );
                  // _list![i];
                },
              );
            }),
          ),
        ),
        Obx(() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              HomeController.to.sliderList.length,
              (index) => buildDot(index, context),
            ),
          );
        }),
      ],
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: nextPage == index ? 6 : 4,
      width: nextPage == index ? 6 : 4,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: nextPage == index ? kPrimaryColor : const Color(0xff939393),
      ),
    );
  }
}

class SliderBox extends StatelessWidget {
  final Widget child;
  final double? margin;
  const SliderBox({Key? key, required this.child, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(margin ?? 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 20),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: child,
      ),
    );
  }
}
