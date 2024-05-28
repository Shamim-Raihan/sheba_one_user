import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/models/appointment_slot_model.dart';
import 'package:shebaone/models/doctor_appointment_model.dart';
import 'package:shebaone/models/doctor_city_model.dart';
import 'package:shebaone/models/doctor_model.dart';
import 'package:shebaone/models/doctor_organ_model.dart';
import 'package:shebaone/models/doctor_speciality_model.dart';
import 'package:shebaone/services/database.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/global.dart';

class DoctorAppointmentController extends GetxController {
  static DoctorAppointmentController get to => Get.find();
  final Database database = Database();

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
  Rx<DoctorViewAll> doctorViewAll = DoctorViewAll.generic.obs;

  ///All DoctorSpeciality List OBS
  RxList<DoctorSpecialityModel> doctorSpecialityList =
      <DoctorSpecialityModel>[].obs;

  ///All DoctorSpeciality List OBS
  RxList doctorSpecialityStringList = [].obs;

  ///Get All DoctorSpeciality List
  List<DoctorSpecialityModel> get getDoctorSpecialityList =>
      doctorSpecialityList;

  ///All Doctor Sub Speciality List OBS
  RxList<DoctorSubSpecialityModel> doctorSubSpecialityList =
      <DoctorSubSpecialityModel>[].obs;

  ///All DoctorSpeciality List OBS
  RxList<String> doctorSubSpecialityStringList = <String>[].obs;

  ///Get All DoctorSpeciality List
  List<DoctorSubSpecialityModel> get getDoctorSubSpecialityList =>
      doctorSubSpecialityList;

  ///Home Page Loading for DoctorSpeciality
  RxBool loading = false.obs;

  ///All DoctorSpeciality List OBS
  RxList<CityModel> doctorCityList = <CityModel>[].obs;

  ///Get All DoctorSpeciality List
  List<CityModel> get getDoctorCityList => doctorCityList;

  RxList cityList = [].obs;

  ///Home Page Loading for DoctorSpeciality
  RxBool doctorCityLoading = false.obs;

  ///All DoctorOrgan List OBS
  RxList<OrganModel> doctorOrganList = <OrganModel>[].obs;

  ///Get All DoctorOrgan List
  List<OrganModel> get getDoctorOrganList => doctorOrganList;

  ///Home Page Loading for DoctorOrgan
  RxBool doctorOrganLoading = false.obs;

  ///Single doctor loading
  RxBool singleDoctorLoading = false.obs;

  ///All DoctorSpeciality List OBS
  RxList<DoctorModel> doctorByCategoryList = <DoctorModel>[].obs;
  RxList<DoctorModel> doctorFilterListInPage = <DoctorModel>[].obs;

  ///Get All DoctorSpeciality List
  List<DoctorModel> get getDoctorByCategoryList => doctorByCategoryList;

  ///Home Page Loading for DoctorSpeciality
  RxBool doctorByCategoryLoading = false.obs;

  ///All Doctor List OBS
  RxList<DoctorModel> doctorList = <DoctorModel>[].obs;

  ///Speciality Doctor List OBS
  RxList<DoctorModel> specialityDoctorList = <DoctorModel>[].obs;

  ///All Online Doctor List OBS
  RxList<DoctorModel> onlineDoctorList = <DoctorModel>[].obs;

  ///All Online Doctor List OBS
  RxList<DoctorModel> onlineDoctorListBySpeciality = <DoctorModel>[].obs;

  ///All Online Doctor List OBS
  RxList<String> onlineSpeciality = <String>[].obs;

  ///Get All Doctor List
  List<DoctorModel> get getDoctorList => doctorList;

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
  Rx<DoctorModel> singleDoctorDetails = DoctorModel().obs;

  ///Get Single Doctor Profile
  DoctorModel get getSingleDoctorDetails => singleDoctorDetails.value;

  ///Single Doctor Appointment Slot (Regular Online)
  RxList<AppointmentSlotModel> appointmentSlotModelList =
      <AppointmentSlotModel>[].obs;

  ///Get Single Doctor Appointment Slot (Regular Online)
  List<AppointmentSlotModel> get getAppointmentSlotModelList =>
      appointmentSlotModelList;

