import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:intl/intl.dart';
import 'package:shebaone/pages/orders/ui/image_preview.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../../models/fitness_appointment_model.dart';
import '../../../utils/widgets/network_image/network_image.dart';

class FitnessAppointmentDetailsOnlineScreen extends StatefulWidget {
  const FitnessAppointmentDetailsOnlineScreen({
    Key? key,
    required this.info,
  }) : super(key: key);
  final FitnessAppointmentModel info;

  @override
  State<FitnessAppointmentDetailsOnlineScreen> createState() => _AppointmentDetailsOnlineScreenState();
}

class _AppointmentDetailsOnlineScreenState extends State<FitnessAppointmentDetailsOnlineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Appointment Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(1, 3),
                  ),
                ],
                color: Colors.white,
              ),
              child: Container(
                height: 138,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  // boxShadow: const [
                  //   // BoxShadow(
                  //   //   color: Colors.black12,
                  //   //   blurRadius: 4,
                  //   //   offset: Offset(1, 3),
                  //   // ),
                  // ],
                  // color: const Color(0xFF005C1A).withOpacity(.08),
                  gradient: LinearGradient(
                    colors: [
                      kPrimaryColor.withOpacity(.08),
                      kPrimaryColor.withOpacity(.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(children: [
                  Positioned(
                    top: 0,
                    right: 120,
                    child: Image.asset(
                      'assets/images/halfbg.png',
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 95,
                    child: Image.asset(
                      'assets/images/roundbg3.png',
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Image.asset(
                      'assets/images/halfroungbg.png',
                      color: const Color(0xff005C1A).withOpacity(.08),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        space4C,
                        Text(
                          widget.info.patientName!,
                          style: const TextStyle(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                        space1C,
                        Text(
                          "Appointment ID: ${widget.info.id}",
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        space2C,
                        Row(
                          children: [
                            Image.asset('assets/images/visit_date.png'),
                            space2R,
                            Text(
                              widget.info.appointmentSlot!.isEmpty
                                  ? '-'
                                  : DateFormat('dd MMM yyyy')
                                      .format(DateTime.parse(widget.info.appointmentSlot![0].appointmentStart!)),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            Image.asset('assets/images/visit_time.png'),
                            space2R,
                            Text(
                              widget.info.appointmentSlot!.isEmpty
                                  ? '-'
                                  : DateFormat.jm()
                                      .format(DateTime.parse(widget.info.appointmentSlot![0].appointmentStart!)),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(1, 3),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff4A8B5C).withOpacity(.04),
                      const Color(0xff4A8B5C).withOpacity(.06),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  color: const Color(0xFFEEEEEE),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -43,
                      right: -25,
                      child: Image.asset(
                        'assets/images/roundbg4.png',
                      ),
                    ),
                    Positioned(
                      bottom: 210,
                      right: 30,
                      child: Image.asset(
                        'assets/images/roundbg3.png',
                      ),
                    ),
                    Column(
                      children: [
                        space3C,
                        if (widget.info.doctorPrescription!.length > 2)
                          Column(
                            children: [
                              Row(
                                children: [
                                  space3R,
                                  Image.asset('assets/images/test_report.png'),
                                  space3R,
                                  const Text(
                                    'Prescription',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              space3C,
                              GestureDetector(
                                onTap: () {
                                  final list = jsonDecode(widget.info.doctorPrescription!);
                                  List<String> imageList = [];
                                  list.forEach((ele) {
                                    imageList.add(ele.toString());
                                  });
                                  globalLogger.d(list);
                                  globalLogger.d(imageList.runtimeType);

                                  // _player.play(
                                  //     AssetSource('assets/audio/ringing.mp3'));

                                  // if (false)
                                  Get.to(() => ImagePreview(
                                        title: 'Prescription Image',
                                        imageList: imageList,
                                        index: 0,
                                      ));
                                },
                                child: Container(
                                    height: 125,
                                    width: Get.width * .7,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black54),
                                    child: jsonDecode(widget.info.doctorPrescription!).isEmpty
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/prescription.png',
                                                height: 50,
                                              ),
                                              space2C,
                                              const TitleText(
                                                title: 'Upload Prescription',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.horizontal(
                                                      left: const Radius.circular(8),
                                                      right: Radius.circular(
                                                          jsonDecode(widget.info.doctorPrescription!).length > 1
                                                              ? 0
                                                              : 8),
                                                    ),
                                                    child: CustomNetworkImage(
                                                      networkImagePath: jsonDecode(widget.info.doctorPrescription!)[0]!,
                                                      height: 125,
                                                      width: jsonDecode(widget.info.doctorPrescription!).length > 1
                                                          ? (MediaQuery.of(context).size.width * .7) / 2
                                                          : MediaQuery.of(context).size.width * .7,
                                                      fit: BoxFit.cover,
                                                    ),

                                                    // Image.network(
                                                    //   jsonDecode(widget.info.doctorPrescription!)[0]!,
                                                    //   fit: BoxFit.cover,
                                                    //   height: 125,
                                                    //   width: jsonDecode(widget.info.doctorPrescription!).length > 1
                                                    //       ? (MediaQuery.of(context).size.width * .7) / 2
                                                    //       : MediaQuery.of(context).size.width * .7,
                                                    //   loadingBuilder: (BuildContext context, Widget child,
                                                    //       ImageChunkEvent? loadingProgress) {
                                                    //     if (loadingProgress == null) {
                                                    //       return child;
                                                    //     }
                                                    //     return Center(
                                                    //       child: CircularProgressIndicator(
                                                    //         value: loadingProgress.expectedTotalBytes != null
                                                    //             ? loadingProgress.cumulativeBytesLoaded /
                                                    //                 loadingProgress.expectedTotalBytes!
                                                    //             : null,
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    //   errorBuilder: (context, exception, stackTrack) => Image.asset(
                                                    //     'assets/icons/error.gif',
                                                    //     height: 125,
                                                    //     width: jsonDecode(widget.info.doctorPrescription!).length > 1
                                                    //         ? (MediaQuery.of(context).size.width * .7) / 2
                                                    //         : MediaQuery.of(context).size.width * .7,
                                                    //     fit: BoxFit.fill,
                                                    //   ),
                                                    // ),
                                                  ),
                                                  // Image.file(
                                                  //   File(jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']'))[0].path),
                                                  //   fit: BoxFit.cover,
                                                  //   height: 150,
                                                  //   width: jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']')).length > 1
                                                  //       ? (MediaQuery.of(context).size.width - 100) /
                                                  //       2
                                                  //       : MediaQuery.of(context).size.width - 112,
                                                  // ),
                                                  if (jsonDecode(widget.info.doctorPrescription!).length > 1)
                                                    Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: const Radius.circular(8),
                                                            bottomRight: Radius.circular(
                                                                jsonDecode(widget.info.doctorPrescription!).length > 2
                                                                    ? 0
                                                                    : 8),
                                                          ),
                                                          child: CustomNetworkImage(
                                                            networkImagePath:
                                                                jsonDecode(widget.info.doctorPrescription!)[1]!,
                                                            height:
                                                                jsonDecode(widget.info.doctorPrescription!).length > 2
                                                                    ? 125 / 2
                                                                    : 125,
                                                            width: (MediaQuery.of(context).size.width * .7) / 2,
                                                            fit: jsonDecode(widget.info.doctorPrescription!).length > 2
                                                                ? BoxFit.cover
                                                                : BoxFit.fitWidth,
                                                          ),

                                                          // Image.network(
                                                          //   jsonDecode(widget
                                                          //       .info
                                                          //       .doctorPrescription!)[1]!,
                                                          //   fit: jsonDecode(widget
                                                          //                   .info
                                                          //                   .doctorPrescription!)
                                                          //               .length >
                                                          //           2
                                                          //       ? BoxFit.cover
                                                          //       : BoxFit
                                                          //           .fitWidth,
                                                          //   height: jsonDecode(widget
                                                          //                   .info
                                                          //                   .doctorPrescription!)
                                                          //               .length >
                                                          //           2
                                                          //       ? 125 / 2
                                                          //       : 125,
                                                          //   width: (MediaQuery.of(
                                                          //                   context)
                                                          //               .size
                                                          //               .width *
                                                          //           .7) /
                                                          //       2,
                                                          //   loadingBuilder:
                                                          //       (BuildContext
                                                          //               context,
                                                          //           Widget
                                                          //               child,
                                                          //           ImageChunkEvent?
                                                          //               loadingProgress) {
                                                          //     if (loadingProgress ==
                                                          //         null) {
                                                          //       return child;
                                                          //     }
                                                          //     return Center(
                                                          //       child:
                                                          //           CircularProgressIndicator(
                                                          //         value: loadingProgress
                                                          //                     .expectedTotalBytes !=
                                                          //                 null
                                                          //             ? loadingProgress
                                                          //                     .cumulativeBytesLoaded /
                                                          //                 loadingProgress
                                                          //                     .expectedTotalBytes!
                                                          //             : null,
                                                          //       ),
                                                          //     );
                                                          //   },
                                                          //   errorBuilder: (context,
                                                          //           exception,
                                                          //           stackTrack) =>
                                                          //       Image.asset(
                                                          //     'assets/icons/error.gif',
                                                          //     height: jsonDecode(widget
                                                          //                     .info
                                                          //                     .doctorPrescription!)
                                                          //                 .length >
                                                          //             2
                                                          //         ? 125 / 2
                                                          //         : 125,
                                                          //     width: (MediaQuery.of(
                                                          //                     context)
                                                          //                 .size
                                                          //                 .width *
                                                          //             .7) /
                                                          //         2,
                                                          //     fit: BoxFit.fill,
                                                          //   ),
                                                          // ),
                                                        ),
                                                        // Image.file(
                                                        //   File(jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']'))[1].path),
                                                        //   fit: jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? BoxFit.cover
                                                        //       : BoxFit.fitWidth,
                                                        //   height: jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? 75
                                                        //       : 150,
                                                        //   width: (MediaQuery.of(context).size.width -
                                                        //       112) -
                                                        //       (MediaQuery.of(context).size.width -
                                                        //           100) /
                                                        //           2,
                                                        // ),
                                                        if (jsonDecode(widget.info.doctorPrescription!).length > 2)
                                                          ClipRRect(
                                                            borderRadius: const BorderRadius.only(
                                                              bottomRight: Radius.circular(8),
                                                            ),
                                                            child: CustomNetworkImage(
                                                              networkImagePath:
                                                                  jsonDecode(widget.info.doctorPrescription!)[2]!,
                                                              height:
                                                                  jsonDecode(widget.info.doctorPrescription!).length > 2
                                                                      ? 125 / 2
                                                                      : 125,
                                                              width: (MediaQuery.of(context).size.width * .7) / 2,
                                                              fit:
                                                                  jsonDecode(widget.info.doctorPrescription!).length > 2
                                                                      ? BoxFit.cover
                                                                      : BoxFit.fitWidth,
                                                            ),
                                                            //     Image.network(
                                                            //   jsonDecode(widget
                                                            //       .info
                                                            //       .doctorPrescription!)[2]!,
                                                            //   fit: jsonDecode(widget
                                                            //                   .info
                                                            //                   .doctorPrescription!)
                                                            //               .length >
                                                            //           2
                                                            //       ? BoxFit.cover
                                                            //       : BoxFit
                                                            //           .fitWidth,
                                                            //   height: jsonDecode(widget
                                                            //                   .info
                                                            //                   .doctorPrescription!)
                                                            //               .length >
                                                            //           2
                                                            //       ? 125 / 2
                                                            //       : 125,
                                                            //   width: (MediaQuery.of(
                                                            //                   context)
                                                            //               .size
                                                            //               .width *
                                                            //           .7) /
                                                            //       2,
                                                            //   loadingBuilder:
                                                            //       (BuildContext
                                                            //               context,
                                                            //           Widget
                                                            //               child,
                                                            //           ImageChunkEvent?
                                                            //               loadingProgress) {
                                                            //     if (loadingProgress ==
                                                            //         null) {
                                                            //       return child;
                                                            //     }
                                                            //     return Center(
                                                            //       child:
                                                            //           CircularProgressIndicator(
                                                            //         value: loadingProgress.expectedTotalBytes !=
                                                            //                 null
                                                            //             ? loadingProgress.cumulativeBytesLoaded /
                                                            //                 loadingProgress.expectedTotalBytes!
                                                            //             : null,
                                                            //       ),
                                                            //     );
                                                            //   },
                                                            //   errorBuilder: (context,
                                                            //           exception,
                                                            //           stackTrack) =>
                                                            //       Image.asset(
                                                            //     'assets/icons/error.gif',
                                                            //     height: jsonDecode(widget.info.doctorPrescription!)
                                                            //                 .length >
                                                            //             2
                                                            //         ? 125 / 2
                                                            //         : 125,
                                                            //     width: (MediaQuery.of(context)
                                                            //                 .size
                                                            //                 .width *
                                                            //             .7) /
                                                            //         2,
                                                            //     fit:
                                                            //         BoxFit.fill,
                                                            //   ),
                                                            // ),
                                                          ),
                                                        // Image.file(
                                                        //   File(jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']'))[2].path),
                                                        //   fit: jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? BoxFit.cover
                                                        //       : BoxFit.fitWidth,
                                                        //   height: jsonDecode(widget.info.doctorPrescription!+((widget.info.doctorPrescription!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? 75
                                                        //       : 150,
                                                        //   width: (MediaQuery.of(context)
                                                        //       .size
                                                        //       .width -
                                                        //       112) -
                                                        //       (MediaQuery.of(context).size.width -
                                                        //           100) /
                                                        //           2,
                                                        // ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              if (jsonDecode(widget.info.doctorPrescription!).length > 1)
                                                Positioned(
                                                  top: 0,
                                                  left: (MediaQuery.of(context).size.width * .7) / 2,
                                                  child: Container(
                                                    height: 125,
                                                    width: jsonDecode(widget.info.doctorPrescription!).length > 1
                                                        ? (MediaQuery.of(context).size.width * .7) / 2
                                                        : MediaQuery.of(context).size.width * .7,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black45,
                                                      borderRadius: BorderRadius.horizontal(
                                                        right: Radius.circular(8),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: TitleText(
                                                          title:
                                                              '+${(jsonDecode(widget.info.doctorPrescription!).length - 1).toString()}',
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          )

                                    // const Center(
                                    //   child: Text(
                                    //     'No Information',
                                    //     style: TextStyle(
                                    //         shadows: <Shadow>[
                                    //           Shadow(
                                    //             offset: Offset(0, 4.0),
                                    //             blurRadius: 6.0,
                                    //             color: Colors.black26,
                                    //           ),
                                    //         ],
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: 18),
                                    //   ),
                                    // ),
                                    ),
                              ),
                              space6C,
                            ],
                          ),
                        if (widget.info.textPrescription!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  space3R,
                                  const Icon(
                                    Icons.description,
                                    color: Color(0xff939393),
                                    size: 18,
                                  ),
                                  space3R,
                                  const Text(
                                    'Instruction By Doctor',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              space3C,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 42.0),
                                child: Text(
                                  widget.info.textPrescription!,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              space6C,
                            ],
                          ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     space4R,
                        //     Image.asset('assets/images/fees_info.png'),
                        //     space3R,
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         const Text(
                        //           'Fees Information',
                        //           style: TextStyle(
                        //             color: Colors.black,
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 14,
                        //           ),
                        //         ),
                        //         // space2C,
                        //         // Row(
                        //         //   children: [
                        //         //     const Text(
                        //         //       'Paid: ',
                        //         //       style: TextStyle(
                        //         //           color: Colors.black54,
                        //         //           fontWeight: FontWeight.w500,
                        //         //           fontSize: 12),
                        //         //     ),
                        //         //     Text(
                        //         //       widget.info.fees!,
                        //         //       style: const TextStyle(
                        //         //         color: Colors.black,
                        //         //         fontWeight: FontWeight.w600,
                        //         //         fontSize: 13,
                        //         //       ),
                        //         //     ),
                        //         //   ],
                        //         // ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        space4C,
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(1, 3),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xff4A8B5C).withOpacity(.04),
                      const Color(0xff4A8B5C).withOpacity(.06),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  color: const Color(0xFFEEEEEE),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: -43,
                      right: -25,
                      child: Image.asset(
                        'assets/images/roundbg4.png',
                      ),
                    ),
                    Positioned(
                      bottom: 210,
                      right: 30,
                      child: Image.asset(
                        'assets/images/roundbg3.png',
                      ),
                    ),
                    Column(
                      children: [
                        space3C,
                        if (widget.info.reportUpload!.length > 2)
                          Column(
                            children: [
                              Row(
                                children: [
                                  space3R,
                                  Image.asset('assets/images/test_report.png'),
                                  space3R,
                                  const Text(
                                    'Your Submitted Document',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              space3C,
                              GestureDetector(
                                onTap: () {
                                  final list = jsonDecode(widget.info.reportUpload!);
                                  List<String> imageList = [];
                                  list.forEach((ele) {
                                    imageList.add(ele.toString());
                                  });
                                  globalLogger.d(list);
                                  globalLogger.d(imageList.runtimeType);

                                  // _player.play(
                                  //     AssetSource('assets/audio/ringing.mp3'));

                                  // if (false)
                                  Get.to(() => ImagePreview(
                                        title: 'Prescription Image',
                                        imageList: imageList,
                                        index: 0,
                                      ));
                                },
                                child: Container(
                                    height: 125,
                                    width: Get.width * .7,
                                    decoration:
                                        BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black54),
                                    child: jsonDecode(widget.info.reportUpload!).isEmpty
                                        ? Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/prescription.png',
                                                height: 50,
                                              ),
                                              space2C,
                                              const TitleText(
                                                title: 'Upload Prescription',
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ],
                                          )
                                        : Stack(
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.horizontal(
                                                      left: const Radius.circular(8),
                                                      right: Radius.circular(
                                                          jsonDecode(widget.info.reportUpload!).length > 1 ? 0 : 8),
                                                    ),
                                                    child: CustomNetworkImage(
                                                      networkImagePath: jsonDecode(widget.info.reportUpload!)[0]!,
                                                      height: 125,
                                                      width: jsonDecode(widget.info.reportUpload!).length > 1
                                                          ? (MediaQuery.of(context).size.width * .7) / 2
                                                          : MediaQuery.of(context).size.width * .7,
                                                      fit: BoxFit.cover,
                                                    ),

                                                    // Image.network(
                                                    //   jsonDecode(widget.info.reportUpload!)[0]!,
                                                    //   fit: BoxFit.cover,
                                                    //   height: 125,
                                                    //   width: jsonDecode(widget.info.reportUpload!).length > 1
                                                    //       ? (MediaQuery.of(context).size.width * .7) / 2
                                                    //       : MediaQuery.of(context).size.width * .7,
                                                    //   loadingBuilder: (BuildContext context, Widget child,
                                                    //       ImageChunkEvent? loadingProgress) {
                                                    //     if (loadingProgress == null) {
                                                    //       return child;
                                                    //     }
                                                    //     return Center(
                                                    //       child: CircularProgressIndicator(
                                                    //         value: loadingProgress.expectedTotalBytes != null
                                                    //             ? loadingProgress.cumulativeBytesLoaded /
                                                    //                 loadingProgress.expectedTotalBytes!
                                                    //             : null,
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    //   errorBuilder: (context, exception, stackTrack) => Image.asset(
                                                    //     'assets/icons/error.gif',
                                                    //     height: 125,
                                                    //     width: jsonDecode(widget.info.reportUpload!).length > 1
                                                    //         ? (MediaQuery.of(context).size.width * .7) / 2
                                                    //         : MediaQuery.of(context).size.width * .7,
                                                    //     fit: BoxFit.fill,
                                                    //   ),
                                                    // ),
                                                  ),
                                                  // Image.file(
                                                  //   File(jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']'))[0].path),
                                                  //   fit: BoxFit.cover,
                                                  //   height: 150,
                                                  //   width: jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']')).length > 1
                                                  //       ? (MediaQuery.of(context).size.width - 100) /
                                                  //       2
                                                  //       : MediaQuery.of(context).size.width - 112,
                                                  // ),
                                                  if (jsonDecode(widget.info.reportUpload!).length > 1)
                                                    Column(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.only(
                                                            topRight: const Radius.circular(8),
                                                            bottomRight: Radius.circular(
                                                                jsonDecode(widget.info.reportUpload!).length > 2
                                                                    ? 0
                                                                    : 8),
                                                          ),
                                                          child: CustomNetworkImage(
                                                            networkImagePath: jsonDecode(widget.info.reportUpload!)[1]!,
                                                            height: jsonDecode(widget.info.reportUpload!).length > 2
                                                                ? 125 / 2
                                                                : 125,
                                                            width: (MediaQuery.of(context).size.width * .7) / 2,
                                                            fit: jsonDecode(widget.info.reportUpload!).length > 2
                                                                ? BoxFit.cover
                                                                : BoxFit.fitWidth,
                                                          ),

                                                          // Image.network(
                                                          //   jsonDecode(widget
                                                          //       .info
                                                          //       .reportUpload!)[1]!,
                                                          //   fit: jsonDecode(widget
                                                          //                   .info
                                                          //                   .reportUpload!)
                                                          //               .length >
                                                          //           2
                                                          //       ? BoxFit.cover
                                                          //       : BoxFit
                                                          //           .fitWidth,
                                                          //   height: jsonDecode(widget
                                                          //                   .info
                                                          //                   .reportUpload!)
                                                          //               .length >
                                                          //           2
                                                          //       ? 125 / 2
                                                          //       : 125,
                                                          //   width: (MediaQuery.of(
                                                          //                   context)
                                                          //               .size
                                                          //               .width *
                                                          //           .7) /
                                                          //       2,
                                                          //   loadingBuilder:
                                                          //       (BuildContext
                                                          //               context,
                                                          //           Widget
                                                          //               child,
                                                          //           ImageChunkEvent?
                                                          //               loadingProgress) {
                                                          //     if (loadingProgress ==
                                                          //         null) {
                                                          //       return child;
                                                          //     }
                                                          //     return Center(
                                                          //       child:
                                                          //           CircularProgressIndicator(
                                                          //         value: loadingProgress
                                                          //                     .expectedTotalBytes !=
                                                          //                 null
                                                          //             ? loadingProgress
                                                          //                     .cumulativeBytesLoaded /
                                                          //                 loadingProgress
                                                          //                     .expectedTotalBytes!
                                                          //             : null,
                                                          //       ),
                                                          //     );
                                                          //   },
                                                          //   errorBuilder: (context,
                                                          //           exception,
                                                          //           stackTrack) =>
                                                          //       Image.asset(
                                                          //     'assets/icons/error.gif',
                                                          //     height: jsonDecode(widget
                                                          //                     .info
                                                          //                     .reportUpload!)
                                                          //                 .length >
                                                          //             2
                                                          //         ? 125 / 2
                                                          //         : 125,
                                                          //     width: (MediaQuery.of(
                                                          //                     context)
                                                          //                 .size
                                                          //                 .width *
                                                          //             .7) /
                                                          //         2,
                                                          //     fit: BoxFit.fill,
                                                          //   ),
                                                          // ),
                                                        ),
                                                        // Image.file(
                                                        //   File(jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']'))[1].path),
                                                        //   fit: jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? BoxFit.cover
                                                        //       : BoxFit.fitWidth,
                                                        //   height: jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? 75
                                                        //       : 150,
                                                        //   width: (MediaQuery.of(context).size.width -
                                                        //       112) -
                                                        //       (MediaQuery.of(context).size.width -
                                                        //           100) /
                                                        //           2,
                                                        // ),
                                                        if (jsonDecode(widget.info.reportUpload!).length > 2)
                                                          ClipRRect(
                                                            borderRadius: const BorderRadius.only(
                                                              bottomRight: Radius.circular(8),
                                                            ),
                                                            child: CustomNetworkImage(
                                                              networkImagePath:
                                                                  jsonDecode(widget.info.reportUpload!)[2]!,
                                                              height: jsonDecode(widget.info.reportUpload!).length > 2
                                                                  ? 125 / 2
                                                                  : 125,
                                                              width: (MediaQuery.of(context).size.width * .7) / 2,
                                                              fit: jsonDecode(widget.info.reportUpload!).length > 2
                                                                  ? BoxFit.cover
                                                                  : BoxFit.fitWidth,
                                                            ),
                                                            //     Image.network(
                                                            //   jsonDecode(widget
                                                            //       .info
                                                            //       .reportUpload!)[2]!,
                                                            //   fit: jsonDecode(widget
                                                            //                   .info
                                                            //                   .reportUpload!)
                                                            //               .length >
                                                            //           2
                                                            //       ? BoxFit.cover
                                                            //       : BoxFit
                                                            //           .fitWidth,
                                                            //   height: jsonDecode(widget
                                                            //                   .info
                                                            //                   .reportUpload!)
                                                            //               .length >
                                                            //           2
                                                            //       ? 125 / 2
                                                            //       : 125,
                                                            //   width: (MediaQuery.of(
                                                            //                   context)
                                                            //               .size
                                                            //               .width *
                                                            //           .7) /
                                                            //       2,
                                                            //   loadingBuilder:
                                                            //       (BuildContext
                                                            //               context,
                                                            //           Widget
                                                            //               child,
                                                            //           ImageChunkEvent?
                                                            //               loadingProgress) {
                                                            //     if (loadingProgress ==
                                                            //         null) {
                                                            //       return child;
                                                            //     }
                                                            //     return Center(
                                                            //       child:
                                                            //           CircularProgressIndicator(
                                                            //         value: loadingProgress.expectedTotalBytes !=
                                                            //                 null
                                                            //             ? loadingProgress.cumulativeBytesLoaded /
                                                            //                 loadingProgress.expectedTotalBytes!
                                                            //             : null,
                                                            //       ),
                                                            //     );
                                                            //   },
                                                            //   errorBuilder: (context,
                                                            //           exception,
                                                            //           stackTrack) =>
                                                            //       Image.asset(
                                                            //     'assets/icons/error.gif',
                                                            //     height: jsonDecode(widget.info.reportUpload!)
                                                            //                 .length >
                                                            //             2
                                                            //         ? 125 / 2
                                                            //         : 125,
                                                            //     width: (MediaQuery.of(context)
                                                            //                 .size
                                                            //                 .width *
                                                            //             .7) /
                                                            //         2,
                                                            //     fit:
                                                            //         BoxFit.fill,
                                                            //   ),
                                                            // ),
                                                          ),
                                                        // Image.file(
                                                        //   File(jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']'))[2].path),
                                                        //   fit: jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? BoxFit.cover
                                                        //       : BoxFit.fitWidth,
                                                        //   height: jsonDecode(widget.info.reportUpload!+((widget.info.reportUpload!.toString().contains(']'))?'':']')).length > 2
                                                        //       ? 75
                                                        //       : 150,
                                                        //   width: (MediaQuery.of(context)
                                                        //       .size
                                                        //       .width -
                                                        //       112) -
                                                        //       (MediaQuery.of(context).size.width -
                                                        //           100) /
                                                        //           2,
                                                        // ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              if (jsonDecode(widget.info.reportUpload!).length > 1)
                                                Positioned(
                                                  top: 0,
                                                  left: (MediaQuery.of(context).size.width * .7) / 2,
                                                  child: Container(
                                                    height: 125,
                                                    width: jsonDecode(widget.info.reportUpload!).length > 1
                                                        ? (MediaQuery.of(context).size.width * .7) / 2
                                                        : MediaQuery.of(context).size.width * .7,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black45,
                                                      borderRadius: BorderRadius.horizontal(
                                                        right: Radius.circular(8),
                                                      ),
                                                    ),
                                                    child: Center(
                                                      child: TitleText(
                                                          title:
                                                              '+${(jsonDecode(widget.info.reportUpload!).length - 1).toString()}',
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                            ],
                                          )

                                    // const Center(
                                    //   child: Text(
                                    //     'No Information',
                                    //     style: TextStyle(
                                    //         shadows: <Shadow>[
                                    //           Shadow(
                                    //             offset: Offset(0, 4.0),
                                    //             blurRadius: 6.0,
                                    //             color: Colors.black26,
                                    //           ),
                                    //         ],
                                    //         color: Colors.white,
                                    //         fontWeight: FontWeight.w600,
                                    //         fontSize: 18),
                                    //   ),
                                    // ),
                                    ),
                              ),
                              space6C,
                            ],
                          ),
                        if (widget.info.patientProblem!.isNotEmpty)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  space3R,
                                  const Icon(
                                    Icons.description,
                                    color: Color(0xff939393),
                                    size: 18,
                                  ),
                                  space3R,
                                  const Text(
                                    'Problem',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              space3C,
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 42.0),
                                child: Text(
                                  widget.info.patientProblem!,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              space6C,
                            ],
                          ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            space4R,
                            Image.asset('assets/images/fees_info.png'),
                            space3R,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fees Information',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                space2C,
                                Row(
                                  children: [
                                    const Text(
                                      'Paid: ',
                                      style:
                                          TextStyle(color: Colors.black54, fontWeight: FontWeight.w500, fontSize: 12),
                                    ),
                                    Text(
                                      widget.info.fees!,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        space4C,
                      ],
                    )
                  ],
                ),
              ),
            ),
            space8C,
          ],
        ),
      ),
    );
  }
}
