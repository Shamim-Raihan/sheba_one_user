import 'package:get/instance_manager.dart';
import '../register_controller.dart';

class RegisterBinding extends Bindings{
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController());
  }
}