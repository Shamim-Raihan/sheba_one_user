import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/models/lab_cart_model.dart';
import 'package:shebaone/models/lab_model.dart';
import 'package:shebaone/models/lab_order_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';

class LabController extends GetxController {
  static LabController get to => Get.find();
  final Database database = Database();

  ///Refer code
  RxString refferCode = ''.obs;

  /// ***************************** Paginate item start *****************************

  ///Lab add loading
  RxBool labOrderAddLoading = false.obs;

  ///Lab next page url
  RxString labOrderNextPageUrl = ''.obs;

  ///Lab current add loading
  RxBool labCurrentOrderAddLoading = false.obs;

  ///Lab current next page url
  RxString labCurrentOrderNextPageUrl = ''.obs;

  ///Lab previous add loading
  RxBool labPreviousOrderAddLoading = false.obs;

  ///Lab previous next page url
  RxString labPreviousOrderNextPageUrl = ''.obs;

  /// ***************************** Paginate item end *****************************

  /// ------------------------------- USE FOR LAB DATA --------------------------------///

  ///All Lab List OBS
  RxList<LabModel> labList = <LabModel>[].obs;

  ///Single Lab test Lab List OBS
  RxList<LabModel> labListForSingleLab = <LabModel>[].obs;

  ///All Lab List OBS
  RxList<LabTestModel> labTestList = <LabTestModel>[].obs;

  ///All Lab Category List OBS
  RxList<LabTestCategoryModel> labTestCategoryList =
      <LabTestCategoryModel>[].obs;

  ///Single Lab Test
  Rx<LabTestModel> singleLabTest = LabTestModel().obs;

  ///All Lab Category Loading OBS
  RxBool labTestCategoryLoading = false.obs;

  ///All Lab Loading OBS
  RxBool labLoading = false.obs;

  ///Single Lab Test Lab Loading OBS
  RxBool labLoadingForSingleLabTest = false.obs;

  ///All Lab List Loading OBS
  RxBool labTestLoading = false.obs;

  ///Single Lab Loading OBS
  RxBool singleLabLoading = false.obs;

  /// ------------------------------- END USE FOR LAB DATA --------------------------------///

  /// ------------------------------- USE FOR SEARCH PAGE --------------------------------///

  ///List of Search Lab Data
  RxList<LabTestModel> labSearchList = <LabTestModel>[].obs;

  ///List of Search Lab Data by key
  RxList<LabTestModel> labSearchListByKey = <LabTestModel>[].obs;

  ///Loading for Order Data
  RxBool searchListLoading = false.obs;

  ///Loading for Search Data
  RxBool searchLoading = false.obs;

  ///Loading for Order Data
  RxString nextPageSearch = ''.obs;

  /// ------------------------------- END USE FOR SEARCH PAGE --------------------------------///

  /// ------------------------------- USE FOR LAB CART --------------------------------///

  /// Medicine Cart List
  RxList<LabCartModel> labCartList = <LabCartModel>[].obs;

  ///Get Medicine Cart List
  List<LabCartModel> get getLabCartList => labCartList;

  ///Cart Total Price
  RxString cartTotalPrice = ''.obs;

  ///Get Cart Total Price
  String get getCartTotalPrice => cartTotalPrice.value;

  /// ------------------------------- END USE FOR LAB CART --------------------------------///

  /// ------------------------------- USE FOR LAB ORDER --------------------------------///

  ///Payment Method info
  Rx<PaymentMethod> paymentMethod = PaymentMethod.cod.obs;

  ///orderSuccessData
  RxMap orderSuccessData = {}.obs;

  /// ------------------------------- END USE FOR LAB ORDER --------------------------------///

  /// ------------------------------- USE FOR ORDER PAGE --------------------------------///

  ///Order list
  RxList<LabOrderModel> labOrderList = <LabOrderModel>[].obs;

  ///Loading for Order Data
  RxBool orderListLoading = false.obs;

  ///Previous Order list
  RxList<LabOrderModel> previousLabOrderList = <LabOrderModel>[].obs;

  ///Previous Loading for Order Data
  RxBool previousOrderListLoading = false.obs;

  ///Current Order list
  RxList<LabOrderModel> currentLabOrderList = <LabOrderModel>[].obs;

  ///Current Loading for Order Data
  RxBool currentOrderListLoading = false.obs;

  ///Current Orders
  RxInt currentOrders = 0.obs;

  ///Total Orders
  RxInt totalOrders = 0.obs;

  RxList categoryWiseLabTestList = [].obs;

  /// ------------------------------- END USE FOR ORDER PAGE --------------------------------///

  @override
  void onReady() async {
    syncLabCartData();
    await getCategoryWiseTestList();
    await getLabCategoryList();
    await getLabList();
    super.onReady();
  }

  ///Lab Search List Get
  Future<void> getSearchList(String keyword,
      {bool paginateCall = false}) async {
    if (paginateCall) {
      searchListLoading(true);
      try {
        await database.getLabSearchList(nextPageSearch.value,
            paginateCall: paginateCall);
      } catch (e) {
        debugPrint(e.toString());
      }
      searchListLoading(false);
    } else {
      searchLoading(true);
      try {
        await database.getLabSearchList(keyword);
      } catch (e) {
        debugPrint(e.toString());
      }
      searchLoading(false);
    }
  }

  ///Lab Search List Get
  Future<void> getSearchListByKey(String keyword) async {
    searchListLoading(true);
    await database.getLabSearchListByKey(keyword);
    searchLoading(false);
  }

