import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/models/doctor_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';

class DoctorController extends GetxController {
  static DoctorController get to => Get.find();
  final Database database = Database();
  Rx<DoctorByEnum> doctorByEnum = DoctorByEnum.city.obs;
  RxString headline = ''.obs;

  ///Use for search and others
  RxString city = ''.obs;

  ///Use for search and others
  RxBool useCity = false.obs;

  /// ------------------------------- USE FOR SEARCH PAGE --------------------------------///

  ///List of Search Doctor Data
  RxList<DoctorModel> doctorSearchList = <DoctorModel>[].obs;

  ///List of Search Doctor Data By Key
  RxList<DoctorModel> doctorSearchListByKey = <DoctorModel>[].obs;

  ///Loading for Order Data
  RxBool searchListLoading = false.obs;

  ///Loading for Search Data
  RxBool searchLoading = false.obs;

  ///Loading for Search Data
  RxString nextPageSearch = ''.obs;

  ///Location for Search Data
  RxString searchLocation = ''.obs;

  /// ------------------------------- END USE FOR SEARCH PAGE --------------------------------///

  /// ------------------------------- USE FOR FILTER --------------------------------///

  ///List of Filter Doctor Data
  RxList<DoctorModel> doctorFilterList = <DoctorModel>[].obs;

  ///List of CHECK category
  RxList<bool> specialityCheckList = <bool>[].obs;

  ///List of CHECK sub category
  RxList<bool> cityCheckList = <bool>[].obs;

  ///List of CHECK brand
  RxList<bool> organCheckList = <bool>[].obs;

  ///price type
  Rx<PriceType> priceType = PriceType.two_50.obs;

  ///Gender type
  Rx<DoctorGender> genderType = DoctorGender.male.obs;

  ///Loading for Pagination Data
  RxBool filterAddLoading = false.obs;

  ///Loading for Search Data
  RxBool filterLoading = false.obs;

  ///Loading for Search Data
  RxString nextPageFilter = ''.obs;

  /// ------------------------------- END USE FOR FILTER --------------------------------///

  @override
  void onReady() async {
    super.onReady();
  }

  void changeDoctorByActivityWithLabel(DoctorByEnum itemEnum, String label) {
    doctorByEnum.value = itemEnum;
    headline.value = label;
  }

  void changeDoctorByActivity(DoctorByEnum itemEnum) {
    doctorByEnum.value = itemEnum;
  }

  void changeLabel(String label) {
    headline.value = label;
  }

  void changeCity(String cityS) {
    city.value = cityS;
  }

  ///Doctor Search List Get
  Future<void> getSearchList(String keyword,
      {bool paginateCall = false}) async {
    headline.value = 'Search Results';
    if (paginateCall) {
      searchListLoading(true);
      try {
        await database.getDoctorSearchList(nextPageSearch.value, city.value,
            paginateCall: paginateCall);
      } catch (e) {
        debugPrint(e.toString());
      }
      searchListLoading(false);
    } else {
      searchLoading(true);
      try {
        await database.getDoctorSearchList(keyword, city.value);
      } catch (e) {
        debugPrint(e.toString());
      }
      searchLoading(false);
    }
  }

  ///Doctor Search List By Key Get
  Future<void> getDoctorSearchListByKey(String keyword,) async {
    headline.value = 'Search Results';

      searchLoading(true);
      try {
        await database.getDoctorSearchListByKey(keyword, city.value);
      } catch (e) {
        debugPrint(e.toString());
      }
      searchLoading(false);

  }

  ///Doctor Filter List Get
  Future<void> getFilterDoctorList({bool paginateCall = false}) async {
    if (paginateCall) {
      filterAddLoading(true);
      try {
        await database.getDoctorFilterList(paginateCall: paginateCall);
      } catch (e) {
        debugPrint(e.toString());
      }
      filterAddLoading(false);
    } else {
      filterLoading(true);
      try {
        await database.getDoctorFilterList();
      } catch (e) {
        debugPrint(e.toString());
      }
      filterLoading(false);
    }
  }

  Map processFilterData() {
    Map data = {};
    if (doctorByEnum.value == DoctorByEnum.speciality) {
      List<String> _list = [];
      for (int i = 0; i < specialityCheckList.length; i++) {
        if (specialityCheckList[i]) {
          _list.add(DoctorAppointmentController
              .to.getDoctorSpecialityList[i].id!);
        }
      }
      data['specialization'] = json.encode(_list);
    } else if (doctorByEnum.value == DoctorByEnum.organ) {
      List<String> _list = [];
      for (int i = 0; i < organCheckList.length; i++) {
        if (organCheckList[i]) {
          _list.add(DoctorAppointmentController
              .to.getDoctorOrganList[i].id!);
        }
      }
      data['special_organ'] = json.encode(_list);
    } else {
      List<String> _list = [];
      for (int i = 0; i < cityCheckList.length; i++) {
        if (cityCheckList[i]) {
          _list.add(DoctorAppointmentController.to.getDoctorCityList[i].id!);
        }
      }
      data['city'] = json.encode(_list);
    }

    data['gender'] = json
        .encode([genderType.value == DoctorGender.male ? 'Male' : 'Female']);
    data['consult_fee'] = json.encode([
      priceType.value == PriceType.two_50
          ? '250'
          : priceType.value == PriceType.five_100
              ? '500'
              : '5000'
    ]);
    return data;
  }

  processCityFilterData() {
    List<DoctorModel> _list = [];
    for (var element in DoctorAppointmentController.to.doctorFilterListInPage) {
      if (element.gender!.toLowerCase() ==
              (genderType.value == DoctorGender.male ? 'male' : 'female') &&
          double.parse(element.consultFee!) <=
              double.parse(priceType.value == PriceType.two_50
                  ? '250'
                  : priceType.value == PriceType.five_100
                      ? '500'
                      : '5000')) {
        _list.add(element);
      }
    }
    DoctorAppointmentController.to.doctorByCategoryList.value = _list;
    doctorByEnum.value == DoctorByEnum.city
        ? DoctorController.to.changeLabel(
            '${DoctorAppointmentController.to.doctorByCategoryList.length} Doctor Available in $city')
        : DoctorController.to.changeLabel(
            '${DoctorAppointmentController.to.doctorByCategoryList.length} Doctor Available');
  }
}
