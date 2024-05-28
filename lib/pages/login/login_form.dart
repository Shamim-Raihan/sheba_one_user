import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/pages/login/login_intro.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
// import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class LoginForm extends StatefulWidget {
   LoginForm({Key? key, required this.Ambulance_car}) : super(key: key);
   bool Ambulance_car=false;
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _controller;
  FocusNode? _focusNode;
  // WebViewPlusController? _wbController;
  String _selectedCountryCode = '+88';
  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const LoginIntro(),
            SizedBox(height: Get.height * .1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: CustomDropDownMenu(
                          hintText: '+88',
                          list: data,
                          fontSize: 16,
                          onChange: (val) {
                            _selectedCountryCode = val;

                            setState(() {});
                          },
                          leftPadding: 8,
                          height: 55,
                          selectedOption: _selectedCountryCode,
                          color: const Color(0xffF3F4F8),
                          elevation: 0,
                          // shadowColor: Colors.transparent,
                          // borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      space2R,
                      Expanded(
                        flex: 7,
                        child: CustomTextField(
                          textFieldHeight: 48,
                          textFieldVerticalContentPadding: 12,
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: kTextColorLite,
                          ),
                          controller: _controller!,
                          focusNode: _focusNode!,
                          hintText: 'XX XX XXXXXX',
                          hintTextStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // const Divider(height: 0),
            const SizedBox(height: 16),
            const Spacer(),
            SizedBox(
              width: Get.width - 64,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {

                  if (_formKey.currentState!.validate()) {

                    String countryCode = '';
                    if (_selectedCountryCode.contains('(')) {
                      final s1 = _selectedCountryCode.substring(
                          _selectedCountryCode.indexOf('(') + 1, _selectedCountryCode.indexOf(')'));
                      countryCode = s1;
                    } else {
                      countryCode = _selectedCountryCode;
                    }
                    //showing progress indicator
                    Get.defaultDialog(
                      title: 'OTP sending...',
                      content: const Center(child: CircularProgressIndicator()),
                    );
                    //trying to login using getx controller
                    AuthController.to.userPhoneForLogin(_controller!.text.trim().replaceAll(' ', ''));
                    AuthController.to.userCountryCodeForLogin(countryCode);

                    await AuthController.to.setUserId();
                    Get.back();//this line is added by mahbub
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
                child: const Text('Send OTP Code'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}



final data = [
  "+88",
  "Estonia (+372)",
  "Algeria (+213)",
  "American Samoa (+1-684)",
  "Andorra (+376)",
  "Angola (+244)",
  "Anguilla (+1-264)",
  "Antigua and Barbuda (+1-268)",
  "Argentina (+54)",
  "Aruba (+297)",
  "Austria (+43)",
  "Azerbaijan (+994)",
  "Bahamas (+1-242)",
  "Bahrain (+973)",
  "Barbados (+1-246)",
  "Belgium (+32)",
  "Belize (+501)",
  "Benin (+229)",
  "Bermuda (+1-441)",
  "Bhutan (+975)",
  "Bolivia (+591)",
  "Botswana (+267)",
  "Brazil (+55)",
  "British Virgin Islands (+1-284)",
  "Brunei (+673)",
  "Burkina Faso (+226)",
  "Cape Verde (+238)",
  "Canada (+1)",
  "Cayman Islands (+1-345)",
  "Central African Republic (+236)",
  "Chile (+56)",
  "China (+86)",
  "Colombia (+57)",
  "Comoros (+269)",
  "Congo Republic (+242)",
  "Cook Islands (+682)",
  "Costa Rica (+506)",
  "Cote d'Ivoire (+225)",
  "Croatia (+385)",
  "Curacao (+599)",
  "Cyprus (+357)",
  "Denmark (+45)",
  "Djibouti (+253)",
  "Dominica (+1-767)",
  "Dominican Republic (+1-809, +1-829, +1-849)",
  "Ecuador (+593)",
  "El Salvador (+503)",
  "Equatorial Guinea (+240)",
  "Eritrea (+291)",
  "Falkland Islands (+500)",
  "Faroe Islands (+298)",
  "Fiji (+679)",
  "Finland (+358)",
  "France (+33)",
  "French Guinea (+594)",
  "French Polynesia (+689)",
  "Gabon (+241)",
  "Germany (+49)",
  "Gibraltar (+350)",
  "Greece (+30)",
  "Greenland (+299)",
  "Grenada (+1-473)",
  "Guadeloupe (+590)",
  "Guam (+1-671)",
  "Guatemala (+502)",
  "Guernsey (+44-1481)",
  "Guinea (+224)",
  "Guyana (+592)",
  "Honduras (+504)",
  "Hungary (+36)",
  "Iceland (+354)",
  "India (+91)",
  "Iraq (+964)",
  "Ireland (+353)",
  "Isle of Man (+44-1624)",
  "Italy (+39)",
  "Jamaica (+1-876)",
  "Japan (+81)",
  "Jersey (+44-1534)",
  "Kiribati (+686)",
  "Kosovo (+383)",
  "Kyrgyzstan (+996)",
  "Latvia (+371)",
  "Lebanon (+961)",
  "Lesotho (+266)",
  "Libya (+218)",
  "Liechtenstein (+423)",
  "Lithuania (+370)",
  "Luxembourg (+352)",
  "Macau (+853)",
  "Madagascar (+261)",
  "Malawi (+265)",
  "Malaysia (+60)",
  "Maldives (+960)",
  "Mali (+223)",
  "Malta (+356)",
  "Martinique (+596)",
  "Mauritania (+222)",
  "Mauritius (+230)",
  "Mexico (+52)",
  "Micronesia (+691)",
  "Moldova (+373)",
  "Monaco (+377)",
  "Mongolia (+976)",
  "Montenegro (+382)",
  "Montserrat (+1-664)",
  "Namibia (+264)",
  "Netherlands (+31)",
  "New Caledonia (+687)",
  "Niger (+227)",
  "Norway (+47)",
  "Palau (+680)",
  "Panama (+507)",
  "Papua New Guinea (+675)",
  "Paraguay (+595)",
  "Peru (+51)",
  "Poland (+48)",
  "Portugal (+351)",
  "Puerto Rico (+1-787, +1-939)",
  "Qatar (+974)",
  "Reunion (+262)",
  "Saint Barthelemy (+590)",
  "Saint Kitts and Nevis (+1-869)",
  "Saint Lucia (+1-758)",
  "Saint Pierre and Miquelon (+508)",
  "Saint Vincent and the Grenadines (+1-784)",
  "Samoa (+685)",
  "San Marino (+378)",
  "Sao Tome and Principe (+239)",
  "Saudi Arabia (+966)",
  "Senegal (+221)",
  "Seychelles (+248)",
  "Sierra Leone (+232)",
  "Sint Maarten (+1-721)",
  "Slovakia (+421)",
  "Slovenia (+386)",
  "Solomon Islands (+677)",
  "Somalia (+252)",
  "Spain (+34)",
  "Sudan (+249)",
  "Suriname (+597)",
  "Sweden (+46)",
  "Switzerland (+41)",
  "Syria (+963)",
  "Tajikistan (+992)",
  "Togo (+228)",
  "Tonga (+676)",
  "Trinidad and Tobago (+1-868)",
  "Tunisia (+216)",
  "Turkmenistan (+993)",
  "Turks and Caicos Islands (+1-649)",
  "Tuvalu (+688)",
  "United Arab Emirates (+971)",
  "United Kingdom (+44)",
  "United States (+1)",
  "Uruguay (+598)",
  "Vanuatu (+678)",
  "Wallis and Futuna (+681)",
  "Zimbabwe (+263)"
];
