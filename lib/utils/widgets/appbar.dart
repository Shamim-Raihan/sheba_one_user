import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shebaone/controllers/doctor_appointment_controller.dart';
import 'package:shebaone/controllers/doctor_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/lab_controller.dart';
import 'package:shebaone/pages/cart/ui/healthcare_live_cart_screen.dart';
import 'package:shebaone/pages/doctor/ui/doctor_filter_screen.dart';
import 'package:shebaone/pages/search/ui/lab_search_screen.dart';
import 'package:shebaone/pages/search/ui/search_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';

import '../../controllers/fitness_appointment_controller.dart';
import '../../controllers/fitness_controller.dart';
import '../../pages/fitness/ui/fitness_filter_screen.dart';

class AppBarWithSearch extends StatelessWidget {
  const AppBarWithSearch({
    this.title,
    this.isSearchShow = true,
    this.isBarShow = true,
    this.hasStyle = true,
    this.hasBackArrow = false,
    this.withLocation = true,
    required this.moduleSearch,
    this.onCartTapped,
    Key? key,
  }) : super(key: key);
  final Widget? title;
  final bool isSearchShow;
  final bool isBarShow;
  final bool hasStyle;
  final bool hasBackArrow;
  final bool withLocation;
  final ModuleSearch moduleSearch;
  final Function()? onCartTapped;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        image: DecorationImage(
          alignment: Alignment.topCenter,
          fit: BoxFit.fill,
          image: AssetImage(
              'assets/images/${hasStyle ? 'dashboard-appbar-bg' : 'appbar-bg'}.png'),
        ),
      ),
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).padding.top,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    hasBackArrow
                        ? Get.back()
                        : HomeController.to.changeMenuOpenActivity();
                  },
                  child: hasBackArrow
                      ? const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        )
                      : Image.asset(
                          'assets/icons/menu.png',
                          height: 20,
                        ),
                ),
                title == null
                    ? Image.asset(
                        'assets/images/logo.png',
                        height: 40,
                      )
                    : SizedBox(
                        height: 40,
                        child: Center(child: title!
                            // TitleText(
                            //   title: title!,
                            //   fontSize: 18,
                            //   color: Colors.white,
                            // ),
                            ),
                      ),
                GestureDetector(
                  onTap: onCartTapped ??
                      () {
                        // Get.toNamed(HealthcareCartScreen.routeName);
                        Get.toNamed(HealthcareLiveCartScreen.routeName);
                      },
                  child: Stack(
                    children: [
                      Image.asset(
                        'assets/icons/cart.png',
                        height: 22,
                      ),
                      // Positioned(
                      //   right: 0,
                      //   top: 0,
                      //   child: Container(
                      //     height: 10,
                      //     width: 10,
                      //     padding: const EdgeInsets.all(1),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(100),
                      //       color: Color(0xffE72545),
                      //     ),
                      //     child: Center(
                      //       child: Text(
                      //         '0',
                      //         style: TextStyle(
                      //           fontSize: 9,
                      //           height: 1.08,
                      //           color: Colors.white,
                      //           fontWeight: FontWeight.w600,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          space2C,
          isBarShow
              ? const HorizontalDivider(
                  height: 1,
                  color: Colors.white,
                )
              : const SizedBox(),
          space2C,
          isSearchShow
              ? AppBarSearch(
                  withLocation: withLocation, moduleSearch: moduleSearch)
              : const SizedBox(),
          space2C,
        ],
      ),
    );
  }
}

class AppBarSearch extends StatefulWidget {
  const AppBarSearch({
    Key? key,
    this.withLocation = true,
    required this.moduleSearch,
  }) : super(key: key);
  final bool withLocation;
  final ModuleSearch moduleSearch;

  @override
  State<AppBarSearch> createState() => _AppBarSearchState();
}

class _AppBarSearchState extends State<AppBarSearch> {
  TextEditingController? _controller;
  FocusNode? _focusNode;
  String _selectedText = 'Dhaka';