  ///Single Doctor Appointment Slot (Home)
  RxList<HomeAppointmentSlotModel> homeAppointmentSlotModelList =
      <HomeAppointmentSlotModel>[].obs;

  ///Get Single Doctor Appointment Slot (Home)
  List<HomeAppointmentSlotModel> get getHomeAppointmentSlotModelList =>
      homeAppointmentSlotModelList;

  ///Single Doctor Appointment Slot (All)
  RxList<GenericAppointmentSlotModel> appointmentList =
      <GenericAppointmentSlotModel>[].obs;

  ///Get Single Doctor Appointment Slot (All)
  List<GenericAppointmentSlotModel> get getAppointmentList => appointmentList;

  ///Unique Appointment Slot (All)
  RxList<GenericAppointmentSlotModel> uniqueAppointmentList =
      <GenericAppointmentSlotModel>[].obs;

  ///Get Unique Appointment Slot (All)
  List<GenericAppointmentSlotModel> get getUniqueAppointmentList =>
      uniqueAppointmentList;

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
  Rx<AppointmentType> appointmentType = AppointmentType.clinic.obs;

  /// ------------------------------- USE FOR ORDER PAGE --------------------------------///

  ///Order list
  RxList<DoctorAppointmentModel> appointmentOrderList =
      <DoctorAppointmentModel>[].obs;

  ///Loading for Order Data
  RxBool orderListLoading = false.obs;

  ///Previous Order list
  RxList<DoctorAppointmentModel> previousAppointmentOrderList =
      <DoctorAppointmentModel>[].obs;

  ///Previous Loading for Order Data
  RxBool previousOrderListLoading = false.obs;

  ///Current Order list
  RxList<DoctorAppointmentModel> currentAppointmentOrderList =
      <DoctorAppointmentModel>[].obs;

  ///Current Loading for Order Data
  RxBool currentOrderListLoading = false.obs;

  ///Current Orders
  RxInt currentOrders = 0.obs;

  ///Total Orders
  RxInt totalOrders = 0.obs;

  /// ------------------------------- END USE FOR ORDER PAGE --------------------------------///
  @override
  void onReady() async {
    await getSpecialityDoctorList();
    // await getDoctorSpeciality(0);
    await getDoctorCity();
    await getDoctorOrgan();
    super.onReady();
  }

  String getOrganName(String id) {
    for (var element in getDoctorOrganList) {
      if (element.id == id) {
        return element.specialOrgan!;
      }
    }
    return getDoctorOrganList.isNotEmpty
        ? getDoctorOrganList[0].specialOrgan!
        : '';
  }

