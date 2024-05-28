import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/models/doctor_appointment_model.dart';
import 'package:shebaone/utils/constants.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  const AppointmentDetailsScreen({
    Key? key,
    required this.info,
  }) : super(key: key);
  final DoctorAppointmentModel info;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Appointment Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        8,
                      ),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.08),
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 134,
                          width: Get.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(1, 3),
                              ),
                            ],
                            color: kPrimaryColor,
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(8),
                                  ),
                                  child: Image.asset(
                                    'assets/images/appointment_details.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        space6C,

                                        const Text(
                                          'Appointment ID',
                                          style:
                                              TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                                        ),
                                        space3C,
                                        // space6R,
                                        Text(
                                          info.id!,
                                          style: const TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w700, fontSize: 40),
                                        ),
                                      ],
                                    ),
                                    if (info.appointmentType.toString().toLowerCase() == 'home')
                                      Column(
                                        children: [
                                          space6C,
                                          const Text(
                                            'Visit Date',
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                          ),
                                          Text(
                                            info.homeSlot!.isEmpty ? '' : info.homeSlot![0].appointmentDate!,
                                            style: const TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                                          ),
                                          space4C,
                                          // space6R,
                                          const Text(
                                            'Visit Time',
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                                          ),
                                          Text(
                                            info.homeSlot!.isEmpty
                                                ? ''
                                                : DateFormat.jm().format(DateTime.parse(
                                                    info.homeSlot![0].appointmentDate! +
                                                        'T' +
                                                        info.homeSlot![0].appointmentTime!)),
                                            style: const TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        space6C,
                        DetailsCard(
                          iconPath: 'patient_info',
                          label: 'Patient Information',
                          title: 'Name: ${info.patientName}',
                        ),
                        space3C,
                        info.appointmentType.toString().toLowerCase() == 'home'
                            ? DetailsCard(
                                iconPath: 'location',
                                label: 'Location',
                                title: info.patientAddress,
                              )
                            : DetailsCard(
                                iconPath: 'visit_date',
                                label: 'Visit Date',
                                title: info.appointmentSlot!.isEmpty
                                    ? ''
                                    : DateFormat('dd MMM yyyy')
                                        .format(DateTime.parse(info.appointmentSlot![0].appointmentStart!)),
                              ),
                        space3C,
                        info.appointmentType.toString().toLowerCase() == 'home'
                            ? DetailsCard(
                                iconPath: 'mobile_no',
                                label: 'Mobile number',
                                title: info.patientPhone,
                              )
                            : DetailsCard(
                                iconPath: 'visit_time',
                                label: 'Visit Time',
                                title: info.appointmentSlot!.isEmpty
                                    ? ''
                                    : DateFormat.jm()
                                        .format(DateTime.parse(info.appointmentSlot![0].appointmentStart!)),
                              ),
                      ],
                    ),
                  ),
                  space1C,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Appointment Summery',
                            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        space6C,
                        DetailsCard(
                          iconPath: 'status',
                          label: 'Status',
                          title: info.status,
                        ),
                        space3C,
                        DetailsCard(
                          iconPath: 'fees_info',
                          label: 'Fees Information',
                          titleLabel: 'Unpaid :',
                          titleContent: double.parse(info.fees!).toStringAsFixed(2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsCard extends StatelessWidget {
  const DetailsCard({
    Key? key,
    required this.iconPath,
    required this.label,
    this.title,
    this.titleLabel,
    this.titleContent,
  }) : super(key: key);
  final String iconPath;
  final String label;
  final String? title;
  final String? titleLabel;
  final String? titleContent;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            space4R,
            Image.asset('assets/images/$iconPath.png'),
            space3R,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
                ),
                space2C,
                title != null
                    ? Text(
                        title!,
                        style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 12),
                      )
                    : Row(
                        children: [
                          Text(
                            titleLabel!,
                            style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 12),
                          ),
                          Text(
                            titleContent!,
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                        ],
                      ),
                space3C
              ],
            ),
          ],
        ),
      ],
    );
  }
}
