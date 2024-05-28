import 'package:flutter/material.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/models/user_model.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);
  static String routeName = '/UpdateProfile';

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController? _nameController;
  TextEditingController? _mobileController;
  TextEditingController? _addressController;
  TextEditingController? _districtController;
  TextEditingController? _areaController;

  @override
  void initState() {
    // TODO: implement initState
    _nameController =
        TextEditingController(text: UserController.to.userInfo.value.name);
    _mobileController =
        TextEditingController(text: UserController.to.userInfo.value.mobile);
    _addressController =
        TextEditingController(text: UserController.to.userInfo.value.address);
    _districtController =
        TextEditingController(text: UserController.to.userInfo.value.district);
    _areaController =
        TextEditingController(text: UserController.to.userInfo.value.area);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppbarBgColor,
        foregroundColor: Colors.white,
        title: const TitleText(
          title: 'Update Profile',
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BgContainer(
              horizontalPadding: 0,
              child: MainContainer(
                horizontalMargin: 20,
                borderColor: Colors.transparent,
                child: Column(
                  children: [
                    space8C,
                    UnderlineTextFieldItem(
                      label: 'Full Name',
                      controller: _nameController!,
                    ),
                    space2C,
                    UnderlineTextFieldItem(
                      label: 'Mobile',
                      controller: _mobileController!,
                    ),
                    space2C,
                    UnderlineTextFieldItem(
                      label: 'Address',
                      controller: _addressController!,
                    ),
                    space2C,
                    UnderlineTextFieldItem(
                      label: 'Area',
                      controller: _areaController!,
                    ),
                    space2C,
                    UnderlineTextFieldItem(
                      label: 'District',
                      controller: _districtController!,
                    ),
                    space8C,
                    space8C,
                    PrimaryButton(
                        marginHorizontal: 0,
                        label: 'Update',
                        onPressed: () {
                          UserModel _userModel =
                              UserController.to.userInfo.value;
                          _userModel.name = _nameController!.text;
                          _userModel.mobile =  AuthController.to.userPhoneForLogin.value;
                          _userModel.address = _addressController!.text;
                          _userModel.district = _districtController!.text;
                          _userModel.area = _areaController!.text;
                          AuthController.to.updateUser(_userModel);
                        }),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class UnderlineTextFieldItem extends StatelessWidget {
  const UnderlineTextFieldItem({
    required this.label,
    required TextEditingController controller,
    FocusNode? focusNode,
    TextInputType? keyboardType,
    this.maxLines = 1,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.borderRadius,
    this.horizontalMargin,
    this.verticalMargin,
    this.onEditingComplete,
    this.enableColor,
    this.focusColor,
    this.validator,
    this.isLabelExist = false,
    this.isRequired = false,
    this.isEnable = true,
    Key? key,
  })  : _controller = controller,
        keyboardType = keyboardType ??
            (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
        _focusNode = focusNode,
        super(key: key);
  final String label;

  final TextEditingController _controller;
  final FocusNode? _focusNode;
  final String? hintText;
  final String? labelText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final Function()? onEditingComplete;
  final BorderRadius? borderRadius;
  final bool isLabelExist;
  final bool isRequired;
  final bool isEnable;
  final double? horizontalMargin, verticalMargin;
  final Color? focusColor, enableColor;
  final String? Function(String?)? validator;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalMargin ?? 0, vertical: verticalMargin ?? 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              TitleText(
                title: label,
                color: const Color(0xff3C3C3C),
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              if (isRequired)
                const TitleText(
                  title: '*',
                  color: Color(0xffff1414),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
            ],
          ),
          space1C,
          TextFormField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType: keyboardType,
            enabled: isEnable,
            cursorColor: const Color(0xff3c3c3c),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xff3c3c3c),
            ),
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText ?? '',
              contentPadding: EdgeInsets.zero,
              fillColor: Colors.transparent,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: .6,
                  color: focusColor ?? Color(0xff3C3C3C),
                ),
              ),
              border: const UnderlineInputBorder(
                borderSide: BorderSide(
                  width: .6,
                  color: Color(0xff3C3C3C),
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  width: .6,
                  color: enableColor ?? Color(0xff3C3C3C),
                ),
              ),
            ),
          ),
          space3C,
        ],
      ),
    );
  }
}
