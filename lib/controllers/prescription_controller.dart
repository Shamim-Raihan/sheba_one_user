import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/upload_prescription_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/models/pharmacy_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';
import 'package:socket_io_client/socket_io_client.dart';

class PrescriptionController extends GetxController {
  static PrescriptionController get to => Get.find();
  final Database database = Database();

  /// ------------------------------- USE FOR LIVE SEARCH --------------------------------///

  ///Home Page Loading for Pharmacy List Live Search
  RxBool pharmacyListLoading = false.obs;

  ///All Pharmacy List OBS
  RxList<PharmacyModel> pharmacyList = <PharmacyModel>[].obs;

  ///process Pharmacy Send Data
  RxList<Map<String, dynamic>> processPharmacyDataList = <Map<String, dynamic>>[].obs;

  ///Confirmation Data
  RxMap confirmationPharmacyData = {}.obs;

  ///Order Success Data
  RxMap orderSuccessData = {}.obs;

  ///Payment Method info
  Rx<PaymentMethod> paymentMethod = PaymentMethod.cod.obs;

  ///Loading for single Medicine Product
  RxBool prescriptionLiveSearchLoading = true.obs;

  ///Confirm Order
  RxBool confirmOrderStatus = false.obs;

  ///timer bool
  RxBool timerStatus = false.obs;

  ///timer time
  RxInt time = 0.obs;

  ///Distance time
  RxString distanceTime = ''.obs;

  /// ------------------------------- END USE FOR LIVE SEARCH --------------------------------///

  /// ------------------------------- USE FOR ORDER PAGE --------------------------------///

  ///Order list
  RxList<MedicineOrderModel> medicineOrderList = <MedicineOrderModel>[].obs;

  ///Loading for Order Data
  RxBool orderListLoading = false.obs;

  ///Current Orders
  RxInt currentOrders = 0.obs;

  ///Single Order Item list
  RxList<MedicineSingleOrderItemModel> medicineSingleOrderItemList = <MedicineSingleOrderItemModel>[].obs;

  /// ------------------------------- END USE FOR ORDER PAGE --------------------------------///

  @override
  void onReady() async {
    syncData();
    // await getOrderList();
    super.onReady();
  }

  // ///Medicine Order List Get
  // Future<void> getOrderList() async {
  //   orderListLoading.value = true;
  //   currentOrders.value = 0;
  //   try {
  //     medicineOrderList.value = await database.getMedicineOrderList();
  //     for (var value in medicineOrderList) {
  //       if (value.orderStatus!.toLowerCase() == 'pending') {
  //         currentOrders++;
  //       }
  //     }
  //   } catch (e) {
  //     debugPrint(e.toString());
  //   }
  //   orderListLoading.value = false;
  // }

  ///Medicine Single Order item List Get
  Future<void> getSingleOrderDetailsList(String orderId) async {
    HomeController.to.orderDetailsLoading(true);
    try {
      medicineSingleOrderItemList.value = await database.getMedicineSingleOrderItemList(orderId);
    } catch (e) {
      debugPrint(e.toString());
    }
    HomeController.to.orderDetailsLoading(false);
  }

  ///Get Pharmacy List For Live Search
  Future<void> getPharmacyListForLiveSearch(
    Map info,
  ) async {
    await database.uploadPrescriptionImage(UploadPrescriptionController.to.getImagePath).then(
      (value) async {
        pharmacyListLoading.value = true;
        globalLogger.d(value, 'prescriptionImage');
        print('Working...');
        pharmacyList.value = [];
        processPharmacyDataList.value = [];

        final data = await database.pharmacyList(info);
        pharmacyList.addAll(data);
        List<Map<String, dynamic>> processData = [];
        for (var element in pharmacyList) {
          processData.add(processLiveSearchData(element, UploadPrescriptionController.to.getImagePath));
        }
        // globalLogger.d(data);
        processPharmacyDataList.value = processData;
        // globalLogger.d(processPharmacyDataList, processData.length);

        pharmacyListLoading.value = false;
      },
    );
  }

