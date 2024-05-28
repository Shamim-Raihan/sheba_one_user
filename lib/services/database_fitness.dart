import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shebaone/controllers/fitness_appointment_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/fitness_appointment_model.dart';
import 'package:shebaone/models/fitness_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';

import '../controllers/fitness_controller.dart';
import '../models/doctor_city_model.dart';
import '../models/fitness_appointment_slot_model.dart';

class DatabaseFitness {
  final String apiUrl = Database.apiUrl;

  ///Fitness Order List Data
  Future<List<FitnessAppointmentModel>> getFitnessOrderList({
    bool isPaginate = false,
  }) async {
    List<FitnessAppointmentModel> appointments = [];
    var url = FitnessAppointmentController.to.doctorOrderNextPageUrl.isNotEmpty
        ? Uri.parse(
            FitnessAppointmentController.to.doctorOrderNextPageUrl.value)
        : Uri.parse(
            "${apiUrl}fitness/appointment-list/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      FitnessAppointmentController.to.totalOrders(data['total'] ?? 0);
      FitnessAppointmentController.to.currentOrders(data['pending'] ?? 0);
      data['appointment_list']['data'].forEach((element) {
        appointments.add(FitnessAppointmentModel.fromJson(element));
      });
      if (data['appointment_list']['next_page_url'] != null) {
        FitnessAppointmentController.to
            .doctorOrderNextPageUrl(data['appointment_list']['next_page_url']);
      } else {
        FitnessAppointmentController.to.doctorOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return appointments;
  }

  ///Speciality with fitness List
  Future<List> getSpecialityFitness() async {
    List specialityFitness = [];
    var url = Uri.parse("${apiUrl}fitness-center-lists");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    globalLogger.d(data, 'FitnessList');
    if (data['status'] == true) {
      //for each data in the list
      specialityFitness = data['fitness_lists'];
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return specialityFitness;
  }

  ///Fitness Previous Order List Data
  Future<List<FitnessAppointmentModel>> getDoctorPreviousOrderList({
    bool isPaginate = false,
  }) async {
    List<FitnessAppointmentModel> appointments = [];
    var url = isPaginate
        ? Uri.parse(FitnessAppointmentController
            .to.doctorPreviousOrderNextPageUrl.value)
        : Uri.parse(
            "${apiUrl}doctor/appointment-list-delivered/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      data['appointment_list']['data'].forEach((element) {
        appointments.add(FitnessAppointmentModel.fromJson(element));
      });
      if (data['appointment_list']['next_page_url'] != null) {
        FitnessAppointmentController.to.doctorPreviousOrderNextPageUrl(
            data['appointment_list']['next_page_url']);
      } else {
        FitnessAppointmentController.to.doctorPreviousOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return appointments;
  }

  ///Fitness Current Order List Data
  Future<List<FitnessAppointmentModel>> getDoctorCurrentOrderList({
    bool isPaginate = false,
  }) async {
    List<FitnessAppointmentModel> appointments = [];
    var url = isPaginate
        ? Uri.parse(
            FitnessAppointmentController.to.doctorCurrentOrderNextPageUrl.value)
        : Uri.parse(
            "${apiUrl}doctor/appointment-list-pending/${UserController.to.getUserInfo.id}");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      // DoctorAppointmentController.to.totalOrders(data['total'] ?? 0);
      // DoctorAppointmentController.to.currentOrders(data['pending'] ?? 0);
      data['appointment_list']['data'].forEach((element) {
        appointments.add(FitnessAppointmentModel.fromJson(element));
      });
      if (data['appointment_list']['next_page_url'] != null) {
        FitnessAppointmentController.to.doctorCurrentOrderNextPageUrl(
            data['appointment_list']['next_page_url']);
      } else {
        FitnessAppointmentController.to.doctorCurrentOrderNextPageUrl('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return appointments;
  }

  Future<List<String>> getFitnessSpecialityData() async {
    return ["Gym", "Yoga", "Wellness"];
  }

  Future<List<CityModel>> getDoctorCityData() async {
    List<CityModel> doctorCityList = [];
    var url = Uri.parse("${apiUrl}fitness/city-lists");
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

  Future<List<FitnessModel>> getDoctorByCategory(
    String categoryValue,
    FitnessByEnum doctorByCategory,
    String? city,
  ) async {
    List<FitnessModel> fitnessList = [];
    var url = Uri.parse("${apiUrl}fitness/fitness-search");
    var response = await http.post(url, body: {'city': city});
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      data['fitness_search_lists'].forEach((element) {
        fitnessList.add(FitnessModel.fromJson(element));
      });
    } else {
      Get.back();
      showAlert(
          'Your selected category fitness center are not available, we are unable to book fitness center in this category for you. You may try other category/area.',
          color: Colors.red);
    }
    return fitnessList;
  }

  Future<List<FitnessModel>> getAllFitness({String? urlS}) async {
    List<FitnessModel> doctorList = [];
    var url = Uri.parse(urlS ?? "${apiUrl}fitness/fitness-lists-pagination");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['fitness_lists']['data'].forEach((element) {
        doctorList.add(FitnessModel.fromJson(element));
      });
      if (data['fitness_lists']['next_page_url'] != null) {
        FitnessAppointmentController.to
            .setNextPageURL(data['fitness_lists']['next_page_url']);
      } else {
        FitnessAppointmentController.to.setNextPageURL('');
      }
    } else {
      Get.back();
      showAlert(data['message']);
    }
    return doctorList;
  }

  Future<FitnessModel> getSingleFitness(String fitnessId) async {
    FitnessModel doctorModel = FitnessModel();
    List<FitnessAppointmentSlotModel> _appointmentList = [];
    var url = Uri.parse("${apiUrl}fitness/user-select-to-fitness/$fitnessId");
    var response = await http.get(url);
    var data = jsonDecode(response.body);
    debugPrint(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      globalLogger.d(data);
      doctorModel = FitnessModel.fromJson(data['fitness_info']);
      data['appointment_slot'].forEach((element) {
        _appointmentList.add(FitnessAppointmentSlotModel.fromJson(element));
      });
      FitnessAppointmentController.to.setAppointmentSlot(_appointmentList);
    } else {
      Get.back();
      showAlert(data['message']);
    }
    print(doctorModel.name);
    return doctorModel;
  }

  Future<bool> postAppointment(Map info) async {
    var url = Uri.parse("${apiUrl}fitness/fitness-appointment");
    globalLogger.d(url);
    globalLogger.d(info);
    var response = await http.post(url, body: info);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());

    //checking if the code is valid
    if (data['status'] == true) {
      FitnessAppointmentController.to
          .appointmentSuccessInfo(data['appointment']);
      return true;
    } else {
      showAlert(data['message']);
    }

    return false;
  }

  ///Doctor Search List Data
  Future<void> getDoctorSearchList(String keyword, String location,
      {bool paginateCall = false}) async {
    List<FitnessModel> doctorList = [];

    globalLogger.d("location: $location");
    var url = Uri.parse(paginateCall
        ? keyword
        : "${apiUrl}search/search-fitness?search_keyword=$keyword&city=$location");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['fitness']['data'].forEach((element) {
        doctorList.add(FitnessModel.fromJson(element));
      });
      if (data['fitness']['next_page_url'] != null) {
        FitnessController.to.nextPageSearch(data['fitness']['next_page_url'] +
            "&search_keyword=$keyword&city=$location");
      } else {
        FitnessController.to.nextPageSearch('');
      }
      FitnessController.to.doctorSearchList.addAll(doctorList);
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
    List<FitnessModel> doctorList = [];
    globalLogger.d("location: $location");
    var url = Uri.parse(
        "${apiUrl}search/search-fitness?search_keyword=$keyword&city=$location");
    var response = await http.post(url);
    globalLogger.d(response.body);
    var data = jsonDecode(response.body);
    globalLogger.d(data.toString());
    if (data['status'] == true) {
      //for each data in the list
      data['fitness']['data'].forEach((element) {
        doctorList.add(FitnessModel.fromJson(element));
      });
      FitnessController.to.doctorSearchListByKey.value = doctorList;
    } else {
      Get.back();
      showAlert(data['message']);
    }
  }

  ///Doctor Filter List Data
  Future<void> getFitnessFilterList(bool shouldFilterCategory, {bool paginateCall = false}) async {
    final Map<String, dynamic> info = FitnessController.to.processFilterData(shouldFilterCategory);
    globalLogger.d(info, 'INFO DATA');
    List<FitnessModel> doctorList = [];
    var url = Uri.parse(paginateCall
        ? FitnessController.to.nextPageFilter.value
        : "${apiUrl}fitness/city_filter_search");
    var response = await http.post(
      url,
      headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode(info),
    );
    var data = jsonDecode(response.body);
    globalLogger.d(data);
    // if (data['status'] == true) {
    if (response.statusCode == 200) {
      //for each data in the list
      data['search_result']['data'].forEach((element) {
        doctorList.add(FitnessModel.fromJson(element));
      });
      if (data['search_result']['next_page_url'] != null) {
        FitnessController.to.nextPageFilter(data['search_result']['next_page_url']);
      } else {
        FitnessController.to.nextPageFilter('');
      }
      FitnessController.to.doctorFilterList.value = doctorList;
      FitnessAppointmentController.to.doctorByCategoryList.value = doctorList;
      FitnessAppointmentController.to.doctorList.value = doctorList;
    } else {
      Get.back();
      showAlert(data['message']);
    }
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
