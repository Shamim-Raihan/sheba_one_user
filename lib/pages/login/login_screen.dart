import 'package:flutter/material.dart';
import 'package:shebaone/pages/login/login_form.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key, this.from, this.Ambulance_car}) : super(key: key);
  static const String routeName = '/login';
  final String? from;
  String? Ambulance_car;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 148,
            child: Image.asset(
              'assets/images/style-bg.png',
              width: 220,
            ),
          ),
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
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 40,
                    width: 120,
                  ),
                ),
              ),
              Expanded(
                child: LoginForm(Ambulance_car: false),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
