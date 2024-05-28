import 'package:flutter/material.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/pages/verify/verify_form.dart';

class VerifyScreen extends StatelessWidget {
  const VerifyScreen({Key? key, this.from}) : super(key: key);
  static const String routeName = '/verify';
  final String? from;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height:
                    MediaQuery.of(context).size.height * 0.4 < 189 ? 189 : 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    alignment: Alignment.topCenter,
                    image: AssetImage('assets/images/header-bg.png'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 5),
                      child: const Text(
                        'Verification',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: VerifyForm(),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 10,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () => AuthController.to.setNullUser(),
            ),
          ),
          Positioned(
            right: 0,
            top: 148,
            child: Image.asset(
              'assets/images/style-bg.png',
              width: 220,
            ),
          ),
        ],
      ),
    );
  }
}
