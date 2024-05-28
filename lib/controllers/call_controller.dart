import 'package:get/get.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';

class CallController extends GetxController {
  static CallController get to => Get.find();
  Rx<CallStatus> callStatus = CallStatus.none.obs;

  @override
  void onReady() async {
    globalLogger.d(callStatus.value);
    callStatus(CallStatus.none);
    super.onReady();
  }
}
