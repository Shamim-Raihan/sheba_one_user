import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/user_model.dart';
import 'package:shebaone/pages/cart/ui/place_order_screen.dart';
import 'package:shebaone/pages/cart/ui/purchase_done_screen.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/profile/ui/update_profile_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/ssl.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class BillingScreen extends StatefulWidget {
  const BillingScreen({Key? key}) : super(key: key);
  static String routeName = '/BillingScreen';

  @override
  State<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  TextEditingController? _nameController;
  TextEditingController? _mobileController;
  TextEditingController? _addressController;
  TextEditingController? _emailController;
  FocusNode? _nameFocusNode;
  FocusNode? _mobileFocusNode;
  FocusNode? _addressFocusNode;
  FocusNode? _emailFocusNode;
  TextEditingController? _cityController;
  TextEditingController? _areaController;
  String _selectedCity = 'Dhaka';
  String _selectedArea = 'Dhanmondi';
  List<String> _location = ['Dhanmondi'];
  bool isContinue = false;
  dynamic from;

  @override
  void initState() {
    // TODO: implement initState
    getLocation();
    from = Get.arguments != null ? Get.arguments['from'] : null;
    _nameController = TextEditingController();
    _mobileController = TextEditingController(text: AuthController.to.userPhoneForLogin.value);
    _emailController = TextEditingController();
    _addressController = TextEditingController();
    _nameFocusNode = FocusNode();
    _mobileFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _addressFocusNode = FocusNode();
    _cityController = TextEditingController();
    _areaController = TextEditingController();
    super.initState();
  }

  //  @override
  // void didChangeDependencies(){
  //    super.didChangeDependencies();
  //     AuthController.to.userPhoneForLogin.value = (AuthController.to.getUserId.isNotEmpty && AuthController.to.getIsVerified)? UserController.to.getUserInfo.mobile!:'';
  //    setState(() {
  //    });
  //
  //  }

  getLocation() async {
    _selectedArea = 'Dhanmondi';
    _location = await HealthCareController.to.getAreaList('Dhaka');
    setState(() {});
  }

  PaymentMethod _paymentMethod = PaymentMethod.online;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // if( AuthController.to.userPhoneForLogin.value.isEmpty){
    //    AuthController.to.userPhoneForLogin.value = (AuthController.to.getUserId.isNotEmpty && AuthController.to.getIsVerified)? UserController.to.getUserInfo.mobile!:'';
    // } setState(() {
    // });
    return Obx(
      () => AuthController.to.getUserId.isEmpty
          ? LoginScreen(
              from: BillingScreen.routeName,
            )
          : AuthController.to.getUserId.isNotEmpty && AuthController.to.getIsVerified == false
              ? VerifyScreen(
                  from: BillingScreen.routeName,
                )
              : Scaffold(
                  appBar: AppBar(
                    backgroundColor: kScaffoldColor,
                    title: Container(
                      height: 30,
                      width: Get.width * .6,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
                      child: const Center(
                        child: TitleText(
                          title: 'Checkout',
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  body: Stack(
                    children: [
                      SizedBox(
                        height: Get.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: TitleText(
                                  title: 'Billing Details',
                                  fontSize: 20,
                                  color: Color(0xff3c3c3c),
                                ),
                              ),
                              space3C,
                              HorizontalDivider(
                                horizontalMargin: 24,
                                color: kPrimaryColor,
                                height: 1,
                              ),
                              space8C,
                              Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      UnderlineTextFieldItem(
                                        horizontalMargin: 24,
                                        label: 'Full Name',
                                        controller: _nameController!,
                                        focusNode: _nameFocusNode,
                                        isRequired: true,
                                        enableColor: isContinue && _nameController!.text.isEmpty ? Colors.red : null,
                                        focusColor:
                                            isContinue && _nameFocusNode!.hasFocus && _nameController!.text.isEmpty
                                                ? Colors.red
                                                : null,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Your Name';
                                          }
                                          return null;
                                        },
                                      ),
                                      space2C,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                TitleText(
                                                  title: 'Mobile',
                                                  color: const Color(0xff3C3C3C),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                const TitleText(
                                                  title: '*',
                                                  color: Color(0xffff1414),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ],
                                            ),
                                            space4C,
                                            Obx(
                                              () => Text(
                                                AuthController.to.userPhoneForLogin.value,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xff3c3c3c),
                                                ),
                                              ),
                                            ),
                                            space4C,
                                          ],
                                        ),
                                      ),
                                      space2C,
                                      UnderlineTextFieldItem(
                                        horizontalMargin: 24,
                                        label: 'Email',
                                        controller: _emailController!,
                                        focusNode: _emailFocusNode,
                                      ),
                                      space2C,
                                      UnderlineTextFieldItem(
                                        horizontalMargin: 24,
                                        label: 'Address',
                                        controller: _addressController!,
                                        focusNode: _addressFocusNode,
                                        isRequired: true,
                                        enableColor: isContinue && _addressController!.text.isEmpty ? Colors.red : null,
                                        focusColor: isContinue &&
                                                _addressFocusNode!.hasFocus &&
                                                _addressController!.text.isEmpty
                                            ? Colors.red
                                            : null,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Your Address';
                                          }
                                          return null;
                                        },
                                      ),
                                      space2C,
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: CustomDropDownMenu(
                                                label: 'City',
                                                isRequired: true,
                                                hintText: 'Location',
                                                list: HealthCareController.to.citys,
                                                onChange: (val) async {
                                                  _selectedCity = val;
                                                  if (val == 'Dhaka') {
                                                    _selectedArea = 'Dhanmondi';
                                                  } else {
                                                    _selectedArea = val;
                                                  }
                                                  final dataS = await HealthCareController.to.getAreaList(val);
                                                  globalLogger.d(dataS);
                                                  _location = dataS;
                                                  setState(() {});
                                                },
                                                height: 50,
                                                selectedOption: _selectedCity,
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                borderRadius: BorderRadius.circular(0),
                                                underline: const HorizontalDivider(
                                                  thickness: .6,
                                                  color: Color(0xff3C3C3C),
                                                  height: 0,
                                                ),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color(0xff3c3c3c),
                                                icon: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: const Color(0xffD9D9D9),
                                                  ),
                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down_rounded,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            space4R,
                                            Expanded(
                                              child: CustomDropDownMenu(
                                                label: 'Area',
                                                isRequired: true,
                                                hintText: 'Location',
                                                list: _location,
                                                onChange: (val) {
                                                  _selectedArea = val;
                                                  setState(() {});
                                                },
                                                height: 50,
                                                selectedOption: _selectedArea,
                                                elevation: 0,
                                                shadowColor: Colors.transparent,
                                                borderRadius: BorderRadius.circular(0),
                                                underline: const HorizontalDivider(
                                                  thickness: .6,
                                                  color: Color(0xff3C3C3C),
                                                  height: 0,
                                                ),
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                textColor: const Color(0xff3c3c3c),
                                                icon: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(50),
                                                    color: const Color(0xffD9D9D9),
                                                  ),
                                                  child: const Icon(
                                                    Icons.keyboard_arrow_down_rounded,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ),
                                      if (HomeController.to.cartType.value == CartType.lab) space5C,
                                      if (HomeController.to.cartType.value == CartType.lab)
                                        MainContainer(
                                          borderColor: Colors.transparent,
                                          withBoxShadow: true,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const TitleText(
                                                title: 'Choose Payment Method',
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              space3C,
                                              // CustomRadio(
                                              //   label: 'Cash on Delivery',
                                              //   group: _paymentMethod,
                                              //   value: PaymentMethod.cod,
                                              //   onChanged: (dynamic value) {
                                              //     setState(() {
                                              //       _paymentMethod = value;
                                              //       print(value.toString());
                                              //     });
                                              //   },
                                              // ),
                                              CustomRadio(
                                                label: 'Bkash',
                                                group: _paymentMethod,
                                                value: PaymentMethod.mobileBanking,
                                                onChanged: (dynamic value) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Please select  online  payment option, once you select  mobile  banking,  you will find Bikash or Nogad payment option there');
                                                  // setState(() {
                                                  //   _paymentMethod = value;
                                                  //   print(value.toString());
                                                  // });
                                                },
                                              ),
                                              CustomRadio(
                                                label: 'Nagad',
                                                group: _paymentMethod,
                                                value: PaymentMethod.mobileBanking,
                                                onChanged: (dynamic value) {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'Please select  online  payment option, once you select  mobile  banking,  you will find Bikash or Nogad payment option there');

                                                  // setState(() {
                                                  //   _paymentMethod = value;
                                                  //   print(value.toString());
                                                  // });
                                                },
                                              ),
                                              CustomRadio(
                                                label: 'Online Payment',
                                                group: _paymentMethod,
                                                value: PaymentMethod.online,
                                                onChanged: (dynamic value) {
                                                  setState(() {
                                                    _paymentMethod = value;
                                                    print(value.toString());
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      if (HomeController.to.cartType.value == CartType.lab) space5C,
                                      if (HomeController.to.cartType.value == CartType.lab)
                                        /// /////////////////////////////////////////////////////// ///
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                          child: TitleText(
                                            title:
                                                'Pay ${(double.parse(LabController.to.getCartTotalPrice) * double.parse(HomeController.to.commission['lab_commission'] != null ? HomeController.to.commission['lab_commission'].toString() : '0') / 100).toStringAsFixed(2)} Taka Service charge now, remaining ${(double.parse(LabController.to.getCartTotalPrice) - (double.parse(LabController.to.getCartTotalPrice) * double.parse(HomeController.to.commission['lab_commission'] != null ? HomeController.to.commission['lab_commission'].toString() : '0') / 100)).toStringAsFixed(2)} Taka pay to lab',
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ],
                                  )),
                              space2C,
                              const SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        child: Container(
                          height: 80,
                          width: Get.width,
                          color: kScaffoldColor,
                          child: PrimaryButton(
                            label: HomeController.to.cartType.value == CartType.lab
                                ? 'Pay ${(double.parse(LabController.to.getCartTotalPrice) * double.parse(HomeController.to.commission['lab_commission'] != null ? HomeController.to.commission['lab_commission'].toString() : '0') / 100).toStringAsFixed(2)} Taka Service charge now'
                                : 'Continue to Checkout',
                            marginHorizontal: 24,
                            marginVertical: 15,
                            height: 50,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                globalLogger.d(HomeController.to.liveSearchType.value);
                                globalLogger.d(from);
                                UserModel user = UserController.to.getUserInfo;
                                isContinue = true;
                                setState(() {});
                                if (HomeController.to.liveSearchType.value == LiveSearchType.medicine ||
                                    HomeController.to.liveSearchType.value == LiveSearchType.prescription) {
                                  List<dynamic> _items = [];
                                  double amount = 0.0;
                                  double actualAmount = 0.0;
                                  double discount = 0.0;
                                  for (var element in HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                      ? MedicineController.to.confirmationPharmacyData['available']
                                      : PrescriptionController.to.confirmationPharmacyData['available']) {
                                    if (HomeController.to.liveSearchType.value == LiveSearchType.medicine) {
                                      amount = amount +
                                          (double.parse(element['sell_price'] == null
                                                  ? '0.00'
                                                  : element['sell_price'].toString()) *
                                              int.parse(element['count'].toString()));
                                      actualAmount = actualAmount +
                                          double.parse(element['price'] == null ? '0.00' : element['price'].toString());
                                    } else {
                                      amount = amount +
                                          (double.parse(
                                                  element['price'] == null ? '0.00' : element['price'].toString()) *
                                              int.parse(element['count'].toString()));
                                      actualAmount = actualAmount +
                                          double.parse(element['sell_price'] == null
                                              ? '0.00'
                                              : element['sell_price'].toString());
                                    }
                                    discount = discount +
                                        ((double.parse(
                                                    element['price'] == null ? '0.00' : element['price'].toString()) *
                                                double.parse(element['discount'] == null
                                                    ? '0.00'
                                                    : element['discount'].toString()) /
                                                100) *
                                            int.parse(element['count'].toString()));
                                    _items.add({
                                      "medicine_id": element['id'],
                                      "availability": "Available",
                                      "medicine_name": element['name'].toString(),
                                      "medicine_price": element['sell_price'].toString(),
                                      "qty": element['count'].toString()
                                    });
                                  }

                                  String jsonStringMap = json.encode(_items);
                                  Map infoData = {
                                    'user_id': user.id,
                                    'user_name': _nameController!.text,
                                    'user_mobile':  AuthController.to.userPhoneForLogin.value,
                                    'user_email': _emailController!.text,
                                    'user_address': _addressController!.text,
                                    'city': _selectedCity,
                                    'area': _selectedArea,
                                    'discount': discount.toString(),
                                    'lat': HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                        ? MedicineController.to.getMarkerData()['user-marker']['lat'].toString()
                                        : PrescriptionController.to.getMarkerData()['user-marker']['lat'].toString(),
                                    'lon': HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                        ? MedicineController.to.getMarkerData()['user-marker']['lon'].toString()
                                        : PrescriptionController.to.getMarkerData()['user-marker']['lon'].toString(),
                                    'pharmacy_id': HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                        ? MedicineController.to.confirmationPharmacyData['pharmacy_id']
                                        : PrescriptionController.to.confirmationPharmacyData['pharmacy_id'],
                                    'order_type': HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                        ? MedicineController.to.confirmationPharmacyData['order_type']
                                        : PrescriptionController.to.confirmationPharmacyData['order_type'],
                                    'order_amount': actualAmount.toString(),
                                    //TODO: File
                                    'prescription': '',
                                    'refer_code': MedicineController.to.refferCode.value,
                                    'delivery_charge': HomeController.to.liveSearchType.value == LiveSearchType.medicine
                                        ? MedicineController.to.confirmationPharmacyData['delivery_charge'].toString()
                                        : PrescriptionController.to.confirmationPharmacyData['delivery_charge']
                                            .toString(),

                                    ///TODO: Remove One
                                    ///'prescription/medicine'
                                    'order_for': 'medicine',
                                    'payment_status': 'pending',
                                    'items': jsonStringMap
                                  };
                                  globalLogger.d(infoData);
                                  if (_addressController!.text.isNotEmpty &&
                                      _nameController!.text.isNotEmpty &&
                                       AuthController.to.userPhoneForLogin.value.isNotEmpty) {
                                    Get.offAndToNamed(
                                      PlaceOrderScreen.routeName,
                                      arguments: {
                                        'from': 'Medicine',
                                        'info': infoData,
                                        'discount': discount.toString().replaceAll('-', ''),
                                        'actual_price': actualAmount.toString(),
                                      },
                                    );
                                  }
                                } else if (HomeController.to.liveSearchType.value == LiveSearchType.healthcare) {
                                  globalLogger.d(HealthCareController.to.confirmationPharmacyData);
                                  List<dynamic> _items = [];
                                  double amount = 0.0;
                                  double actualAmount = 0.0;
                                  double discount = 0.0;
                                  for (var element in HealthCareController.to.confirmationPharmacyData['available']) {
                                    amount = amount +
                                        (double.parse(
                                                element['price'] == 'null' ? '0.00' : element['price'].toString()) *
                                            int.parse(element['qty']));
                                    actualAmount = actualAmount +
                                        double.parse(element['price'] == 'null' ? '0.00' : element['price'].toString());

                                    discount = discount +
                                        (double.parse(
                                                element['price'] == 'null' ? '0.00' : element['price'].toString()) -
                                            double.parse(
                                                element['price'] == 'null' ? '0.00' : element['price'].toString()));
                                    _items.add({
                                      "product_id": element['id'],
                                      "product_name": element['name'].toString(),
                                      "product_price": element['price'].toString(),
                                      "qty": element['qty'].toString()
                                    });
                                  }

                                  String jsonStringMap = json.encode(_items);
                                  Map infoData = {
                                    "userId": user.id,
                                    "user_name": _nameController!.text,
                                    "user_phone":  AuthController.to.userPhoneForLogin.value,
                                    "user_email": _emailController!.text,
                                    "user_address": _addressController!.text,
                                    'district': _selectedCity,
                                    'area': _selectedArea,
                                    'refer_code': HealthCareController.to.refferCode.value,
                                    "lat": HealthCareController.to.getMarkerData()['user-marker']['lat'],
                                    "lon": HealthCareController.to.getMarkerData()['user-marker']['lon'],
                                    "pharmacy_id": HealthCareController.to.confirmationPharmacyData['pharmacy_id'],
                                    "order_type": HealthCareController.to.confirmationPharmacyData['order_type'],
                                    "order_amount": amount.toString(),
                                    "order_for": "healthcare",
                                    "discount_amount": "0",
                                    "products_sell_price": amount.toString(),
                                    //     (HealthCareController.to.confirmationPharmacyData['available'] as List)
                                    //         .map((e) => double.parse(e['price']!))
                                    //         .toList()
                                    //         .sum,
                                    "collected_amount": (amount +
                                            double.parse(HealthCareController
                                                .to.confirmationPharmacyData['delivery_charge']
                                                .toString()))
                                        .toString(),
                                    "delivery_charge":
                                        HealthCareController.to.confirmationPharmacyData['delivery_charge'].toString(),

                                    // (double.parse(
                                    //             (HealthCareController.to.confirmationPharmacyData['available'] as List)
                                    //                 .map((e) {
                                    //                   return double.parse(e['price']!);
                                    //                 })
                                    //                 .toList()
                                    //                 .sum
                                    //                 .toString()) +
                                    //         80)
                                    //     .toString(),
                                    "order_info": _items

                                    // jsonStringMap

                                    // {
                                    //   "pharmacy_id": HealthCareController.to.confirmationPharmacyData['pharmacy_id'],
                                    //   "pharmacy_name":
                                    //       HealthCareController.to.confirmationPharmacyData['pharmacy_name'],
                                    //   "pharmacy_mobile":
                                    //       HealthCareController.to.confirmationPharmacyData['pharmacy_mobile'],
                                    //   "product_id": HealthCareController.to.confirmationPharmacyData['product_id'],
                                    //   "product_name": HealthCareController.to.confirmationPharmacyData['product_name'],
                                    //   "product_price": HealthCareController.to.confirmationPharmacyData['total_price'],
                                    //   "product_qty": HealthCareController.to.confirmationPharmacyData['product_qty'],
                                    //   "total_price": HealthCareController.to.confirmationPharmacyData['total_price']
                                    // }
                                  };
                                  globalLogger.d(infoData);
                                  if (_addressController!.text.isNotEmpty &&
                                      _nameController!.text.isNotEmpty &&
                                       AuthController.to.userPhoneForLogin.value.isNotEmpty) {
                                    Get.offAndToNamed(PlaceOrderScreen.routeName, arguments: infoData);
                                  }
                                } else if (HomeController.to.cartType.value == CartType.lab) {
                                  globalLogger.d('Hello');

                                  ///TODO: IMPLEMENT LAB FUNCTION
                                  List<dynamic> _items = [];
                                  for (var element in LabController.to.labCartList) {
                                    _items.add({
                                      "test_id": int.parse(element.id!),
                                      "lab_id": int.parse(element.labId!),
                                      "lab_name": element.labName,
                                      "test_name": element.testName,
                                      "test_price": double.parse(element.labPrice!),
                                      "home_sample": 0,
                                    });
                                  }
                                  String jsonStringMap = json.encode(_items);
                                  Map infoData = {
                                    'user_id': user.id,
                                    'name': _nameController!.text,
                                    'mobile':  AuthController.to.userPhoneForLogin.value,
                                    'email': _emailController!.text,
                                    'address': _addressController!.text,
                                    'district': _selectedCity,
                                    'area': _selectedArea,
                                    'total_item': LabController.to.labCartList.length.toString(),
                                    "refer_code": LabController.to.refferCode.value,
                                    'total': LabController.to.getCartTotalPrice,
                                    'service_charge':
                                        (double.parse(LabController.to.getCartTotalPrice) * .05).toStringAsFixed(2),
                                    'grand_total': (double.parse(LabController.to.getCartTotalPrice)).toString(),
                                    'items': jsonStringMap
                                  };
                                  if (_addressController!.text.isNotEmpty &&
                                      _nameController!.text.isNotEmpty &&
                                       AuthController.to.userPhoneForLogin.value.isNotEmpty) {
                                    // infoData['payment_method'] = 'Online';
                                    SSLCTransactionInfoModel res = await sslCommerzGeneralCallTest(
                                        (double.parse(LabController.to.getCartTotalPrice) * .05), 'Lab Test');
                                    if (res.status!.toLowerCase() == 'valid') {
                                      globalLogger.d(infoData);
                                      infoData['bank_transaction_id'] = res.bankTranId;
                                      infoData['payment_id'] = res.tranId;
                                      infoData["payment_method"] = res.cardIssuer;
                                      final resp = await LabController.to.orderLabTests(infoData);

                                      if (resp) {
                                        LabController.to.deleteAllCart();

                                        Get.offAndToNamed(
                                          PurchaseDoneScreen.routeName,
                                          arguments: {'from': 'Lab', 'info': infoData, 'ssl_res': res.cardIssuer},
                                        );
                                      }
                                    }

                                    //
                                    // Get.offAndToNamed(PlaceOrderScreen.routeName,
                                    //     arguments: infoData);
                                  }
                                } else {
                                  double productsBuyPrice = 0;
                                  double productsOrgSellPrice = 0;
                                  double productsSellPrice = 0;
                                  double discountAmount = 0;
                                  List<dynamic> _items = [];
                                  for (var element in HealthCareController.to.healthcareCartList) {
                                    productsBuyPrice = productsBuyPrice +
                                        (double.parse(element.purchasePrice!) * int.parse(element.userQuantity!));
                                    productsOrgSellPrice = productsOrgSellPrice +
                                        (double.parse(element.offerPrice!) * int.parse(element.userQuantity!));
                                    productsSellPrice = productsSellPrice +
                                        (double.parse(element.mrp!) * int.parse(element.userQuantity!));
                                    discountAmount = discountAmount +
                                        ((double.parse(element.mrp!) * int.parse(element.userQuantity!)) -
                                            (double.parse(element.offerPrice!) * int.parse(element.userQuantity!)));
                                    _items.add({
                                      "product_id": element.id,
                                      "product_name": element.name,
                                      "qty": element.userQuantity,
                                      "buy_price": element.purchasePrice,
                                      "org_sell_price": element.offerPrice,
                                      "discount_percent": element.offerPercentage,
                                      "sell_price": element.mrp,
                                      "subtotal":
                                          (double.parse(element.mrp!) * int.parse(element.userQuantity!)).toString(),
                                    });
                                  }
                                  String jsonStringMap = json.encode(_items);
                                  Map infoData = {
                                    'user_id': user.userId,
                                    'user_name': _nameController!.text,
                                    'user_mobile':  AuthController.to.userPhoneForLogin.value,
                                    'user_email': _emailController!.text,
                                    'user_address': _addressController!.text,
                                    'district': _selectedCity,
                                    'area': _selectedArea,
                                    'total_items': HealthCareController.to.healthcareCartList.length.toString(),
                                    'products_buy_price': productsBuyPrice.toString(),
                                    'products_org_sell_price': productsOrgSellPrice.toString(),
                                    'products_sell_price': productsSellPrice.toString(),
                                    'discount_amount': discountAmount.toString(),
                                    'collected_amount': (productsOrgSellPrice + 80).toString(),
                                    'payment_method': '',
                                    'refer_code': '',
                                    'coupon_code': '',
                                    'coupon_amount': '',
                                    'product_items': jsonStringMap
                                  };
                                  if (_addressController!.text.isNotEmpty &&
                                      _nameController!.text.isNotEmpty &&
                                       AuthController.to.userPhoneForLogin.value.isNotEmpty) {
                                    Get.offAndToNamed(PlaceOrderScreen.routeName, arguments: infoData);
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
