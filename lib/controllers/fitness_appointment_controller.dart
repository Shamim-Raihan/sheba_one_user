import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/models/fitness_appointment_model.dart';
import 'package:shebaone/models/fitness_appointment_slot_model.dart';
import 'package:shebaone/services/database_fitness.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';

import '../models/doctor_city_model.dart';
import '../models/fitness_model.dart';
import 'fitness_controller.dart';

class FitnessAppointmentController extends GetxController {
  static FitnessAppointmentController get to => Get.find();
  final DatabaseFitness database = DatabaseFitness();

  ///Refer code
  RxString refferCode = ''.obs;

  /// ***************************** Paginate item start *****************************

  ///Doctor add loading
  RxBool doctorOrderAddLoading = false.obs;

  ///Doctor next page url
  RxString doctorOrderNextPageUrl = ''.obs;

  ///Doctor current add loading
  RxBool doctorCurrentOrderAddLoading = false.obs;

  ///Doctor current next page url
  RxString doctorCurrentOrderNextPageUrl = ''.obs;

  ///Doctor previous add loading
  RxBool doctorPreviousOrderAddLoading = false.obs;

  ///Doctor previous next page url
  RxString doctorPreviousOrderNextPageUrl = ''.obs;

  /// ***************************** Paginate item end *****************************

  ///doctorViewAll Type
  Rx<FitnessViewAll> doctorViewAll = FitnessViewAll.generic.obs;

  ///All DoctorSpeciality List OBS
  RxList<String> doctorSpecialityList = <String>[].obs;

  ///All DoctorSpeciality List OBS
  RxList doctorSpecialityStringList = [].obs;

  ///Get All DoctorSpeciality List
  List<String> get getDoctorSpecialityList => doctorSpecialityList;

  ///Home Page Loading for DoctorSpeciality
  RxBool loading = false.obs;

  ///All DoctorSpeciality List OBS
  RxList<CityModel> doctorCityList = <CityModel>[].obs;

  ///Get All DoctorSpeciality List
  List<CityModel> get getDoctorCityList => doctorCityList;

  RxList cityList = [].obs;

  ///Home Page Loading for DoctorSpeciality
  RxBool doctorCityLoading = false.obs;

  ///Single doctor loading
  RxBool singleDoctorLoading = false.obs;

  ///All DoctorSpeciality List OBS
  RxList<FitnessModel> doctorByCategoryList = <FitnessModel>[].obs;
  RxList<FitnessModel> doctorFilterListInPage = <FitnessModel>[].obs;

  ///Get All DoctorSpeciality List
  List<FitnessModel> get getDoctorByCategoryList => doctorByCategoryList;

  ///Home Page Loading for DoctorSpeciality
  RxBool doctorByCategoryLoading = false.obs;

  ///All Doctor List OBS
  RxList<FitnessModel> doctorList = <FitnessModel>[].obs;

  ///Speciality Doctor List OBS
  RxList<FitnessModel> specialityDoctorList = <FitnessModel>[].obs;

  ///All Online Doctor List OBS
  RxList<FitnessModel> onlineDoctorList = <FitnessModel>[].obs;

  ///All Online Doctor List OBS
  RxList<String> onlineSpeciality = <String>[].obs;

  ///Get All Doctor List
  List<FitnessModel> get getDoctorList => doctorList;

  ///Loading for Doctor
  RxBool doctorLoading = false.obs;

  ///Loading for Doctor Pagination
  RxBool addDoctorLoading = false.obs;

  ///Loading for Online Doctor
  RxBool onlineDoctorLoading = false.obs;

  ///Loading for Online Doctor Pagination
  RxBool addOnlineDoctorLoading = false.obs;

  ///Next Page URL
  RxString nextPage = ''.obs;

  ///Next Page URL For Online Doctor
  RxString nextPageOnline = ''.obs;

  ///Single Doctor Profile
  Rx<FitnessModel> singleDoctorDetails = FitnessModel().obs;

  ///Get Single Doctor Profile
  FitnessModel get getSingleDoctorDetails => singleDoctorDetails.value;

  ///Single Doctor Appointment Slot (Regular Online)
  RxList<FitnessAppointmentSlotModel> appointmentSlotModelList =
      <FitnessAppointmentSlotModel>[].obs;

  ///Get Single Doctor Appointment Slot (Regular Online)
  List<FitnessAppointmentSlotModel> get getAppointmentSlotModelList =>
      appointmentSlotModelList;

