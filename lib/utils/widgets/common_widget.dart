import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shebaone/utils/constants.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    required this.title,
    this.color,
    this.fontSize,
    this.height,
    this.fontWeight,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.fontFamily,
    this.textDecoration,
    Key? key,
  }) : super(key: key);
  final String title;
  final Color? color;
  final double? fontSize;
  final double? height;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final String? fontFamily;
  final int? maxLines;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      overflow: textOverflow ?? TextOverflow.visible,
      style: TextStyle(
        decoration: textDecoration,
        fontFamily: fontFamily,
        color: color ?? kPrimaryColor,
        fontWeight: fontWeight ?? FontWeight.w600,
        fontSize: fontSize ?? 32,
        height: height,
      ),
    );
  }
}

class Waiting extends StatelessWidget {
  const Waiting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Image.asset('assets/icons/wating.gif'),
      ),
    );
  }
}

class HorizontalDivider extends StatelessWidget {
  const HorizontalDivider({
    this.color,
    this.height,
    this.thickness,
    this.horizontalMargin,
    this.verticalMargin,
    Key? key,
  }) : super(key: key);
  final Color? color;
  final double? height;
  final double? thickness;
  final double? horizontalMargin;
  final double? verticalMargin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalMargin ?? 0,
        vertical: verticalMargin ?? 0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: thickness,
              height: height,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class RegexUtil {
  RegexUtil._();

  static final spaceOrNewLine = RegExp(r'[ ^\s]+');
}

class MaxWordTextInputFormater extends TextInputFormatter {
  final int maxWords;
  final ValueChanged<int>? currentLength;

