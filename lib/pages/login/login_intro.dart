import 'package:flutter/material.dart';
import 'package:shebaone/utils/constants.dart';

class LoginIntro extends StatelessWidget {
  const LoginIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Welcome',
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
            children: const [
              TextSpan(
                text: '\nSign in to continue',
                style: TextStyle(
                  height: 1.5,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