  @override
  void initState() {
    // TODO: implement initState
    _controller = TextEditingController();
    _focusNode = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      _controller!.dispose();
    }
    if (_focusNode != null) {
      _focusNode!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (HomeController.to.getMenuItemEnum == MenuItemEnum.home &&
            HomeController.to.search.isNotEmpty) {
          _controller!.text = '';
          _focusNode!.unfocus();
          HomeController.to.search('');
          return false;
        }
        HomeController.to.search('');
        return true;
      },
      child: Row(
        children: [
          if (widget.withLocation)
            Flexible(
              flex: 3,
              child: Obx(() {
                List<String> _loc = [];
                for (var element
                    in DoctorAppointmentController.to.getDoctorCityList) {
                  _loc.add(element.city!);
                }
                return CustomDropDownMenu(
                  hasPrefixIcon: true,
                  useFittedBox: true,
                  hintText: 'Location',
                  list: _loc,
                  onChange: (val) {
                    _selectedText = val;
                    setState(() {});
                  },
                  selectedOption: _selectedText,
                );
              }),
            ),
          if (widget.withLocation) space1R,
          Flexible(
            flex: 6,
            child: CustomTextField(
              controller: _controller!,
              focusNode: _focusNode!,
              prefixIcon: Icon(
                Icons.search,
                color: kTextColorLite,
              ),
              onChanged: (val) {
                globalLogger.d(widget.moduleSearch);
                HomeController.to.moduleSearchType(widget.moduleSearch);
                HomeController.to.search(val);
                if (widget.moduleSearch == ModuleSearch.none) {
                  HomeController.to.getSearchData(val);
                }
                if (widget.moduleSearch == ModuleSearch.medicine) {
                  HomeController.to.searchListType(SearchType.medicine);
                  HomeController.to.getSearchList(val);
                } else if (widget.moduleSearch == ModuleSearch.lab) {
                  LabController.to.getSearchListByKey(val);
                } else if (widget.moduleSearch == ModuleSearch.healthcare) {
                  HomeController.to.getSearchList(val);
                } else if (widget.moduleSearch == ModuleSearch.doctor) {
                  if (!DoctorController.to.useCity.value) {
                    DoctorController.to.city(DoctorAppointmentController.to
                        .getCityId(_selectedText));
                  }

                  DoctorController.to.getDoctorSearchListByKey(val);
                } else if (widget.moduleSearch == ModuleSearch.fitness) {
                  if (!FitnessController.to.useCity.value) {
                    FitnessController.to.city(FitnessAppointmentController.to
                        .getCityId(_selectedText));
                  }

                  FitnessController.to.getDoctorSearchListByKey(val);
                }
              },
              hintText: widget.moduleSearch == ModuleSearch.medicine
                  ? 'Search for medicine'
                  : widget.moduleSearch == ModuleSearch.doctor
                      ? 'Search for doctor'
                      : widget.moduleSearch == ModuleSearch.fitness
                          ? 'Search for Fitness Center'
                          : widget.moduleSearch == ModuleSearch.lab
                              ? 'Search for lab'
                              : 'Search for product',
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(5),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(5),
              ),
            ),
            height: 38,
            width: 38,
            child: IconButton(
              color: const Color(0xff4B9C62),
              onPressed: () {
                if (_controller!.text.isNotEmpty) {
                  HomeController.to.moduleSearchType(widget.moduleSearch);
                  if (widget.moduleSearch == ModuleSearch.none) {
                    HomeController.to.getSearchList(_controller!.text);
                    Get.toNamed(SearchScreen.routeName);
                  } else if (widget.moduleSearch == ModuleSearch.healthcare) {
                    HomeController.to.searchListType(SearchType.healthcare);
                    HomeController.to.getSearchList(_controller!.text);
                    Get.toNamed(SearchScreen.routeName);
                  } else if (widget.moduleSearch == ModuleSearch.medicine) {
                    HomeController.to.searchListType(SearchType.medicine);
                    HomeController.to.getSearchList(_controller!.text);
                    Get.toNamed(SearchScreen.routeName);
                  } else if (widget.moduleSearch == ModuleSearch.doctor) {
                    if (!DoctorController.to.useCity.value) {
                      DoctorController.to.city(FitnessAppointmentController.to
                          .getCityId(_selectedText));
                    }
                    DoctorController.to.getSearchList(_controller!.text);
                    Get.toNamed(DoctorFilterScreen.routeName);
                  } else if (widget.moduleSearch == ModuleSearch.fitness) {
                    if (!FitnessController.to.useCity.value) {
                      FitnessController.to.city(FitnessAppointmentController.to
                          .getCityId(_selectedText));
                    }
                    FitnessController.to.getSearchList(_controller!.text);
                    Get.toNamed(FitnessFilterScreen.routeName);
                  } else if (widget.moduleSearch == ModuleSearch.lab) {
                    LabController.to.getSearchList(_controller!.text);
                    Get.toNamed(LabSearchScreen.routeName);
                  }
                }

                _controller!.text = '';
                HomeController.to.search('');
              },
              icon: const Icon(Icons.search),
            ),
          ),
        ],
      ),
    );
  }
}
