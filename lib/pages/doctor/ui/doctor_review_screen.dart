import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class DoctorReviewScreen extends StatefulWidget {
  const DoctorReviewScreen({Key? key}) : super(key: key);
  static String routeName = '/DoctorReviewScreen';

  @override
  State<DoctorReviewScreen> createState() => _DoctorReviewScreenState();
}

class _DoctorReviewScreenState extends State<DoctorReviewScreen> {
  TextEditingController? _controller;

  int _count = 0;
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    super.initState();
  }

  int _activeIndex = -1;
  void chageCount(int count) {
    setState(() {
      _count = count;
    });
    print(_count);
  }

  String? recommended;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kScaffoldColor,
        title: Container(
          height: 30,
          width: Get.width * .6,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
          child: const Center(
            child: TitleText(
              title: 'Write a Review',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  space4C,
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/doc.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  space4C,
                  const TitleText(
                    title: 'How was your experience with',
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  const TitleText(
                    title: 'Dr. Linda Gothic?',
                    fontSize: 18,
                  ),
                  space4C,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _activeIndex = 1;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.star_rounded,
                          color: _activeIndex >= 1
                              ? const Color(0xffFFA873)
                              : kTextColorLite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _activeIndex = 2;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.star_rounded,
                          color: _activeIndex >= 2
                              ? const Color(0xffFFA873)
                              : kTextColorLite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _activeIndex = 3;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.star_rounded,
                          color: _activeIndex >= 3
                              ? const Color(0xffFFA873)
                              : kTextColorLite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _activeIndex = 4;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.star_rounded,
                          color: _activeIndex >= 4
                              ? const Color(0xffFFA873)
                              : kTextColorLite,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          _activeIndex = 5;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.star_rounded,
                          color: _activeIndex == 5
                              ? const Color(0xffFFA873)
                              : kTextColorLite,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitleText(
                          title: 'Write a comment',
                          color: kTextColorLite,
                          fontSize: 18,
                          fontFamily: 'Raleway',
                        ),
                        TitleText(
                          title: 'Max 600 words',
                          color: kTextColorLite,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                  MainContainer(
                    horizontalMargin: 24,
                    horizontalPadding: 0,
                    borderColor: kTextColorLite.withOpacity(.5),
                    borderWidth: 1,
                    borderRadius: 12,
                    color: kScaffoldColor,
                    child: CustomTextField(
                      textFieldHeight: 100,
                      controller: _controller!,
                      hintTextStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: kTextColorLite,
                      ),
                      hintText: 'Type here....',
                      fillColor: kScaffoldColor,
                      horizontalPadding: 0,
                      horizontalMargin: 0,
                      verticalMargin: 0,
                      labelTextFontSize: 14,
                      verticalPadding: 0,
                      keyboardType: TextInputType.multiline,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r"[a-z\.\,.*\/\>\d\s_-]+"),
                        ),
                        MaxWordTextInputFormater(
                            maxWords: 600, currentLength: chageCount)
                      ],
                      textFieldHorizontalContentPadding: 16,
                      maxLines: 10,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16,
                    ),
                    child: TitleText(
                      title:
                          'Would you recommend Dr. Linda Gothic to your friend?',
                      color: kTextColorLite,
                      fontSize: 18,
                      fontFamily: 'Raleway',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            recommended = 'yes';
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: recommended == 'yes'
                                    ? kPrimaryColor
                                    : kTextColorLite,
                              ),
                              space2R,
                              TitleText(
                                title: 'Yes',
                                color: kTextColorLite,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                        space4R,
                        space4R,
                        GestureDetector(
                          onTap: () {
                            recommended = 'no';
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                size: 18,
                                color: recommended == 'no'
                                    ? kPrimaryColor
                                    : kTextColorLite,
                              ),
                              space2R,
                              TitleText(
                                title: 'No',
                                color: kTextColorLite,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          PrimaryButton(
            marginHorizontal: 24,
            marginVertical: 16,
            label: 'Submit Review',
            isDisable: _activeIndex >= 0 ? false : true,
            borderColor: Colors.transparent,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class AppointmentDateCard extends StatelessWidget {
  const AppointmentDateCard({
    Key? key,
    required this.onTap,
    this.isActive = false,
  }) : super(key: key);
  final Function() onTap;
  final bool? isActive;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: isActive! ? kPrimaryColor : Colors.white,
          border: Border.all(color: kPrimaryColor, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TitleText(
              title: 'Mon',
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: isActive! ? Colors.white : kPrimaryColor,
            ),
            space2C,
            TitleText(
              title: '02',
              fontSize: 18,
              color: isActive! ? Colors.white : kPrimaryColor,
            ),
          ],
        ),
      ),
    );
  }
}

class ShortInfo extends StatelessWidget {
  const ShortInfo({
    Key? key,
    this.position = 0,
    required this.imagePath,
    required this.title,
    required this.label,
  }) : super(key: key);
  final String imagePath, title, label;
  final int? position;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        mainAxisAlignment: position! < 0
            ? MainAxisAlignment.start
            : position! > 0
                ? MainAxisAlignment.end
                : MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/$imagePath.png',
            height: 11,
          ),
          space2R,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(title: title, color: Colors.black, fontSize: 13),
              TitleText(
                title: label,
                color: Colors.black54,
                fontSize: 8,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AdaptableText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign textAlign;
  final ui.TextDirection textDirection;
  final double minimumFontScale;
  final TextOverflow textOverflow;
  const AdaptableText(this.text,
      {this.style,
      this.textAlign = TextAlign.left,
      this.textDirection = ui.TextDirection.ltr,
      this.minimumFontScale = 0.5,
      this.textOverflow = TextOverflow.ellipsis,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextPainter _painter = TextPainter(
        text: TextSpan(text: text, style: style),
        textAlign: textAlign,
        textScaleFactor: 1,
        maxLines: 100,
        textDirection: textDirection);

    return LayoutBuilder(
      builder: (context, constraints) {
        _painter.layout(maxWidth: constraints.maxWidth);
        double textScaleFactor = 1;

        if (_painter.height > constraints.maxHeight) {
          //
          print('${_painter.size}');
          _painter.textScaleFactor = minimumFontScale;
          _painter.layout(maxWidth: constraints.maxWidth);
          print('${_painter.size}');

          if (_painter.height > constraints.maxHeight) {
            //
            //even minimum does not fit render it with minimum size
            print("Using minimum set font");
            textScaleFactor = minimumFontScale;
          } else if (minimumFontScale < 1) {
            //binary search for valid Scale factor
            int h = 100;
            int l = (minimumFontScale * 100).toInt();
            while (h > l) {
              int mid = (l + (h - l) / 2).toInt();
              double newScale = mid.toDouble() / 100.0;
              _painter.textScaleFactor = newScale;
              _painter.layout(maxWidth: constraints.maxWidth);

              if (_painter.height > constraints.maxHeight) {
                //
                h = mid - 1;
              } else {
                l = mid + 1;
              }
              if (h <= l) {
                print('${_painter.size}');
                textScaleFactor = newScale - 0.01;
                _painter.textScaleFactor = newScale;
                _painter.layout(maxWidth: constraints.maxWidth);
                break;
              }
            }
          }
        }

        return Text(
          this.text,
          style: this.style,
          textAlign: this.textAlign,
          textDirection: this.textDirection,
          textScaleFactor: textScaleFactor,
          maxLines: 100,
          overflow: textOverflow,
        );
      },
    );
  }
}

///
///AdaptableText(
//                                 path.isEmpty
//                                     ? "face_text_1".tr().toString()
//                                     : "face_text_2".tr().toString(),
//                                 textAlign: TextAlign.center,
//                                 style: Theme.of(context)
//                                     .textTheme
//                                     .subtitle1!
//                                     .copyWith(
//                                       color: Colors.white,
//                                       fontSize: 24,
//                                     ),
//                               ),
