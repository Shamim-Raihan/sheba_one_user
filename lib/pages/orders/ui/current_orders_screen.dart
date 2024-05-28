import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/models/doctor_appointment_model.dart';
import 'package:shebaone/models/healthcare_order_model.dart';
import 'package:shebaone/models/lab_order_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/pages/home/parent_with_navbar.dart';
import 'package:shebaone/pages/orders/ui/appointment_details.dart';
import 'package:shebaone/pages/orders/ui/appointment_details_online_screen.dart';
import 'package:shebaone/pages/orders/ui/lab_order_details_screen.dart';
import 'package:shebaone/pages/orders/ui/order_details_screen.dart';
import 'package:shebaone/pages/orders/ui/orders_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class CurrentOrdersScreen extends StatefulWidget {
  const CurrentOrdersScreen({Key? key}) : super(key: key);
  static String routeName = "/CurrentOrdersScreen";

  @override
  State<CurrentOrdersScreen> createState() => _CurrentOrdersScreenState();
}

class _CurrentOrdersScreenState extends State<CurrentOrdersScreen> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollListener() async {
    if (HomeController.to.currentOrderListType.value == OrderType.healthcare) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!HealthCareController.to.healthcareCurrentOrderAddLoading.value &&
            HealthCareController.to.healthcareCurrentOrderNextPageUrl.value.isNotEmpty) {
          await HealthCareController.to.getCurrentOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.currentOrderListType.value == OrderType.medicine) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!MedicineController.to.medicineCurrentOrderAddLoading.value &&
            MedicineController.to.medicineCurrentOrderNextPageUrl.value.isNotEmpty) {
          await MedicineController.to.getCurrentOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.currentOrderListType.value == OrderType.lab) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!LabController.to.labCurrentOrderAddLoading.value &&
            LabController.to.labCurrentOrderNextPageUrl.value.isNotEmpty) {
          await LabController.to.getCurrentOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.currentOrderListType.value == OrderType.doctor) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (!DoctorAppointmentController.to.doctorCurrentOrderAddLoading.value &&
            DoctorAppointmentController.to.doctorCurrentOrderNextPageUrl.value.isNotEmpty) {
          await DoctorAppointmentController.to.getCurrentOrderList(isPaginate: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ParentPageWithNav(
      child: Column(
        children: [
          const AppBarWithSearch(
            isSearchShow: false,
            hasStyle: false,
            moduleSearch: ModuleSearch.none,
          ),
          BgContainer(
            horizontalPadding: 0,
            verticalPadding: 0,
            child: MainContainer(
              horizontalMargin: 0,
              verticalMargin: 0,
              verticalPadding: 20,
              borderColor: kScaffoldColor,
              color: kScaffoldColor,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Obx(
                          () => PrimaryButton(
                            contentPadding: 0,
                            height: 36,
                            elevation: .5,
                            marginHorizontal: 0,
                            marginVertical: 0,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            labelColor: HomeController.to.currentOrderListType.value == OrderType.healthcare
                                ? Colors.white
                                : const Color(0xff363942),
                            primary: HomeController.to.currentOrderListType.value == OrderType.healthcare
                                ? null
                                : Colors.white,
                            label: 'Healthcare Orders',
                            onPressed: () {
                              HomeController.to.currentOrderListType(OrderType.healthcare);
                              HealthCareController.to.getCurrentOrderList();
                            },
                          ),
                        ),
                      ),
                      space5R,
                      Expanded(
                        flex: 1,
                        child: Obx(
                          () => PrimaryButton(
                            contentPadding: 0,
                            elevation: .5,
                            height: 36,
                            marginHorizontal: 0,
                            marginVertical: 0,
                            labelColor: HomeController.to.currentOrderListType.value == OrderType.medicine
                                ? Colors.white
                                : const Color(0xff363942),
                            fontSize: 12,
                            primary: HomeController.to.currentOrderListType.value == OrderType.medicine
                                ? null
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                            label: 'Medicine Orders',
                            onPressed: () {
                              HomeController.to.currentOrderListType(OrderType.medicine);
                              MedicineController.to.getCurrentOrderList();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  space4C,
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Obx(
                          () => PrimaryButton(
                            contentPadding: 0,
                            height: 36,
                            elevation: .5,
                            marginHorizontal: 0,
                            marginVertical: 0,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            labelColor: HomeController.to.currentOrderListType.value == OrderType.lab
                                ? Colors.white
                                : const Color(0xff363942),
                            primary:
                                HomeController.to.currentOrderListType.value == OrderType.lab ? null : Colors.white,
                            label: 'Lab Test Orders',
                            onPressed: () {
                              HomeController.to.currentOrderListType(OrderType.lab);
                              LabController.to.getCurrentOrderList();
                            },
                          ),
                        ),
                      ),
                      space5R,
                      Expanded(
                        flex: 1,
                        child: Obx(
                          () => PrimaryButton(
                            contentPadding: 0,
                            elevation: .5,
                            height: 36,
                            marginHorizontal: 0,
                            marginVertical: 0,
                            labelColor: HomeController.to.currentOrderListType.value == OrderType.doctor
                                ? Colors.white
                                : const Color(0xff363942),
                            fontSize: 12,
                            primary:
                                HomeController.to.currentOrderListType.value == OrderType.doctor ? null : Colors.white,
                            fontWeight: FontWeight.w500,
                            label: 'Doctor Appointment',
                            onPressed: () {
                              HomeController.to.currentOrderListType(OrderType.doctor);
                              DoctorAppointmentController.to.getCurrentOrderList();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
              () => HomeController.to.currentOrderListType.value == OrderType.healthcare &&
                      HealthCareController.to.currentOrderListLoading.value
                  ? const Center(
                      child: Waiting(),
                    )
                  : HomeController.to.currentOrderListType.value == OrderType.medicine &&
                          MedicineController.to.currentOrderListLoading.value
                      ? const Center(
                          child: Waiting(),
                        )
                      : HomeController.to.currentOrderListType.value == OrderType.lab &&
                              LabController.to.currentOrderListLoading.value
                          ? const Center(
                              child: Waiting(),
                            )
                          : HomeController.to.currentOrderListType.value == OrderType.doctor &&
                                  DoctorAppointmentController.to.currentOrderListLoading.value
                              ? const Center(
                                  child: Waiting(),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: HomeController.to.currentOrderListType.value == OrderType.healthcare
                                      ? HealthCareController.to.healthcareCurrentOrderList.length
                                      : HomeController.to.currentOrderListType.value == OrderType.medicine
                                          ? MedicineController.to.currentMedicineOrderList.length
                                          : HomeController.to.currentOrderListType.value == OrderType.lab
                                              ? LabController.to.currentLabOrderList.length
                                              : DoctorAppointmentController.to.currentAppointmentOrderList.length,
                                  itemBuilder: (_, index) {
                                    MedicineOrderModel? healthcareData;
                                    MedicineOrderModel? medicineData;
                                    LabOrderModel? labData;
                                    DoctorAppointmentModel? docData;
                                    if (HomeController.to.currentOrderListType.value == OrderType.healthcare) {
                                      healthcareData = HealthCareController.to.healthcareCurrentOrderList[index];
                                    } else if (HomeController.to.currentOrderListType.value == OrderType.medicine) {
                                      medicineData = MedicineController.to.currentMedicineOrderList[index];
                                    } else if (HomeController.to.currentOrderListType.value == OrderType.lab) {
                                      labData = LabController.to.currentLabOrderList[index];
                                    } else if (HomeController.to.currentOrderListType.value == OrderType.doctor) {
                                      docData = DoctorAppointmentController.to.currentAppointmentOrderList[index];
                                    }

                                    return GestureDetector(
                                      onTap: () {
                                        if (HomeController.to.currentOrderListType.value == OrderType.healthcare) {
                                          HealthCareController.to.getSingleOrderDetailsList(healthcareData!.id!);
                                          Get.toNamed(OrderDetails.routeName, arguments: healthcareData);
                                        } else if (HomeController.to.currentOrderListType.value == OrderType.medicine) {
                                          MedicineController.to.getSingleOrderDetailsList(medicineData!.id!);
                                          Get.toNamed(OrderDetails.routeName, arguments: medicineData);
                                        } else if (HomeController.to.currentOrderListType.value == OrderType.lab) {
                                          // HealthCareController.to.getSingleOrderDetailsList(healthcareData!.orderId!);
                                          Get.toNamed(LabOrderDetails.routeName, arguments: labData!);
                                        } else if (HomeController.to.currentOrderListType.value == OrderType.doctor) {
                                          if (docData!.appointmentType!.toLowerCase() == 'online') {
                                            Get.to(() => AppointmentDetailsOnlineScreen(
                                                  info: docData!,
                                                ));
                                          } else {
                                            Get.to(() => AppointmentDetailsScreen(
                                                  info: docData!,
                                                ));
                                          }
                                          // MedicineController.to.getSingleOrderDetailsList(medicineData!.orderId!);
                                          // Get.toNamed(OrderDetails.routeName, arguments: medicineData);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          OrderItem(
                                            invoice:
                                                HomeController.to.currentOrderListType.value == OrderType.healthcare
                                                    ? '#${healthcareData!.orderId}'
                                                    : HomeController.to.currentOrderListType.value == OrderType.medicine
                                                        ? '#${medicineData!.orderId}'
                                                        : HomeController.to.currentOrderListType.value == OrderType.lab
                                                            ? '#${labData!.orderNo!}'
                                                            : '#${docData!.id}',
                                            date: DateFormat('dd/MM/yyyy').format(
                                              DateTime.parse(HomeController.to.currentOrderListType.value ==
                                                      OrderType.healthcare
                                                  ? healthcareData!.createdAt!
                                                  : HomeController.to.currentOrderListType.value == OrderType.medicine
                                                      ? medicineData!.createdAt!
                                                      : HomeController.to.currentOrderListType.value == OrderType.lab
                                                          ? labData!.createdAt!
                                                          : docData!.createdAt!),
                                            ),
                                            appointmentType:
                                                HomeController.to.currentOrderListType.value == OrderType.doctor
                                                    ? docData!.appointmentType!
                                                    : null,
                                            status: HomeController.to.currentOrderListType.value == OrderType.healthcare
                                                ? healthcareData!.orderStatus!
                                                : HomeController.to.currentOrderListType.value == OrderType.medicine
                                                    ? medicineData!.orderStatus!
                                                    : HomeController.to.currentOrderListType.value == OrderType.lab
                                                        ? labData!.orderStatus!
                                                        : docData!.status!,
                                            // index == 5 ? 'Completed' : 'Pending',
                                            price: HomeController.to.currentOrderListType.value == OrderType.healthcare
                                                ? double.parse(healthcareData!.orderAmount!).toStringAsFixed(2)
                                                : HomeController.to.currentOrderListType.value == OrderType.medicine
                                                    ? double.parse(medicineData!.orderAmount!).toStringAsFixed(2)
                                                    : HomeController.to.currentOrderListType.value == OrderType.lab
                                                        ? double.parse(labData!.grandTotal!).toStringAsFixed(2)
                                                        : double.parse(docData!.fees!).toStringAsFixed(2),
                                          ),
                                          Obx(
                                            () => ((HealthCareController.to.healthcareCurrentOrderAddLoading.value &&
                                                        HomeController.to.currentOrderListType.value ==
                                                            OrderType.healthcare &&
                                                        index + 1 ==
                                                            HealthCareController
                                                                .to.healthcareCurrentOrderList.length) ||
                                                    (MedicineController.to.medicineCurrentOrderAddLoading.value &&
                                                        HomeController.to.currentOrderListType.value ==
                                                            OrderType.medicine &&
                                                        index + 1 ==
                                                            MedicineController.to.currentMedicineOrderList.length) ||
                                                    (LabController.to.labCurrentOrderAddLoading.value &&
                                                        HomeController.to.currentOrderListType.value == OrderType.lab &&
                                                        index + 1 == LabController.to.currentLabOrderList.length) ||
                                                    (DoctorAppointmentController
                                                            .to.doctorCurrentOrderAddLoading.value &&
                                                        (HomeController.to.currentOrderListType.value ==
                                                                OrderType.doctor &&
                                                            index + 1 ==
                                                                DoctorAppointmentController
                                                                    .to.currentAppointmentOrderList.length)))
                                                ? const Waiting()
                                                : const SizedBox(),
                                          ),
                                          if (HomeController.to.currentOrderListType.value == OrderType.healthcare &&
                                              index + 1 == HealthCareController.to.healthcareCurrentOrderList.length)
                                            const SizedBox(
                                              height: 110,
                                            ),
                                          if (HomeController.to.currentOrderListType.value == OrderType.medicine &&
                                              index + 1 == MedicineController.to.currentMedicineOrderList.length)
                                            const SizedBox(
                                              height: 110,
                                            ),
                                          if (HomeController.to.currentOrderListType.value == OrderType.lab &&
                                              index + 1 == LabController.to.currentLabOrderList.length)
                                            const SizedBox(
                                              height: 110,
                                            ),
                                          if (HomeController.to.currentOrderListType.value == OrderType.doctor &&
                                              index + 1 ==
                                                  DoctorAppointmentController.to.currentAppointmentOrderList.length)
                                            const SizedBox(
                                              height: 110,
                                            )
                                        ],
                                      ),
                                    );
                                  },
                                ),
            ),
          ),
        ],
      ),
    );
  }
}