  ///Single Doctor Appointment Slot (All)
  RxList<GenericAppointmentSlotModel> appointmentList =
      <GenericAppointmentSlotModel>[].obs;

  ///Get Single Doctor Appointment Slot (All)
  List<GenericAppointmentSlotModel> get getAppointmentList => appointmentList;

  ///Unique Appointment Slot (All)
  RxList<GenericAppointmentSlotModel> uniqueAppointmentList2 =
      <GenericAppointmentSlotModel>[].obs;

  ///Get Unique Appointment Slot (All)
  List<GenericAppointmentSlotModel> get getUniqueAppointmentList =>
      uniqueAppointmentList2;

  ///Selected Appointment Slot By Date (All)
  RxList<GenericAppointmentSlotModel> selectedAppointmentListByDate =
      <GenericAppointmentSlotModel>[].obs;

  ///Get Selected Appointment Slot By Date (All)
  List<GenericAppointmentSlotModel> get getSelectedAppointmentListByDate =>
      selectedAppointmentListByDate;

  ///Map Appointment Slot (All)
  RxMap<String, List<GenericAppointmentSlotModel>> mapAppointmentList =
      <String, List<GenericAppointmentSlotModel>>{}.obs;

  ///Get Map Appointment Slot (All)
  Map<String, List<GenericAppointmentSlotModel>> get getMapAppointmentList =>
      mapAppointmentList;

  ///Loading for Doctor
  RxBool doctorDetailsLoading = false.obs;

  ///Loading for Doctor
  RxBool isBookAppointmentSucceed = false.obs;

  ///OnlinePackageType
  Rx<OnlinePackageType> onlinePackageType = OnlinePackageType.audio.obs;

  ///Appointment Loading
  RxBool appointmentLoading = false.obs;

  ///Map Appointment Slot (All)
  RxMap appointmentSuccessInfo = {}.obs;

  ///Appointment Type
  Rx<FitnessAppointmentType> appointmentType = FitnessAppointmentType.gym.obs;

  /// ------------------------------- USE FOR ORDER PAGE --------------------------------///

  ///Order list
  RxList<FitnessAppointmentModel> appointmentOrderList =
      <FitnessAppointmentModel>[].obs;

  ///Loading for Order Data
  RxBool orderListLoading = false.obs;

  ///Previous Order list
  RxList<FitnessAppointmentModel> previousAppointmentOrderList =
      <FitnessAppointmentModel>[].obs;

  ///Previous Loading for Order Data
  RxBool previousOrderListLoading = false.obs;

  ///Current Order list
  RxList<FitnessAppointmentModel> currentAppointmentOrderList =
      <FitnessAppointmentModel>[].obs;

  ///Current Loading for Order Data
  RxBool currentOrderListLoading = false.obs;

  ///Current Orders
  RxInt currentOrders = 0.obs;

  ///Total Orders
  RxInt totalOrders = 0.obs;

  /// ------------------------------- END USE FOR ORDER PAGE --------------------------------///
  @override
  void onReady() async {
    await getFitnessSpeciality();
    await getSpecialityFitnessList();
    await getDoctorCity();
    super.onReady();
  }

  ///Doctor Appointment Order List Get
  Future<void> getOrderList({bool isPaginate = false}) async {
    List<FitnessAppointmentModel> info = [];
    if (isPaginate) {
      doctorOrderAddLoading(true);
    } else {
      orderListLoading(true);
    }
    try {
      info = await database.getFitnessOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      appointmentOrderList.addAll(info);
      doctorOrderAddLoading(false);
    } else {
      appointmentOrderList.value = info;
      orderListLoading(false);
    }
  }

