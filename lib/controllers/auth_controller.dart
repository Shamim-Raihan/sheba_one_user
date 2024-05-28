import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/register_model.dart';
import 'package:shebaone/pages/ambulance/view/search_location_on_map.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/utils/global.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final Database database = Database();

  RxString userId = "".obs;
  RxString userPhoneForLogin = "".obs;
  RxString userCountryCodeForLogin = "".obs;
  RxString userPhone = "".obs;
  RxBool isVerified = false.obs;
  RxBool isAmulance = false.obs;

  String get getUserId => userId.value;
  String get getUserPhone => userPhone.value;

  bool get getIsVerified => isVerified.value;

  bool get isFirstTime => storage.read('isFirstTime') ?? true;

  bool get isLoggedIn => storage.read('userId') != null;

  @override
  void onInit() {
    // TODO: implement onInit
    // emptyDeliveryProcess();
    syncDeliverymanOrderIdData();
    if (isLoggedIn) {
      userId.value = storage.read('userId');
      userPhone.value = storage.read('userPhone');
      isVerified.value = true;
      Get.put<UserController>(UserController(), permanent: true);
    }
    super.onInit();
  }

  setNullUser() {
    userId.value = '';
    userPhone.value = '';
  }

  Future<void> setUserId() async {
    String userId = await database.getUserId(
        userCountryCodeForLogin.value, userPhoneForLogin.value);
    if (userId.isNotEmpty) {
      this.userId.value = userId;
      userPhone.value = userPhoneForLogin.value;
      print(userId);
    }
    print(getUserId);
  }

  RxMap getDeliveryManPosition = {}.obs;
  RxString deliveryOrderId = ''.obs;
  RxString deliverymanId = ''.obs;

  void syncDeliverymanOrderIdToLocal(
      {required String orderId, required String deliverymanId}) {
    storage.write('deliverymanId', deliverymanId);
    storage.write('deliveryOrderId', orderId);
    syncDeliverymanOrderIdData();
  }

  syncDeliverymanOrderIdData() {
    if (storage.read('deliverymanId') == null) {
      storage.write('deliverymanId', '');
    }
    if (storage.read('deliveryOrderId') == null) {
      storage.write('deliveryOrderId', '');
    }
    deliverymanId(storage.read('deliverymanId'));
    deliveryOrderId(storage.read('deliveryOrderId'));
  }

  emptyDeliveryProcess() {
    storage.write('deliverymanId', '');
    storage.write('deliveryOrderId', '');
    getDeliveryManPosition({});
    deliverymanId('');
    deliveryOrderId('');
    conn.close();
    if (locationSubscription != null) locationSubscription!.cancel();
  }

  redisServiceReady(String deliveryManId) async {
    globalLogger.d('4', 'FCM_WORK');
    dynamic redisConnection = await conn.connect('66.29.145.244', 6379);
    locationSubscription = location?.onLocationChanged.listen((loc) {
      globalLogger.d('5', 'FCM_WORK');
      final position = LatLng(loc.latitude!, loc.longitude!);
      // globalLogger.d(position.toJson());
      redisConnection
          .send_object(["Get", 'deliveryman_list']).then((var response) {
        final data = response ?? '[]';
        final info = jsonDecode(data);
        // final dataSort = {
        //   "id": AuthController.to.getUserId,
        //   "latitude": loc.latitude!,
        //   "longitude": loc.longitude!,
        // };
        // globalLogger.d(data_sort);
        for (var element in info) {
          if (element['id']!.isNotEmpty && element['id'] == deliveryManId) {
            getDeliveryManPosition({
              "id": element['id'],
              'lat': element['latitude'],
              'lon': element['longitude'],
            });
            break;
          }
        }
        globalLogger.d(getDeliveryManPosition, info);
      }).catchError((e) async {
        globalLogger.e(e);
        redisConnection = await conn.connect('66.29.145.244', 6379);
      });
    });
  }

  void offIntroPage() {
    storage.write('isFirstTime', false);
  }

  void verifyVerificationCode(String code, bool Ambulance_car) async {
    bool isVerified = await database.verifyVerificationCode(code, getUserId);
    //TODO: change not (!) in isVerified

    if (isVerified) {
      userCountryCodeForLogin("");
      userPhoneForLogin("");
      Get.put<UserController>(UserController(), permanent: true);
      await HomeController.to.getOrders();
      this.isVerified.value = isVerified;
      //storage write
      storage.write('userId', getUserId);
      storage.write('userPhone', getUserPhone);
      storage.write('isFirstTime', false);
      print("================================> $isAmulance");
      if (storage.read("isAmulance") == "yes") {
        //this line is added by mahbub
        // Get.to(()=>SearchLocationOnMap());
      }
    }
  }

  void resendVerificationCode() {
    database.resendVerificationCode(getUserId);
  }

  void updateUser(UserModel model) async {
    bool isUpdated = await database.updateUser(model);
    if (isUpdated) {
      UserController.to.getUpdatedUserInfo();
    }
  }

  void registerUser(RegisterModel registerModel) {
    database.registerUser(registerModel);
  }

  Future<void> logout() async {
    storage.write("isAmulance", null);
    final updatedTokenStatus = await database.updateToken(
        userType: 'user', userId: AuthController.to.getUserId, token: '');
    Get.delete<UserController>(force: true);
    HealthCareController.to.deleteAllCart();
    MedicineController.to.deleteAllCart();
    LabController.to.deleteAllCart();
    storage.remove('userId');
    userId.value = "";
    userPhone.value = "";
    isVerified.value = false;
    Get.offAllNamed('/');
  }
}
