import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/fitness_appointment_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/models/doctor_appointment_model.dart';
import 'package:shebaone/models/fitness_appointment_model.dart';
import 'package:shebaone/models/healthcare_order_model.dart';
import 'package:shebaone/models/lab_order_model.dart';
import 'package:shebaone/models/medicine_order_model.dart';
import 'package:shebaone/pages/orders/ui/appointment_details.dart';
import 'package:shebaone/pages/orders/ui/appointment_details_online_screen.dart';
import 'package:shebaone/pages/orders/ui/lab_order_details_screen.dart';
import 'package:shebaone/pages/orders/ui/order_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/appbar.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import 'fitness_appointment_details_online_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
    if (HomeController.to.orderListType.value == OrderType.healthcare) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!HealthCareController.to.healthcareOrderAddLoading.value &&
            HealthCareController.to.healthcareOrderNextPageUrl.value
                .isNotEmpty) {
          await HealthCareController.to.getOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.orderListType.value == OrderType.medicine) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!MedicineController.to.medicineOrderAddLoading.value &&
            MedicineController.to.medicineOrderNextPageUrl.value.isNotEmpty) {
          await MedicineController.to.getOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.orderListType.value == OrderType.lab) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!LabController.to.labOrderAddLoading.value &&
            LabController.to.labOrderNextPageUrl.value.isNotEmpty) {
          await LabController.to.getOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.orderListType.value == OrderType.doctor) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!DoctorAppointmentController.to.doctorOrderAddLoading.value &&
            DoctorAppointmentController.to.doctorOrderNextPageUrl.value
                .isNotEmpty) {
          await DoctorAppointmentController.to.getOrderList(isPaginate: true);
        }
      }
    } else if (HomeController.to.orderListType.value == OrderType.fitness) {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (!FitnessAppointmentController.to.doctorOrderAddLoading.value &&
            FitnessAppointmentController.to.doctorOrderNextPageUrl.value
                .isNotEmpty) {
          await FitnessAppointmentController.to.getOrderList(isPaginate: true);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                              () =>
                              PrimaryButton(
                                contentPadding: 0,
                                height: 36,
                                elevation: .5,
                                marginHorizontal: 0,
                                marginVertical: 0,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                labelColor: HomeController.to.orderListType
                                    .value == OrderType.healthcare
                                    ? Colors.white
                                    : const Color(0xff363942),
                                primary:
                                HomeController.to.orderListType.value ==
                                    OrderType.healthcare ? null : Colors.white,
                                label: 'Healthcare Orders',
                                onPressed: () {
                                  HomeController.to.orderListType(
                                      OrderType.healthcare);
                                  HealthCareController.to.getOrderList();
                                },
                              ),
                        ),
                      ),
                      space5R,
                      Expanded(
                        flex: 1,
                        child: Obx(
                              () =>
                              PrimaryButton(
                                contentPadding: 0,
                                elevation: .5,
                                height: 36,
                                marginHorizontal: 0,
                                marginVertical: 0,
                                labelColor: HomeController.to.orderListType
                                    .value == OrderType.medicine
                                    ? Colors.white
                                    : const Color(0xff363942),
                                fontSize: 12,
                                primary: HomeController.to.orderListType
                                    .value == OrderType.medicine ? null : Colors
                                    .white,
                                fontWeight: FontWeight.w500,
                                label: 'Medicine Orders',
                                onPressed: () {
                                  HomeController.to.orderListType(
                                      OrderType.medicine);
                                  MedicineController.to.getOrderList();
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
                              () =>
                              PrimaryButton(
                                contentPadding: 0,
                                height: 36,
                                elevation: .5,
                                marginHorizontal: 0,
                                marginVertical: 0,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                labelColor: HomeController.to.orderListType
                                    .value == OrderType.lab
                                    ? Colors.white
                                    : const Color(0xff363942),
                                primary: HomeController.to.orderListType
                                    .value == OrderType.lab ? null : Colors
                                    .white,
                                label: 'Lab Test Orders',
                                onPressed: () {
                                  HomeController.to.orderListType(
                                      OrderType.lab);
                                  LabController.to.getOrderList();
                                },
                              ),
                        ),
                      ),
                      space5R,
                      Expanded(
                        flex: 1,
                        child: Obx(
                              () =>
                              PrimaryButton(
                                contentPadding: 0,
                                elevation: .5,
                                height: 36,
                                marginHorizontal: 0,
                                marginVertical: 0,
                                labelColor: HomeController.to.orderListType
                                    .value == OrderType.doctor
                                    ? Colors.white
                                    : const Color(0xff363942),
                                fontSize: 12,
                                primary: HomeController.to.orderListType
                                    .value == OrderType.doctor ? null : Colors
                                    .white,
                                fontWeight: FontWeight.w500,
                                label: 'Doctor Appointment',
                                onPressed: () {
                                  HomeController.to.orderListType(
                                      OrderType.doctor);
                                  DoctorAppointmentController.to.getOrderList();
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
                              () =>
                              PrimaryButton(
                                contentPadding: 0,
                                elevation: .5,
                                height: 36,
                                marginHorizontal: 0,
                                marginVertical: 0,
                                labelColor: HomeController.to.orderListType
                                    .value == OrderType.fitness
                                    ? Colors.white
                                    : const Color(0xff363942),
                                fontSize: 12,
                                primary: HomeController.to.orderListType
                                    .value == OrderType.fitness ? null : Colors
                                    .white,
                                fontWeight: FontWeight.w500,
                                label: 'Fitness Appointment',
                                onPressed: () {
                                  HomeController.to.orderListType(
                                      OrderType.fitness);
                                  FitnessAppointmentController.to.getOrderList();
                                },
                              ),
                        ),
                      ),
                      space5R,
                      const Expanded(
                        flex: 1,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(
                  () =>
              HomeController.to.orderListType.value == OrderType.healthcare &&
                  HealthCareController.to.orderListLoading.value
                  ? const Center(
                child: Waiting(),
              )
                  : HomeController.to.orderListType.value ==
                  OrderType.medicine &&
                  MedicineController.to.orderListLoading.value
                  ? const Center(
                child: Waiting(),
              )
                  : HomeController.to.orderListType.value == OrderType.lab &&
                  LabController.to.orderListLoading.value
                  ? const Center(
                  child: Waiting()
              )
                  : HomeController.to.orderListType.value == OrderType.doctor &&
                  DoctorAppointmentController.to.orderListLoading.value
                  ? const Center(
                  child: Waiting()
              )
                  : HomeController.to.orderListType.value == OrderType.fitness &&
                  FitnessAppointmentController.to.orderListLoading.value
                  ? const Center(
                child: Waiting(),
              ) : ListView.builder(
                controller: scrollController,
                padding: EdgeInsets.zero,
                itemCount: HomeController.to.orderListType.value ==
                    OrderType.healthcare
                    ? HealthCareController.to.healthcareOrderList.length
                    : HomeController.to.orderListType.value ==
                    OrderType.medicine
                    ? MedicineController.to.medicineOrderList.length
                    : HomeController.to.orderListType.value == OrderType.lab
                    ? LabController.to.labOrderList.length
                    : HomeController.to.orderListType.value == OrderType.doctor
                    ? DoctorAppointmentController.to.appointmentOrderList
                    .length : FitnessAppointmentController.to
                    .appointmentOrderList
                    .length,
                itemBuilder: (_, index) {
                  MedicineOrderModel? healthcareData;
                  MedicineOrderModel? medicineData;
                  LabOrderModel? labData;
                  DoctorAppointmentModel? docData;
                  FitnessAppointmentModel? fitnessData;
                  if (HomeController.to.orderListType.value ==
                      OrderType.healthcare) {
                    healthcareData =
                    HealthCareController.to.healthcareOrderList[index];
                  } else if (HomeController.to.orderListType.value ==
                      OrderType.medicine) {
                    medicineData =
                    MedicineController.to.medicineOrderList[index];
                  } else
                  if (HomeController.to.orderListType.value == OrderType.lab) {
                    labData = LabController.to.labOrderList[index];
                  } else if (HomeController.to.orderListType.value ==
                      OrderType.doctor) {
                    docData =
                    DoctorAppointmentController.to.appointmentOrderList[index];
                  } else if (HomeController.to.orderListType.value ==
                      OrderType.fitness) {
                    fitnessData =
                    FitnessAppointmentController.to.appointmentOrderList[index];
                  }

                  return GestureDetector(
                    onTap: () {
                      if (HomeController.to.orderListType.value ==
                          OrderType.healthcare) {
                        HealthCareController.to.getSingleOrderDetailsList(
                            healthcareData!.id!);
                        Get.toNamed(
                            OrderDetails.routeName, arguments: healthcareData);
                      } else if (HomeController.to.orderListType.value ==
                          OrderType.lab) {
                        Get.toNamed(
                            LabOrderDetails.routeName, arguments: labData!);
                      } else if (HomeController.to.orderListType.value ==
                          OrderType.medicine) {
                        MedicineController.to.getSingleOrderDetailsList(
                            medicineData!.id!);
                        Get.toNamed(
                            OrderDetails.routeName, arguments: medicineData);
                      } else if (HomeController.to.orderListType.value ==
                          OrderType.doctor) {
                        if (docData!.appointmentType!.toLowerCase() ==
                            'online') {
                          Get.to(() =>
                              AppointmentDetailsOnlineScreen(
                                info: docData!,
                              ));
                        } else {
                          Get.to(() =>
                              AppointmentDetailsScreen(
                                info: docData!,
                              ));
                        }
                      } else if (HomeController.to.orderListType.value ==
                          OrderType.fitness) {
                        Get.to(() =>
                            FitnessAppointmentDetailsOnlineScreen(
                              info: fitnessData!,
                            ));
                      }
                    },
                    child: Column(
                      children: [
                        OrderItem(
                          invoice: HomeController.to.orderListType.value ==
                              OrderType.healthcare
                              ? '#${healthcareData!.orderId}'
                              : HomeController.to.orderListType.value ==
                              OrderType.medicine
                              ? '#${medicineData!.orderId}'
                              : HomeController.to.orderListType.value ==
                              OrderType.lab
                              ? '#${labData!.orderNo!}'
                              : HomeController.to.orderListType.value ==
                              OrderType.doctor
                              ? '#${docData!.id}' : '#${fitnessData!.id}',
                          date: DateFormat('dd/MM/yyyy').format(
                            DateTime.parse(
                                HomeController.to.orderListType.value ==
                                    OrderType.healthcare
                                    ? healthcareData!.createdAt!
                                    : HomeController.to.orderListType.value ==
                                    OrderType.medicine
                                    ? medicineData!.createdAt!
                                    : HomeController.to.orderListType.value ==
                                    OrderType.lab
                                    ? labData!.createdAt!
                                    : HomeController.to.orderListType.value ==
                                    OrderType.doctor
                                    ? docData!.createdAt! : fitnessData!
                                    .createdAt!),
                          ),
                          appointmentType: HomeController.to.orderListType
                              .value == OrderType.doctor
                              ? docData!.appointmentType!
                              : null,
                          status: HomeController.to.orderListType.value ==
                              OrderType.healthcare
                              ? healthcareData!.orderStatus!
                              : HomeController.to.orderListType.value ==
                              OrderType.medicine
                              ? medicineData!.orderStatus!
                              : HomeController.to.orderListType.value ==
                              OrderType.lab
                              ? labData!.orderStatus!
                              : HomeController.to.orderListType.value ==
                              OrderType.doctor
                              ? docData!.status! : fitnessData!.status!,
                          price: HomeController.to.orderListType.value ==
                              OrderType.healthcare
                              ? double.parse(healthcareData!.orderAmount!)
                              .toStringAsFixed(2)
                              : HomeController.to.orderListType.value ==
                              OrderType.medicine
                              ? double.parse(medicineData!.orderAmount!)
                              .toStringAsFixed(2)
                              : HomeController.to.orderListType.value ==
                              OrderType.lab
                              ? double.parse(labData!.grandTotal!)
                              .toStringAsFixed(2)
                              : HomeController.to.orderListType.value ==
                              OrderType.doctor
                              ? double.parse(docData!.fees!).toStringAsFixed(2)
                              : double.parse(fitnessData!.fees!)
                              .toStringAsFixed(2),
                        ),
                        Obx(
                              () =>
                          ((HealthCareController.to.healthcareOrderAddLoading
                              .value &&
                              HomeController.to.orderListType.value ==
                                  OrderType.healthcare &&
                              index + 1 ==
                                  HealthCareController.to.healthcareOrderList
                                      .length) ||
                              (MedicineController.to.medicineOrderAddLoading
                                  .value &&
                                  HomeController.to.orderListType.value ==
                                      OrderType.medicine &&
                                  index + 1 ==
                                      MedicineController.to.medicineOrderList
                                          .length) ||
                              (LabController.to.labOrderAddLoading.value &&
                                  HomeController.to.orderListType.value ==
                                      OrderType.lab &&
                                  index + 1 ==
                                      LabController.to.labOrderList.length) ||
                              (DoctorAppointmentController.to
                                  .doctorOrderAddLoading.value &&
                                  (HomeController.to.orderListType.value ==
                                      OrderType.doctor &&
                                      index + 1 ==
                                          DoctorAppointmentController
                                              .to.appointmentOrderList
                                              .length)) ||
                              (FitnessAppointmentController.to
                                  .doctorOrderAddLoading.value &&
                                  (HomeController.to.orderListType.value ==
                                      OrderType.fitness &&
                                      index + 1 ==
                                          FitnessAppointmentController
                                              .to.appointmentOrderList.length)))
                              ? const Waiting()
                              : const SizedBox(),
                        ),
                        if ((HomeController.to.orderListType.value ==
                            OrderType.healthcare &&
                            index + 1 ==
                                HealthCareController.to.healthcareOrderList
                                    .length) ||
                            (HomeController.to.orderListType.value ==
                                OrderType.medicine &&
                                index + 1 ==
                                    MedicineController.to.medicineOrderList
                                        .length) ||
                            (HomeController.to.orderListType.value ==
                                OrderType.lab &&
                                index + 1 ==
                                    LabController.to.labOrderList.length) ||
                            (HomeController.to.orderListType.value ==
                                OrderType.doctor &&
                                index + 1 ==
                                    DoctorAppointmentController.to
                                        .appointmentOrderList.length) ||
                            (HomeController.to.orderListType.value ==
                                OrderType.fitness &&
                                index + 1 ==
                                    FitnessAppointmentController.to
                                        .appointmentOrderList.length))
                          const SizedBox(
                            height: 110,
                          ),
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

class OrderItem extends StatelessWidget {
  const OrderItem({
    Key? key,
    required this.invoice,
    required this.date,
    required this.status,
    required this.price,
    this.appointmentType,
  }) : super(key: key);
  final String invoice, date, status, price;
  final String? appointmentType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Container(
              height: 47,
              width: 47,
              decoration: BoxDecoration(
                color: const Color(0xff4A8B5C).withOpacity(.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Center(
                child: Image.asset(
                  'assets/icons/gift.png',
                  height: 27,
                ),
              ),
            ),
            space5R,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TitleText(
                  title: invoice,
                  fontSize: 16,
                ),
                TitleText(
                  title: 'Order date: $date',
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    if (appointmentType != null)
                      Container(
                        padding: const EdgeInsets.all(2),
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: appointmentType!.toLowerCase() == 'regular'
                              ? kPrimaryColor.withOpacity(.2)
                              : appointmentType!.toLowerCase() == 'home'
                              ? Colors.blue.withOpacity(.2)
                              : appointmentType!.toLowerCase() == 'online'
                              ? Colors.blueGrey.withOpacity(.2)
                              : Colors.white,

                          // status.toLowerCase() == 'pending'
                          //     ? const Color(0xffE8F1EF)
                          //     : status.toLowerCase() == 'processing'
                          //         ? Colors.orange
                          //         : status.toLowerCase() == 'cancelled'
                          //             ? Colors.redAccent
                          //             : kPrimaryColor,
                        ),
                        child: Center(
                          child: TitleText(
                            title: appointmentType!,
                            fontSize: 10,
                            fontWeight: FontWeight.normal,
                            color: appointmentType!.toLowerCase() == 'regular'
                                ? kPrimaryColor
                                : appointmentType!.toLowerCase() == 'home'
                                ? Colors.blue
                                : appointmentType!.toLowerCase() == 'online'
                                ? Colors.blueGrey
                                : Colors.white,
                          ),
                        ),
                      ),
                    space2R,
                    Container(
                      padding: const EdgeInsets.all(2),
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: status.toLowerCase() == 'pending'
                            ? const Color(0xffE8F1EF)
                            : status.toLowerCase() == 'processing'
                            ? Colors.orange
                            : status.toLowerCase() == 'cancelled'
                            ? Colors.redAccent
                            : kPrimaryColor,
                      ),
                      child: Center(
                        child: TitleText(
                          title: status,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                          color: status.toLowerCase() == 'pending'
                              ? kPrimaryColor
                              : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                TitleText(
                  title: price,
                  fontSize: 16,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
