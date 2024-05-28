import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/healthcare_cart_model.dart';
import 'package:shebaone/models/healthcare_category_model.dart';
import 'package:shebaone/models/healthcare_order_model.dart';
import 'package:shebaone/models/healthcare_product_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/models/pharmacy_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/local_file.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:socket_io_client/socket_io_client.dart';

class HealthCareController extends GetxController {
  static HealthCareController get to => Get.find();
  final Database database = Database();
  //Local Database
  final LocalFileDatabase localFileDatabase = LocalFileDatabase();

  /// ***************************** Paginate item start *****************************

  ///Healthcare add loading
  RxBool healthcareOrderAddLoading = false.obs;

  ///Healthcare next page url
  RxString healthcareOrderNextPageUrl = ''.obs;

  ///Healthcare current add loading
  RxBool healthcareCurrentOrderAddLoading = false.obs;

  ///Healthcare current next page url
  RxString healthcareCurrentOrderNextPageUrl = ''.obs;

  ///Healthcare previous add loading
  RxBool healthcarePreviousOrderAddLoading = false.obs;

  ///Healthcare previous next page url
  RxString healthcarePreviousOrderNextPageUrl = ''.obs;

  /// ***************************** Paginate item end *****************************

  /// ------------------------------- USE FOR HEALTHCARE PRODUCT --------------------------------///

  /// Use For healthcare product list hold
  RxList<HealthCareProductModel> healthcareProductList = <HealthCareProductModel>[].obs;

  /// Use For category wise healthcare product list hold
  RxList<HealthCareProductModel> healthcareCategoryProductList = <HealthCareProductModel>[].obs;

  /// Use For single product hold
  Rx<HealthCareProductModel> singleProduct = HealthCareProductModel().obs;

  /// Use For category list hold
  RxList<HealthCareCategoryModel> healthcareCategoryList = <HealthCareCategoryModel>[].obs;

  /// Use For category list hold
  RxList<dynamic> healthcareBrandList = <dynamic>[].obs;

  /// Use For sub category list hold
  RxList<HealthCareCategoryModel> healthcareSubCategoryList = <HealthCareCategoryModel>[].obs;

  /// Use For category wise healthcare product list hold
  RxList<Map> categoryWiseData = <Map>[].obs;

  /// Use For pagination
  RxString nextPage = ''.obs;

  /// Use For category wise pagination
  RxString categoryNextPage = ''.obs;

  /// Use For home page loading
  RxBool loading = false.obs;

  /// Use For pagination loading
  RxBool addLoading = false.obs;

  /// Use For category wise pagination loading
  RxBool categoryLoading = false.obs;

  /// Use For sub category wise loading
  RxBool subCategoryLoading = false.obs;

  /// Use For single product loading
  RxBool productLoading = false.obs;

  ///orderSuccessData
  RxMap orderSuccessData = {}.obs;

  /// Use For Get Product Details
  HealthCareProductModel get getSingleProductInfo => singleProduct.value;

  /// Use For Get Product List
  List<HealthCareProductModel> get getHealthcareProductList => healthcareProductList;

  /// Use For Get Category List
  List<HealthCareCategoryModel> get getHealthcareCategoryList => healthcareCategoryList;

  /// Use For Get sub Category List
  List<HealthCareCategoryModel> get getHealthcareSubCategoryList => healthcareSubCategoryList;

  /// Use For Get Product List
  List<HealthCareProductModel> get getHealthcareCategoryProductList => healthcareCategoryProductList;

  /// Use For Get pagination URL
  String get getNextPageURL => nextPage.value;

  /// Use For Get category wise data
  List<Map> get getCategoryWiseData => categoryWiseData;

  /// ------------------------------- END USE FOR HEALTHCARE PRODUCT --------------------------------///

  /// ------------------------------- USE FOR CART --------------------------------///

  ///Cart Total Price
  RxString cartTotalPrice = ''.obs;

  ///Get Cart Total Price
  String get getCartTotalPrice => cartTotalPrice.value;

  /// Use For Healthcare Product Cart List
  RxList<HealthCareCartModel> healthcareCartList = <HealthCareCartModel>[].obs;

