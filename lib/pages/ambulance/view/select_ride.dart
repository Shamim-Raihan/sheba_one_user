// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shebaone/pages/ambulance/model/vehicle_details_model.dart';
// import 'package:shebaone/pages/ambulance/view/map_button.dart';
// import 'package:shebaone/pages/ambulance/widgets/custom_button.dart';

// class SelectRide extends StatelessWidget {
//   final VehicleDetailsModel ambulance;
//   final VehicleDetailsModel car;
//   final VehicleDetailsModel micro;
//   const SelectRide({super.key,required this.ambulance,required this.car,required this.micro});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             fit: BoxFit.cover,
//             image: AssetImage(
//               'assets/images/snapedit_1694173749131.jpg',
//             ),
//           ),
//         ),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           body: Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: 400,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(20),
//                     topRight: Radius.circular(20),
//                   ),
//                   color: Colors.white),
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Align(
//                         alignment: Alignment.topRight,
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Icon(
//                             Icons.close,
//                             size: 15,
//                           ),
//                         )),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     Align(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Choose a ride',
//                         style: TextStyle(fontSize: 17),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 30,
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset('assets/images/Mask Group 64.png'),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text("${ambulance.charge}"),
//                                 Text(
//                                   'Ambulance',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   '5 min away',
//                                   style: TextStyle(fontSize: 10),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Text(
//                           'BDT 223.53',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Container(
//                       color: Color(0xFF0D6526).withOpacity(.3),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 5.0, horizontal: 5),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset('assets/images/Mask Group 63.png'),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Patient Car',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                     SizedBox(
//                                       height: 5,
//                                     ),
//                                     Text(
//                                       '10 min away',
//                                       style: TextStyle(fontSize: 10),
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Text(
//                               'BDT 333.53',
//                               style: TextStyle(fontSize: 14),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Image.asset('assets/images/Mask Group 65.png'),
//                             SizedBox(
//                               width: 10,
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Patient Micro',
//                                   style: TextStyle(fontSize: 14),
//                                 ),
//                                 SizedBox(
//                                   height: 5,
//                                 ),
//                                 Text(
//                                   '20 min away',
//                                   style: TextStyle(fontSize: 10),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                         Text(
//                           'BDT 285.53',
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ],
//                     ),
//                     Spacer(),
//                     GestureDetector(
//                         onTap: () {
//                           Get.to(() => MapScreen());
//                         },
//                         child: customButton('Confirm')),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
