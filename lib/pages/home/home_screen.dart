import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/pages/home/home_page.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/services/enums.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';
  Future<bool> checkConnection() async {
    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        connected = true;
      }
    } on SocketException catch (_) {
      connected = false;
    }
    return connected;
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return FutureBuilder(
          future: checkConnection(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!) {
                return Obx(
                  () {
                    AuthController authController = AuthController.to;
                    return authController.getUserId.isEmpty &&
                            (HomeController.to.menuItemEnum.value ==
                                    MenuItemEnum.profile ||
                                HomeController.to.menuItemEnum.value ==
                                    MenuItemEnum.orders ||
                                HomeController.to.menuItemEnum.value ==
                                    MenuItemEnum.prescription)
                        ?  LoginScreen()
                        : authController.getUserId.isNotEmpty &&
                                authController.getIsVerified == false
                            ? const VerifyScreen()
                            : MainHomePage();
                  },
                );
              } else {
                return const Scaffold(
                  body: Center(
                    child: Text(
                      'No Internet Connection',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
    //return HomeWidget();
  }
}
