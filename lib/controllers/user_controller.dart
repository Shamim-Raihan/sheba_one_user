import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/models/user_model.dart';
import 'package:shebaone/utils/global.dart';

import '../services/database.dart';

class UserController extends GetxController {
  static UserController get to => Get.find();
  final Database database = Database();

  Rx<UserModel> userInfo = UserModel().obs;

  UserModel get getUserInfo => userInfo.value;

  @override
  void onInit() async {
    await getUpdatedUserInfo();
    AuthController.to.userPhoneForLogin.value = UserController.to.getUserInfo.mobile!;

    super.onInit();
  }

  Future<void> getUpdatedUserInfo() async {
    final token = await FirebaseMessaging.instance.getToken();
    globalLogger.d(token);
    final updatedTokenStatus =
        await database.updateToken(userType: 'user', userId: AuthController.to.getUserId, token: token!);
    userInfo.value = await database.getUser(AuthController.to.getUserId);
  }
}