  /// Use For Healthcare Product Live Cart List
  RxList<HealthCareCartModel> healthcareLiveCartList = <HealthCareCartModel>[].obs;

  /// ------------------------------- END USE FOR CART --------------------------------///

  /// ------------------------------- USE FOR CITY LIST --------------------------------///

  ///Get Districts data
  RxList<String> citys = <String>[].obs;

  ///Get City data
  RxList<String> areas = <String>[].obs;

  /// ------------------------------- END USE FOR CITY LIST --------------------------------///

  /// Use For Get CART List
  List<HealthCareCartModel> get getHealthcareCartList => healthcareCartList;

  /// Use For Get CART List
  List<HealthCareCartModel> get getHealthcareLiveCartList => healthcareLiveCartList;

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
  RxMap orderSuccessDataForLive = {}.obs;

  ///Payment Method info
  Rx<PaymentMethod> paymentMethod = PaymentMethod.cod.obs;

  ///Loading for single Medicine Product
  RxBool healthcareLiveSearchLoading = true.obs;

  ///Confirm Order
  RxBool confirmOrderStatus = false.obs;

  ///timer bool
  RxBool timerStatus = false.obs;

  ///timer time
  RxInt time = 0.obs;

  ///Distance time
  RxString distanceTime = ''.obs;

  ///Refer code
  RxString refferCode = ''.obs;

  /// ------------------------------- END USE FOR LIVE SEARCH --------------------------------///

  /// ------------------------------- USE FOR ORDER PAGE --------------------------------///

  ///List of Order Data
  RxList<MedicineOrderModel> healthcareOrderList = <MedicineOrderModel>[].obs;

  ///List of Order Data
  RxList<MedicineOrderModel> healthcareCurrentOrderList = <MedicineOrderModel>[].obs;

  ///List of Order Data
  RxList<MedicineOrderModel> healthcarePreviousOrderList = <MedicineOrderModel>[].obs;

  ///Current Orders
  RxInt currentOrders = 0.obs;

  ///Current Orders
  RxInt totalOrders = 0.obs;

  ///Loading for Order Data
  RxBool orderListLoading = false.obs;

  ///Loading for Order Data
  RxBool currentOrderListLoading = false.obs;

  ///Loading for Order Data
  RxBool previousOrderListLoading = false.obs;

  ///List of Order Data
  RxList<HealthcareSingleOrderModel> healthcareSingleOrderDetailsList = <HealthcareSingleOrderModel>[].obs;


  /// ------------------------------- END USE FOR ORDER PAGE --------------------------------///

  /// ------------------------------- USE FOR SEARCH PAGE --------------------------------///

  ///List of Search Healthcare Data
  RxList<HealthCareProductModel> healthcareSearchList = <HealthCareProductModel>[].obs;

  ///Loading for Order Data
  RxBool searchListLoading = false.obs;

  ///Loading for Order Data
  RxString nextPageSearch = ''.obs;

  /// ------------------------------- END USE FOR SEARCH PAGE --------------------------------///

  /// ------------------------------- USE FOR FILTER --------------------------------///

  ///List of CHECK category
  RxList<bool> categoryCheckList = <bool>[].obs;

  ///List of CHECK sub category
  RxList<bool> subCategoryCheckList = <bool>[].obs;

  ///List of CHECK brand
  RxList<bool> brandCheckList = <bool>[].obs;

  ///Apply Filter
  RxBool isApplyFilter = false.obs;

  ///Apply Filter
  RxBool isApplyFilterInCategoryDetails = false.obs;

  ///price type
  Rx<PriceType> priceType = PriceType.two_50.obs;

  ///Loading for Pagination Data
  RxBool filterAddLoading = false.obs;

  ///Loading for Search Data
  RxBool filterLoading = false.obs;

  ///Loading for Search Data
  RxString nextPageFilter = ''.obs;

  /// Use For healthcare product list hold
  RxList<HealthCareProductModel> healthcareFilterList = <HealthCareProductModel>[].obs;

  /// ------------------------------- END USE FOR FILTER --------------------------------///

