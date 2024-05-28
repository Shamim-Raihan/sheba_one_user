import 'dart:io';

import 'package:get/get.dart';
import 'package:shebaone/models/country_model.dart';
import 'package:shebaone/services/database.dart';

import 'auth_controller.dart';

class RegisterController extends GetxController {
  static RegisterController get to => Get.find();
  final Database database = Database();
  RxList<CountryModel> countries = <CountryModel>[].obs;

  File? image;

  List<CountryModel> get getCountries => countries.value;

  @override
  void onReady() async {
    countries.value = await database.getCountries();
    super.onReady();
  }

  void updateImage() {
    database.uploadImage(image!, AuthController.to.getUserId);
  }
}