  MaxWordTextInputFormater({this.maxWords = 1, this.currentLength});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    int count = 0;
    if (newValue.text.isEmpty) {
      count = 0;
    } else {
      count = newValue.text.trim().split(RegexUtil.spaceOrNewLine).length;
    }
    if (count > maxWords) {
      return oldValue;
    }
    currentLength?.call(count);
    return newValue;
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    this.maxLines = 1,
    this.hintText,
    this.labelText,
    this.prefixIcon,
    this.fillColor,
    this.isEnable = true,
    this.onChanged,
    this.borderRadius,
    this.verticalMargin,
    this.horizontalMargin,
    this.horizontalPadding,
    this.verticalPadding,
    this.textFieldHeight,
    this.textFieldHorizontalContentPadding,
    this.textFieldVerticalContentPadding,
    this.labelTextFontSize,
    this.onEditingComplete,
    this.hintTextStyle,
    this.inputFormatters,
    this.isLabelExist = false,
    this.isRequired = false,
    this.isOuterBorderExist = false,
  })  : _controller = controller,
        _focusNode = focusNode,
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        super(key: key);

  final TextEditingController _controller;
  final FocusNode? _focusNode;
  final String? hintText;
  final String? labelText;
  final Widget? prefixIcon;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  final TextStyle? hintTextStyle;
  final ValueChanged<String>? onChanged;
  final Function()? onEditingComplete;
  final BorderRadius? borderRadius;
  final bool isLabelExist;
  final bool? isRequired;
  final bool? isEnable;
  final bool? isOuterBorderExist;
  final double? verticalMargin,
      horizontalMargin,
      horizontalPadding,
      verticalPadding,
      textFieldHeight,
      textFieldHorizontalContentPadding,
      textFieldVerticalContentPadding,
      labelTextFontSize;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Row(
            children: [
              Text(
                labelText ?? '',
                style: TextStyle(
                  fontSize: labelTextFontSize ?? 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (isRequired!)
                const TitleText(
                  title: '*',
                  color: Color(0xffff1414),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
            ],
          ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalMargin ?? 0, vertical: verticalMargin ?? 8),
          child: Material(
              borderRadius: borderRadius ?? BorderRadius.circular(5),
              color: fillColor ?? const Color(0xffF3F4F8),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding ?? 4.0,
                    vertical: verticalPadding ?? 4),
                child: SizedBox(
                  height: textFieldHeight ?? 30,
                  child: Center(
                    child: TextFormField(
                      enabled: isEnable,
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: onChanged,
                      style: hintTextStyle ??
                          const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                      keyboardType: keyboardType,
                      maxLines: maxLines,
                      inputFormatters: inputFormatters,
                      decoration: InputDecoration(
                        prefixIcon: prefixIcon,
                        fillColor: fillColor ?? Colors.transparent,
                        hintText: hintText ?? '',
                        hintStyle: hintTextStyle,
                        border: isOuterBorderExist!
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                  width: .5,
                                ),
                              )
                            : InputBorder.none,
                        enabledBorder: isOuterBorderExist!
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                  width: .5,
                                ),
                              )
                            : InputBorder.none,
                        focusedBorder: isOuterBorderExist!
                            ? OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: kPrimaryColor,
                                  width: .5,
                                ),
                              )
                            : InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: textFieldHorizontalContentPadding ?? 4,
                          vertical: textFieldVerticalContentPadding ?? 6,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              // .padding(all: 16).decorated(
              //   borderRadius: BorderRadius.circular(10),
              // ),
              ),
        ),
      ],
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.primary,
    this.borderColor,
    this.labelColor,
    this.fontSize,
    this.fontWeight,
    this.iconData,
    this.height,
    this.borderWidth = 1.0,
    this.elevation,
    this.width,
    this.borderRadiusAll,
    this.contentPadding,
    this.marginHorizontal,
    this.marginVertical,
    this.contentHorizontalPadding,
    this.contentVerticalPadding,
    this.isDisable = false,
  }) : super(key: key);
  final String label;
  final Function()? onPressed;
  final Color? primary;
  final Color? labelColor;
  final Color? borderColor;
  final double? fontSize;
  final double? marginHorizontal;
  final double? marginVertical;
  final double? height;
  final double? elevation;
  final double? contentPadding;
  final double? contentHorizontalPadding;
  final double? contentVerticalPadding;
  final double? width;
  final double? borderWidth;
  final double? borderRadiusAll;
  final FontWeight? fontWeight;
  final String? iconData;
  final bool isDisable;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: iconData != null ? 75 : height ?? 50,
        width: width ?? size.width,
        margin: EdgeInsets.symmetric(
          horizontal: marginHorizontal ?? 32,
          vertical: marginVertical ?? 32,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: elevation,
            // onPrimary: isDisable ? const Color(0xff4A8B5C) : null,
            backgroundColor:
                isDisable ? const Color(0xff4A8B5C) : primary ?? kPrimaryColor,
            padding: EdgeInsets.symmetric(
                horizontal: contentHorizontalPadding ?? contentPadding ?? 8,
                vertical: contentVerticalPadding ?? contentPadding ?? 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusAll ?? 8),
              side: BorderSide(
                  color: borderColor ?? primary ?? kPrimaryColor,
                  width: borderWidth!),
            ),
          ),
          onPressed: isDisable ? () {} : onPressed,
          child: iconData == null
              ? Text(
                  label,
                  style: TextStyle(
                    color: labelColor ?? Colors.white,
                    fontWeight: fontWeight ?? FontWeight.normal,
                    fontSize: fontSize ?? 16,
                  ),
                  textAlign: TextAlign.center,
                )
              : Stack(
                  children: [
                    Container(
                      width: size.width,
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/$iconData.png',
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        label,
                        style: TextStyle(
                            color: labelColor ?? Colors.white,
                            fontWeight: fontWeight ?? FontWeight.normal,
                            fontSize: fontSize ?? 16),
                      ),
                    ),
                  ],
                ),
        ));
  }
}

