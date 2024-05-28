// ignore_for_file: depend_on_referenced_packages

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shebaone/controllers/bindings/auth_binding.dart';
import 'package:shebaone/controllers/bindings/home_binding.dart';
import 'package:shebaone/controllers/call_controller.dart';
import 'package:shebaone/pages/ambulance/controller/ambulance_search_controller.dart';
import 'package:shebaone/pages/ambulance/controller/distance_between_rider_controller.dart';
import 'package:shebaone/pages/ambulance/view/chat_bot.dart';
import 'package:shebaone/pages/ambulance/view/test_map.dart';

import 'package:shebaone/pages/app_intro_screen.dart';
import 'package:shebaone/pages/cart/ui/billing_screen.dart';
import 'package:shebaone/pages/cart/ui/healthcare_cart_screen.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/cart/ui/lab_cart_screen.dart';
import 'package:shebaone/pages/cart/ui/medicine_cart_screen.dart';
import 'package:shebaone/pages/cart/ui/place_order_screen.dart';
import 'package:shebaone/pages/cart/ui/purchase_done_screen.dart';
import 'package:shebaone/pages/dashboard/ui/dashboard.dart';
import 'package:shebaone/pages/doctor/ui/doctor_appointment_details_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_appointment_done_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_book_appointment_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_by_category_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_explore_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_filter_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_online_appointment_package_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_profile_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_review_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_appointment_details_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_appointment_done_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_book_appointment_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_by_category_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_explore_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_filter_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_online_appointment_package_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_profile_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_review_screen.dart';
import 'package:shebaone/pages/fitness/ui/fitness_screen.dart';
import 'package:shebaone/pages/healthcare/ui/category_details_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_category_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/home/home_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_health_checkup_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_test_category_details_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_test_category_screen.dart';
import 'package:shebaone/pages/lab/ui/single_test_details_screen.dart';
import 'package:shebaone/pages/live_search/ui/check_login_map_page.dart';
import 'package:shebaone/pages/live_search/ui/medicine_map_page.dart';
import 'package:shebaone/pages/login/login_screen.dart';
import 'package:shebaone/pages/medicine/ui/all_medicine_screen.dart';
import 'package:shebaone/pages/medicine/ui/medicine_screen.dart';
import 'package:shebaone/pages/orders/ui/current_orders_screen.dart';
import 'package:shebaone/pages/orders/ui/lab_order_details_screen.dart';
import 'package:shebaone/pages/orders/ui/order_details_screen.dart';
import 'package:shebaone/pages/orders/ui/previous_orders_screen.dart';
import 'package:shebaone/pages/prescription/prescription_screen.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/pages/product/ui/medicine_product_details_screen.dart';
import 'package:shebaone/pages/search/ui/lab_search_screen.dart';
import 'package:shebaone/pages/search/ui/search_screen.dart';
import 'package:shebaone/pages/splash_screen.dart';
import 'package:shebaone/pages/verify/verify_screen.dart';
import 'package:shebaone/pages/women_corner/women_corner_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/services/fcm.dart';
import 'package:shebaone/services/jitsi_meet.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/theme.dart';
import 'pages/profile/ui/update_profile_screen.dart';
import 'pages/webview/webview_screen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // Setup FCM
  setupFirebaseMessenging();

  AwesomeNotifications().initialize(
    'resource://drawable/logo',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        channelDescription: 'Notification channel for basic tests',
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupName: 'Basic tests',
        channelGroupKey: 'basic_tests',
      ),
    ],
    debug: true,
  );
  // runApp(const RestartWidget(
  //   child: MyApp(function: RestartWidget.restartApp),
  // ));
  runApp(const MyApp());
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({required this.child, Key? key}) : super(key: key);
  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    // required this.function
  }) : super(key: key);

  // final Function function;
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  var _uuid;
  var _currentUuid;

  dynamic currentCall;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    //Check call when open app from terminated
    checkAndNavigationCallingPage();
  }

  Future<void> getDevicePushTokenVoIP() async {
    var devicePushTokenVoIP =
        await FlutterCallkitIncoming.getDevicePushTokenVoIP();
    print(devicePushTokenVoIP);
  }

  checkAndNavigationCallingPage({AppLifecycleState? state}) async {
    currentCall = await getCurrentCall(state: state);
    globalLogger.d(currentCall, 'currentCall');
    if (currentCall != null &&
        currentCall['extra']['callCount'] != null &&
        currentCall['extra']['callCount'] == callCount) {
      globalLogger.d(currentCall, 'ACTIVE CALL');
      globalLogger.d(recentCallStatus, 'recentCallStatus');
      if (state == AppLifecycleState.resumed ||
          recentCallStatus == 'ACTION_CALL_ACCEPT') {
        // Get.to(CallingPage(), arguments: currentCall);
        JitsiUtil.joinMeeting(
          isVideoCallOptionEnable: currentCall['type'] == 1,
          subject: currentCall['nameCaller'],
          roomName: currentCall['extra']['roomId'],
          // roomName:
        );
        CallController.to.callStatus(CallStatus.running);
        calling = currentCall;
        callCount++;
        currentCall = null;
      }
    }
  }

  getCurrentCall({AppLifecycleState? state}) async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    globalLogger.d(calls, 'getCurrentCall');
    if (calls is List) {
      if (calls.isNotEmpty) {
        CallController.to.callStatus(CallStatus.incoming);
        if (calls[calls.length - 1]['extra']['callCount'] != null &&
            calls[calls.length - 1]['extra']['callCount'] == callCount &&
            (state == AppLifecycleState.resumed ||
                recentCallStatus == 'ACTION_CALL_ACCEPT')) {
          CallController.to.callStatus(CallStatus.accepted);
          sendPushMessage(
            callType: calls[calls.length - 1]['type'] == 1 ? 'video' : 'audio',
            callStatus: 'accepted',
            token: calls[calls.length - 1]['extra']['token'],
            notificationType: 'call',
            title: 'Current call',
            body: 'Running',
          );
          // sendMessage(
          //   type: calls[calls.length - 1]['type'] == 1 ? 'video' : 'audio',
          //   callStatus: 'accepted',
          //   token: calls[calls.length - 1]['extra']['token'],
          // );
        }
        // if (DateTime.now()
        //         .difference(DateTime.parse(calls[0]['extra']['ringTime']))
        //         .inSeconds <
        //     45) {
        //   joinMeeting(isVideoCallOptionEnable: calls[0]['type'] == 1);
        // }
        // for (int i = 0; i < calls.length - 1; i++) {
        //   await FlutterCallkitIncoming.endCall(calls[i]);
        // }
        final call = calls[calls.length - 1];
        calls = [];
        calls.add(call);
        globalLogger.d(calls[0]['type']);
        globalLogger.d(calls);
        _currentUuid = calls[0]['id'];
        return calls[0];
      } else {
        _currentUuid = "";
        return null;
      }
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    globalLogger.d(state, '======state======');
    if (state == AppLifecycleState.resumed) {
      //Check call when open app from background
      checkAndNavigationCallingPage(state: state);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Get.put(AmbulanceServiceController());
    // Get.put(DistanceBetweenRiderController());
    return GetMaterialApp(
      scaffoldMessengerKey: snackbarKey,
      title: 'ShebaOne',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      initialBinding: AuthBinding(),
      getPages: [
        // GetPage(
        //   name: '/',
        //   page: () => MapView(),
        // ),
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: AppIntroScreen.routeName,
          page: () => const AppIntroScreen(),
        ),
        GetPage(
          name: HomeScreen.routeName,
          page: () => const HomeScreen(),
          binding: HomeBinding(),
        ),

        GetPage(
          name: LoginScreen.routeName,
          page: () => LoginScreen(),
        ),
        GetPage(
          name: VerifyScreen.routeName,
          page: () => const VerifyScreen(),
        ),
        GetPage(
          name: PreviousOrdersScreen.routeName,
          page: () => const PreviousOrdersScreen(),
        ),
        GetPage(
          name: CurrentOrdersScreen.routeName,
          page: () => const CurrentOrdersScreen(),
        ),
        // GetPage(
        //   name: RegisterScreen.routeName,
        //   page: () => const RegisterScreen(),
        //   binding: RegisterBinding(),
        // ),
        //
        GetPage(
          name: DashboardScreen.routeName,
          page: () => const DashboardScreen(),
          // binding: DashboardBinding(),
        ),
        GetPage(
          name: UpdateProfile.routeName,
          page: () => const UpdateProfile(),
        ),
        GetPage(
          name: WebViewPage.routeName,
          page: () => const WebViewPage(),
        ),
        GetPage(
          name: PrescriptionScreen.routeName,
          page: () => const PrescriptionScreen(),
        ),
        GetPage(
          name: OrderDetails.routeName,
          page: () => const OrderDetails(),
        ),
        GetPage(
          name: HealthcareScreen.routeName,
          page: () => const HealthcareScreen(),
        ),
        GetPage(
          name: HealthcareCategoryScreen.routeName,
          page: () => const HealthcareCategoryScreen(),
        ),
        GetPage(
          name: CategoryDetailsScreen.routeName,
          page: () => const CategoryDetailsScreen(),
        ),
        GetPage(
          name: HealthcareProductDetailsScreen.routeName,
          page: () => const HealthcareProductDetailsScreen(),
        ),
        GetPage(
          name: HealthcareCartScreen.routeName,
          page: () => const HealthcareCartScreen(),
        ),
        GetPage(
          name: HealthcareLiveCartScreen.routeName,
          page: () => const HealthcareLiveCartScreen(),
        ),
        GetPage(
          name: BillingScreen.routeName,
          page: () => const BillingScreen(),
        ),
        GetPage(
          name: PurchaseDoneScreen.routeName,
          page: () => const PurchaseDoneScreen(),
        ),
        GetPage(
          name: SearchScreen.routeName,
          page: () => const SearchScreen(),
        ),
        GetPage(
          name: LabSearchScreen.routeName,
          page: () => const LabSearchScreen(),
        ),
        // GetPage(
        //   name: AddcardPage.routeName,
        //   page: () => const AddcardPage(),
        // ),
        GetPage(
          name: DoctorAppointmentDoneScreen.routeName,
          page: () => const DoctorAppointmentDoneScreen(),
        ),
        GetPage(
          name: PlaceOrderScreen.routeName,
          page: () => const PlaceOrderScreen(),
        ),
        GetPage(
          name: LabOrderDetails.routeName,
          page: () => const LabOrderDetails(),
        ),
        GetPage(
          name: MedicineScreen.routeName,
          page: () => MedicineScreen(),
        ),
        GetPage(
          name: LogInCheckLiveMapPage.routeName,
          page: () => const LogInCheckLiveMapPage(),
        ),
        GetPage(
          name: MedicineLiveMapPage.routeName,
          page: () => const MedicineLiveMapPage(),
        ),
        GetPage(
          name: AllMedicineScreen.routeName,
          page: () => AllMedicineScreen(),
        ),
        GetPage(
          name: MedicineProductDetailsScreen.routeName,
          page: () => const MedicineProductDetailsScreen(),
        ),
        GetPage(
          name: MedicineCartScreen.routeName,
          page: () => const MedicineCartScreen(),
        ),
        GetPage(
          name: LabCartScreen.routeName,
          page: () => const LabCartScreen(),
        ),
        GetPage(
          name: LabScreen.routeName,
          page: () => const LabScreen(),
        ),
        GetPage(
          name: LabTestCategoryScreen.routeName,
          page: () => const LabTestCategoryScreen(),
        ),
        GetPage(
          name: LabTestCategoryDetailsScreen.routeName,
          page: () => const LabTestCategoryDetailsScreen(),
        ),
        GetPage(
          name: LabHealthCheckupScreen.routeName,
          page: () => const LabHealthCheckupScreen(),
        ),
        GetPage(
          name: SingleTestDetailsScreen.routeName,
          page: () => const SingleTestDetailsScreen(),
        ),
        GetPage(
          name: DoctorScreen.routeName,
          page: () => DoctorScreen(),
        ),
        GetPage(
          name: DoctorByCategoryScreen.routeName,
          page: () => const DoctorByCategoryScreen(),
        ),
        GetPage(
          name: DoctorFilterScreen.routeName,
          page: () => const DoctorFilterScreen(),
        ),
        GetPage(
          name: DoctorExploreScreen.routeName,
          page: () => const DoctorExploreScreen(),
        ),
        GetPage(
          name: DoctorProfileScreen.routeName,
          page: () => const DoctorProfileScreen(),
        ),
        GetPage(
          name: DoctorBookAppointmentScreen.routeName,
          page: () => const DoctorBookAppointmentScreen(),
        ),
        GetPage(
          name: DoctorAppointmentDetailsScreen.routeName,
          page: () => const DoctorAppointmentDetailsScreen(),
        ),
        GetPage(
          name: DoctorOnlinePackagePackageScreen.routeName,
          page: () => const DoctorOnlinePackagePackageScreen(),
        ),
        GetPage(
          name: DoctorReviewScreen.routeName,
          page: () => const DoctorReviewScreen(),
        ),
        //
        // GetPage(
        //   name: AboutUsScreen.routeName,
        //   page: () => const AboutUsScreen(),
        // ),
        //
        // GetPage(
        //   name: CompanyPage.routeName,
        //   page: () => const CompanyPage(),
        // ),

        GetPage(
          name: FitnessScreen.routeName,
          page: () => const FitnessScreen(),
        ),
        GetPage(
          name: FitnessByCategoryScreen.routeName,
          page: () => const FitnessByCategoryScreen(),
        ),
        GetPage(
          name: FitnessProfileScreen.routeName,
          page: () => const FitnessProfileScreen(),
        ),
        GetPage(
          name: FitnessBookAppointmentScreen.routeName,
          page: () => const FitnessBookAppointmentScreen(),
        ),
        GetPage(
          name: FitnessOnlinePackagePackageScreen.routeName,
          page: () => const FitnessOnlinePackagePackageScreen(),
        ),
        GetPage(
          name: FitnessAppointmentDoneScreen.routeName,
          page: () => const FitnessAppointmentDoneScreen(),
        ),
        GetPage(
          name: FitnessAppointmentDetailsScreen.routeName,
          page: () => const FitnessAppointmentDetailsScreen(),
        ),
        GetPage(
          name: FitnessFilterScreen.routeName,
          page: () => const FitnessFilterScreen(),
        ),
        GetPage(
          name: FitnessReviewScreen.routeName,
          page: () => const FitnessReviewScreen(),
        ),
        GetPage(
          name: FitnessExploreScreen.routeName,
          page: () => const FitnessExploreScreen(),
        ),
        GetPage(
          name: WomenCornerScreen.routeName,
          page: () => const WomenCornerScreen(),
        ),
      ],
    );
  }
}