  ///Speciality Doctor List Get
  Future<void> getSpecialityFitnessList() async {
    try {
      final data = await database.getSpecialityFitness();
      globalLogger.d(data, 'specialityFitnessList');
      for (var element in data) {
        specialityDoctorList.add(FitnessModel.fromJson(element));
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Doctor Previous Appointment Order List Get
  Future<void> getPreviousOrderList({bool isPaginate = false}) async {
    List<FitnessAppointmentModel> info = [];
    if (isPaginate) {
      doctorPreviousOrderAddLoading(true);
    } else {
      previousOrderListLoading(true);
    }
    try {
      info = await database.getDoctorPreviousOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      previousAppointmentOrderList.addAll(info);
      doctorPreviousOrderAddLoading(false);
    } else {
      previousAppointmentOrderList.value = info;
      previousOrderListLoading(false);
    }
  }

  ///Doctor Current Appointment Order List Get
  Future<void> getCurrentOrderList({bool isPaginate = false}) async {
    List<FitnessAppointmentModel> info = [];
    if (isPaginate) {
      doctorCurrentOrderAddLoading(true);
    } else {
      currentOrderListLoading(true);
    }
    try {
      info = await database.getDoctorCurrentOrderList(isPaginate: isPaginate);
    } catch (e) {
      debugPrint(e.toString());
    }
    if (isPaginate) {
      currentAppointmentOrderList.addAll(info);
      doctorCurrentOrderAddLoading(false);
    } else {
      currentAppointmentOrderList.value = info;
      currentOrderListLoading(false);
    }
  }

  String getCityName(String id) {
    for (var element in getDoctorCityList) {
      if (element.id == id) {
        return element.city!;
      }
    }
    return getDoctorCityList.isNotEmpty ? getDoctorCityList[0].city! : id;
  }

  String getCityId(String name) {
    for (var element in getDoctorCityList) {
      if (element.city == name) {
        return element.id!;
      }
    }
    return name;
  }

  ///Get DoctorSpeciality Data
  Future<void> getFitnessSpeciality() async {
    try {
      loading.value = true;
      globalLogger.d('fitnessSpecialityList Init');
      FitnessController.to.specialityCheckList.value = [];
      doctorSpecialityList.value = await database.getFitnessSpecialityData();
      globalLogger.d(doctorSpecialityList, 'doctorSpecialityList.value');
      for (var element in doctorSpecialityList) {
        FitnessController.to.specialityCheckList.add(false);
      }
      doctorSpecialityStringList.value = [];
      doctorSpecialityStringList.add('All');
      for (var element in doctorSpecialityList) {
        doctorSpecialityStringList.add(element);
      }

      globalLogger.d(doctorSpecialityStringList, 'fitnessSpecialityList.value');
    } catch (e) {
      debugPrint(e.toString());
    }
    loading.value = false;
  }

  ///Get DoctorCity Data
  Future<void> getDoctorCity() async {
    try {
      doctorCityLoading.value = true;
      FitnessController.to.cityCheckList.value = [];
      doctorCityList.value = await database.getDoctorCityData();
      for (var element in doctorCityList) {
        FitnessController.to.cityCheckList.add(false);
      }
      List _location = [];
      for (var element in FitnessAppointmentController.to.getDoctorCityList) {
        _location.add(element.city!);
      }
      cityList.value = _location;
    } catch (e) {
      debugPrint(e.toString());
    }
    doctorCityLoading.value = false;
  }

  ///Get DoctorSpeciality Data
  Future<void> getDoctorListByCategory(
    String categoryValue,
    FitnessByEnum doctorByCategory,
    String? city,
  ) async {
    try {
      doctorByCategoryList.value = [];
      doctorByCategoryLoading.value = true;
      if (doctorByCategory == FitnessByEnum.city) {
        FitnessController.to.changeCity(categoryValue);
      }
      globalLogger.d(city);
      final data = await database.getDoctorByCategory(
        categoryValue,
        doctorByCategory,
        city,
      );
      doctorByCategoryList.value = data;
      doctorFilterListInPage.value = data;
    } catch (e) {
      debugPrint(e.toString());
    }

    // 12 Doctors Available in Dhaka
    doctorByCategory == FitnessByEnum.city
        ? FitnessController.to.changeLabel(
            '${doctorByCategoryList.length} Fitness Center Available in ${doctorByCategory == FitnessByEnum.city ? getCityName(categoryValue) : categoryValue}')
        : FitnessController.to.changeLabel(
            '${doctorByCategoryList.length} Fitness Center Available');
    doctorByCategoryLoading.value = false;
  }

  ///Get All Doctor
  Future<void> getAllDoctor([bool isNotPrimary = false]) async {
    try {
      if (nextPage.value.isEmpty && !isNotPrimary) {
        print('======================');
        doctorLoading.value = true;
        doctorList.value = await database.getAllFitness();
      } else {
        addDoctorLoading.value = true;
        print('Working...');
        final data = await database.getAllFitness(urlS: nextPage.value);
        doctorList.addAll(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    doctorLoading.value = false;
    addDoctorLoading.value = false;
  }

  ///Get Online Doctor
  Future<void> getAllOnlineDoctor(String speciality,
      [bool isNotPrimary = false]) async {
    try {
      if (nextPageOnline.value.isEmpty && !isNotPrimary) {
        onlineSpeciality.value = [];
        print('======================');
        onlineDoctorLoading.value = true;
        onlineDoctorList.value = await database.getAllFitness();

        onlineSpeciality.add('All');
      } else {
        addOnlineDoctorLoading.value = true;
        print('Working...');
        final data = await database.getAllFitness(urlS: nextPageOnline.value);
        onlineDoctorList.addAll(data);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    onlineDoctorLoading.value = false;
    addOnlineDoctorLoading.value = false;
  }

  ///Get Specific DoctorDetails
  Future<void> getSingleDoctor(String doctorId) async {
    try {
      doctorDetailsLoading.value = true;
      uniqueAppointmentList2.value = [];
      appointmentList.value = [];
      appointmentSlotModelList.value = [];
      mapAppointmentList.value = {};
      singleDoctorLoading(true);
      singleDoctorDetails.value = await database.getSingleFitness(doctorId);
      singleDoctorLoading(false);
    } catch (e) {
      debugPrint(e.toString());
    }
    doctorDetailsLoading.value = false;
  }

  ///Set AppointSlot
  void setAppointmentSlot(List<FitnessAppointmentSlotModel> appSlotList) {
    appointmentSlotModelList.value = appSlotList;
    //Generic Appointment List Create from Regular and Online Appointment slot
    for (var element in appointmentSlotModelList) {
      if (DateTime.parse(element.appointmentStart!)
                  .difference(DateTime.now())
                  .inDays <
              30 &&
          element.appointmentStatus.toString().toLowerCase() == 'free') {
        // print(DateFormat('dd-MM-yyyy')
        //     .format(DateTime.parse(element.appointmentStart!)));
        print(element.id);
        print(element.type);

        Map<String, dynamic> data = {
          "date":
              DateFormat.d().format(DateTime.parse(element.appointmentStart!)),
          "dmy": DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(element.appointmentStart!)),
          "day":
              DateFormat.E().format(DateTime.parse(element.appointmentStart!)),
          "full_day": DateFormat.yMMMMEEEEd()
              .format(DateTime.parse(element.appointmentStart!)),
          "start_time":
              DateFormat.jm().format(DateTime.parse(element.appointmentStart!)),
          "type": element.type == FitnessAppointmentType.wellness
              ? 'Wellness'
              : element.type == FitnessAppointmentType.yoga
                  ? 'Yoga'
                  : 'Gym',
          "slot_id": element.id,
          "fitness_id": element.doctorInfoId,
          "status": element.appointmentStatus,
        };
        String jsonStringMap = json.encode(data);
        appointmentList.add(
          GenericAppointmentSlotModel.fromJson(jsonDecode(jsonStringMap)),
        );
      }
    }
    appointmentList.sort((a, b) {
      return a.dmy!.compareTo(b.dmy!);
    });
    //Unique List Create
    var seen = <String>{};
    uniqueAppointmentList2.value = appointmentList
        .where((appointment) => seen.add(appointment.date!))
        .toList();
    //Map Appointment Slot by Date
    for (var appointment in appointmentList) {
      if (mapAppointmentList[appointment.date] == null) {
        mapAppointmentList[appointment.date!] = [];
        mapAppointmentList[appointment.date]!.add(appointment);
      } else {
        mapAppointmentList[appointment.date]!.add(appointment);
      }
    }

    print(mapAppointmentList);
  }

  void setSelectedAppointmentSlot2(
      List<GenericAppointmentSlotModel> appointments) {
    selectedAppointmentListByDate.value = appointments;
  }

  Future<bool> doctorAppointment(Map info) async {
    appointmentLoading(true);
    globalLogger.d('Here');
    final data = await database.postAppointment(info);
    if (data) {
      isBookAppointmentSucceed.value = true;
      getOrderList();
    }
    appointmentLoading(false);

    return data;
  }

  void setOnlinePackageType(OnlinePackageType type) {
    onlinePackageType.value = type;
  }

  void setNextPageURL(String url) {
    nextPage.value = url;
    print(nextPage.value);
  }
}