class CustomDropDownMenu extends StatelessWidget {
  const CustomDropDownMenu({
    Key? key,
    required String? selectedOption,
    required String? hintText,
    required this.onChange,
    required List<dynamic> list,
    this.borderRadius,
    this.elevation,
    this.height,
    this.color,
    this.shadowColor,
    this.horizontalMargin,
    this.verticalMargin,
    this.prefixIcon,
    this.prefixIconColor,
    this.prefixIconSize,
    this.textColor,
    this.fontWeight,
    this.fontSize,
    this.icon,
    this.hasPrefixIcon = false,
    this.leftAlign = false,
    this.useFittedBox = false,
    this.isRequired = false,
    this.label,
    this.leftPadding,
    this.extension,
    this.textAlign = TextAlign.left,
    this.underline,
  })  : _selectedOption = selectedOption,
        _hintText = hintText,
        _list = list,
        super(key: key);

  final String? _selectedOption;
  final String? _hintText, label;
  final List<dynamic> _list;
  final Function onChange;
  final double? elevation;
  final double? height;
  final FontWeight? fontWeight;

  final double? verticalMargin, fontSize;
  final double? horizontalMargin;
  final Color? color;
  final BorderRadius? borderRadius;
  final Color? shadowColor;
  final Widget? underline, icon;
  final IconData? prefixIcon;
  final double? prefixIconSize;
  final double? leftPadding;
  final Color? prefixIconColor, textColor;
  final bool hasPrefixIcon;
  final bool leftAlign;
  final TextAlign textAlign;
  final String? extension;
  final bool useFittedBox;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: verticalMargin ?? 8.0, horizontal: horizontalMargin ?? 0),
      child: Column(
        children: [
          if (label != null)
            Column(
              children: [
                Row(
                  children: [
                    TitleText(
                      title: label!,
                      color: const Color(0xff3C3C3C),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                    if (isRequired)
                      const TitleText(
                        title: '*',
                        color: const Color(0xffff1414),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                  ],
                ),
                space1C,
              ],
            ),
          Material(
            color: color,
            elevation: elevation ?? 2.0,
            shadowColor: shadowColor ?? Colors.grey,
            borderRadius: borderRadius ??
                BorderRadius.circular(
                  5.0,
                ),
            child: SizedBox(
              height: height ?? 38,
              child: DropdownButton(
                icon: icon ??
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: kPrimaryColor,
                    ),
                isExpanded: true,
                underline: underline ?? const SizedBox(),
                hint: Text(
                  _hintText!,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff818181),
                  ),
                ), // Not necessary for Option 1
                value: _selectedOption,
                onChanged: (newValue) {
                  onChange(newValue);
                },

                items: _list.map((playlist) {
                  return DropdownMenuItem(
                    value: playlist,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (prefixIcon != null || hasPrefixIcon)
                          Row(
                            children: [
                              space1R,
                              Icon(
                                prefixIcon ?? Icons.location_on_outlined,
                                color: prefixIconColor ?? kPrimaryColor,
                                size: prefixIconSize ?? 13,
                              ),
                            ],
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0)
                                .copyWith(left: leftPadding ?? 2.0),
                            child: useFittedBox
                                ? FittedBox(
                                    fit: BoxFit.none,
                                    child: Text(
                                      playlist.toString() +
                                          (extension != null
                                              ? ' ${extension!}'
                                              : ''),
                                      style: TextStyle(
                                        fontSize: fontSize ?? 10,
                                        fontWeight:
                                            fontWeight ?? FontWeight.w300,
                                        color: textColor ??
                                            const Color(0xff818181),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                                : Text(
                                    playlist.toString() +
                                        (extension != null
                                            ? ' ${extension!}'
                                            : ''),
                                    style: TextStyle(
                                      fontSize: fontSize ?? 10,
                                      fontWeight: fontWeight ?? FontWeight.w300,
                                      color:
                                          textColor ?? const Color(0xff818181),
                                    ),
                                    textAlign: textAlign,
                                  ),
                          ),
                        ),
                        if (leftAlign) const Spacer(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
