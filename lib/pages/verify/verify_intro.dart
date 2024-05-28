import 'package:flutter/material.dart';
import 'package:shebaone/utils/constants.dart';

class VerifyIntro extends StatelessWidget {
  const VerifyIntro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: 'Get Your Code\n',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                  height: .5),
              children: const [
                TextSpan(
                  text:
                      '\nPlease enter the 6 digit code sent\nto your phone number.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]),
        ),
      ],
    );
  }
}
