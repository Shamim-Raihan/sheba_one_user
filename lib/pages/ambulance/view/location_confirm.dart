import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/pages/ambulance/view/chat_bot.dart';

class ConfirmRide extends StatefulWidget {
  const ConfirmRide({super.key, required});

  @override
  State<ConfirmRide> createState() => _ConfirmRideState();
}

class _ConfirmRideState extends State<ConfirmRide> {
  // Function to show the alert dialog with a text field
  void _changeDestinationDialog(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Destinaton'),
          content: TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter new destination',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Color(0xFF0D6526),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                  color: Color(0xFF0D6526),
                ),
              ),
              onPressed: () {
                // You can access the text entered in the text field
                String enteredText = textEditingController.text;
                print('Entered Text: $enteredText');
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  // Image.network(
                  //   "https://img.freepik.com/premium-vector/street-map-with-pin-routes_23-2147622544.jpg?w=2000",
                  //   fit: BoxFit.cover,
                  // ),
                  Image.asset(
                    'assets/images/snapedit_1694173749131.jpg',
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 30.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(Icons.menu),
                          ),
                          SizedBox(
                            width: 300,
                          ),
                          Container(
                            height: 34,
                            width: 34,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Icon(Icons.notifications_active_outlined),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: Container(
                          height: 7,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Your patient car is coming in : 5 min",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Container(
                          height: 54,
                          width: 59,
                          child: Image.asset('assets/images/Rectangle 553.jpg'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        title: Text(
                          "Rony Hassn",
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_pin),
                                Text("800m (5mins away)"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text("4.9 (531 review)"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                      ListTile(
                        leading: Container(
                          height: 54,
                          width: 59,
                          child: Image.asset('assets/images/Mask Group 63.png'),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        title: Text(
                          "Normal Sedan",
                        ),
                        subtitle: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(Icons.location_pin),
                                Text("SKE9 103689"),
                                Spacer(),
                                Container(
                                  color: Color(0xFF0D6526),
                                  child: InkWell(
                                      onTap: () {
                                        _changeDestinationDialog(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0, vertical: 8),
                                        child: Text(
                                          'Change Destination',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text("White"),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.black,
                        thickness: 0.5,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 54,
                            width: 172,
                            child: Center(
                              child: Text(
                                "Call",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0D6526),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  width: 2.0, color: Color(0xFF0D6526)),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => ChatBotPage());
                            },
                            child: Container(
                              height: 54,
                              width: 172,
                              child: Center(
                                child: Text(
                                  "Message",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFF0D6526),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
