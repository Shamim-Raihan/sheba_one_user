import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/pages/app_intro_screen.dart';
import 'package:shebaone/pages/home/home_screen.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: (!AuthController.to.isFirstTime ? 0 : 3)),
        () {
      AuthController.to.isFirstTime
          ? Get.offAllNamed(AppIntroScreen.routeName)
          : Get.offAllNamed(HomeScreen.routeName);
    });
    return Scaffold(
      body: !AuthController.to.isFirstTime
          ? const Center()
          : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset('assets/images/splash.png'),
                ),
                const TitleText(
                  title: 'ShebaOne',
                ),
              ],
            ),
    );
  }
}
