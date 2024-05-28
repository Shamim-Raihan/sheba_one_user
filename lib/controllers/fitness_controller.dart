import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/services/database_fitness.dart';
import 'package:shebaone/services/enums.dart';

import '../models/fitness_model.dart';
import 'fitness_appointment_controller.dart';

class FitnessController extends GetxController {
  static FitnessController get to => Get.find();
  final DatabaseFitness database = DatabaseFitness();
  Rx<FitnessByEnum> doctorByEnum = FitnessByEnum.city.obs;
  RxString headline = ''.obs;

  ///Use for search and others
  RxString city = ''.obs;

  ///Use for search and others
  RxBool useCity = false.obs;

  /// ------------------------------- USE FOR SEARCH PAGE --------------------------------///

  ///List of Search Doctor Data
  RxList<FitnessModel> doctorSearchList = <FitnessModel>[].obs;

  ///List of Search Doctor Data By Key
  RxList<FitnessModel> doctorSearchListByKey = <FitnessModel>[].obs;

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
  RxList<FitnessModel> doctorFilterList = <FitnessModel>[].obs;

  ///List of CHECK category
  RxList<bool> specialityCheckList = <bool>[].obs;

  ///List of CHECK sub category
  RxList<bool> cityCheckList = <bool>[].obs;

  ///List of CHECK brand
  RxList<bool> organCheckList = <bool>[].obs;

  ///price type
  Rx<PriceType> priceType = PriceType.two_50.obs;

  ///Gender type
  Rx<FitnessGender> genderType = FitnessGender.male.obs;

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

  void changeDoctorByActivityWithLabel(FitnessByEnum itemEnum, String label) {
    doctorByEnum.value = itemEnum;
    headline.value = label;
  }

  void changeDoctorByActivity(FitnessByEnum itemEnum) {
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
    final cityId = "";
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
  Future<void> getDoctorSearchListByKey(
    String keyword,
  ) async {
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
  Future<void> getFilterDoctorList(bool searchByCategory,
      {bool paginateCall = false}) async {
    if (paginateCall) {
      filterAddLoading(true);
      try {
        await database.getFitnessFilterList(searchByCategory,
            paginateCall: paginateCall);
      } catch (e) {
        debugPrint(e.toString());
      }
      filterAddLoading(false);
    } else {
      filterLoading(true);
      try {
        await database.getFitnessFilterList(searchByCategory);
      } catch (e) {
        debugPrint(e.toString());
      }
      filterLoading(false);
    }
  }

  Map<String, dynamic> processFilterData(bool shouldFilterCategory) {
    Map<String, dynamic> data = {};
    if (shouldFilterCategory) {
      List<String> categoryList = [];
      final list = FitnessAppointmentController.to.getDoctorSpecialityList;
      final checkedList = FitnessController.to.specialityCheckList;
      for (int i = 0; i < list.length; i++) {
        if (checkedList[i]) {
          categoryList.add(list[i]);
        }
      }
      data['category'] = categoryList;
    }
    data['gender'] = genderType.value.name.toString();
    data['fee'] = priceType.value == PriceType.two_50
        ? '250'
        : priceType.value == PriceType.five_100
        ? '500'
        : '5000';
    return data;
  }
}
