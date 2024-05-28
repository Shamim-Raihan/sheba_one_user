import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/company_controller.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/appointment_slot_model.dart';
import 'package:shebaone/models/country_model.dart';
import 'package:shebaone/models/delivery_charge_model.dart';
import 'package:shebaone/models/doctor_appointment_model.dart';
import 'package:shebaone/models/doctor_city_model.dart';
import 'package:shebaone/models/doctor_model.dart';
import 'package:shebaone/models/doctor_organ_model.dart';
import 'package:shebaone/models/doctor_speciality_model.dart';
import 'package:shebaone/models/healthcare_category_model.dart';
import 'package:shebaone/models/healthcare_order_model.dart';
import 'package:shebaone/models/healthcare_product_model.dart';
import 'package:shebaone/models/lab_model.dart';
import 'package:shebaone/models/lab_order_model.dart';
import 'package:shebaone/models/medicine_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/models/pharmacy_model.dart';
import 'package:shebaone/models/register_model.dart';
import 'package:shebaone/models/slider_model.dart';
import 'package:shebaone/models/user_model.dart';
import 'package:shebaone/models/user_status_model.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

class Database {

  static const String apiUrl = "https://www.shebaone.com/api/";

  // final String apiUrl = /* kReleaseMode ? */ "https://www.shebaone.com/api/" /*: "http://192.168.1.163:9000/api/"*/;