  ///Doctor Appointment Order List Get
  Future<void> getOrderList({bool isPaginate = false}) async {
    List<DoctorAppointmentModel> info = [];
    if (isPaginate) {
      doctorOrderAddLoading(true);
    } else {
      orderListLoading(true);
    }
    try {
      info = await database.getDoctorOrderList(isPaginate: isPaginate);
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
  Future<void> getSpecialityDoctorList() async {
    try {
      globalLogger.d('data', 'specialityDoctorList');
      final data = await database.getSpecialityDoctor();
      globalLogger.d(data, 'specialityDoctorList');
      for (var element in data) {
        if (element['doctor'] != null) {
          specialityDoctorList.add(DoctorModel.fromJson(element['doctor']));
        }
      }
      globalLogger.d(specialityDoctorList.length, 'specialityDoctorList');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  ///Doctor Previous Appointment Order List Get
  Future<void> getPreviousOrderList({bool isPaginate = false}) async {
    List<DoctorAppointmentModel> info = [];
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
    List<DoctorAppointmentModel> info = [];
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

  String getOrganId(String name) {
    for (var element in getDoctorOrganList) {
      if (element.specialOrgan == name) {
        return element.id!;
      }
    }
    return '';
  }

  String getSpecializationName(String id) {
    for (var element in getDoctorSpecialityList) {
      if (element.id == id) {
        return element.specialization!;
      }
    }
    return getDoctorSpecialityList.isNotEmpty
        ? getDoctorSpecialityList[0].specialization!
        : '';
  }

  String getSpecializationId(String name) {
    for (var element in getDoctorSpecialityList) {
      if (element.specialization == name) {
        return element.id!;
      }
    }
    return '';
  }

  String getCityName(String id) {
    for (var element in getDoctorCityList) {
      if (element.id == id) {
        return element.city!;
      }
    }
    return getDoctorCityList.isNotEmpty ? getDoctorCityList[0].city! : '';
  }

  String getCityId(String name) {
    for (var element in getDoctorCityList) {
      if (element.city == name) {
        return element.id!;
      }
    }
    return '';
  }

  String getSubSpecializationName(String? id) {
    if (id == null) return '';
    for (var element in getDoctorSubSpecialityList) {
      if (element.id == id) {
        return element.subSpecialization!;
      }
    }
    return getDoctorSubSpecialityList.isNotEmpty
        ? getDoctorSubSpecialityList[0].subSpecialization!
        : '';
  }

  String getSubSpecializationId(String name) {
    for (var element in getDoctorSubSpecialityList) {
      if (element.subSpecialization == name) {
        return element.id!;
      }
    }
    return '';
  }

  ///Get DoctorSpeciality Data
  Future<void> getDoctorSpeciality(int isWomenRelated) async {
    try {
      loading.value = true;
      globalLogger.d('doctorSpecialityList Init');
      DoctorController.to.specialityCheckList.value = [];
      doctorSpecialityList.value = await database.getDoctorSpecialityData(isWomenRelated);
      globalLogger.d(doctorSpecialityList, 'doctorSpecialityList.value');
      for (var element in doctorSpecialityList) {
        DoctorController.to.specialityCheckList.add(false);
      }
      doctorSpecialityStringList.value = [];
      doctorSpecialityStringList.add('All');
      for (var element in doctorSpecialityList) {
        doctorSpecialityStringList.add(element.specialization!);
      }

      globalLogger.d(
          doctorSpecialityStringList, 'doctorSpecialityStringList.value');
    } catch (e) {
      debugPrint(e.toString());
    }
    loading.value = false;
  }

  ///Get DoctorCity Data
  Future<void> getDoctorCity() async {
    try {
      doctorCityLoading.value = true;
      DoctorController.to.cityCheckList.value = [];
      doctorCityList.value = await database.getDoctorCityData();
      for (var element in doctorCityList) {
        DoctorController.to.cityCheckList.add(false);
      }
      List _location = [];
      for (var element in DoctorAppointmentController.to.getDoctorCityList) {
        _location.add(element.city!);
      }
      cityList.value = _location;
    } catch (e) {
      debugPrint(e.toString());
    }
    doctorCityLoading.value = false;
  }

  ///Get DoctorOrgan Data
  Future<void> getDoctorOrgan() async {
    try {
      doctorOrganLoading.value = true;

      DoctorController.to.organCheckList.value = [];
      doctorOrganList.value = await database.getDoctorOrganData();
      for (var element in doctorOrganList) {
        DoctorController.to.organCheckList.add(false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    doctorOrganLoading.value = false;
  }

  ///Get DoctorSpeciality Data
  Future<void> getDoctorListByCategory(
      String categoryValue, DoctorByEnum doctorByCategory, String? city) async {
    try {
      doctorByCategoryList.value = [];
      doctorByCategoryLoading.value = true;
      if (doctorByCategory == DoctorByEnum.city) {
        DoctorController.to.changeCity(categoryValue);
      }
      globalLogger.d(city);
      final data = await database.getDoctorByCategory(
          categoryValue, doctorByCategory, city);
      doctorByCategoryList.value = data;
      doctorFilterListInPage.value = data;
    } catch (e) {
      debugPrint(e.toString());
    }

    // 12 Doctors Available in Dhaka
    doctorByCategory == DoctorByEnum.city
        ? DoctorController.to.changeLabel(
            '${doctorByCategoryList.length} Doctor Available in ${doctorByCategory==DoctorByEnum.city?getCityName( categoryValue):categoryValue}')
        : DoctorController.to
            .changeLabel('${doctorByCategoryList.length} Doctor Available');
    doctorByCategoryLoading.value = false;
  }

  ///Get All Doctor
  Future<void> getAllDoctor([bool isNotPrimary = false]) async {
    try {
      if (nextPage.value.isEmpty && !isNotPrimary) {
        print('======================');
        doctorLoading.value = true;
        doctorList.value = await database.getAllDoctor();
      } else {
        addDoctorLoading.value = true;
        print('Working...');
        final data = await database.getAllDoctor(urlS: nextPage.value);
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
        onlineDoctorList.value = await database.getOnlineDoctor();

        onlineSpeciality.add('All');
      } else {
        addOnlineDoctorLoading.value = true;
        print('Working...');
        final data = await database.getOnlineDoctor(urlS: nextPageOnline.value);
        onlineDoctorList.addAll(data);
      }
      for (var element in onlineDoctorList) {
        if (!onlineSpeciality.contains(element.specialization!)) {
          onlineSpeciality.add(element.specialization!);
        }
      }
      getOnlineDoctorBySpeciality(speciality);
    } catch (e) {
      debugPrint(e.toString());
    }
    onlineDoctorLoading.value = false;
    addOnlineDoctorLoading.value = false;
  }

  getOnlineDoctorBySpeciality(String speciality) {
    onlineDoctorListBySpeciality.value = [];
    if (speciality == 'All') {
      onlineDoctorListBySpeciality.value = onlineDoctorList;
    }
    for (var element in onlineDoctorList) {
      if (element.specialization == speciality) {
        onlineDoctorListBySpeciality.add(element);
      }
    }
  }

  ///Get Specific DoctorDetails
  Future<void> getSingleDoctor(String doctorId) async {
    try {
      doctorDetailsLoading.value = true;
      uniqueAppointmentList.value = [];
      appointmentList.value = [];
      appointmentSlotModelList.value = [];
      homeAppointmentSlotModelList.value = [];
      mapAppointmentList.value = {};
      singleDoctorLoading(true);
      singleDoctorDetails.value = await database.getSingleDoctor(doctorId);
      singleDoctorLoading(false);
    } catch (e) {
      debugPrint(e.toString());
    }
    doctorDetailsLoading.value = false;
  }

  ///Set AppointSlot
  void setAppointmentSlot(List<AppointmentSlotModel> appSlotList,
      List<HomeAppointmentSlotModel> homeAppointmentList) {
    appointmentSlotModelList.value = appSlotList;
    homeAppointmentSlotModelList.value = homeAppointmentList;
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
          "type": element.type == AppointmentType.clinic ? 'Regular' : 'Online',
          "slot_id": element.id,
          "doctor_id": element.doctorInfoId,
          "status": element.appointmentStatus,
        };
        String jsonStringMap = json.encode(data);
        appointmentList.add(
            GenericAppointmentSlotModel.fromJson(jsonDecode(jsonStringMap)));
      }
    }
    //Generic Appointment List Create from Home Appointment slot
    for (var element in homeAppointmentSlotModelList) {
      if (DateTime.parse(element.appointmentDate!)
                  .difference(DateTime.now())
                  .inDays <
              30 &&
          element.appointmentStatus.toString().toLowerCase() == 'free') {
        // print(DateFormat('dd-MM-yyyy')
        //     .format(DateTime.parse(element.appointmentDate!)));

        // print(element.id);
        // print(element.type);

        final data = {
          "date":
              DateFormat.d().format(DateTime.parse(element.appointmentDate!)),
          "dmy": DateFormat('dd-MM-yyyy')
              .format(DateTime.parse(element.appointmentDate!)),
          "day":
              DateFormat.E().format(DateTime.parse(element.appointmentDate!)),
          "full_day": DateFormat.yMMMMEEEEd()
              .format(DateTime.parse(element.appointmentDate!)),
          "start_time": DateFormat.jm().format(DateTime.parse(
              '${element.appointmentDate}T${element.appointmentTime}')),
          "type": 'Home',
          "slot_id": element.id,
          "doctor_id": element.doctorId,
          "status": element.appointmentStatus,
        };
        String jsonStringMap = json.encode(data);
        appointmentList.add(
            GenericAppointmentSlotModel.fromJson(jsonDecode(jsonStringMap)));
      }
    }
    appointmentList.sort((a, b) {
      return a.dmy!.compareTo(b.dmy!);
    });
    //Unique List Create
    var seen = <String>{};
    uniqueAppointmentList.value = appointmentList
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

  void setSelectedAppointmentSlot(
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