  Map<String, dynamic> processLiveSearchData(PharmacyModel pharmacyModel, String prescriptionImage) {
    Map<String, dynamic> data = {
      "distance": pharmacyModel.distance,
      "user_id": UserController.to.getUserInfo.id,
      "contact_no": pharmacyModel.contactNo,
      "pharmacy_id": pharmacyModel.id,
      "pharmacy_name": pharmacyModel.pharmacyName,
      "latitude": pharmacyModel.latitude,
      "longitude": pharmacyModel.longitude,
      "image": prescriptionImage,
    };

    // List<Map> _cartItems = [];
    // for (var element in medicineCartList) {
    //   final info = {
    //     "id": element.id,
    //     "name": element.name,
    //     "sell_price": element.offerPrice,
    //     "price": element.mrp,
    //     "discount": element.offerPercentage,
    //     "img": element.images!.isEmpty ? '' : element.images![0],
    //     "count": element.userQuantity,
    //     "generic": element.generic == null ? '' : element.generic!.name,
    //     "strength": element.strength == null ? '' : element.strength!.name
    //   };
    //   _cartItems.add(info);
    // }

    // data['medicine'] = _cartItems;
    globalLogger.d(data);
    return data;
  }

  setConfirmPharmacyData(dynamic data) {
    // confirmationPharmacyData.value = data;
    globalLogger.d('ASCHE');
    List<Map<String, dynamic>> _availableMedicine = [];
    List<Map<String, dynamic>> _unavailableMedicine = [];
    for (int i = 0; i < data['order_info'].length; i++) {
      if (data['order_info'][i]['availability'].toString().toLowerCase() == 'available') {
        _availableMedicine.add(data['order_info'][i]);
      } else {
        _unavailableMedicine.add(data['order_info'][i]);
      }
    }
    confirmationPharmacyData.value = {
      'pharmacy_id': data['pharmacy_id'],
      'pharmacy_name': data['pharmacy_name'],
      'pharmacy_mobile': data['pharmacy_mobile'],
      'drug_license_no': data['drug_license_no'],
      'delivery_charge': data['delivery_charge'],
      'rating': data['rating'],
      'available': _availableMedicine,
      'unavailable': _unavailableMedicine,
      'order_type': _unavailableMedicine.isEmpty ? 'full' : 'partial',
    };
  }

  Future<bool> orderMedicine(dynamic serverInfo) async {
    globalLogger.d(serverInfo);
    final data = await database.orderMedicineProduct(serverInfo);
    if (data.runtimeType == bool) {
      return false;
    } else {
      orderSuccessData.value = data;
      dynamic info = {
        "order_status": "order_confirm",
        "order_amount": data['order_amount'],
        "order_id": data['order_id'],
        "order_date": DateFormat.MMMEd().format(DateTime.parse(data['created_at'])),
        "pharmacy_mobile": confirmationPharmacyData['pharmacy_mobile']
      };
      orderInfoConfirm = info;

      socket.disconnect();
      socket.dispose();
      socket.connect();
      socket.onConnect((_) {
        socket.emit('sendChatToServer3', [info]);
        socket.disconnect();
        socket.dispose();
      });
      MedicineController.to.getOrderList();
      return true;
    }
    // final pharmacyData = await database.orderMedicinePharmacy(orderConfirmInfo);
    // return data;
    // return false;
  }

  removeLiveSearchInfo() {
    confirmationPharmacyData({});
    orderSuccessData({});
    confirmOrderStatus(false);
    syncDataFromPharmacy();
    AuthController.to.emptyDeliveryProcess();
  }

  void syncDataFromPharmacy() {
    storage.write('confirmationFromPharmacyDataForPrescription', confirmationPharmacyData);
    storage.write('orderSuccessDataForPrescription', orderSuccessData);
    storage.write('confirmOrderStatusForPrescription', confirmOrderStatus.value);
  }

  void syncConfirmOrderStatusToLocal() {
    storage.write('confirmOrderStatusForPrescription', confirmOrderStatus.value);
  }

  syncData() {
    if (storage.read('confirmationFromPharmacyDataForPrescription') == null) {
      storage.write('confirmationFromPharmacyDataForPrescription', {});
    }
    if (storage.read('orderSuccessDataForPrescription') == null) {
      storage.write('orderSuccessDataForPrescription', {});
    }
    if (storage.read('confirmOrderStatusForPrescription') == null) {
      storage.write('confirmOrderStatusForPrescription', false);
    }
    confirmationPharmacyData(storage.read('confirmationFromPharmacyDataForPrescription'));
    orderSuccessData(storage.read('orderSuccessDataForPrescription'));
    confirmOrderStatus(storage.read('confirmOrderStatusForPrescription'));
  }