  void checkUpdate() async {
    var url = Uri.parse("${apiUrl}app-version");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      if (data['data'] > appVersion) {
        Get.snackbar(
          "Update Available",
          "New update available, please update the app",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () async {
              String _url = "https://play.google.com/store/apps/details?id=com.wiztecbd.shebaone";
              Get.back();
              if (!await launch(_url)) throw 'Could not launch $_url';
            },
            child: const Text("Update Now"),
          ),
        );
      }
    } else {
      showAlert(data['message']);
    }
  }

  Future<List<CountryModel>> getCountries() async {
    List<CountryModel> countries = [];
    final url = Uri.parse("${apiUrl}country-list");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    //for each data in the list
    data['country_list'].forEach((element) {
      countries.add(CountryModel.fromJson(element));
    });
    return countries;
  }

  Future<dynamic> getCommisionsInfo() async {
    final url = Uri.parse("${apiUrl}commission-info");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      if (data['status']) {
        dynamic info = {};
        info.addAll(data['data']);
        info.addAll(data['refer_commission']);
        return info;
      }
    } else {
      return {};
    }
  }

  Future<dynamic> getOfferList() async {
    final url = Uri.parse("${apiUrl}offer-list");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      if (data['status']) {
        return data['data'];
      }
    } else {
      return {};
    }
  }

  Future<dynamic> getCategoryWithTestList() async {
    final url = Uri.parse("${apiUrl}category-with-test");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      if (data['status']) {
        return data['data'];
      }
    } else {
      return {};
    }
  }

  Future<dynamic> getSliderList() async {
    final url = Uri.parse("${apiUrl}healthcare/sliders-lists");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      if (data['status']) {
        return data['slider_lists'];
      }
    } else {
      return [];
    }
  }

  Future<dynamic> getMedicineSliderList() async {
    final url = Uri.parse("${apiUrl}medicine-slider");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      if (data['status']) {
        return data['slider'];
      }
    } else {
      return [];
    }
  }

  Future<MedicineOrderModel> getOrderInfo(String orderId) async {
    MedicineOrderModel orderModel = MedicineOrderModel();
    var url = Uri.parse("${apiUrl}deliveryman/healthcare-order-details/$orderId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      orderModel = MedicineOrderModel.fromJson(data['message']);
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return orderModel;
  }

  Future<List<HealthCareProductModel>> getHomeHeathCareProducts({String? urlS}) async {
    List<HealthCareProductModel> heathCareProducts = [];
    var url = Uri.parse(urlS ?? "${apiUrl}healthcare/products-lists-pagination");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['product_lists']['data'].forEach((element) {
        heathCareProducts.add(HealthCareProductModel.fromJson(element));
      });
      if (data['product_lists']['next_page_url'] != null) {
        HealthCareController.to.setNextPageURL(data['product_lists']['next_page_url']);
      } else {
        HealthCareController.to.setNextPageURL('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareProducts;
  }

  Future<List<MedicineModel>> getMedicineData({String? urlS}) async {
    List<MedicineModel> medicineList = [];
    var url = Uri.parse(urlS ?? "${apiUrl}medicine/medicine-products-pagination");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['product_lists']['data'].forEach((element) {
        medicineList.add(MedicineModel.fromJson(element));
      });
      if (data['product_lists']['next_page_url'] != null) {
        MedicineController.to.setNextPageURL(data['product_lists']['next_page_url']);
      } else {
        MedicineController.to.setNextPageURL('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return medicineList;
  }

  ///Lab Test Category List
  Future<List<LabTestCategoryModel>> getLabTestCategoryData() async {
    List<LabTestCategoryModel> labCategoryList = [];
    var url = Uri.parse("${apiUrl}lab/all-tests");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['test_category'].forEach((element) {
        labCategoryList.add(LabTestCategoryModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labCategoryList;
  }

  ///Lab Test Category List
  Future<List<ChargeModel>> getDeliveryChargeList() async {
    List<ChargeModel> deliveryChargeList = [];
    var url = Uri.parse("${apiUrl}deliveryman/delivery-charge-list");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['message'].forEach((element) {
        deliveryChargeList.add(ChargeModel.fromJson(element));
      });
    } else {
      // Get.back();
      showAlert(data['message']);
    }
    return deliveryChargeList;
  }

  ///Speciality with doctor List
  Future<List> getSpecialityDoctor() async {
    globalLogger.d('data 2', 'specialityDoctorList');
    List specialityDoctor = [];
    var url = Uri.parse("${apiUrl}get-speciality-with-doctor");
    globalLogger.d(url, 'specialityDoctorList');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    globalLogger.d(data, 'specialityDoctorList');
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      specialityDoctor = data['speciality'];
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return specialityDoctor;
  }

  ///Prescription upload
  Future<void> uploadPrescription(
    File image,
    String name,
    String phone,
  ) async {
    var url = Uri.parse("${apiUrl}lab/upload-prescription");
    var request = http.MultipartRequest("POST", url);
    request.fields['name'] = name;
    request.fields['phone'] = phone;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    request.send().then(
      (response) {
        if (response.statusCode == 200) {
          ///TODO: Uncomment
          // Get.offAllNamed(HomeScreen.routeName);

          Get.defaultDialog(title: 'Uploaded Successfully', content: const SizedBox());
          Future.delayed(const Duration(seconds: 2), () {
            Get.back();
          });
        } else {
          showAlert("Something went wrong");
        }
      },
    );
  }

  ///Lab List
  Future<List<LabModel>> getLabData() async {
    List<LabModel> labList = [];
    var url = Uri.parse("${apiUrl}lab/lab-lists");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['data'].forEach((element) {
        labList.add(LabModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labList;
  }

  ///Filter Lab List
  Future<List<LabModel>> getFilterLabData(String testId) async {
    List<LabModel> labList = [];
    var url = Uri.parse("${apiUrl}lab/lab-filter/$testId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['data'].forEach((element) {
        labList.add(LabModel.fromJson(element));
        data['lab_sheba'].forEach((info) {
          if (info['lab_register_id'] == element['id']) {
            labList[labList.length - 1].fees = info['fees'].toString();
            labList[labList.length - 1].status = info['status'].toString();
          }
        });
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }

    return labList;
  }

  ///Lab Test List
  Future<List<LabTestModel>> getLabTestData(String categoryId) async {
    List<LabTestModel> labTestList = [];
    var url = Uri.parse("${apiUrl}lab/test-subcategory/$categoryId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['lab_test'].forEach((element) {
        labTestList.add(LabTestModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labTestList;
  }

  ///Single Lab Test
  Future<LabTestModel> getSingleLabData(String testId) async {
    LabTestModel labTest = LabTestModel();
    var url = Uri.parse("${apiUrl}lab/lab-test-details/$testId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      labTest = LabTestModel.fromJson(data['test_details']);
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labTest;
  }

  Future<List<DoctorModel>> getAllDoctor({String? urlS}) async {
    List<DoctorModel> doctorList = [];
    var url = Uri.parse(urlS ?? "${apiUrl}doctor/doctor-lists-pagination");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['doctor_lists']['data'].forEach((element) {
        doctorList.add(DoctorModel.fromJson(element));
      });
      if (data['doctor_lists']['next_page_url'] != null) {
        DoctorAppointmentController.to.setNextPageURL(data['doctor_lists']['next_page_url']);
      } else {
        DoctorAppointmentController.to.setNextPageURL('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return doctorList;
  }

  ///Online Doctor Get
  Future<List<DoctorModel>> getOnlineDoctor({String? urlS}) async {
    List<DoctorModel> doctorList = [];
    var url = Uri.parse("${apiUrl}doctor/online-dorctor-lists${urlS ?? ''}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['doctor']['data'].forEach((element) {
        if (element['doctor'] != null) {
          doctorList.add(DoctorModel.fromJson(element['doctor']));
        }
      });
      if (data['doctor']['next_page_url'] != null) {
        DoctorAppointmentController.to.setNextPageURL(data['doctor']['next_page_url']);
      } else {
        DoctorAppointmentController.to.setNextPageURL('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return doctorList;
  }

  Future<DoctorModel> getSingleDoctor(String doctorId) async {
    DoctorModel doctorModel = DoctorModel();
    List<AppointmentSlotModel> _appointmentList = [];
    List<HomeAppointmentSlotModel> _homeAppointmentList = [];
    var url = Uri.parse("${apiUrl}doctor/user-select-to-doctor/$doctorId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      globalLogger.d(data);
      doctorModel = DoctorModel.fromJson(data['doctor_info']);
      doctorModel.experience = data['experience'].toString();
      doctorModel.patients = data['patients'].toString();
      data['appointment_slot'].forEach((element) {
        _appointmentList.add(AppointmentSlotModel.fromJson(element));
      });
      data['home_visit_slot'].forEach((element) {
        _homeAppointmentList.add(HomeAppointmentSlotModel.fromJson(element));
      });
      DoctorAppointmentController.to.setAppointmentSlot(_appointmentList, _homeAppointmentList);
    } else {
      Get.back();
      showAlert(data['message']);
    }
    print(doctorModel.name);
    return doctorModel;
  }

  Future<List<DoctorSpecialityModel>> getDoctorSpecialityData(int isWomenRelated) async {
    List<DoctorSpecialityModel> doctorSpecialityList = [];
    var url = Uri.parse("${apiUrl}doctor/doctor-speciality");
    if (isWomenRelated == 1) {
      url = Uri.parse("${apiUrl}doctor/doctor-speciality?isWomenRelated=1");
    }
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      if (data['doctor_seciality'].runtimeType == List) {
        data['doctor_seciality'].forEach((element) {
          doctorSpecialityList.add(DoctorSpecialityModel.fromJson(element));
        });
      } else {
        List newList = data['doctor_seciality'].keys.toList();
        for (var element in newList) {
          doctorSpecialityList.add(DoctorSpecialityModel.fromJson(data['doctor_seciality'][element]));
        }
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return doctorSpecialityList;
  }

  Future<List<CityModel>> getDoctorCityData() async {
    List<CityModel> doctorCityList = [];
    var url = Uri.parse("${apiUrl}doctor/city-lists");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      data['city_lists'].forEach((element) {
        doctorCityList.add(CityModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return doctorCityList;
  }

  Future<List<OrganModel>> getDoctorOrganData() async {
    List<OrganModel> doctorOrganList = [];
    var url = Uri.parse("${apiUrl}doctor/special-organs");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      data['special_organs'].forEach((element) {
        doctorOrganList.add(OrganModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return doctorOrganList;
  }

  Future<List<DoctorModel>> getDoctorByCategory(
      String categoryValue, DoctorByEnum doctorByCategory, String? city,) async {
    List<DoctorModel> doctorList = [];
    var url = Uri.parse(
        "${apiUrl}doctor/${doctorByCategory == DoctorByEnum.organ ? "organ-doctor-search" : doctorByCategory == DoctorByEnum.speciality ? "speciality-doctor-search" : "city-doctor-search"}");
    var response = await http.post(url,
        body: doctorByCategory == DoctorByEnum.organ
            ? {'special_organ': categoryValue, 'city': city}
            : doctorByCategory == DoctorByEnum.speciality
                ? {'specialization': categoryValue, 'city': city}
                : {'city': city});
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      data['doctor_search_lists'].forEach((element) {
        doctorList.add(DoctorModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(
          'Your selected category doctors are not available, we are unable to book doctor in this category for you. You may try other category/area.',
          color: Colors.red);
    }
    return doctorList;
  }

  Future<bool> postAppointment(Map info) async {
    globalLogger.d('Here');
    var url = Uri.parse("${apiUrl}doctor/doctor-appointment");
    var response = await http.post(url, body: info);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      DoctorAppointmentController.to.appointmentSuccessInfo(data['appointment']);
      return true;
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  Future<dynamic> orderHealthcareProduct(Map info) async {
    var url = Uri.parse("${apiUrl}healthcare/healthcare-product-order");
    var response = await http.post(url, body: info);
    globalLogger.d(response.body);

    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      return data['order_info'];
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  Future<dynamic> orderLabTests(Map info) async {
    var url = Uri.parse("${apiUrl}lab/test-order");
    var response = await http.post(url, body: info);
    globalLogger.d(response.body);

    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      return data['data'];
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  Future<dynamic> orderHealthcareProductLive(Map info) async {
    var url = Uri.parse("${apiUrl}pharmacy_order_healthcare");
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(info),
    );
    globalLogger.d(response.body);

    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    if (data['success'] == 1) {
      return data['order'];
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  Future<dynamic> orderMedicineProduct(Map info) async {
    var url = Uri.parse("${apiUrl}medicine/medicine-product-order");
    var response = await http.post(url, body: info);
    globalLogger.d(response.body);

    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      return data['order_info'];
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  Future<dynamic> getDistanceTime(Map info) async {
    globalLogger.d(info);
    var url = Uri.parse(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=${info['user-marker']['lat']},${info['user-marker']['lon']}&destinations=${AuthController.to.getDeliveryManPosition['lat']},${AuthController.to.getDeliveryManPosition['lon']}&key=$mapApiKey");
    var response = await http.get(url);
    globalLogger.d(response.body);

    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    // if (data['status'] == true) {
    //   return data['order_info'];
    // } else {
    //   showAlert(data['message']);
    // }

    return data;
  }

  Future<String?> uploadPrescriptionImage(String image) async {
    var url = Uri.parse("${apiUrl}api/upload_file");
    String? imagePath;
    var request = http.MultipartRequest("POST", url);
    request.files.add(await http.MultipartFile.fromPath('prescription_image', image));

    request.send().then(
      (response) async {
        if (response.statusCode == 200) {
          ///TODO: Uncomment
          var responseString = await response.stream.bytesToString();
          final data = json.decode(responseString);
          globalLogger.d(data);
          // Get.offAllNamed(HomeScreen.routeName);
          imagePath = data['image'];
          globalLogger.d(data['image']);
        } else {
          showAlert("Something went wrong");
        }
      },
    );
    return imagePath;
  }

  Future<dynamic> pharmacyList(Map info) async {
    globalLogger.d(info);
    List<PharmacyModel> pharmacyList = [];
    var url = Uri.parse("${apiUrl}api_check_near_by_pharmacy");
    var response = await http.post(url, body: info);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    //checking if the code is valid
    if (data['success'] == 1) {
      globalLogger.d('Enter');
      data['data'].forEach((pharmacy) {
        pharmacyList.add(PharmacyModel.fromJson(pharmacy));
      });
      // List newList = data['data'].keys.toList();
      // for (var element in newList) {
      //   pharmacyList.add(PharmacyModel.fromJson(data['data'][element]));
      // }
    } else {
      // showAlert(data['message']);
    }

    return pharmacyList;
  }

  Future<dynamic> healthStoreList(Map info) async {
    globalLogger.d(info);
    List<PharmacyModel> pharmacyList = [];
    var url = Uri.parse("https://shebaone.com/check_near_by_pharmacy_health");
    var response = await http.post(url, body: info);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    //checking if the code is valid
    if (data['success'] == 1) {
      globalLogger.d('Enter');
      data['data'].forEach((pharmacy) {
        pharmacyList.add(PharmacyModel.fromJson(pharmacy));
      });
      // List newList = data['data'].keys.toList();
      // for (var element in newList) {
      //   pharmacyList.add(PharmacyModel.fromJson(data['data'][element]));
      // }
    } else {
      // showAlert(data['message']);
    }

    return pharmacyList;
  }

  // Future<int> submitSubscription(
  //     {required List<File> file, required String info}) async {
  //   ///MultiPart request
  //   var request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse("${apiUrl}doctor/doctor-appointment"),
  //   );
  //   Map<String, String> headers = {"Content-type": "multipart/form-data"};
  //
  //   request.files.add(
  //     http.MultipartFile(
  //       'report_upload',
  //       file.readAsBytes().asStream(),
  //       file.lengthSync(),
  //       filename: filename,
  //       contentType: MediaType('image', 'jpeg'),
  //     ),
  //   );
  //   request.headers.addAll(headers);
  //   request.fields
  //       .addAll({"name": "test", "email": "test@gmail.com", "id": "12345"});
  //   print("request: " + request.toString());
  //   var res = await request.send();
  //   print("This is response:" + res.toString());
  //   return res.statusCode;
  // }

  Future<List<HealthCareProductModel>> getHeathCareCategoryProducts({String? categoryId, String? urlS}) async {
    List<HealthCareProductModel> heathCareCategoryProducts = [];
    var url = Uri.parse(urlS ?? "${apiUrl}healthcare/parent-category-wise-product/$categoryId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['healthcare']['data'].forEach((element) {
        heathCareCategoryProducts.add(HealthCareProductModel.fromJson(element));
      });
      if (data['healthcare']['next_page_url'] != null) {
        HealthCareController.to.setCategoryNextPageURL(data['healthcare']['next_page_url']);
      } else {
        HealthCareController.to.setCategoryNextPageURL('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareCategoryProducts;
  }

  ///Get Single Healthcare Product
  ///Healthcare Product Details API
  Future<HealthCareProductModel> getSingleProduct({required String productId}) async {
    HealthCareProductModel heathCareProduct = HealthCareProductModel();
    var url = Uri.parse("${apiUrl}healthcare/product-details/$productId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list

      heathCareProduct = HealthCareProductModel.fromJson(data['product_details']);
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareProduct;
  }

  ///Get Single Medicine Product
  ///Medicine Product Details API
  Future<MedicineModel> getSingleMedicine({required String medicineId}) async {
    MedicineModel medicineProduct = MedicineModel();
    var url = Uri.parse("${apiUrl}medicine/medicine-products-details/$medicineId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list

      medicineProduct = MedicineModel.fromJson(data['product_details']);
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return medicineProduct;
  }

  Future<List<HealthCareProductModel>> getCategoryWiseHomeHeathCareProducts(String categoryId, int index) async {
    List<HealthCareProductModel> heathCareProducts = [];
    var url = Uri.parse("${apiUrl}healthcare/parent-category-wise-product/$categoryId");
    var response = await http.get(url);
    // print(response.statusCode);
    var data = jsonDecode(response.body);
    debugPrint(categoryId);
    // debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['healthcare']['data'].forEach((element) {
        heathCareProducts.add(HealthCareProductModel.fromJson(element));
      });
      if (data['healthcare']['next_page_url'] != null) {
        HealthCareController.to.categoryWiseData[index] = {
          'loading': false,
          'next_page_url': data['healthcare']['next_page_url'],
          categoryId: heathCareProducts
        };
      } else {
        HealthCareController.to.categoryWiseData[index] = {
          'loading': false,
          'next_page_url': "",
          categoryId: heathCareProducts
        };
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }

    // HealthCareController.to.categoryWiseData[index] = {
    //   'loading': false,
    //   categoryId: []
    // };
    // print(HealthCareController.to.categoryWiseData[index]['loading']);
    // print(HealthCareController.to.categoryWiseData[index]['next_page_url']);
    // print(HealthCareController.to.categoryWiseData[index][categoryId]);
    return heathCareProducts;
  }

  Future<List<HealthCareCategoryModel>> getHomeHeathCareCategories(int isWomenRelated, int isFitnessRelated) async {
    List<HealthCareCategoryModel> heathCareCategories = [];
    var url = Uri.parse("${apiUrl}healthcare/category-lists");
    if (isWomenRelated == 1 && isFitnessRelated == 1) {
      url = Uri.parse("${apiUrl}healthcare/category-lists?isWomenRelated=1&isFitnessRelated=1");
    } if (isWomenRelated == 1) {
      url = Uri.parse("${apiUrl}healthcare/category-lists?isWomenRelated=1");
    } else if (isFitnessRelated == 1) {
      url = Uri.parse("${apiUrl}healthcare/category-lists?isFitnessRelated=1");
    } else {
      url = Uri.parse("${apiUrl}healthcare/category-lists");
    }
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['categories_lists'].forEach((element) {
        heathCareCategories.add(HealthCareCategoryModel.fromJson(element));
        HealthCareController.to.categoryWiseData.add({'loading': false, 'next_page_url': '', element['id']: []});
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareCategories;
  }

  Future<List<dynamic>> getHomeHeathCareBrands() async {
    List<dynamic> heathCareBrands = [];
    var url = Uri.parse("${apiUrl}healthcare/brand-lists");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      heathCareBrands = data['brands_lists'];
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareBrands;
  }

  ///Healthcare Order List Data
  Future<List<MedicineOrderModel>> getHomeHeathCareOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> heathCareOrders = [];
    var url = HealthCareController.to.healthcareOrderNextPageUrl.isNotEmpty
        ? Uri.parse(HealthCareController.to.healthcareOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}healthcare/healthcare-order-lists/${AuthController.to.userId}");
    globalLogger.d(url, 'Healthcare order url');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString(), 'Healthcare order data');
    if (data['status'] == true) {
      HealthCareController.to.totalOrders(data['total_order'] ?? 10);
      HealthCareController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['orders']['data'].forEach((element) {
        heathCareOrders.add(MedicineOrderModel.fromJson(element));
      });
      if (data['orders']['next_page_url'] != null) {
        HealthCareController.to.healthcareOrderNextPageUrl(data['orders']['next_page_url']);
      } else {
        HealthCareController.to.healthcareOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareOrders;
  }

  ///Healthcare Previous Order List Data
  Future<List<MedicineOrderModel>> getHomeHeathCarePreviousOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> heathCareOrders = [];
    var url = isPaginate
        ? Uri.parse(HealthCareController.to.healthcarePreviousOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}healthcare/healthcare-order-lists-delivered/${AuthController.to.userId}");
    globalLogger.d(url, 'Healthcare order url');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString(), 'Healthcare order data');
    if (data['status'] == true) {
      data['orders']['data'].forEach((element) {
        heathCareOrders.add(MedicineOrderModel.fromJson(element));
      });
      if (data['orders']['next_page_url'] != null) {
        HealthCareController.to.healthcarePreviousOrderNextPageUrl(data['orders']['next_page_url']);
      } else {
        HealthCareController.to.healthcarePreviousOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareOrders;
  }

  ///Healthcare Previous Order List Data
  Future<List<MedicineOrderModel>> getHomeHeathCareCurrentOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> heathCareOrders = [];
    var url = isPaginate
        ? Uri.parse(HealthCareController.to.healthcareCurrentOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}healthcare/healthcare-order-lists-pending/${AuthController.to.userId}");
    globalLogger.d(url, 'Healthcare order url');
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString(), 'Healthcare order data');
    if (data['status'] == true) {
      data['orders']['data'].forEach((element) {
        heathCareOrders.add(MedicineOrderModel.fromJson(element));
        if (data['orders']['next_page_url'] != null) {
          HealthCareController.to.healthcareCurrentOrderNextPageUrl(data['orders']['next_page_url']);
        } else {
          HealthCareController.to.healthcareCurrentOrderNextPageUrl('');
        }
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareOrders;
  }

  ///Healthcare Search List Data
  Future<void> getSearchList(String keyword, {bool typo = false}) async {
    List<HealthCareProductModel> heathCareList = [];
    List<MedicineModel> medicineList = [];
    var url = Uri.parse(typo ? keyword : "${apiUrl}search/search-product?search_keyword=$keyword");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      if (!typo) {
        data['health_search']['data'].forEach((element) {
          heathCareList.add(HealthCareProductModel.fromJson(element));
        });
        data['medicine']['data'].forEach((element) {
          medicineList.add(MedicineModel.fromJson(element));
        });

        if (data['health_search']['next_page_url'] != null) {
          HealthCareController.to.nextPageSearch(data['health_search']['next_page_url'] + "&search_keyword=$keyword");
        } else {
          HealthCareController.to.nextPageSearch('');
        }
        if (data['medicine']['next_page_url'] != null) {
          MedicineController.to.nextPageSearch(data['medicine']['next_page_url'] + "&search_keyword=$keyword");
        } else {
          MedicineController.to.nextPageSearch('');
        }
        HealthCareController.to.healthcareSearchList.value = heathCareList;
        MedicineController.to.medicineSearchList.value = medicineList;
      } else {
        if (HomeController.to.searchListType.value == SearchType.healthcare) {
          data['health_search']['data'].forEach((element) {
            heathCareList.add(HealthCareProductModel.fromJson(element));
          });
          if (data['health_search']['next_page_url'] != null) {
            HealthCareController.to.nextPageSearch(data['health_search']['next_page_url'] + "&search_keyword=$keyword");
          } else {
            HealthCareController.to.nextPageSearch('');
          }
          HealthCareController.to.healthcareSearchList.addAll(heathCareList);
        } else {
          data['medicine']['data'].forEach((element) {
            medicineList.add(MedicineModel.fromJson(element));
          });
          if (data['medicine']['next_page_url'] != null) {
            MedicineController.to.nextPageSearch(data['medicine']['next_page_url'] + "&search_keyword=$keyword");
          } else {
            MedicineController.to.nextPageSearch('');
          }
          MedicineController.to.medicineSearchList.addAll(medicineList);
        }
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Healthcare Search List Data
  Future<List> getSearchListByKey(String keyword) async {
    List searchList = [];
    var url = Uri.parse("${apiUrl}search/search-product-easy?search_keyword=$keyword");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (response.statusCode == 200) {
      if (data['status'] == true) {
        searchList = data['products']['data'];
        //for each data in the list
        return searchList;
      } else {
        Get.back();
        showAlert(data['message']);
      }
    }
    return [];
  }

  ///Lab Test Search List Data
  Future<void> getLabSearchList(String keyword, {bool paginateCall = false}) async {
    List<LabTestModel> labTestList = [];
    var url = Uri.parse(paginateCall ? keyword : "${apiUrl}lab/test-search?search_keyword=$keyword");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['search_results']['data'].forEach((element) {
        labTestList.add(LabTestModel.fromJson(element));
      });
      if (data['search_results']['next_page_url'] != null) {
        LabController.to.nextPageSearch(data['search_results']['next_page_url'] + "&search_keyword=$keyword");
      } else {
        LabController.to.nextPageSearch('');
      }
      LabController.to.labSearchList.addAll(labTestList);
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Lab Test Search List on Key
  Future<void> getLabSearchListByKey(
    String keyword,
  ) async {
    globalLogger.d(keyword);
    List<LabTestModel> labTestList = [];
    var url = Uri.parse("${apiUrl}lab/test-search?search_keyword=$keyword");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (response.statusCode == 200) {
      if (data['status'] == true) {
        //for each data in the list
        data['search_results']['data'].forEach((element) {
          labTestList.add(LabTestModel.fromJson(element));
        });

        LabController.to.labSearchListByKey.value = labTestList;
      } else {
        Get.back();
        showAlert(data['message']);
      }
    }
  }

  ///Doctor Search List Data
  Future<void> getDoctorSearchList(String keyword, String location, {bool paginateCall = false}) async {
    List<DoctorModel> doctorList = [];
    var url =
        Uri.parse(paginateCall ? keyword : "${apiUrl}search/search-doctor?search_keyword=$keyword&city=$location");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['doctor']['data'].forEach((element) {
        doctorList.add(DoctorModel.fromJson(element));
      });
      if (data['doctor']['next_page_url'] != null) {
        DoctorController.to.nextPageSearch(data['doctor']['next_page_url'] + "&search_keyword=$keyword&city=$location");
      } else {
        DoctorController.to.nextPageSearch('');
      }
      DoctorController.to.doctorSearchList.addAll(doctorList);
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Doctor Search List Data
  Future<void> getDoctorSearchListByKey(
    String keyword,
    String location,
  ) async {
    List<DoctorModel> doctorList = [];
    var url = Uri.parse("${apiUrl}search/search-doctor?search_keyword=$keyword&city=$location");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['doctor']['data'].forEach((element) {
        doctorList.add(DoctorModel.fromJson(element));
      });
      DoctorController.to.doctorSearchListByKey.value = doctorList;
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Doctor Filter List Data
  Future<void> getDoctorFilterList({bool paginateCall = false}) async {
    final info = DoctorController.to.processFilterData();
    globalLogger.d(info, 'INFO DATA');
    List<DoctorModel> doctorList = [];
    var url = Uri.parse(paginateCall
        ? DoctorController.to.nextPageFilter.value
        : "$apiUrl${DoctorController.to.doctorByEnum.value == DoctorByEnum.speciality ? 'doctor/specialization_filter_search' : DoctorController.to.doctorByEnum.value == DoctorByEnum.organ ? 'doctor/organ_filter_search' : 'doctor/city_filter_search'}");
    var response = await http.post(url,
        headers: {
          // "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: info);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    // if (data['status'] == true) {
    if (response.statusCode == 200) {
      //for each data in the list
      data['search_result']['data'].forEach((element) {
        doctorList.add(DoctorModel.fromJson(element));
      });
      if (data['search_result']['next_page_url'] != null) {
        DoctorController.to.nextPageFilter(data['doctor']['next_page_url']);
      } else {
        DoctorController.to.nextPageFilter('');
      }
      DoctorController.to.doctorFilterList.addAll(doctorList);
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Healthcare Filter List Data
  Future<void> getHealthcareFilterList({bool paginateCall = false}) async {
    final info = HealthCareController.to.processFilterData();
    globalLogger.d(info, 'INFO DATA');
    List<HealthCareProductModel> healthcareProductList = [];
    var url =
        Uri.parse(paginateCall ? HealthCareController.to.nextPageFilter.value : "${apiUrl}healthcare/filter_search");
    var response = await http.post(url,
        headers: {
          // "Content-type": "application/json",
          "Accept": "application/json",
        },
        body: info);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    // if (data['status'] == true) {
    if (response.statusCode == 200) {
      //for each data in the list
      data['search_result']['data'].forEach((element) {
        globalLogger.d(element);
        healthcareProductList.add(HealthCareProductModel.fromJson(element));
      });
      if (data['search_result']['next_page_url'] != null) {
        HealthCareController.to.nextPageFilter(data['search_result']['next_page_url']);
      } else {
        HealthCareController.to.nextPageFilter('');
      }
      HealthCareController.to.healthcareFilterList.addAll(healthcareProductList);
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Healthcare Single Order Details List Data
  Future<List<HealthcareSingleOrderModel>> getHeathCareSingleOrderDetailsList(String orderId) async {
    List<HealthcareSingleOrderModel> heathCareSingleOrderItems = [];
    var url = Uri.parse("${apiUrl}healthcare/healthcare-order-itmes/$orderId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['orders_items'].forEach((element) {
        heathCareSingleOrderItems.add(HealthcareSingleOrderModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareSingleOrderItems;
  }

  ///Medicine Order List Data
  Future<List<MedicineOrderModel>> getMedicineOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> medicineOrders = [];
    var url = MedicineController.to.medicineOrderNextPageUrl.isNotEmpty
        ? Uri.parse(MedicineController.to.medicineOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}medicine/medicine-order-lists/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      MedicineController.to.totalOrders(data['total_order'] ?? 0);
      MedicineController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['orders']['data'].forEach((element) {
        medicineOrders.add(MedicineOrderModel.fromJson(element));
      });
      if (data['orders']['next_page_url'] != null) {
        MedicineController.to.medicineOrderNextPageUrl(data['orders']['next_page_url']);
      } else {
        MedicineController.to.medicineOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return medicineOrders;
  }

  ///Medicine Previous Order List Data
  Future<List<MedicineOrderModel>> getPreviousMedicineOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> medicineOrders = [];
    var url = isPaginate
        ? Uri.parse(MedicineController.to.medicinePreviousOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}medicine/medicine-order-lists-delivered/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // MedicineController.to.totalOrders(data['total_order'] ?? 0);
      // MedicineController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['orders']['data'].forEach((element) {
        medicineOrders.add(MedicineOrderModel.fromJson(element));
      });
      if (data['orders']['next_page_url'] != null) {
        MedicineController.to.medicinePreviousOrderNextPageUrl(data['orders']['next_page_url']);
      } else {
        MedicineController.to.medicinePreviousOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return medicineOrders;
  }

  ///Medicine Order List Data
  Future<List<MedicineOrderModel>> getCurrentMedicineOrderList({bool isPaginate = false}) async {
    List<MedicineOrderModel> medicineOrders = [];
    var url = isPaginate
        ? Uri.parse(MedicineController.to.medicineCurrentOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}medicine/medicine-order-lists-pending/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // MedicineController.to.totalOrders(data['total_order'] ?? 0);
      // MedicineController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['orders']['data'].forEach((element) {
        medicineOrders.add(MedicineOrderModel.fromJson(element));
      });
      if (data['orders']['next_page_url'] != null) {
        MedicineController.to.medicineCurrentOrderNextPageUrl(data['orders']['next_page_url']);
      } else {
        MedicineController.to.medicineCurrentOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return medicineOrders;
  }

  ///Lab Order List Data
  Future<List<LabOrderModel>> getLabOrderList({bool isPaginate = false}) async {
    List<LabOrderModel> labOrders = [];
    var url = LabController.to.labOrderNextPageUrl.isNotEmpty
        ? Uri.parse(LabController.to.labOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}lab/lab-order-list/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      LabController.to.totalOrders(data['total_order'] ?? 0);
      LabController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['lab_order_list']['data'].forEach((element) {
        labOrders.add(LabOrderModel.fromJson(element));
      });
      if (data['lab_order_list']['next_page_url'] != null) {
        LabController.to.labOrderNextPageUrl(data['lab_order_list']['next_page_url']);
      } else {
        LabController.to.labOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labOrders;
  }

  ///Previous Lab Order List Data
  Future<List<LabOrderModel>> getPreviousLabOrderList({bool isPaginate = false}) async {
    List<LabOrderModel> labOrders = [];
    var url = isPaginate
        ? Uri.parse(LabController.to.labPreviousOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}lab/lab-order-list-delivered/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // LabController.to.totalOrders(data['total_order'] ?? 0);
      // LabController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['lab_order_list']['data'].forEach((element) {
        labOrders.add(LabOrderModel.fromJson(element));
      });
      if (data['lab_order_list']['next_page_url'] != null) {
        LabController.to.labPreviousOrderNextPageUrl(data['lab_order_list']['next_page_url']);
      } else {
        LabController.to.labPreviousOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labOrders;
  }

  ///Current Lab Order List Data
  Future<List<LabOrderModel>> getCurrentLabOrderList({bool isPaginate = false}) async {
    List<LabOrderModel> labOrders = [];
    var url = isPaginate
        ? Uri.parse(LabController.to.labCurrentOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}lab/lab-order-list-pending/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // LabController.to.totalOrders(data['total_order'] ?? 0);
      // LabController.to.currentOrders(data['total_pending_order'] ?? 0);
      data['lab_order_list']['data'].forEach((element) {
        labOrders.add(LabOrderModel.fromJson(element));
      });
      if (data['lab_order_list']['next_page_url'] != null) {
        LabController.to.labCurrentOrderNextPageUrl(data['lab_order_list']['next_page_url']);
      } else {
        LabController.to.labCurrentOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return labOrders;
  }

  ///Doctor Order List Data
  Future<List<DoctorAppointmentModel>> getDoctorOrderList({bool isPaginate = false}) async {
    List<DoctorAppointmentModel> appointments = [];
    var url = DoctorAppointmentController.to.doctorOrderNextPageUrl.isNotEmpty
        ? Uri.parse(DoctorAppointmentController.to.doctorOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}doctor/appointment-list/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      DoctorAppointmentController.to.totalOrders(data['total'] ?? 0);
      DoctorAppointmentController.to.currentOrders(data['pending'] ?? 0);
      data['appointment_list']['data'].forEach((element) {
        appointments.add(DoctorAppointmentModel.fromJson(element));
      });
      if (data['appointment_list']['next_page_url'] != null) {
        DoctorAppointmentController.to.doctorOrderNextPageUrl(data['appointment_list']['next_page_url']);
      } else {
        DoctorAppointmentController.to.doctorOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return appointments;
  }

  ///Doctor Previous Order List Data
  Future<List<DoctorAppointmentModel>> getDoctorPreviousOrderList({bool isPaginate = false}) async {
    List<DoctorAppointmentModel> appointments = [];
    var url = isPaginate
        ? Uri.parse(DoctorAppointmentController.to.doctorPreviousOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}doctor/appointment-list-delivered/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // DoctorAppointmentController.to.totalOrders(data['total'] ?? 0);
      // DoctorAppointmentController.to.currentOrders(data['pending'] ?? 0);
      data['appointment_list']['data'].forEach((element) {
        appointments.add(DoctorAppointmentModel.fromJson(element));
      });
      if (data['appointment_list']['next_page_url'] != null) {
        DoctorAppointmentController.to.doctorPreviousOrderNextPageUrl(data['appointment_list']['next_page_url']);
      } else {
        DoctorAppointmentController.to.doctorPreviousOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return appointments;
  }

  ///Doctor Current Order List Data
  Future<List<DoctorAppointmentModel>> getDoctorCurrentOrderList({bool isPaginate = false}) async {
    List<DoctorAppointmentModel> appointments = [];
    var url = isPaginate
        ? Uri.parse(DoctorAppointmentController.to.doctorCurrentOrderNextPageUrl.value)
        : Uri.parse("${apiUrl}doctor/appointment-list-pending/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // DoctorAppointmentController.to.totalOrders(data['total'] ?? 0);
      // DoctorAppointmentController.to.currentOrders(data['pending'] ?? 0);
      data['appointment_list']['data'].forEach((element) {
        appointments.add(DoctorAppointmentModel.fromJson(element));
      });
      if (data['appointment_list']['next_page_url'] != null) {
        DoctorAppointmentController.to.doctorCurrentOrderNextPageUrl(data['appointment_list']['next_page_url']);
      } else {
        DoctorAppointmentController.to.doctorCurrentOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return appointments;
  }

  ///Medicine Single Order Item List Data
  Future<List<MedicineSingleOrderItemModel>> getMedicineSingleOrderItemList(String orderId) async {
    List<MedicineSingleOrderItemModel> medicineSingleOrderItems = [];
    var url = Uri.parse("${apiUrl}medicine/medicine-order-itmes/$orderId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['orders_items'].forEach((element) {
        medicineSingleOrderItems.add(MedicineSingleOrderItemModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return medicineSingleOrderItems;
  }

  Future<List<HealthCareCategoryModel>> getHomeHeathCareSubCategories(String categoryId) async {
    List<HealthCareCategoryModel> heathCareSubCategories = [];
    var url = Uri.parse("${apiUrl}healthcare/category-with-subcategory/$categoryId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['cat_with_subcat'].forEach((element) {
        heathCareSubCategories.add(HealthCareCategoryModel.fromJson(element));
        // HealthCareController.to.categoryWiseData
        //     .add({'loading': false, 'next_page_url': '', element['id']: []});
      });
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return heathCareSubCategories;
  }

  Future<UserModel> getUser(String id) async {
    UserModel userInfo = UserModel();
    var url = Uri.parse("${apiUrl}user-info/$id");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      userInfo = UserModel.fromJson(data['user_info']);
    } else {
      showAlert(data['message']);
    }

    return userInfo;
  }

  Future<bool> updateToken({
    required String userType,
    required String userId,
    required String token,
  }) async {
    var url = Uri.parse("${apiUrl}userUpdateToken?user_type=$userType&user_id=$userId&token=$token");
    var response = await http.post(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (response.statusCode == 200) {
      return data['status'];
    } else {
      return false;
    }
  }

  Future<String> getUserId(String countryCode, String phone) async {
    String id = "";
    var url = Uri.parse("${apiUrl}login");
    print(url);

    var request = http.MultipartRequest("POST", url);
    request.fields.addAll({"country_code": countryCode, "phone": phone});
    // var response = await http.post(url, body: {"phone": phone});
    final res = await request.send();
    var response = await http.Response.fromStream(res);

    globalLogger.d(response.body, "LOG IN LOG");
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    print("Response data is=========> $data");

    //removing the progress bar
    Get.back();

    //checking if the user is valid
    if (data['status'] == true) {
      id = data['user']['id'].toString();
    } else {
      showAlert(data['message']);
    }
    print('login ID==============>>>>>> $id');
    return id;
  }



  void forgotPassword(String userId, String password, String code) async {
    var url = Uri.parse("${apiUrl}change-password");
    var response = await http.post(url, body: {"user_id": userId, "code": code, "new_password": password});
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    //checking if the user is valid
    ///TODO:Uncomment
    // if (data['status'] == true) {
    //   Get.offAllNamed(HomeScreen.routeName);
    // } else {
    //   showAlert(data['message']);
    // }
  }

  Future<String> forgotPasswordCode(String email) async {
    String userId = "";
    var url = Uri.parse("${apiUrl}forget-password");
    var response = await http.post(url, body: {"email": email});
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      userId = data['user_id'].toString();
      Get.snackbar("Success", "Verification code sent successfully", snackPosition: SnackPosition.BOTTOM);
    } else {
      showAlert(data['message']);
    }

    return userId;
  }

  void registerUser(RegisterModel registerModel) async {
    var url = Uri.parse("${apiUrl}user-registration");
    var response = await http.post(url, body: {
      "name": registerModel.name,
      "email": registerModel.email,
      "phone": registerModel.phone,
      "country_id": registerModel.countryId,
      "password": registerModel.password,
      'referel_code': registerModel.referelCode ?? "none",
      'gender': registerModel.gender,
    });
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    //removing the progress bar
    Get.back();

    //checking if the user is valid
    ///TODO:Uncomment
    // if (data['status'] == true) {
    //   Get.defaultDialog(
    //     title: "Success",
    //     content: const Text("Registration Successful"),
    //     actions: [
    //       ElevatedButton(
    //         child: const Text("OK"),
    //         onPressed: () {
    //           Get.offAllNamed(HomeScreen.routeName);
    //         },
    //       )
    //     ],
    //   );
    // } else {
    //   showAlert(data['message']);
    // }
  }

  Future<bool> updateUser(UserModel userInfo) async {
    bool status = false;
    var url = Uri.parse("${apiUrl}profile-update");
    var response = await http.post(url, body: {
      "user_id": userInfo.id,
      "name": userInfo.name,
      "mobile": userInfo.mobile,
      'address': userInfo.address,
      'district': userInfo.district,
      'area': userInfo.area,
    });
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    //removing the progress bar
    Get.back();

    //checking if the user is valid
    ///TODO:Uncomment
    if (data['status'] == true) {
      status = true;
      Get.defaultDialog(
        title: "Success",
        content: const Text("Update Successful"),
        actions: [
          ElevatedButton(
            child: const Text("OK"),
            onPressed: () {
              Get.back();
            },
          )
        ],
      );
    } else {
      showAlert(data['message']);
    }

    return status;
  }

  void uploadImage(File image, String userId) async {
    var url = Uri.parse("${apiUrl}profile-image-update");
    var request = http.MultipartRequest("POST", url);
    request.fields['user_id'] = userId;
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    request.send().then(
      (response) {
        if (response.statusCode == 200) {
          ///TODO: Uncomment
          // Get.offAllNamed(HomeScreen.routeName);
        } else {
          showAlert("Something went wrong");
        }
      },
    );
  }

  Future<bool> verifyVerificationCode(String code, String userId) async {
    UserModel userInfo = UserModel();
    var url = Uri.parse("${apiUrl}login-verify");
    print(userId);
    var response = await http.post(url, body: {"verify_code": code, "user_id": userId});
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    //removing the progress bar
    Get.back();

    //checking if the code is valid
    if (data['status'] == true) {
      return true;
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  void resendVerificationCode(String userId) async {
    var url = Uri.parse("${apiUrl}resend-verify/$userId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      Get.snackbar("Success", "Verification code sent successfully", snackPosition: SnackPosition.BOTTOM);
    } else {
      showAlert(data['message']);
    }
  }

  Future<List<SliderModel>> getSliders() async {
    List<SliderModel> sliders = [];
    var url = Uri.parse("${apiUrl}slider-list");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['data'].forEach((element) {
        sliders.add(SliderModel.fromJson(element));
      });
      var HomeController;
      HomeController.to.featuredImage.value = data['fixed_depo_img']['image'] ?? "";
    }
    return sliders;
  }

  Future<UserStatusModel> getUserStatus(String userId) async {
    var url = Uri.parse("${apiUrl}user-reg-info/$userId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    return UserStatusModel.fromJson(data);
  }

  void getCompanyDetails() async {
    var url = Uri.parse("${apiUrl}company-details");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    CompanyController.to.title.value = data['company_details']['title'];
    CompanyController.to.body.value = data['company_details']['body'];
  }

  void showAlert(String message, {Color? color}) {
    Get.defaultDialog(
      title: "Error",
      content: Text(
        message,
        style: TextStyle(color: color),
      ),
      actions: [
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {
            Get.back();
          },
        )
      ],
    );
  }
}
