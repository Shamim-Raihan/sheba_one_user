import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/pages/ambulance/view/ride_on_going.dart';

import 'package:shebaone/pages/ambulance/widgets/custom_button.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  color: Color(0xFF0D6526),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          color: Color(0xff8AD4B5),
                          child: Center(
                              child: Icon(
                            Icons.close,
                            size: 15,
                          )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Payment',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   'Payment',
                      //   style: TextStyle(fontSize: 18, color: Colors.grey),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/cash_on.png',
                                height: 30,
                                width: 50,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text('Cash On Delivery'),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/icons8_visa 1.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text('....'),
                              Text('2432'),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/Group 562.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text('....'),
                              Text('3043'),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/images/Group 563.png'),
                              SizedBox(
                                width: 10,
                              ),
                              Text('....'),
                              Text('1820'),
                            ],
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 10,
                          )
                        ],
                      ),
                      Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text('Add Payment Method'),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        thickness: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: GestureDetector(
                  onTap: () {
                    //Get.to(() => RideOngoing());
                  },
                  child: customButton('Continue')),
            ),
          ],
        ),
      ),
    );
  }
}