  @override
  void onReady() async {
    syncData();
    await getProduct();
    await getCityList();
    await getBrand();
    super.onReady();
  }

  ///Get Pharmacy List For Live Search
  Future<void> getPharmacyListForLiveSearch(Map info) async {
    try {
      pharmacyListLoading.value = true;
      globalLogger.d('Working...');
      pharmacyList.value = [];
      processPharmacyDataList.value = [];
      final data = await database.healthStoreList(info);

      pharmacyList.addAll(data);
      globalLogger.d(pharmacyList);
      List<Map<String, dynamic>> processData = [];
      for (var element in pharmacyList) {
        processData.add(processLiveSearchData(element));
      }
      globalLogger.d(processData, 'processData');
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
    for (var element in healthcareLiveCartList) {
      final info = {
        "id": element.id,
        "name": element.name,
        // "price": element.mrp,
        // "mrp": element.mrp,
        // "discount": (double.parse(element.mrp!) *  double.parse(element.offerPercentage!)/100).toStringAsFixed(2),
        "price": element.offerPrice,
        "qty": element.userQuantity,
        "product_img": element.images!.isNotEmpty ? element.images![0].imagePath! : '',
      };
      _cartItems.add(info);
    }

    // String jsonStringMap = json.encode(_cartItems);
    data['medicine'] = _cartItems;

    return data;
  }

  setConfirmPharmacyData(dynamic data) {
    globalLogger.d('ASCHE');
    List<Map<String, dynamic>> _availableMedicine = [];
    List<Map<String, dynamic>> _unavailableMedicine = [];
    for (int i = 0; i < data['available'].length; i++) {
      if (data['available'][i].toString().toLowerCase() == 'available') {
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
      'rating': data['rating'],
      'delivery_charge': data['delivery_charge'],
      'available': _availableMedicine,
      'unavailable': _unavailableMedicine,
      'order_type': _unavailableMedicine.isEmpty ? 'full' : 'partial',
    };
  }

  removeLiveSearchInfo() {
    confirmationPharmacyData({});
    orderSuccessData({});
    confirmOrderStatus(false);
    syncDataFromPharmacy();
    AuthController.to.emptyDeliveryProcess();
  }

  void syncDataFromPharmacy() {
    storage.write('confirmationFromPharmacyHealthcare', confirmationPharmacyData);
    storage.write('orderSuccessHealthcareData', orderSuccessData);
    storage.write('confirmOrderStatusHealthcare', confirmOrderStatus.value);
  }

  void syncConfirmOrderStatusToLocal() {
    storage.write('confirmOrderStatusHealthcare', confirmOrderStatus.value);
  }

  void syncConfirmationPharmacyDataToLocal() {
    storage.write('confirmationFromPharmacyHealthcare', confirmationPharmacyData);
  }

  syncData() {
    syncHealthcareCartData();
    syncHealthcareLiveCartData();

    if (storage.read('confirmationFromPharmacyHealthcare') == null) {
      storage.write('confirmationFromPharmacyHealthcare', {});
    }
    if (storage.read('orderSuccessHealthcareData') == null) {
      storage.write('orderSuccessHealthcareData', {});
    }
    if (storage.read('confirmOrderStatusHealthcare') == null) {
      storage.write('confirmOrderStatusHealthcare', false);
    }
    confirmationPharmacyData(storage.read('confirmationFromPharmacyHealthcare'));
    orderSuccessData(storage.read('orderSuccessHealthcareData'));
    confirmOrderStatus(storage.read('confirmOrderStatusHealthcare'));
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

  ///Get Next Page Product For Healthcare Product
  Future<void> getProduct() async {
    try {
      if (nextPage.value.isEmpty) {
        loading.value = true;
        healthcareProductList.value = await database.getHomeHeathCareProducts();
      } else {
        addLoading.value = true;
        print('Working...');
        final data = await database.getHomeHeathCareProducts(urlS: nextPage.value);
        healthcareProductList.addAll(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    loading.value = false;
    addLoading.value = false;
  }

  ///Get Next Page Product in specific category
  Future<void> getNextProduct() async {
    try {
      addLoading.value = true;
      print('categoryNextPage.value');
      print(categoryNextPage.value);
      final data = await database.getHeathCareCategoryProducts(urlS: categoryNextPage.value);
      healthcareCategoryProductList.addAll(data);
    } catch (e) {
      debugPrint(e.toString());
    }
    addLoading.value = false;
  }

  Future<void> getCategory(int isWomenRelated, int isFitnessRelated) async {
    categoryLoading.value = true;
    healthcareCategoryList.value = [];
    categoryCheckList.value = [];
    try {
      healthcareCategoryList.value = await database.getHomeHeathCareCategories(isWomenRelated, isFitnessRelated);
      for (var element in healthcareCategoryList) {
        categoryCheckList.add(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    categoryLoading.value = false;
  }

  ///Brand
  Future<void> getBrand() async {
    healthcareBrandList.value = [];
    brandCheckList.value = [];
    try {
      healthcareBrandList.value = await database.getHomeHeathCareBrands();
      for (var element in healthcareBrandList) {
        brandCheckList.add(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Filter Process DATA
  Future<void> getFilterProductList({bool paginateCall = false}) async {
    if (paginateCall) {
      filterAddLoading(true);
      try {
        await database.getHealthcareFilterList(paginateCall: paginateCall);
      } catch (e) {
        debugPrint(e.toString());
      }
      filterAddLoading(false);
    } else {
      filterLoading(true);
      healthcareFilterList.value = [];
      try {
        await database.getHealthcareFilterList();
      } catch (e) {
        debugPrint(e.toString());
      }
      filterLoading(false);
    }
  }

  Map processFilterData() {
    Map data = {};
    List<String> _list = [];
    for (int i = 0; i < getHealthcareSubCategoryList.length; i++) {
      if (subCategoryCheckList[i]) {
        _list.add(getHealthcareSubCategoryList[i].id!);
      }
    }
    data['subcategory_id'] = json.encode(_list);
    List<String> _brandList = [];
    for (int i = 0; i < healthcareBrandList.length; i++) {
      if (brandCheckList[i]) {
        _brandList.add(healthcareBrandList[i]['id'].toString());
      }
    }
    data['brand_id'] = _brandList.isEmpty ? json.encode([""]) : json.encode(_brandList);
    data['price_rang'] = json.encode([
      priceType.value == PriceType.two_50
          ? '250'
          : priceType.value == PriceType.five_100
              ? '500'
              : '100000'
    ]);
    return data;
  }

  ///Healthcare Order List Get
  Future<void> getOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> info = [];
    if (isPaginate) {
      healthcareOrderAddLoading(true);
    } else {
      orderListLoading(true);
    }
    globalLogger.d(healthcareOrderAddLoading, 'Paginate VAlue');
    try {
      info = await database.getHomeHeathCareOrderList(isPaginate: isPaginate);
      globalLogger.d(healthcareOrderList.length, 'Healthcare order');
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      healthcareOrderList.addAll(info);
      healthcareOrderAddLoading(false);
    } else {
      healthcareOrderList.value = info;
      orderListLoading(false);
    }
    globalLogger.d(healthcareOrderAddLoading, 'Paginate VAlue');
  }

  ///Healthcare Previous Order List Get
  Future<void> getPreviousOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> info = [];
    if (isPaginate) {
      healthcarePreviousOrderAddLoading(true);
    } else {
      previousOrderListLoading(true);
    }
    try {
      info = await database.getHomeHeathCarePreviousOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      healthcarePreviousOrderList.addAll(info);
      healthcarePreviousOrderAddLoading(false);
    } else {
      healthcarePreviousOrderList.value = info;
      previousOrderListLoading(false);
    }
  }

  ///Healthcare Current Ordet List Get
  Future<void> getCurrentOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> info = [];
    if (isPaginate) {
      healthcareCurrentOrderAddLoading(true);
    } else {
      currentOrderListLoading(true);
    }
    try {
      info = await database.getHomeHeathCareCurrentOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      healthcareCurrentOrderList.addAll(info);
      healthcareCurrentOrderAddLoading(false);
    } else {
      healthcareCurrentOrderList.value = info;
      currentOrderListLoading(false);
    }
  }

  ///Healthcare Single Order item List Get
  Future<void> getSingleOrderDetailsList(String orderId) async {
    HomeController.to.orderDetailsLoading(true);
    try {
      healthcareSingleOrderDetailsList.value = await database.getHeathCareSingleOrderDetailsList(orderId);
    } catch (e) {
      debugPrint(e.toString());
    }
    HomeController.to.orderDetailsLoading(false);
  }

  Future<void> getSubCategory(String categoryId) async {
    subCategoryLoading.value = true;
    healthcareSubCategoryList.value = [];
    subCategoryCheckList.value = [];
    try {
      healthcareSubCategoryList.value = await database.getHomeHeathCareSubCategories(categoryId);
      for (var element in healthcareSubCategoryList) {
        subCategoryCheckList.add(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    subCategoryLoading.value = false;
  }

  Future<List<HealthCareProductModel>> getCategoryProduct(String categoryId, int index) async {
    if (categoryWiseData[index][categoryId] != null && categoryWiseData[index][categoryId].isNotEmpty) {
      return categoryWiseData[index][categoryId];
    }
    print(categoryWiseData[index][categoryId]);
    categoryWiseData[index]['loading'] = true;
    print(categoryWiseData[index]['loading']);
    List<HealthCareProductModel> data = await database.getCategoryWiseHomeHeathCareProducts(categoryId, index);
    categoryWiseData[index][categoryId] = data;

    return data;
  }

  Future<void> getSingleCategoryProduct(String categoryId) async {
    addLoading.value = true;
    healthcareCategoryProductList.value = await database.getHeathCareCategoryProducts(categoryId: categoryId);
    addLoading.value = false;
  }

  Future<void> getSingleProduct(String productId) async {
    productLoading.value = true;
    singleProduct.value = await database.getSingleProduct(productId: productId);
    productLoading.value = false;
  }

  void addUpdateDeleteCart(HealthCareCartModel healthCareCartModel,
      {int? quantity, bool isReducing = false, bool isDeleting = false}) {
    bool isExist = false;
    bool isUpdating = false;
    bool isRemoveObjectCall = false;
    dynamic temp;
    if (storage.read('healthcareCart') == null) {
      debugPrint('ok');
      storage.write('healthcareCart', []);
    }
    List<dynamic> data = storage.read('healthcareCart');
    int index = 0;
    int i = 0;
    for (var element in data) {
      HealthCareCartModel cart = HealthCareCartModel.fromJson(element);
      if (cart.id == healthCareCartModel.id) {
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
          if (int.parse(cart.quantity!) > int.parse(cart.userQuantity!)) {
            cart.userQuantity = (int.parse(cart.userQuantity!) + (quantity ?? 1)).toString();
            isUpdating = true;
            temp = cart.toJson();
            index = i;
          } else {
            Get.defaultDialog(
                content: const Text(
                  'This product is not available at ShebaOne store. If you need more then go for live search.',
                  textAlign: TextAlign.center,
                ),
                actions: [
                  PrimaryButton(
                    label: 'Add to Cart for Search',
                    marginVertical: 16,
                    onPressed: () async {
                      Get.back();
                      print('Add to cart');

                      // HealthCareCartModel cartModel = HealthCareCartModel.fromJson(info.toJson());
                      // cartModel.userQuantity = '1';
                      // print('ok');
                      HealthCareController.to.addUpdateDeleteLiveCart(cart);
                      // print('live search');
                      // if (HealthCareController.to.confirmOrderStatus.value ||
                      //     MedicineController.to.confirmOrderStatus.value) {
                      //   Fluttertoast.showToast(
                      //       msg: "Already You have one live search running!",
                      //       toastLength: Toast.LENGTH_SHORT,
                      //       gravity: ToastGravity.CENTER,
                      //       timeInSecForIosWeb: 1,
                      //       backgroundColor: Colors.redAccent,
                      //       textColor: Colors.white,
                      //       fontSize: 16.0);
                      // } else {
                      //   HomeController.to.cartType(CartType.healthcare);
                      //   final data = await HomeController.to.getPosition();
                      //   globalLogger.d(data);
                      //   if (data) {
                      //     HealthCareController.to.getSingleProduct(cart.id!);
                      //     // HealthCareController.to.confirmOrderStatus(false);
                      //     // HealthCareController.to
                      //     //     .syncConfirmOrderStatusToLocal();
                      //
                      //     HomeController.to.liveSearchType(LiveSearchType.healthcare);
                      //     final dataL = await Get.toNamed(LogInCheckLiveMapPage.routeName);
                      //     if (dataL == null) {
                      //       HomeController.to.liveSearchType(LiveSearchType.none);
                      //     }
                      //   }
                      // }
                    },
                  ),
                ]);
          }
        }
      }
      i++;
    }
    if (isRemoveObjectCall) {
      data.removeAt(index);

      Fluttertoast.showToast(
          msg: "This Product is removed from your cart!",
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
      data.add(healthCareCartModel.toJson());
      Fluttertoast.showToast(
          msg: "This Product is added in your Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    storage.write('healthcareCart', data);
    syncHealthcareCartData();
    // debugPrint(storage.read('healthcareCart'));
  }

  syncHealthcareCartData() {
    healthcareCartList.value = [];
    List<dynamic> data = storage.read('healthcareCart') ?? [];
    if (data != null) {
      for (var element in data) {
        healthcareCartList.add(HealthCareCartModel.fromJson(element));
      }
    }
    getTotal(healthcareCartList);
  }

  getTotal(List<HealthCareCartModel> cartList) {
    cartTotalPrice.value = '0';
    double sum = 0.0;
    for (var cartItem in cartList) {
      sum = sum + (double.parse(cartItem.offerPrice!) * int.parse(cartItem.userQuantity!));
    }
    cartTotalPrice.value = sum.toStringAsFixed(2);
  }

  void deleteAllCart() {
    storage.write('healthcareCart', []);
    syncHealthcareCartData();
  }

  void addUpdateDeleteLiveCart(HealthCareCartModel healthCareCartModel,
      {int? quantity, bool isReducing = false, bool isDeleting = false}) {
    bool isExist = false;
    bool isUpdating = false;
    bool isRemoveObjectCall = false;
    dynamic temp;
    if (storage.read('healthcareLiveCart') == null) {
      debugPrint('ok');
      storage.write('healthcareLiveCart', []);
    }
    List<dynamic> data = storage.read('healthcareLiveCart');
    int index = 0;
    int i = 0;
    for (var element in data) {
      HealthCareCartModel cart = HealthCareCartModel.fromJson(element);
      if (cart.id == healthCareCartModel.id) {
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
          // if (int.parse(cart.quantity!) > int.parse(cart.userQuantity!)) {
          cart.userQuantity = (int.parse(cart.userQuantity!) + (quantity ?? 1)).toString();
          isUpdating = true;
          temp = cart.toJson();
          index = i;
          // } else {
          //   Get.defaultDialog(
          //       content: const Text(
          //         'This product is not available at ShebaOne store. If you need more then go for live search.',
          //         textAlign: TextAlign.center,
          //       ),
          //       actions: [
          //         PrimaryButton(
          //           label: 'Search Nearby Store',
          //           marginVertical: 16,
          //           onPressed: () async {
          //             Get.back();
          //             print('live search');
          //             if (HealthCareController.to.confirmOrderStatus.value ||
          //                 MedicineController.to.confirmOrderStatus.value) {
          //               Fluttertoast.showToast(
          //                   msg: "Already You have one live search running!",
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.CENTER,
          //                   timeInSecForIosWeb: 1,
          //                   backgroundColor: Colors.redAccent,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0);
          //             } else {
          //               HomeController.to.cartType(CartType.healthcare);
          //               final data = await HomeController.to.getPosition();
          //               globalLogger.d(data);
          //               if (data) {
          //                 HealthCareController.to.getSingleProduct(cart.id!);
          //                 // HealthCareController.to.confirmOrderStatus(false);
          //                 // HealthCareController.to
          //                 //     .syncConfirmOrderStatusToLocal();
          //
          //                 HomeController.to.liveSearchType(LiveSearchType.healthcare);
          //                 final dataL = await Get.toNamed(LogInCheckLiveMapPage.routeName);
          //                 if (dataL == null) {
          //                   HomeController.to.liveSearchType(LiveSearchType.none);
          //                 }
          //               }
          //             }
          //           },
          //         ),
          //       ]);
          // }
        }
      }
      i++;
    }
    if (isRemoveObjectCall) {
      data.removeAt(index);

      Fluttertoast.showToast(
          msg: "This Product is removed from your cart!",
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
      data.add(healthCareCartModel.toJson());
      Fluttertoast.showToast(
          msg: "This Product is added in your Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    storage.write('healthcareLiveCart', data);
    syncHealthcareLiveCartData();
    // debugPrint(storage.read('healthcareLiveCart'));
  }

  syncHealthcareLiveCartData() {
    healthcareLiveCartList.value = [];
    List<dynamic> data = storage.read('healthcareLiveCart') ?? [];
    if (data != null) {
      for (var element in data) {
        healthcareLiveCartList.add(HealthCareCartModel.fromJson(element));
      }
    }
    getTotal(healthcareLiveCartList);
  }

  getLiveTotal(List<HealthCareCartModel> cartList) {
    cartTotalPrice.value = '0';
    double sum = 0.0;
    for (var cartItem in cartList) {
      sum = sum + (double.parse(cartItem.offerPrice!) * int.parse(cartItem.userQuantity!));
    }
    cartTotalPrice.value = sum.toStringAsFixed(2);
  }

  void deleteAllLiveCart() {
    storage.write('healthcareLiveCart', []);
    syncHealthcareLiveCartData();
  }

  changeLoading(bool loading, int index, String categoryId) {
    categoryWiseData[index] = {'loading': false, categoryId: []};
  }

  getCityList() async {
    citys.value = [];
    final data = await localFileDatabase.loadData('districts');
    data.forEach((city) {
      citys.add(city['name']);
    });
    globalLogger.d(data);
  }

  Future<List<String>> getAreaList(String cityS) async {
    areas.value = [];
    final data = await localFileDatabase.loadData('citys', city: cityS);
    data.forEach((area) {
      areas.add(area['name']);
    });
    if (areas.isEmpty) {
      areas.add(cityS);
    }
    return areas;
  }

  sendEmit(String key, dynamic emitValue) {
    socket.emit(key, emitValue);
  }

  Future<bool> orderHealthcareProduct(dynamic info, LiveSearchType liveSearch) async {
    final data = liveSearch == LiveSearchType.none
        ? await database.orderHealthcareProduct(info)
        : await database.orderHealthcareProductLive(info);
    globalLogger.d(data, 'Healthcare Live Search');
    if (data.runtimeType == bool) {
      return false;
    } else {
      globalLogger.d(liveSearch, 'Healthcare Live Search');
      orderSuccessData.value = data;
      if (LiveSearchType.healthcare == liveSearch) {
        dynamic info = {
          "order_status": "order_confirm",
          "order_amount": data['order_amount'],
          "order_id": data['order_id'],
          "order_date": DateFormat.MMMEd().format(DateTime.parse(data['created_at'])),
          "pharmacy_mobile": confirmationPharmacyData['pharmacy_mobile']
        };
        orderInfoConfirm = info;
        globalLogger.d(info, 'Healthcare Live Search');
        globalLogger.d(socket.connected, 'Healthcare Live Search');
        Future.delayed(Duration(seconds: 1), () {
          socket.disconnect();
          socket.dispose();
          socket.connect();
          socket.onConnect((_) {
            sendEmit('sendChatToServer3', [info]);
            socket.disconnect();
            socket.dispose();
          });
        });
      }
      getOrderList();
      return true;
    }
  }

  void setNextPageURL(String url) {
    nextPage.value = url;
    print(nextPage.value);
  }

  void setCategoryNextPageURL(String url) {
    categoryNextPage.value = url;
    print(categoryNextPage.value);
  }
}
