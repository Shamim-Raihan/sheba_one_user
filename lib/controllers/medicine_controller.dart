import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/medicine_cart_model.dart';
import 'package:shebaone/models/medicine_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/models/pharmacy_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MedicineController extends GetxController {
  static MedicineController get to => Get.find();
  final Database database = Database();

  /// ***************************** Paginate item start *****************************

  ///Medicine add loading
  RxBool medicineOrderAddLoading = false.obs;

  ///Medicine next page url
  RxString medicineOrderNextPageUrl = ''.obs;

  ///Medicine current add loading
  RxBool medicineCurrentOrderAddLoading = false.obs;

  ///Medicine current next page url
  RxString medicineCurrentOrderNextPageUrl = ''.obs;

  ///Medicine previous add loading
  RxBool medicinePreviousOrderAddLoading = false.obs;

  ///Medicine previous next page url
  RxString medicinePreviousOrderNextPageUrl = ''.obs;

  /// ***************************** Paginate item end *****************************

  /// ------------------------------- USE FOR MEDICINE DATA --------------------------------///

  ///All Medicine List OBS
  RxList<MedicineModel> medicineList = <MedicineModel>[].obs;

  ///Get All Medicine List
  List<MedicineModel> get getMedicineList => medicineList;

  ///Next Page URL
  RxString nextPage = ''.obs;

  ///Home Page Loading for Medicine Section
  RxBool loading = false.obs;

  ///Loading for Medicine Pagination
  RxBool addLoading = false.obs;

  ///Loading for single Medicine Product
  RxBool productLoading = false.obs;

  ///Get Single Medicine Product
  Rx<MedicineModel> singleMedicine = MedicineModel().obs;

  ///Get Single Medicine Product
  MedicineModel get getSingleMedicineInfo => singleMedicine.value;

  /// ------------------------------- END USE FOR MEDICINE DATA --------------------------------///

  /// ------------------------------- USE FOR MEDICINE CART --------------------------------///

  /// Medicine Cart List
  RxList<MedicineCartModel> medicineCartList = <MedicineCartModel>[].obs;

  ///Get Medicine Cart List
  List<MedicineCartModel> get getMedicineCartList => medicineCartList;

  ///Cart Total Price
  RxString cartTotalPrice = ''.obs;

  ///Get Cart Total Price
  String get getCartTotalPrice => cartTotalPrice.value;

  /// ------------------------------- END USE FOR MEDICINE CART --------------------------------///

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
  RxBool medicineLiveSearchLoading = true.obs;

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

  ///Current Order list
  RxList<MedicineOrderModel> currentMedicineOrderList = <MedicineOrderModel>[].obs;

  ///Loading for Current Order Data
  RxBool currentOrderListLoading = false.obs;

  ///Previous Order list
  RxList<MedicineOrderModel> previousMedicineOrderList = <MedicineOrderModel>[].obs;

  ///Loading for Previous Order Data
  RxBool previousOrderListLoading = false.obs;

  ///Current Orders
  RxInt totalOrders = 0.obs;

  ///Current Orders
  RxInt currentOrders = 0.obs;

  ///Refer code
  RxString refferCode = ''.obs;

  ///Single Order Item list
  RxList<MedicineSingleOrderItemModel> medicineSingleOrderItemList = <MedicineSingleOrderItemModel>[].obs;

  /// ------------------------------- END USE FOR ORDER PAGE --------------------------------///

  /// ------------------------------- USE FOR SEARCH PAGE --------------------------------///

  ///List of Search Healthcare Data
  RxList<MedicineModel> medicineSearchList = <MedicineModel>[].obs;

  ///Loading for Order Data
  RxBool searchListLoading = false.obs;

  ///Loading for Order Data
  RxString nextPageSearch = ''.obs;

  /// ------------------------------- END USE FOR SEARCH PAGE --------------------------------///

  ///User Marker
  // Rx<Marker> userMarker = const Marker(markerId: MarkerId('user-marker')).obs;

  ///Pharmacy Marker
  // Rx<Marker> pharmacyMarker =
  //     const Marker(markerId: MarkerId('pharmacy-marker')).obs;

  @override
  void onReady() async {
    syncData();
    await getMedicine();
    super.onReady();
  }

  ///Get Medicine Data
  Future<void> getMedicine() async {
    try {
      if (nextPage.value.isEmpty) {
        loading.value = true;
        medicineList.value = await database.getMedicineData();
      } else {
        addLoading.value = true;
        print('Working...');
        final data = await database.getMedicineData(urlS: nextPage.value);
        medicineList.addAll(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    loading.value = false;
    addLoading.value = false;
  }

  ///Medicine Order List Get
  Future<void> getOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> info = [];
    if (isPaginate) {
      medicineOrderAddLoading(true);
    } else {
      orderListLoading(true);
    }
    try {
      info = await database.getMedicineOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      medicineOrderList.addAll(info);
      medicineOrderAddLoading(false);
    } else {
      medicineOrderList.value = info;
      orderListLoading(false);
    }
  }

  ///Medicine Order List Get
  Future<void> getPreviousOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> info = [];
    if (isPaginate) {
      medicinePreviousOrderAddLoading(true);
    } else {
      previousOrderListLoading(true);
    }
    try {
      info = await database.getPreviousMedicineOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      previousMedicineOrderList.addAll(info);
      medicinePreviousOrderAddLoading(false);
    } else {
      previousMedicineOrderList.value = info;
      previousOrderListLoading(false);
    }
  }

  ///Medicine Order List Get
  Future<void> getCurrentOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> info = [];
    if (isPaginate) {
      medicineCurrentOrderAddLoading(true);
    } else {
      currentOrderListLoading(true);
    }
    try {
      info = await database.getCurrentMedicineOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      currentMedicineOrderList.addAll(info);
      medicineCurrentOrderAddLoading(false);
    } else {
      currentMedicineOrderList.value = info;
      currentOrderListLoading(false);
    }
  }

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
  Future<void> getPharmacyListForLiveSearch(Map info) async {
    try {
      pharmacyListLoading.value = true;
      print('Working...');
      pharmacyList.value = [];
      processPharmacyDataList.value = [];
      final data = await database.pharmacyList(info);
      pharmacyList.addAll(data);
      List<Map<String, dynamic>> processData = [];
      for (var element in pharmacyList) {
        processData.add(processLiveSearchData(element));
      }
      // globalLogger.d(data);
      processPharmacyDataList.value = processData;
      // globalLogger.d(processPharmacyDataList, processData.length);
    } catch (e) {
      debugPrint(e.toString());
    }
    pharmacyListLoading.value = false;
  }

  Map<String, dynamic> processLiveSearchData(PharmacyModel pharmacyModel) {
    Map<String, dynamic> data = {
      "distance": pharmacyModel.distance,
      "user_id": UserController.to.getUserInfo.id,
      "contact_no": pharmacyModel.contactNo,
      "pharmacy_id": pharmacyModel.id,
      "pharmacy_name": pharmacyModel.pharmacyName,
      "latitude": pharmacyModel.latitude,
      "longitude": pharmacyModel.longitude,
    };

    List<Map> _cartItems = [];
    for (var element in medicineCartList) {
      final info = {
        "id": int.parse(element.id!),
        "name": element.name,
        "sell_price": int.parse(element.mrp!),
        "price": int.parse(element.mrp!),
        "discount": int.parse(element.offerPercentage!),
        "img": element.images!.isEmpty ? '' : element.images![0].imagePath!,
        "count": int.parse(element.userQuantity!), 
        "generic": element.generic == null ? '' : element.generic!.name,
        "strength": element.strength == null ? '' : element.strength!.name
      };
      _cartItems.add(info);
    }

    // String jsonStringMap = json.encode(_cartItems);
    data['medicine'] = _cartItems;
    return data;
  }

  ///Get Single Medicine Details
  Future<void> getSingleMedicine(String medicineId) async {
    try {
      productLoading.value = true;
      singleMedicine.value = await database.getSingleMedicine(medicineId: medicineId);
    } catch (e) {
      debugPrint(e.toString());
    }
    productLoading.value = false;
  }

  setConfirmPharmacyData(dynamic data) {
    // confirmationPharmacyData.value = data;
    globalLogger.d('ASCHE');
    List<Map<String, dynamic>> _availableMedicine = [];
    List<Map<String, dynamic>> _unavailableMedicine = [];
    for (int i = 0; i < data['medicinecartArray'].length; i++) {
      if (data['medicinecartArray'][i]['status'].toString().toLowerCase() == 'available') {
        _availableMedicine.add(data['medicinecartArray'][i]);
      } else {
        _unavailableMedicine.add(data['medicinecartArray'][i]);
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

  sendEmit(String key, dynamic emitValue) {
    socket.emit(key, emitValue);
  }

  RxBool notifyConfirmationToPharmacy = false.obs;
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

      globalLogger.d(info, "Medicine Order Info");
      globalLogger.d(socket.connected, "socket.connected");
      // if(socket.connected) {
      //   while(!notifyConfirmationToPharmacy.value) {
      //     sendEmit('sendChatToServer3', [info]);
      socket.disconnect();
      socket.dispose();
      // }
      // }else{
      socket.connect();
      socket.onConnect((_) {
        sendEmit('sendChatToServer3', [info]);
        socket.disconnect();
        socket.dispose();
      });
      // }
      getOrderList();
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
    storage.write('confirmationFromPharmacyData', confirmationPharmacyData);
    storage.write('orderSuccessData', orderSuccessData);
    storage.write('confirmOrderStatus', confirmOrderStatus.value);
  }

  void syncConfirmOrderStatusToLocal() {
    storage.write('confirmOrderStatus', confirmOrderStatus.value);
  }

  syncData() {
    if (storage.read('confirmationFromPharmacyData') == null) {
      storage.write('confirmationFromPharmacyData', {});
    }
    if (storage.read('orderSuccessData') == null) {
      storage.write('orderSuccessData', {});
    }
    if (storage.read('confirmOrderStatus') == null) {
      storage.write('confirmOrderStatus', false);
    }
    confirmationPharmacyData(storage.read('confirmationFromPharmacyData'));
    orderSuccessData(storage.read('orderSuccessData'));
    confirmOrderStatus(storage.read('confirmOrderStatus'));
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

  ///Medicine Cart Add update delete Function
  void addUpdateDeleteCart(MedicineCartModel medicineCartModel,
      {int? quantity, bool isReducing = false, bool isDeleting = false}) {
    bool isExist = false;
    bool isUpdating = false;
    bool isRemoveObjectCall = false;
    dynamic temp;
    if (storage.read('medicineCart') == null) {
      debugPrint('ok');
      storage.write('medicineCart', []);
    }
    List<dynamic> data = storage.read('medicineCart');
    int index = 0;
    int i = 0;
    for (var element in data) {
      MedicineCartModel cart = MedicineCartModel.fromJson(element);
      if (cart.id == medicineCartModel.id) {
        isExist = true;
        if (isDeleting) {
          isRemoveObjectCall = true;
          index = i;
          // temp = cart.toJson();
        } else if (isReducing) {
          if (cart.userQuantity == '1') {
            isRemoveObjectCall = true;
            // temp = cart.toJson();
            index = i;
          } else {
            cart.userQuantity = (int.parse(cart.userQuantity!) - 1).toString();
            isUpdating = true;
            temp = cart.toJson();
            index = i;
          }
        } else {
          cart.userQuantity = (int.parse(cart.userQuantity!) + (quantity ?? 1)).toString();
          isUpdating = true;
          temp = cart.toJson();
          index = i;

          // Fluttertoast.showToast(
          //     msg: "This Product is added in your Cart",
          //     toastLength: Toast.LENGTH_SHORT,
          //     gravity: ToastGravity.CENTER,
          //     timeInSecForIosWeb: 1,
          //     backgroundColor: kPrimaryColor,
          //     textColor: Colors.white,
          //     fontSize: 16.0);
        }
      }
      i++;
    }
    if (isRemoveObjectCall) {
      data.removeAt(index);

      Fluttertoast.showToast(
          msg: "This Medicine is removed from your cart!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (isUpdating) {
      data[index] = temp;
    }
    if (!isExist) {
      data.add(medicineCartModel.toJson());
      Fluttertoast.showToast(
          msg: "This Medicine is added in your Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    storage.write('medicineCart', data);
    syncMedicineCartData();
    // debugPrint(storage.read('healthcareCart'));
  }

  getTotal(List<MedicineCartModel> cartList) {
    cartTotalPrice.value = '0';
    double sum = 0.0;
    for (var cartItem in cartList) {
      sum = sum + (double.parse(cartItem.offerPrice!) * int.parse(cartItem.userQuantity!));
    }
    cartTotalPrice.value = sum.toStringAsFixed(2);
  }

  syncMedicineCartData() {
    medicineCartList.value = [];
    List<dynamic> data = storage.read('medicineCart') ?? [];
    for (var element in data) {
      medicineCartList.add(MedicineCartModel.fromJson(element));
    }
    getTotal(medicineCartList);
  }

  void deleteAllCart() {
    storage.write('medicineCart', []);
    syncMedicineCartData();
  }

  void setNextPageURL(String url) {
    nextPage.value = url;
    print(nextPage.value);
  }
}
