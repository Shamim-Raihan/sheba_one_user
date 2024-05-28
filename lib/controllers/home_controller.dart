import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/models/delivery_charge_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  final Database database = Database();
  Rx<MenuItemEnum> menuItemEnum = MenuItemEnum.home.obs;
  RxBool isMenuOpen = false.obs;

  RxString featuredImage = "".obs;
  RxString dynamicLink = "".obs;
  RxString search = "".obs;
  RxBool isSell = false.obs;
  RxBool isFollowUsClicked = false.obs;

  String get getFeaturedImage => featuredImage.value;
  bool get getSell => isSell.value;
  MenuItemEnum get getMenuItemEnum => menuItemEnum.value;

  //////////////////////////////////////////

  ///Order Data Toggle
  Rx<OrderType> orderListType = OrderType.healthcare.obs;

  ///Order Data Toggle
  Rx<OrderType> currentOrderListType = OrderType.healthcare.obs;

  ///Order Data Toggle
  Rx<OrderType> previousOrderListType = OrderType.healthcare.obs;

  ///Search Data Toggle
  Rx<SearchType> searchListType = SearchType.healthcare.obs;

  ///Cart Type
  Rx<CartType> cartType = CartType.none.obs;

  ///Search Data Toggle
  Rx<ModuleSearch> moduleSearchType = ModuleSearch.none.obs;

  ///Live Search Type
  Rx<LiveSearchType> liveSearchType = LiveSearchType.none.obs;

  ///Delivery Status Type
  Rx<DeliveryStatus> deliveryStatus = DeliveryStatus.none.obs;

  ///Loading for Order Data
  RxBool orderDetailsLoading = false.obs;

  ///Loading for Search Data
  RxBool searchLoading = false.obs;

  RxMap userPosition = {}.obs;

  RxMap commission = {}.obs;

  RxList sliderList = [].obs;

  RxList medicineSliderList = [].obs;

  RxList<ChargeModel> deliveryChargeList = <ChargeModel>[].obs;

  RxMap offer = {}.obs;
  RxString directoryPath = ''.obs;

  RxList searchList = [].obs;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    try {
      medicineSliderList([]);
      sliderList(await database.getSliderList());
      medicineSliderList(await database.getMedicineSliderList());
      globalLogger.d(medicineSliderList);
    } catch (e) {
      globalLogger.e(e);
    }
    super.onInit();
  }

  @override
  void onReady() async {
    checkAndGetDeliveryLocation();
    getDirectoryPath();
    commission(await database.getCommisionsInfo());
    offer(await database.getOfferList());
    globalLogger.d(offer.value, 'Offer LIST');
    await getDeliveryChargeListData();
    await getOrders();
    try {
      final isPositionGet = await getPosition();
    } catch (e) {
      globalLogger.e(e);
    }
    super.onReady();
  }

  getDeliveryChargeListData() async {
    deliveryChargeList.value = await database.getDeliveryChargeList();
  }


  getDirectoryPath() async {
   directoryPath.value =  (await getApplicationDocumentsDirectory()).path;
   globalLogger.d(directoryPath.value, 'directoryPath.value');
  }

  Future<void> checkAndGetDeliveryLocation() async {
    // HealthCareController.to.removeLiveSearchInfo();
    // MedicineController.to.removeLiveSearchInfo();
    // MedicineController.to.confirmOrderStatus(true);
    // MedicineController.to.syncConfirmOrderStatusToLocal();
    // PrescriptionController.to.removeLiveSearchInfo();
    globalLogger.d(AuthController.to.deliverymanId.value, "Auth User ID");
    globalLogger.d(HealthCareController.to.orderSuccessData, "Healthcare Order Success");
    globalLogger.d(HealthCareController.to.confirmationPharmacyData, "Healthcare Order Success");
    globalLogger.d(MedicineController.to.orderSuccessData, "Medicine Order Success");
    globalLogger.d(PrescriptionController.to.orderSuccessData, "Prescription Order Success");

    if (HealthCareController.to.orderSuccessData['order_id'] != null ||
        MedicineController.to.orderSuccessData['order_id'] != null ||
        PrescriptionController.to.orderSuccessData['order_id'] != null) {
      MedicineOrderModel info = MedicineOrderModel();
      if (HealthCareController.to.confirmOrderStatus.value) {
        info = await database.getOrderInfo(HealthCareController.to.orderSuccessData['order_id']);
      } else if (MedicineController.to.confirmOrderStatus.value) {
        info = await database.getOrderInfo(MedicineController.to.orderSuccessData['order_id']);
      } else if (PrescriptionController.to.confirmOrderStatus.value) {
        info = await database.getOrderInfo(HealthCareController.to.orderSuccessData['order_id']);
      }
      if (info.orderStatus != null && info.orderStatus!.isNotEmpty) {
        if (info.orderStatus == 'pending') {
          deliveryStatus(DeliveryStatus.none);
          AuthController.to.emptyDeliveryProcess();
        }
        if (info.orderStatus == 'processing') {
          deliveryStatus(DeliveryStatus.accepted);
          AuthController.to.deliverymanId(info.deliverymanId!);
          AuthController.to.deliveryOrderId(info.orderId!);
          AuthController.to.redisServiceReady(info.deliverymanId!);
        } else if (info.orderStatus == 'shipping') {
          deliveryStatus(DeliveryStatus.pickedUp);
          AuthController.to.redisServiceReady(info.deliverymanId!);
        } else if (info.orderStatus == 'delivered') {
          deliveryStatus(DeliveryStatus.delivered);
          HealthCareController.to.removeLiveSearchInfo();
          MedicineController.to.removeLiveSearchInfo();
          PrescriptionController.to.removeLiveSearchInfo();
          AuthController.to.emptyDeliveryProcess();
        } else if (info.orderStatus == 'cancelled') {
          deliveryStatus(DeliveryStatus.cancelled);
        }
      }
    } else {}
  }

  getOrders() async {
    globalLogger.d('All Order Call');
    orderListType(OrderType.healthcare);
    await HealthCareController.to.getOrderList();
    await MedicineController.to.getOrderList();
    await LabController.to.getOrderList();
    await DoctorAppointmentController.to.getOrderList();
  }

  Future<bool> getPosition() async {
    final info = await getGPSPermission();
    globalLogger.d(info, "getGPSPermission");
    if (info) {
      try {globalLogger.d('data');
        Position data = await Geolocator.getCurrentPosition(
            forceAndroidLocationManager: false, desiredAccuracy: LocationAccuracy.high);
        globalLogger.d(data);

        globalLogger.d(data, 'data lat');
        userPosition({
          'lat': data.latitude,
          'lon': data.longitude,
        });
      } catch (e) {
        globalLogger.d('All Order Call 2 3');
        globalLogger.e(e);
      }
    }
    globalLogger.d(userPosition);
    return info;
  }

  getSearchData(String key) async {
    final info = await database.getSearchListByKey(key);
    searchList.value = info;
  }

  void changeMenuItemActivity(MenuItemEnum itemEnum) {
    menuItemEnum.value = itemEnum;
  }

  void changeMenuOpenActivity() {
    isMenuOpen.value = !isMenuOpen.value;
    print(isMenuOpen.value);
  }

  ///Healthcare And Medicine Search List Get
  Future<void> getSearchList(String keyword) async {
    searchLoading(true);
    try {
      await database.getSearchList(keyword);
    } catch (e) {
      debugPrint(e.toString());
    }
    searchLoading(false);
  }

  ///Healthcare And Medicine Search List Get
  Future<void> getPaginationSearchList() async {
    if (searchListType.value == SearchType.healthcare && HealthCareController.to.nextPageSearch.isNotEmpty) {
      HealthCareController.to.searchListLoading(true);
      try {
        await database.getSearchList(HealthCareController.to.nextPageSearch.value, typo: true);
      } catch (e) {
        debugPrint(e.toString());
      }
      HealthCareController.to.searchListLoading(false);
    } else if (searchListType.value == SearchType.medicine && MedicineController.to.nextPageSearch.isNotEmpty) {
      MedicineController.to.searchListLoading(true);
      try {
        await database.getSearchList(MedicineController.to.nextPageSearch.value, typo: true);
      } catch (e) {
        debugPrint(e.toString());
      }
      MedicineController.to.searchListLoading(false);
    }
  }
}
