import 'package:get/get.dart';
import 'package:shebaone/services/database.dart';

class UploadPrescriptionController extends GetxController {
  static UploadPrescriptionController get to => Get.find();
  final Database database = Database();
  RxString imagePath = ''.obs;
  String get getImagePath => imagePath.value;
// @override
// void onReady() async {
//   super.onReady();
// }
  void setImagePath(String path) {
    imagePath.value = path;
    print(path);
  }
}
