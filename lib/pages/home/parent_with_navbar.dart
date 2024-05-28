import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/controllers/healthcare_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/controllers/medicine_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/pages/doctor/ui/doctor_profile_screen.dart';
import 'package:shebaone/pages/home/home_page.dart' as HP;
import 'package:shebaone/pages/home/home_page.dart';
import 'package:shebaone/pages/home/home_screen.dart';
import 'package:shebaone/pages/home/search_bar.dart';
import 'package:shebaone/pages/lab/ui/single_test_details_screen.dart';
import 'package:shebaone/pages/live_search/ui/check_login_map_page.dart';
import 'package:shebaone/pages/product/ui/healthcare_product_details_screen.dart';
import 'package:shebaone/pages/product/ui/medicine_product_details_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/url_utils.dart';
import 'package:shebaone/utils/widgets/network_image/network_image.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ParentPageWithNav extends StatefulWidget {
  const ParentPageWithNav(
      {required this.child,
      this.backgroundColor,
      Key? key,
      this.floatingActionButton,
      this.floatingActionButtonLocation})
      : super(key: key);
  final Widget child;
  final Color? backgroundColor;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  @override
  State<ParentPageWithNav> createState() => _ParentPageWithNavState();
}

class _ParentPageWithNavState extends State<ParentPageWithNav> with TickerProviderStateMixin {
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
    super.initState();
    activeAnimation = 'Idle';
    newActiveAnimation = 'Idle';
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _animationIconController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _dropAnimationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.5)
        .animate(CurvedAnimation(parent: _animationController!, curve: Curves.easeIn));
    _pulseDropAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _dropAnimationController!, curve: Curves.easeIn));

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
    double WIDTH = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        print('Working!!!');
        if (HomeController.to.isMenuOpen.value) {
          HomeController.to.changeMenuOpenActivity();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: widget.backgroundColor ?? const Color(0xffF9FCFF),
        body: Stack(
          key: parentKeyForLiveSearch,
          children: [
            widget.child,

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
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(40)).copyWith(
                        topRight: Radius.circular(40),
                        bottomRight: Radius.circular(leftMenuPosition == 60 || _isLeftDone ? 40 : 10),
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
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(40)).copyWith(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(leftMenuPosition == 60 || _isLeftDone ? 40 : 10),
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
                              bottomRight: Radius.circular(leftMenuPosition == 60 || _isMiddleDone ? 40 : 10),
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
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(40)).copyWith(
                            topLeft: Radius.circular(40),
                            bottomLeft: Radius.circular(leftMenuPosition == 60 || _isMiddleDone ? 40 : 10),
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

            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    HP.MenuItem(
                      menuName: 'Home',
                      isActive: false,
                      onTap: () {
                        HomeController.to.changeMenuItemActivity(MenuItemEnum.home);
                        if (HomeController.to.getMenuItemEnum == MenuItemEnum.home) {
                          Get.back();
                        }
                        if (Get.currentRoute != HomeScreen.routeName) {
                          Get.offAllNamed(HomeScreen.routeName);
                        }
                      },
                    ),
                    HP.MenuItem(
                      isActive: false,
                      menuName: 'Services',
                      onTap: () {
                        HomeController.to.changeMenuItemActivity(MenuItemEnum.services);
                        if (HomeController.to.getMenuItemEnum == MenuItemEnum.services) {
                          Get.back();
                        }
                        if (Get.currentRoute != HomeScreen.routeName) {
                          Get.offAllNamed(HomeScreen.routeName);
                        }
                      },
                    ),
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
                    HP.MenuItem(
                      isActive: false,
                      menuName: 'Orders',
                      onTap: () {
                        HomeController.to.changeMenuItemActivity(MenuItemEnum.orders);
                        if (HomeController.to.getMenuItemEnum == MenuItemEnum.orders) {
                          Get.back();
                        }
                        if (Get.currentRoute != HomeScreen.routeName) {
                          Get.offAllNamed(HomeScreen.routeName);
                        }
                      },
                    ),
                    HP.MenuItem(
                      isActive: false,
                      menuName: 'Profile',
                      onTap: () {

                        HomeController.to.changeMenuItemActivity(MenuItemEnum.profile);
                        if (HomeController.to.getMenuItemEnum == MenuItemEnum.profile) {
                          Get.back();
                        }
                        if (Get.currentRoute != HomeScreen.routeName) {
                          Get.offAllNamed(HomeScreen.routeName);
                        }
                      },
                    ),
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
              () => (!(HomeController.to.getMenuItemEnum == MenuItemEnum.profile ||
                          HomeController.to.getMenuItemEnum == MenuItemEnum.orders)) &&
                      HomeController.to.search.value.isNotEmpty
                  ? const HomeSearchBar()
                  : const SizedBox(),
            ),
            const HP.SideMenuBar(),
            Obx(
              () => (HealthCareController.to.confirmOrderStatus.value ||
                          MedicineController.to.confirmOrderStatus.value ||
                          PrescriptionController.to.confirmOrderStatus.value) &&
                      AuthController.to.isLoggedIn
                  ? DraggableFloatingActionButton(
                      initialOffset: Offset(Get.width - 80, Get.height - 160),
                      parentKey: parentKeyForLiveSearch,
                      onPressed: () {
                        if (HealthCareController.to.confirmOrderStatus.value) {
                          HomeController.to.liveSearchType(LiveSearchType.healthcare);

                        } else if (PrescriptionController.to.confirmOrderStatus.value) {
                          HomeController.to.liveSearchType(LiveSearchType.prescription);
                        } else {
                          HomeController.to.liveSearchType(LiveSearchType.medicine);
                        }
                        if(AuthController.to.deliverymanId.value.isEmpty){
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
                  : const SizedBox(),
            ),
          ],
        ),
        floatingActionButton: widget.floatingActionButton,
        floatingActionButtonLocation: widget.floatingActionButtonLocation,
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
