import 'dart:math' as math;

// import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/pages/dashboard/ui/dashboard.dart';
import 'package:shebaone/pages/doctor/ui/doctor_screen.dart';
import 'package:shebaone/pages/healthcare/ui/healthcare_screen.dart';
import 'package:shebaone/pages/lab/ui/lab_screen.dart';
import 'package:shebaone/pages/live_search/ui/check_login_map_page.dart';
import 'package:shebaone/pages/medicine/ui/medicine_screen.dart';
import 'package:shebaone/pages/orders/ui/orders_screen.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/pages/product/ui/medicine_product_details_screen.dart';
import 'package:shebaone/pages/profile/ui/profile_screen.dart';
import 'package:shebaone/pages/service/ui/service_screen.dart';
import 'package:shebaone/pages/webview/webview_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/url_utils.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';
import 'package:socket_io_client/socket_io_client.dart';

class MainHomePage extends StatefulWidget {
  MainHomePage({Key? key}) : super(key: key);

  @override
  State<MainHomePage> createState() => _MainHomePageState();
}

class _MainHomePageState extends State<MainHomePage>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isIconPlaying = false;
  bool _isLeftDone = false;
  bool _isMiddleDone = false;
  bool _isRightDone = false;
  AnimationController? _animationController;
  AnimationController? _dropAnimationController;
  AnimationController? _animationIconController;
  Animation<double>? _pulseAnimation;
  Animation<double>? _pulseDropAnimation;
  String? activeAnimation;
  String? newActiveAnimation;
  double? leftMenuPosition = 60;
  void animate() {
    if (_isPlaying) {
      _animationController!.forward();
    } else {
      _animationController!.reverse();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });

    setState(() {
      _isIconPlaying = !_isIconPlaying;
      if (_isIconPlaying) {
        _animationIconController!.forward();
        _dropAnimationController!.forward();
        _isLeftDone = false;
        _isMiddleDone = false;
        _isRightDone = false;
      } else {
        _animationIconController!.reverse();
        _dropAnimationController!.reverse();
      }
    });
    leftMenuPosition = _isPlaying ? 120 : 55;

    activeAnimation = (activeAnimation == 'Idle') ? 'Action' : 'Idle';

    // Timer(Duration(milliseconds: 2000), () {
    //   newActiveAnimation = activeAnimation == 'Idle' ? 'Action' : 'Idle';
    // });
  }

  @override
  void initState() {
    storage.write("attempt_value", "0");
    super.initState();
    activeAnimation = 'Idle';
    newActiveAnimation = 'Idle';
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    _animationIconController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _dropAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
        CurvedAnimation(parent: _animationController!, curve: Curves.easeIn));
    _pulseDropAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _dropAnimationController!, curve: Curves.easeIn));

    _pulseAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController!.reverse();
        _animationController!.stop();
      } else if (status == AnimationStatus.dismissed) {
        _animationController!.forward();
        _animationController!.stop();
      }
    });
    _pulseDropAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _dropAnimationController!.reverse();
        _dropAnimationController!.stop();
      } else if (status == AnimationStatus.dismissed) {
        _dropAnimationController!.forward();
        _dropAnimationController!.stop();
      }
    });
  }

  @override
  void dispose() {
    _animationIconController!.dispose();
    _dropAnimationController!.dispose();
    _animationController!.dispose();
    super.dispose();
  }

  final GlobalKey parentKeyForLiveSearch = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Get.put<HomeController>(HomeController());
    double WIDTH = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (HomeController.to.isMenuOpen.value) {
          HomeController.to.changeMenuOpenActivity();
          return false;
        }
        if (HomeController.to.menuItemEnum.value != MenuItemEnum.home) {
          HomeController.to.changeMenuItemActivity(MenuItemEnum.home);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF9FCFF),
        body: Stack(
          key: parentKeyForLiveSearch,
          children: [
            Obx(() {
              if (HomeController.to.getMenuItemEnum == MenuItemEnum.home) {
                return const DashboardScreen();
              } else if (HomeController.to.getMenuItemEnum ==
                  MenuItemEnum.services) {
                return const ServicesScreen();
              }
              // else if (HomeController.to.getMenuItemEnum ==
              //     MenuItemEnum.prescription) {
              //   return const PrescriptionScreen();
              // }
              else if (HomeController.to.getMenuItemEnum ==
                  MenuItemEnum.orders) {
                return const OrdersScreen();
              } else if (HomeController.to.getMenuItemEnum ==
                  MenuItemEnum.profile) {
                return const ProfileScreen();
              }
              return const Center(
                child: Text('404'),
              );
            }),

            ///Left
            AnimatedPositioned(
              onEnd: () {
                _isLeftDone = true;
                setState(() {});
              },
              duration: Duration(milliseconds: _isPlaying ? 250 : 575),
              bottom: _isPlaying ? 120 : 55,
              left: _isPlaying ? (WIDTH * .5) - 100 : (WIDTH * .5) - 22.5,
              child: ScaleTransition(
                scale: _pulseAnimation!,
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.horizontal(
                              left: Radius.circular(40))
                          .copyWith(
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(
                            leftMenuPosition == 60 || _isLeftDone ? 40 : 10),
                      ),
                      color: kPrimaryColor,
                      boxShadow: [
                        if (_isLeftDone)
                          const BoxShadow(
                            color: Colors.black54,
                            blurRadius: 12,
                            offset: Offset(0, 5),
                          )
                      ]
                      // color: Color(0xffff6dd5),
                      ),
                  child: GestureDetector(
                    onTap: () {
                      animate();
                      Utils.launchWhatsapp('+8801311477608');
                    },
                    child: Tooltip(
                      message: 'Whatsapp',
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: kPrimaryColor,
                        ),
                        child: Center(
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: (_isIconPlaying) ? 1.0 : 0,
                            child: Image.asset(
                              'assets/icons/whatsapp.png',
                              width: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///Middle
            AnimatedPositioned(
              onEnd: () {
                _isMiddleDone = true;
                setState(() {});
              },
              duration: const Duration(milliseconds: 350),
              bottom: _isPlaying ? 130 : 55,
              left: _isPlaying ? (WIDTH * .5) - 22.5 : (WIDTH * .5) - 22.5,
              child: ScaleTransition(
                scale: _pulseAnimation!,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: -math.pi / 3.8,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(40))
                              .copyWith(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(
                                leftMenuPosition == 60 || _isLeftDone
                                    ? 40
                                    : 10),
                            bottomRight: Radius.circular(40),
                          ),
                          color: kPrimaryColor,

                          // color: Color(0xffff6dd5),
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: -math.pi / 10,
                      child: Container(
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(40),
                              topLeft: const Radius.circular(40),
                              bottomRight: Radius.circular(
                                  leftMenuPosition == 60 || _isMiddleDone
                                      ? 40
                                      : 10),
                              bottomLeft: const Radius.circular(40),
                            ),
                            // color: Color(0xffff6dd5),
                            color: kPrimaryColor,
                            boxShadow: [
                              if (_isMiddleDone)
                                const BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 12,
                                  offset: Offset(0, 5),
                                )
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        animate();
                        Utils.makePhoneCall('tel:+8801755660692');
                      },
                      child: Tooltip(
                        message: 'Hotline',
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: kPrimaryColor,
                          ),
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: (_isIconPlaying) ? 1.0 : 0,
                              child: Image.asset(
                                'assets/icons/call.png',
                                width: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///Right
            AnimatedPositioned(
              onEnd: () {
                _isRightDone = true;
                setState(() {});
              },
              duration: Duration(milliseconds: _isPlaying ? 575 : 250),
              bottom: _isPlaying ? 120 : 55,
              left: _isPlaying ? (WIDTH * .5) + 60 : (WIDTH * .5) - 22.5,
              child: ScaleTransition(
                scale: _pulseAnimation!,
                child: Stack(
                  children: [
                    Transform.rotate(
                      angle: -math.pi / 10,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: const Radius.circular(40),
                            topLeft: Radius.circular(
                              leftMenuPosition == 60 || _isMiddleDone ? 40 : 10,
                            ),
                            bottomRight: const Radius.circular(40),
                            bottomLeft: const Radius.circular(40),
                          ),
                          // color: Color(0xffff6dd5),
                          color: kPrimaryColor,
                        ),
                        width: 45,
                        height: 45,
                      ),
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(40))
                              .copyWith(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(
                                leftMenuPosition == 60 || _isMiddleDone
                                    ? 40
                                    : 10),
                          ),
                          color: kPrimaryColor,
                          boxShadow: [
                            if (_isRightDone)
                              const BoxShadow(
                                color: Colors.black54,
                                blurRadius: 12,
                                offset: Offset(0, 5),
                              )
                          ]

                          // color: Color(0xffff6dd5),
                          ),
                      child: GestureDetector(
                        onTap: () {
                          animate();
                          // https://www.facebook.com/messages/t/103090905345714
                          Utils.launchMessenger('103090905345714');
                        },
                        child: Tooltip(
                          message: 'Messenger',
                          child: Container(
                            height: 45,
                            width: 45,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: kPrimaryColor,
                            ),
                            child: Center(
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 300),
                                opacity: (_isIconPlaying) ? 1.0 : 0,
                                child: Image.asset(
                                  'assets/icons/messenger.png',
                                  color: Colors.white,
                                  width: 25,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            ///right boom
            AnimatedPositioned(
              duration: Duration(milliseconds: _isIconPlaying ? 300 : 1000),
              bottom: _isPlaying ? 105 : 65,
              left: _isPlaying ? (WIDTH * .5) + 25 : (WIDTH * .5) - 15,
              child: ScaleTransition(
                scale: _pulseDropAnimation!,
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                      color: !_isPlaying ? Colors.transparent : kPrimaryColor,
                      // Color(0xffff6dd5),
                      borderRadius: BorderRadius.circular(40)),
                ),
              ),
            ),

            // Positioned(
            //   bottom: 55,
            //   left: (WIDTH * .5) - 22.5,
            //   child: Transform.rotate(
            //     angle: -math.pi / 3.0,
            //     child: Container(
            //       width: 45,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(40),
            //         child: FlareActor(
            //           'assets/flare/bottomSlime.flr',
            //           color: Color(0xffff6dd5).withOpacity((true) ? 1 : 0),
            //           animation: activeAnimation,
            //           sizeFromArtboard: true,
            //           alignment: Alignment.bottomCenter,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //       height: 45,
            //       // width: WIDTH,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 55,
            //   left: (WIDTH * .5) - 22.5,
            //   child: Transform.rotate(
            //     angle: -math.pi / 2.0,
            //     child: Container(
            //       width: 45,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(40),
            //         child: FlareActor(
            //           'assets/flare/bottomSlime.flr',
            //           color: Color(0xffff6dd5).withOpacity((true) ? 1 : 0),
            //           animation: activeAnimation,
            //           sizeFromArtboard: true,
            //           alignment: Alignment.bottomCenter,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //       height: 45,
            //       // width: WIDTH,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 55,
            //   left: (WIDTH * .5) - 22.5,
            //   child: Transform.rotate(
            //     angle: -math.pi / 1.5,
            //     child: Container(
            //       width: 45,
            //       child: ClipRRect(
            //         borderRadius: BorderRadius.circular(40),
            //         child: FlareActor(
            //           'assets/flare/bottomSlime.flr',
            //           color: Color(0xffff6dd5).withOpacity((true) ? 1 : 0),
            //           animation: activeAnimation,
            //           sizeFromArtboard: true,
            //           alignment: Alignment.bottomCenter,
            //           fit: BoxFit.contain,
            //         ),
            //       ),
            //       height: 45,
            //       // width: WIDTH,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   bottom: 55,
            //   left: (WIDTH * .5) - 22.5,
            //   child: Container(
            //     width: 45,
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(40),
            //       child: FlareActor(
            //         'assets/flare/bottomSlime.flr',
            //         color: Color(0xffff6dd5).withOpacity((true) ? 1 : 0),
            //         animation: activeAnimation,
            //         sizeFromArtboard: true,
            //         alignment: Alignment.bottomCenter,
            //         fit: BoxFit.contain,
            //       ),
            //     ),
            //     height: 45,
            //     // width: WIDTH,
            //   ),
            // ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Obx(() {
                      return MenuItem(
                        menuName: 'Home',
                        isActive: HomeController.to.getMenuItemEnum ==
                            MenuItemEnum.home,
                        onTap: () {
                          HomeController.to.search('');
                          if (HomeController.to.getMenuItemEnum ==
                              MenuItemEnum.home) {
                            print('Home');
                          }
                          HomeController.to
                              .changeMenuItemActivity(MenuItemEnum.home);
                        },
                      );
                    }),
                    Obx(() {
                      return MenuItem(
                        isActive: HomeController.to.getMenuItemEnum ==
                            MenuItemEnum.services,
                        menuName: 'Services',
                        onTap: () {
                          HomeController.to.search('');
                          if (HomeController.to.getMenuItemEnum ==
                              MenuItemEnum.services) {
                            print('Services');
                          }
                          HomeController.to
                              .changeMenuItemActivity(MenuItemEnum.services);
                        },
                      );
                    }),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24),
                        child: Text(
                          'Contacts',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kTextColorLite,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    Obx(() {
                      return MenuItem(
                        isActive: HomeController.to.getMenuItemEnum ==
                            MenuItemEnum.orders,
                        menuName: 'Orders',
                        onTap: () {
                          HomeController.to.search('');
                          if (HomeController.to.getMenuItemEnum ==
                              MenuItemEnum.orders) {
                            print('Orders');
                          }
                          HomeController.to
                              .changeMenuItemActivity(MenuItemEnum.orders);
                        },
                      );
                    }),
                    Obx(() {
                      return MenuItem(
                        isActive: HomeController.to.getMenuItemEnum ==
                            MenuItemEnum.profile,
                        menuName: 'Profile',
                        onTap: () {
                          HomeController.to.search('');
                          if (HomeController.to.getMenuItemEnum ==
                              MenuItemEnum.profile) {
                            print('Profile');
                          }
                          HomeController.to
                              .changeMenuItemActivity(MenuItemEnum.profile);
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              left: (MediaQuery.of(context).size.width / 2) - 30,
              child: SizedBox(
                height: 60,
                width: 60,
                child: GestureDetector(
                  onTap: () {
                    // HomeController.to
                    //     .changeMenuItemActivity(MenuItemEnum.prescription);
                    // Utils.makePhoneCall('tel:+8801755660692');

                    print('play');
                    animate();
                  },
                  child: Material(
                    color: Colors.white,
                    elevation: 5,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color(0xff5FC502),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/icons/contact-us.png',
                          width: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            ///key Search
            Obx(
              () => (!(HomeController.to.getMenuItemEnum ==
                              MenuItemEnum.profile ||
                          HomeController.to.getMenuItemEnum ==
                              MenuItemEnum.orders)) &&
                      HomeController.to.search.value.isNotEmpty
                  ? Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top +
                              kToolbarHeight +
                              70),
                      width: Get.width,
                      height: Get.height * .3,
                      color: Colors.white,
                      child: HomeController.to.searchList.isEmpty
                          ? const Center(
                              child: Text('No Result Found!'),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: HomeController.to.searchList.value
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          if (e['type'] == 'health_cares') {
                                            HealthCareController.to
                                                .getSingleProduct(
                                                    e['id'].toString());
                                            Get.toNamed(
                                                HealthcareProductDetailsScreen
                                                    .routeName);
                                          } else {
                                            MedicineController.to
                                                .getSingleMedicine(
                                                    e['id'].toString());
                                            Get.toNamed(
                                                MedicineProductDetailsScreen
                                                    .routeName);
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 8,
                                          ),
                                          width: Get.width,
                                          color: Colors.white,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  CustomNetworkImage(
                                                    networkImagePath:
                                                        e['image_path'] ?? '',
                                                    errorImagePath: e['type'] ==
                                                            'health_cares'
                                                        ? 'assets/icons/healthcare_primary.png'
                                                        : 'assets/icons/medicine.jpg',
                                                    height: 25,
                                                    width: 25,
                                                  ),
                                                  space2R,
                                                  Expanded(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        text: e['name']
                                                            .toString()
                                                            .substring(
                                                                0,
                                                                HomeController
                                                                    .to
                                                                    .search
                                                                    .value
                                                                    .length),
                                                        style: TextStyle(
                                                          color: kPrimaryColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text: e['name']
                                                                .toString()
                                                                .substring(
                                                                    HomeController
                                                                        .to
                                                                        .search
                                                                        .value
                                                                        .length),
                                                            style: TextStyle(
                                                              color:
                                                                  kPrimaryColor,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Icon(Icons
                                                      .chevron_right_rounded),
                                                ],
                                              ),
                                              // Text(
                                              //   e['type'] == 'health_cares' ? 'HealthCare Product' : 'Medicine Product',
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                    )
                  : const SizedBox(),
            ),
            const SideMenuBar(),
            Obx(() => (HealthCareController.to.confirmOrderStatus.value ||
                        MedicineController.to.confirmOrderStatus.value ||
                        PrescriptionController.to.confirmOrderStatus.value) &&
                    AuthController.to.isLoggedIn
                ? DraggableFloatingActionButton(
                    initialOffset: Offset(Get.width - 80, Get.height - 160),
                    parentKey: parentKeyForLiveSearch,
                    onPressed: () {
                      globalLogger
                          .d(HealthCareController.to.confirmOrderStatus.value);
                      if (HealthCareController.to.confirmOrderStatus.value) {
                        HomeController.to
                            .liveSearchType(LiveSearchType.healthcare);
                      } else if (PrescriptionController
                          .to.confirmOrderStatus.value) {
                        HomeController.to
                            .liveSearchType(LiveSearchType.prescription);
                      } else {
                        HomeController.to
                            .liveSearchType(LiveSearchType.medicine);
                      }
                      if (AuthController.to.deliverymanId.value.isEmpty) {
                        initSocket();
                      }
                      Get.toNamed(LogInCheckLiveMapPage.routeName);
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: ShapeDecoration(
                        shadows: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                          )
                        ],
                        shape: CircleBorder(
                          side: BorderSide(
                            color: kPrimaryColor.withOpacity(.8),
                            width: 4,
                          ),
                        ),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.asset(
                          "assets/images/search_map.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()),
          ],
        ),
      ),
    );
  }

  initSocket() {
    globalLogger.d('Init Socket Enter');
    // globalLogger.d(socket!.id, 'Socket Var');
    socket.onConnect((_) {
      globalLogger.d('Connection Socket');

      socket.emit('sendChatToServer3', [orderInfoConfirm]);

      socket.disconnect();
      socket.dispose();
    });
    socket.connect();
    socket.onDisconnect((_) => globalLogger.d('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }
}

class DraggableFloatingActionButton extends StatefulWidget {
  final Widget child;
  final Offset initialOffset;
  final VoidCallback onPressed;

  var parentKey;

  DraggableFloatingActionButton({
    required this.child,
    required this.initialOffset,
    required this.onPressed,
    required this.parentKey,
  });

  @override
  State<StatefulWidget> createState() => _DraggableFloatingActionButtonState();
}

class _DraggableFloatingActionButtonState
    extends State<DraggableFloatingActionButton> {
  final GlobalKey _key = GlobalKey();

  bool _isDragging = false;
  late Offset _offset;
  late Offset _minOffset;
  late Offset _maxOffset;

  @override
  void initState() {
    super.initState();
    _offset = widget.initialOffset;

    WidgetsBinding.instance.addPostFrameCallback(_setBoundary);
  }

  void _setBoundary(_) {
    final RenderBox parentRenderBox =
        widget.parentKey.currentContext?.findRenderObject() as RenderBox;
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;

    try {
      final Size parentSize = parentRenderBox.size;
      final Size size = renderBox.size;

      setState(() {
        _minOffset = const Offset(0, 0);
        _maxOffset = Offset(
            parentSize.width - size.width, parentSize.height - size.height);
      });
    } catch (e) {
      print('catch: $e');
    }
  }

  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = _offset.dx + pointerMoveEvent.delta.dx;
    double newOffsetY = _offset.dy + pointerMoveEvent.delta.dy;

    if (newOffsetX < _minOffset.dx) {
      newOffsetX = _minOffset.dx;
    } else if (newOffsetX > _maxOffset.dx) {
      newOffsetX = _maxOffset.dx;
    }

    if (newOffsetY < _minOffset.dy) {
      newOffsetY = _minOffset.dy;
    } else if (newOffsetY > _maxOffset.dy) {
      newOffsetY = _maxOffset.dy;
    }

    setState(() {
      _offset = Offset(newOffsetX, newOffsetY);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _offset.dx,
      top: _offset.dy,
      child: Listener(
        onPointerMove: (PointerMoveEvent pointerMoveEvent) {
          _updatePosition(pointerMoveEvent);

          setState(() {
            _isDragging = true;
          });
        },
        onPointerUp: (PointerUpEvent pointerUpEvent) {
          print('onPointerUp');
          print(_isDragging);

          // if (_isDragging) {
          //   setState(() {
          //     _isDragging = false;
          //   });
          // } else {
          widget.onPressed();
          // }
        },
        child: Container(
          key: _key,
          child: widget.child,
        ),
      ),
    );
  }
}

class SideMenuBar extends StatelessWidget {
  const SideMenuBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Obx(
          () => AnimatedPositioned(
            top: 0,
            // left: HomeController.to.isMenuOpen.value
            //     ? Get.width * .8
            //     : -Get.width,
            right: HomeController.to.isMenuOpen.value ? 0 : -Get.width,
            duration: const Duration(milliseconds: 50),
            child: GestureDetector(
              onTap: () {
                HomeController.to.changeMenuOpenActivity();
              },
              child: Container(
                height: Get.height,
                width: Get.width,
                decoration: BoxDecoration(
                    color: const Color(0xff77DC86).withOpacity(.74)
                    // gradient: LinearGradient(
                    //   // colors: [
                    //   //   const Color(0xff77DC86).withOpacity(.74),
                    //   //   Colors.transparent,
                    //   // ],
                    //   colors: [
                    //     Colors.transparent,
                    //     const Color(0xff77DC86).withOpacity(.74),
                    //   ],
                    // ),
                    ),
              ),
            ),
          ),
        ),
        Obx(
          () => AnimatedPositioned(
            top: 0,
            left: HomeController.to.isMenuOpen.value ? 0 : -Get.width,
            duration: const Duration(milliseconds: 200),
            child: Stack(
              children: [
                Container(
                  height: Get.height,
                  width: Get.width * .85,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).padding.top + 20,
                      ),
                      Column(
                        children: [
                          // Material(
                          //   borderRadius: BorderRadius.circular(100),
                          //   color: Colors.white,
                          //   elevation: 4,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(2.0),
                          //     child: SizedBox(
                          //       height: 100,
                          //       width: 100,
                          //       child: ClipRRect(
                          //         borderRadius: BorderRadius.circular(100),
                          //         child:
                          //             Image.asset('assets/images/product.png'),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          space1hC,
                          TitleText(
                            title: AuthController.to.isLoggedIn
                                ? UserController.to.getUserInfo.name ?? ''
                                : 'Guest User',
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                          ),
                          /*PrimaryButton(
                            label: 'Try Sheba Plus',
                            primary: const Color(0xff5FC502),
                            height: 25,
                            borderRadiusAll: 5,
                            contentPadding: 0,
                            marginVertical: 8,
                            marginHorizontal: 0,
                            fontSize: 12,
                            width: 120,
                            onPressed: () {
                              // globalLogger.d(
                              //     ((HealthCareController.to.orderSuccessData['order_id'] != null &&
                              //         info['orderId'] == HealthCareController.to.orderSuccessData['order_id']) ||
                              //         (MedicineController.to.orderSuccessData['order_id'] != null &&
                              //             info['orderId'] == MedicineController.to.orderSuccessData['order_id']) ||
                              //         (PrescriptionController.to.orderSuccessData['order_id'] != null &&
                              //             info['orderId'] == PrescriptionController.to.orderSuccessData['order_id'])),
                              //     "FCM_CONDITION");

                              if (false) {
                                HealthCareController.to.orderSuccessData({});
                                HealthCareController.to.confirmationPharmacyData({});
                                HealthCareController.to.confirmOrderStatus(false);
                                HealthCareController.to.syncConfirmOrderStatusToLocal();

                                MedicineController.to.orderSuccessData({});
                                MedicineController.to.confirmationPharmacyData({});
                                MedicineController.to.confirmOrderStatus(false);
                                MedicineController.to.syncConfirmOrderStatusToLocal();

                                PrescriptionController.to.orderSuccessData({});
                                PrescriptionController.to.confirmationPharmacyData({});
                                PrescriptionController.to.confirmOrderStatus(false);
                                PrescriptionController.to.syncConfirmOrderStatusToLocal();
                              }

                              // storage.write('isFirstTime', true);
                            },
                          ),*/
                          HorizontalDivider(
                            color: kPrimaryColor,
                            thickness: .4,
                            horizontalMargin: 16,
                          ),
                        ],
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ExpandableItem(
                                label: 'Customer Services',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Buy Health Product',
                                      onTap: () {
                                        if (Get.currentRoute !=
                                            HealthcareScreen.routeName) {
                                          Get.toNamed(
                                              HealthcareScreen.routeName);
                                        }
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Buy Medicine',
                                      onTap: () {
                                        if (Get.currentRoute !=
                                            MedicineScreen.routeName) {
                                          Get.toNamed(MedicineScreen.routeName);
                                        }
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Book a Lab Test',
                                      onTap: () {
                                        if (Get.currentRoute !=
                                            LabScreen.routeName) {
                                          Get.toNamed(LabScreen.routeName);
                                        }
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Book a Doctor',
                                      onTap: () {
                                        if (Get.currentRoute !=
                                            DoctorScreen.routeName) {
                                          Get.toNamed(DoctorScreen.routeName);
                                        }
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Offers and Promotions',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Refer & Earn',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/refer');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Health Article',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Book',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'For Doctor',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Create Your Sheba Profile',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/doctor_register');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    // SideSubMenuItem(
                                    //   label: 'Sign In',
                                    //   onTap: () {},
                                    // ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'For Lab',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Create Your Lab Profile',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/lab_register');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    // SideSubMenuItem(
                                    //   label: 'Sign In',
                                    //   onTap: () {},
                                    // ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'For Pharmacy/Store',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Create Your Pharmacy Profile',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/pharmacy_register');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    // SideSubMenuItem(
                                    //   label: 'Sign In',
                                    //   onTap: () {},
                                    // ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'For Rider',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Create Your Delivery Profile',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/deliveryman/get-create');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'Help',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'FAQ',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Return Policy',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/return-policy');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Privacy Policy',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/privacy-policy');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Terms & Conditions',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/terms-condition');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Corporate Witness',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'Partners with us',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Sell with Us',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Franchise',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'Become A Affiliator',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'Create Your Affiliate Profile',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/affiliate/get-create');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    // SideSubMenuItem(
                                    //   label: 'Sign In',
                                    //   onTap: () {},
                                    // ),
                                  ],
                                ),
                              ),
                              ExpandableItem(
                                label: 'SHEBA',
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SideSubMenuItem(
                                      label: 'About',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/about-us');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Blog',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Careers',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Press',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/coming-soon');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    SideSubMenuItem(
                                      label: 'Contact',
                                      onTap: () {
                                        HomeController.to.dynamicLink(
                                            'https://www.shebaone.com/contact');
                                        callWebViewUrl();
                                        HomeController.to
                                            .changeMenuOpenActivity();
                                      },
                                    ),
                                    FollowUsItem(
                                      label: 'Follow Us',
                                      // onTap: () {
                                      //   HomeController.to.isFollowUsClicked(!HomeController.to.isFollowUsClicked.value);
                                      //
                                      //   // HomeController.to.dynamicLink('https://www.shebaone.com/contact');
                                      //   // callWebViewUrl();
                                      //   // HomeController.to.changeMenuOpenActivity();
                                      // },
                                    ),
                                    // Obx(() {
                                    //   return Visibility(
                                    //     visible: HomeController.to.isFollowUsClicked.value,
                                    //     child: Column(
                                    //       children: [
                                    //         InkWell(
                                    //           onTap: () {
                                    //             HomeController.to.dynamicLink(
                                    //                 'https://www.facebook.com/profile.php?id=100069211376219&ref=pages_you_manage');
                                    //             callWebViewUrl();
                                    //             HomeController.to.changeMenuOpenActivity();
                                    //           },
                                    //           child: Row(
                                    //             children: [
                                    //               const Icon(
                                    //                 Icons.facebook,
                                    //                 size: 25,
                                    //                 color: Colors.blue,
                                    //               ),
                                    //               Text(
                                    //                 'Facebook',
                                    //                 style: TextStyle(color: kPrimaryColor, fontSize: 12),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //         InkWell(
                                    //           onTap: () {
                                    //             HomeController.to.dynamicLink(
                                    //                 'https://www.youtube.com/channel/UCQ5rkozV7JAEwnReFTTiT2w');
                                    //             callWebViewUrl();
                                    //             HomeController.to.changeMenuOpenActivity();
                                    //           },
                                    //           child: Row(
                                    //             children: [
                                    //               Padding(
                                    //                 padding: const EdgeInsets.all(2.0),
                                    //                 child: Image.asset('assets/icons/youtube.png', width: 22),
                                    //               ),
                                    //               Text(
                                    //                 'YouTube',
                                    //                 style: TextStyle(color: kPrimaryColor, fontSize: 12),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //         Row(
                                    //           children: [
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(2.0),
                                    //               child: Image.asset('assets/icons/instagram.png', width: 22),
                                    //             ),
                                    //             Text(
                                    //               'Instagram',
                                    //               style: TextStyle(color: kPrimaryColor, fontSize: 12),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         Row(
                                    //           children: [
                                    //             Padding(
                                    //               padding: const EdgeInsets.all(2.0),
                                    //               child: Image.asset('assets/icons/twitter.png', width: 22),
                                    //             ),
                                    //             Text(
                                    //               'Twitter',
                                    //               style: TextStyle(color: kPrimaryColor, fontSize: 12),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ],
                                    //     ),
                                    //   );
                                    // }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (AuthController.to.isLoggedIn)
                        Align(
                          alignment: Alignment.center,
                          child: PrimaryButton(
                            label: 'Log Out',
                            primary: Colors.white,
                            labelColor: kPrimaryColor,
                            borderColor: kPrimaryColor,
                            height: 36,
                            borderRadiusAll: 6,
                            contentPadding: 0,
                            marginVertical: 20,
                            marginHorizontal: 0,
                            fontSize: 14,
                            width: 160,
                            onPressed: () {
                              if (HomeController.to.isMenuOpen.value) {
                                HomeController.to.changeMenuOpenActivity();
                              }
                              AuthController.to.logout();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top,
                  left: 0,
                  child: IconButton(
                    onPressed: () {
                      HomeController.to.changeMenuOpenActivity();
                    },
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.close),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  void callWebViewUrl() {
    if (Get.currentRoute != WebViewPage.routeName) {
      Get.toNamed(WebViewPage.routeName,
          arguments: HomeController.to.dynamicLink.value);
    } else {
      Get.back();
      Get.toNamed(WebViewPage.routeName,
          arguments: HomeController.to.dynamicLink.value);
      // controller.loadRequest(Uri.parse(HomeController.to.dynamicLink.value));
    }
  }
}

class ExpandableItem extends StatefulWidget {
  const ExpandableItem({
    Key? key,
    required this.label,
    required this.child,
    this.isOdd = false,
    this.labelColor,
    this.labelFontWeight,
    this.childHorizontalPadding,
    this.parentHorizontalPadding,
  }) : super(key: key);
  final String label;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final double? childHorizontalPadding;
  final double? parentHorizontalPadding;
  final Widget child;
  final bool? isOdd;

  @override
  _ExpandableItemState createState() => _ExpandableItemState();
}

class _ExpandableItemState extends State<ExpandableItem> {
  bool _isExpandable = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      width: size.width,
      padding: EdgeInsets.symmetric(
          horizontal: widget.parentHorizontalPadding ?? 16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpandable = !_isExpandable;
              });
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label,
                    style: TextStyle(
                      color: _isExpandable
                          ? widget.labelColor ?? kPrimaryColor
                          : widget.labelColor ?? kTextColor,
                      fontWeight: _isExpandable
                          ? widget.labelFontWeight ?? FontWeight.w600
                          : widget.labelFontWeight ?? FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
                _isExpandable
                    ? Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: kPrimaryColor,
                      )
                    : Icon(
                        Icons.keyboard_arrow_right_outlined,
                        color: kTextColor,
                      ),
              ],
            ),
          ),
          space2C,
          Visibility(
            visible: _isExpandable,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.childHorizontalPadding ?? 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideSubMenuItem extends StatelessWidget {
  const SideSubMenuItem({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  final String label;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: kPrimaryColor,
                fontSize: 12,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}

class FollowUsItem extends StatelessWidget {
  const FollowUsItem({
    Key? key,
    required this.label,
  }) : super(key: key);

  final String label;
  void callWebViewUrl() {
    if (Get.currentRoute != WebViewPage.routeName) {
      Get.toNamed(WebViewPage.routeName,
          arguments: HomeController.to.dynamicLink.value);
    } else {
      Get.back();
      Get.toNamed(WebViewPage.routeName,
          arguments: HomeController.to.dynamicLink.value);
      // controller.loadRequest(Uri.parse(HomeController.to.dynamicLink.value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: kPrimaryColor,
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.justify,
          ),
          Spacer(),
          InkWell(
            onTap: () {
              HomeController.to.dynamicLink(
                  'https://www.facebook.com/profile.php?id=100069211376219&ref=pages_you_manage');
              callWebViewUrl();
              HomeController.to.changeMenuOpenActivity();
            },
            child: Row(
              children: [
                const Icon(
                  Icons.facebook,
                  size: 25,
                  color: Colors.blue,
                ),
                // Text(
                //   'Facebook',
                //   style: TextStyle(color: kPrimaryColor, fontSize: 12),
                // ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              HomeController.to.dynamicLink(
                  'https://www.youtube.com/channel/UCQ5rkozV7JAEwnReFTTiT2w');
              callWebViewUrl();
              HomeController.to.changeMenuOpenActivity();
            },
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.asset('assets/icons/youtube.png', width: 22),
                ),
                // Text(
                //   'YouTube',
                //   style: TextStyle(color: kPrimaryColor, fontSize: 12),
                // ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset('assets/icons/instagram.png', width: 22),
              ),
              // Text(
              //   'Instagram',
              //   style: TextStyle(color: kPrimaryColor, fontSize: 12),
              // ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Image.asset('assets/icons/twitter.png', width: 22),
              ),
              // Text(
              //   'Twitter',
              //   style: TextStyle(color: kPrimaryColor, fontSize: 12),
              // ),
            ],
          ),
          space3R,
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  const MenuItem({
    Key? key,
    this.isActive = false,
    required this.menuName,
    required this.onTap,
  }) : super(key: key);
  final bool isActive;
  final String menuName;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          color: Colors.transparent,
          child: Column(
            children: [
              Container(
                width: 30,
                height: 4,
                decoration: BoxDecoration(
                  color: isActive ? kPrimaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/icons/${isActive ? '${menuName.toLowerCase()}-active' : menuName.toLowerCase()}.png',
                width: 20,
              ),
              space1C,
              Text(
                menuName,
                style: TextStyle(
                  color: isActive ? kPrimaryColor : kTextColorLite,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
