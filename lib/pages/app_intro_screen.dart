import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/pages/home/home_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class AppIntroScreen extends StatefulWidget {
  const AppIntroScreen({Key? key}) : super(key: key);
  static const String routeName = '/app-intro';
  @override
  State<AppIntroScreen> createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  List<Map<String, String>> slides = [
    {
      "title": "Live Online Doctor\nConsultation",
      "subTitle":
          "Easily connect with doctor and start video chat for your better treatment & prescription.",
      "image": "assets/images/intro-1.png",
    },
    {
      "title": "Medicine & Healthcare\nProducts",
      "subTitle":
          "Access thousands of doctors instantly. You can easily contact with the doctors and contact for your needs.",
      "image": "assets/images/intro-1.png",
    },
    {
      "title": "Easy Labratory\nTest",
      "subTitle":
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. At pretium turpis id rhoncus. Turpis fringilla.",
      "image": "assets/images/intro-1.png",
    }
  ];
  int currentIndex = 0;
  PageController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
    slides = slides;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _controller!,
                    onPageChanged: (value) {
                      setState(() {
                        currentIndex = value;
                      });
                    },
                    itemCount: slides.length,
                    itemBuilder: (context, index) {
                      // contents of slider
                      return Slider(
                        image: slides[index]['image']!,
                        title: slides[index]['title']!,
                        subTitle: slides[index]['subTitle']!,
                      );
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  slides.length,
                  (index) => buildDot(index, context),
                ),
              ),
              Container(
                height: 40,
                margin: const EdgeInsets.all(40),
                width: Get.width * .5,
                child: ElevatedButton(
                  onPressed: () {
                    if (currentIndex == slides.length - 1) {
                      AuthController.to.offIntroPage();
                      Get.offAllNamed(HomeScreen.routeName);
                    } else {
                      currentIndex++;
                      _controller!.nextPage(
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.bounceIn);
                      setState(() {});
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  // textColor: Colors.white,
                  child: Text(currentIndex == slides.length - 1
                      ? "Get Started"
                      : "Next"),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 20,
            right: 10,
            child: TextButton(
              onPressed: () {
                AuthController.to.offIntroPage();
                Get.offAllNamed(HomeScreen.routeName);
              },
              child: const Text('Skip'),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  // container created for dots
  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: currentIndex == index ? kPrimaryColor : const Color(0xff939393),
      ),
    );
  }
}

class Slider extends StatelessWidget {
  final String image;
  final String? title;
  final String? subTitle;

  const Slider({required this.image, this.title, this.subTitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // image given in slider
          Image(image: AssetImage(image)),
          space5C,
          space5C,
          TitleText(
            title: title!,
            fontSize: 18,
            color: kTextColor,
            textAlign: TextAlign.center,
          ),
          space5C,
          TitleText(
            title: subTitle!,
            fontSize: 13,
            color: kTextColorLite,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:introduction_screen/introduction_screen.dart';
// import 'package:shebaone/utils/constants.dart';
//
// class AppIntroScreen extends StatelessWidget {
//   const AppIntroScreen({Key? key}) : super(key: key);
//   static const String routeName = '/app-intro';
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           IntroductionScreen(
//             pages: listPagesViewModel,
//             onDone: () {
//               // Get.offAllNamed(AppIntroScreen.routeName);
//             },
//             next: ElevatedButton(
//               onPressed: () {
//                 IntroductionScreenState().next();
//                 // Get.offAllNamed(AppIntroScreen.routeName);
//               },
//               child: const Text('Next'),
//             ),
//             showBackButton: false,
//             showNextButton: true,
//             globalFooter: Container(
//               color: Colors.white,
//               width: double.infinity,
//               padding: const EdgeInsets.all(20.0),
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Get.offAllNamed(AppIntroScreen.routeName);
//                 },
//                 child: const Text('Sign In'),
//               ),
//             ),
//             done: const Text("Continue"),
//             dotsDecorator: dotsDecorator,
//             baseBtnStyle: TextButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//             ),
//           ),
//           Positioned(
//             right: 0,
//             top: 25,
//             child: TextButton(
//               onPressed: () {
//                 // Get.offAllNamed(AppIntroScreen.routeName);
//               },
//               style: TextButton.styleFrom(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//               ),
//               child: const Text('Skip'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// DotsDecorator dotsDecorator = DotsDecorator(
//     size: const Size.square(10.0),
//     activeSize: const Size.square(10.0),
//     activeColor: kPrimaryColor,
//     color: const Color(0xff939393),
//     spacing: const EdgeInsets.symmetric(horizontal: 3.0),
//     activeShape:
//         RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)));
//
// List<PageViewModel> listPagesViewModel = [
//   _generateViewModel(
//       "Live Online Doctor\nConsultation",
//       "Easily connect with doctor and start video chat for your better treatment & prescription.",
//       "assets/images/intro-1.png"),
//   _generateViewModel(
//       "Medicine & Healthcare\nProducts",
//       "Access thousands of doctors instantly. You can easily contact with the doctors and contact for your needs.",
//       "assets/images/intro-2.png"),
//   _generateViewModel(
//       "Easy Labratory\nTest",
//       "Lorem ipsum dolor sit amet, consectetur adipiscing elit. At pretium turpis id rhoncus. Turpis fringilla.",
//       "assets/images/intro-3.png"),
// ];
//
// PageViewModel _generateViewModel(String title, String body, String image) {
//   return PageViewModel(
//     title: title,
//     decoration: PageDecoration(
//       titleTextStyle: TextStyle(
//         fontSize: 16.0,
//         fontWeight: FontWeight.w600,
//         color: kTextColor,
//       ),
//       bodyTextStyle: TextStyle(fontSize: 16.0),
//       pageColor: Colors.white,
//     ),
//     bodyWidget: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 32),
//       child: Text(
//         body,
//         textAlign: TextAlign.center,
//         style: const TextStyle(
//           color: Colors.grey,
//           fontSize: 16.0,
//         ),
//       ),
//     ),
//     image: Container(
//       alignment: Alignment.bottomCenter,
//       padding: const EdgeInsets.all(64),
//       child: Image.asset(
//         image,
//         fit: BoxFit.contain,
//       ),
//     ),
//   );
// }