  void setMarkerLocalStorage({
    required double userLat,
    required double userLon,
    required double pharmacyLat,
    required double pharmacyLon,
    required String pharmacyName,
  }) {
    globalLogger.d(storage.read('trackForMarker'));
    if (storage.read('trackForMarker') == null) {
      debugPrint('ok');
      storage.write('trackForMarker', {});
    }
    dynamic info = {
      'user-marker': {
        'id': 'user-marker',
        'lat': userLat,
        'lon': userLon,
        'title': 'Location: My Location',
      },
      'pharmacy-marker': {
        'id': 'pharmacy-marker',
        'lat': pharmacyLat,
        'lon': pharmacyLon,
        'title': 'Location: $pharmacyName',
      },
    };
    storage.write('trackForMarker', info);
  }

  void setUserMarkerLocalStorage({
    required double userLat,
    required double userLon,
  }) {
    if (storage.read('trackForMarker') == null) {
      debugPrint('ok');
      storage.write('trackForMarker', {});
    }
    dynamic info = storage.read('trackForMarker');
    info['user-marker'] = {
      'id': 'user-marker',
      'lat': userLat,
      'lon': userLon,
      'title': 'Location: My Location',
    };
    storage.write('trackForMarker', info);

    globalLogger.d(storage.read('trackForMarker'), 'set user');
  }

  void setPharmacyMarkerLocalStorage({
    required double pharmacyLat,
    required double pharmacyLon,
    required String pharmacyName,
  }) {
    if (storage.read('trackForMarker') == null) {
      debugPrint('ok');
      storage.write('trackForMarker', {});
    }
    dynamic info = storage.read('trackForMarker');
    info['pharmacy-marker'] = {
      'id': 'pharmacy-marker',
      'lat': pharmacyLat,
      'lon': pharmacyLon,
      'title': 'Location: $pharmacyName',
    };
    storage.write('trackForMarker', info);
    globalLogger.d(storage.read('trackForMarker'), 'set pharmacy');
  }

  void setDeliveryManMarkerLocalStorage({
    required double deliveryLat,
    required double deliveryLon,
    required String deliveryName,
  }) {
    if (storage.read('trackForMarker') == null) {
      debugPrint('ok');
      storage.write('trackForMarker', {});
    }
    dynamic info = storage.read('trackForMarker');
    info['delivery-marker'] = {
      'id': 'delivery-marker',
      'lat': deliveryLat,
      'lon': deliveryLon,
      'title': 'Location: $deliveryName',
    };
    storage.write('trackForMarker', info);
    globalLogger.d(storage.read('trackForMarker'), 'set delivery');
  }

  void emptyDeliveryManMarkerLocalStorage() {
    if (storage.read('trackForMarker') == null) {
      debugPrint('ok');
      storage.write('trackForMarker', {});
    }
    dynamic info = storage.read('trackForMarker');
    info['delivery-marker'] = null;
    storage.write('trackForMarker', info);
    globalLogger.d(storage.read('trackForMarker'), 'empty delivery');
  }

  void emptyAllMarker() {
    storage.write('trackForMarker', {});
  }

  dynamic getMarkerData() {
    // globalLogger.d(storage.read('trackForMarker'));
    if (storage.read('trackForMarker') == null) {
      debugPrint('ok');
      storage.write('trackForMarker', {});
    }
    dynamic data = storage.read('trackForMarker');
    return data;
  }

  double calculateDistance() {
    final info = getMarkerData();
    var p = 0.017453292519943295;
    var c = cos;
    var a = AuthController.to.deliverymanId.value.isNotEmpty
        ? 0.5 -
            c((AuthController.to.getDeliveryManPosition['lat'] - info['user-marker']['lat']) * p) / 2 +
            c(info['user-marker']['lat'] * p) *
                c(AuthController.to.getDeliveryManPosition['lat'] * p) *
                (1 - c((AuthController.to.getDeliveryManPosition['lon'] - info['user-marker']['lon']) * p)) /
                2
        : 0.5 -
            c((info['pharmacy-marker']['lat'] - info['user-marker']['lat']) * p) / 2 +
            c(info['user-marker']['lat'] * p) *
                c(info['pharmacy-marker']['lat'] * p) *
                (1 - c((info['pharmacy-marker']['lon'] - info['user-marker']['lon']) * p)) /
                2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> getTime() async {
    final info = getMarkerData();
    final data = await database.getDistanceTime(info);
    globalLogger.d(data);

    final timeValue = data['rows'][0]['elements'][0]['duration']['value'];
    distanceTime.value = getMinuteSec(timeValue);
  }

  String getMinuteSec(int timeValue) {
    int mins = (timeValue / 60).floor();
    int sec = timeValue % 60;
    return '$mins mins $sec sec';
  }
}
