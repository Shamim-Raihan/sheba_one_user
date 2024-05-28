import 'package:flutter/material.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class ExploreNowCard extends StatelessWidget {
  const ExploreNowCard({
    required this.label,
    required this.content,
    required this.imagePath,
    required this.onTap,
    Key? key,
  }) : super(key: key);
  final String label;
  final String imagePath;
  final String content;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: '$label ',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: content,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const TextSpan(
                            text: 'Explore Now   ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const WidgetSpan(
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Image.asset(
                  'assets/images/$imagePath.png',
                  height: 65,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 16,
          top: 16,
          child: Image.asset(
            'assets/images/style-bg.png',
            width: 97,
          ),
        ),
      ],
    );
  }
}

class DashboardInfoCard extends StatelessWidget {
  const DashboardInfoCard({
    required this.label,
    required this.content,
    required this.imagePath,
    this.textAlign = TextAlign.center,
    this.withLearnMore = true,
    this.contentMaxLines,
    this.imageHeight,
    this.labelFontSize,
    this.labelFontWeight,
    this.contentFontSize,
    this.contentFontWeight,
    this.marginVertical,
    this.marginHorizontal,
    Key? key,
  }) : super(key: key);
  final String label;
  final String imagePath;
  final String content;
  final TextAlign? textAlign;
  final bool? withLearnMore;
  final int? contentMaxLines;
  final double? imageHeight;
  final double? labelFontSize;
  final FontWeight? labelFontWeight;
  final double? contentFontSize;
  final FontWeight? contentFontWeight;
  final double? marginHorizontal;
  final double? marginVertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 16, vertical: marginVertical ?? 16),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: kPrimaryColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor, width: .5),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: kPrimaryColor, width: .5)),
                  child: Image.asset(
                    'assets/icons/$imagePath.png',
                    height: imageHeight ?? 65,
                  ),
                ),
                space4R,
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text.rich(
                      TextSpan(
                        style: TextStyle(color: kPrimaryColor),
                        children: [
                          TextSpan(
                            text: '$label ',
                            style: TextStyle(
                              fontSize: labelFontSize ?? 20,
                              fontWeight: labelFontWeight ?? FontWeight.bold,
                            ),
                          ),
                          WidgetSpan(
                            child: Text(
                              content,
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                fontSize: contentFontSize ?? 12,
                                fontWeight:
                                    contentFontWeight ?? FontWeight.normal,
                                color: Colors.black,
                              ),
                              textAlign: textAlign,
                              maxLines: contentMaxLines ?? 2,
                            ),
                          ),
                          if (withLearnMore!)
                            const TextSpan(
                              text: '\nLearn More',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                        ],
                      ),
                      textAlign: textAlign,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Image.asset(
              'assets/images/style-bg.png',
              width: MediaQuery.of(context).size.width * .4,
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowButton extends StatelessWidget {
  const ArrowButton({
    this.iconData,
    this.color,
    this.iconColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);
  final IconData? iconData;
  final Color? color;
  final Color? iconColor;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      width: 30,
      child: MaterialButton(
        color: color,
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        onPressed: onPressed,
        child: Center(
            child: Icon(
          iconData ?? Icons.arrow_back_ios_rounded,
          color: iconColor,
        )),
      ),
    );
  }
}

class SectionWithViewAll extends StatelessWidget {
  const SectionWithViewAll({
    required this.label,
    this.buttonLabel,
    this.iconPath,
    this.onTap,
    this.buttonColor,
    this.topMargin,
    this.horizontalPadding,
    this.labelFontSize,
    this.elevation,
    this.isIconButton = false,
    this.withSeeAll = true,
    Key? key,
  }) : super(key: key);
  final String label;
  final String? buttonLabel;
  final Color? buttonColor;
  final String? iconPath;
  final Function()? onTap;
  final double? topMargin;
  final double? horizontalPadding;
  final double? labelFontSize;
  final double? elevation;
  final bool isIconButton;
  final bool withSeeAll;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding ?? 16.0)
          .copyWith(top: topMargin ?? 24),
      child: Row(
        children: [
          Expanded(
            child: TitleText(
              title: label,
              fontSize: labelFontSize ?? 16,
              color: kTextColor,
            ),
          ),
          if (withSeeAll)
            SizedBox(
              width: isIconButton ? 40 : null,
              child: CustomTextButton(
                onTap: onTap,
                buttonColor: buttonColor,
                elevation: elevation,
                isIconButton: isIconButton,
                iconPath: iconPath,
                buttonLabel: buttonLabel,
              ),
            )
        ],
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    Key? key,
    this.onTap,
    this.buttonColor,
    this.elevation,
    this.isIconButton = false,
    this.iconPath,
    this.height,
    this.buttonLabel,
    this.labelColor,
  }) : super(key: key);

  final Function()? onTap;
  final Color? buttonColor;
  final Color? labelColor;
  final double? elevation;
  final double? height;
  final bool isIconButton;
  final String? iconPath;
  final String? buttonLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
            backgroundColor: buttonColor,
            padding: EdgeInsets.zero,
            elevation: elevation),
        child: isIconButton
            ? Image.asset(
                'assets/icons/$iconPath.png',
                height: 20,
              )
            : TitleText(
                title: buttonLabel ?? 'View All',
                fontSize: 14,
                color: labelColor,
                fontWeight: FontWeight.w500,
              ),
      ),
    );
  }
}
