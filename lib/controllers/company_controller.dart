import 'package:get/get.dart';
import 'package:shebaone/services/database.dart';

class CompanyController extends GetxController {
  static CompanyController get to => Get.find();
  final Database database = Database();

  RxString title = ''.obs;
  RxString body = ''.obs;

  String get getTitle => title.value;
  String get getBody => body.value;

  @override
  void onReady() async {
    database.getCompanyDetails();
    super.onReady();
  }
}