  ///Lab Order List Get
  Future<void> getOrderList({bool isPaginate = false}) async {
    List<LabOrderModel> info = [];
    if (isPaginate) {
      labOrderAddLoading(true);
    } else {
      orderListLoading(true);
    }
    try {
      info = await database.getLabOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      labOrderList.addAll(info);
      labOrderAddLoading(false);
    } else {
      labOrderList.value = info;
      orderListLoading(false);
    }
  }

  /// Category wise Lab List Get
  Future<void> getCategoryWiseTestList() async {
    try {
      final data = await database.getCategoryWithTestList();
      data.forEach((e) {
        if (e['get_one_lab_test'] != null) {
          dynamic info = {};
          info.addAll(e['get_one_lab_test']);
          info['max_offer'] = e['max_offer'];
          categoryWiseLabTestList.add(info);
        }
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Previous Lab Order List Get
  Future<void> getPreviousOrderList({bool isPaginate = false}) async {
    List<LabOrderModel> info = [];
    if (isPaginate) {
      labPreviousOrderAddLoading(true);
    } else {
      previousOrderListLoading(true);
    }
    try {
      info = await database.getPreviousLabOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      previousLabOrderList.addAll(info);
      labPreviousOrderAddLoading(false);
    } else {
      previousLabOrderList.value = info;
      previousOrderListLoading(false);
    }
  }

  ///Current Lab Order List Get
  Future<void> getCurrentOrderList({bool isPaginate = false}) async {
    List<LabOrderModel> info = [];
    if (isPaginate) {
      labCurrentOrderAddLoading(true);
    } else {
      currentOrderListLoading(true);
    }
    try {
      info = await database.getCurrentLabOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      currentLabOrderList.addAll(info);
      labCurrentOrderAddLoading(false);
    } else {
      currentLabOrderList.value = info;
      currentOrderListLoading(false);
    }
  }

  Future<bool> orderLabTests(dynamic info) async {
    final data = await database.orderLabTests(info);
    if (data.runtimeType == bool) {
      return false;
    } else {
      orderSuccessData.value = data;
      return true;
    }
  }

  ///Get Lab Category List Data
  Future<void> getLabCategoryList() async {
    try {
      labTestCategoryLoading.value = true;
      labTestCategoryList.value = await database.getLabTestCategoryData();
    } catch (e) {
      debugPrint(e.toString());
    }
    labTestCategoryLoading.value = false;
  }

  ///Get Lab List Data
  Future<void> getLabList() async {
    try {
      labLoading.value = true;
      labList.value = await database.getLabData();
    } catch (e) {
      debugPrint(e.toString());
    }
    labLoading.value = false;
  }

  ///Get Lab List For Single Test Data
  Future<void> getFilterLabData(String testId) async {
    try {
      labLoadingForSingleLabTest.value = true;
      labListForSingleLab.value = await database.getFilterLabData(testId);
    } catch (e) {
      debugPrint(e.toString());
    }
    labLoadingForSingleLabTest.value = false;
  }

  ///Get Lab List Data
  Future<void> getLabListCategory(String categoryId) async {
    try {
      labTestLoading.value = true;
      labTestList.value = await database.getLabTestData(categoryId);
    } catch (e) {
      debugPrint(e.toString());
    }
    labTestLoading.value = false;
  }

  ///Get Single Lab Data
  Future<void> getSingleLabTest(String testId) async {
    try {
      singleLabLoading.value = true;
      singleLabTest.value = await database.getSingleLabData(testId);
    } catch (e) {
      debugPrint(e.toString());
    }
    singleLabLoading.value = false;
  }

  ///Medicine Cart Add update delete Function
  void addUpdateDeleteCart(LabCartModel labCartModel,
      {bool isReducing = false, bool isDeleting = false}) {
    bool isExist = false;
    bool isUpdating = false;
    bool isRemoveObjectCall = false;
    dynamic temp;
    if (storage.read('labCart') == null) {
      debugPrint('ok');
      storage.write('labCart', []);
    }
    List<dynamic> data = storage.read('labCart');
    int index = 0;
    int i = 0;
    for (var element in data) {
      LabCartModel cart = LabCartModel.fromJson(element);
      if (cart.id == labCartModel.id) {
        isExist = true;
        if (isDeleting) {
          isRemoveObjectCall = true;
          index = i;
          // temp = cart.toJson();
        }
      }
      i++;
    }
    if (isRemoveObjectCall) {
      data.removeAt(index);

      Fluttertoast.showToast(
          msg: "This Test is removed from your cart!",
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
      data.add(labCartModel.toJson());
      Fluttertoast.showToast(
          msg: "This Test is added in your Cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: "Already you have this test item in your cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.redAccent,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    storage.write('labCart', data);
    syncLabCartData();
    // debugPrint(storage.read('healthcareCart'));
  }

  getTotal(List<LabCartModel> cartList) {
    cartTotalPrice.value = '0';
    double sum = 0.0;
    for (var cartItem in cartList) {
      sum = sum + double.parse(cartItem.labPrice!);
    }
    cartTotalPrice.value = sum.toStringAsFixed(2);
  }

  syncLabCartData() {
    labCartList.value = [];
    List<dynamic> data = storage.read('labCart') ?? [];
    for (var element in data) {
      labCartList.add(LabCartModel.fromJson(element));
    }
    getTotal(labCartList);
  }

  void deleteAllCart() {
    storage.write('labCart', []);
    syncLabCartData();
  }
}
