import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shebaone/controllers/auth_controller.dart';
import 'package:shebaone/controllers/home_controller.dart';
import 'package:shebaone/controllers/prescription_controller.dart';
import 'package:shebaone/controllers/user_controller.dart';
import 'package:shebaone/pages/cart/ui/billing_screen.dart';
import 'package:shebaone/services/enums.dart';
import 'package:shebaone/utils/constants.dart';
import 'package:shebaone/utils/get_dialogs.dart';
import 'package:shebaone/utils/global.dart';
import 'package:shebaone/utils/widgets/common_widget.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class PrescriptionLiveMapPage extends StatefulWidget {
  const PrescriptionLiveMapPage({Key? key}) : super(key: key);
  static String routeName = '/LiveMapPage';

  @override
  State<PrescriptionLiveMapPage> createState() => _PrescriptionLiveMapPageState();
}

class _PrescriptionLiveMapPageState extends State<PrescriptionLiveMapPage> {
  GoogleMapController? _controller;
  Location? _location = Location();
  bool _isRepeatSearchDone = false;
  bool isFirstLoadingDone = false;
  int _listenFromMedicine = 0;
  int _searchCount = 0;
  Marker? userMarker;
  // created empty list of markers
  final List<Marker> _markers = <Marker>[];

  loadData() async {
    for (var element in PrescriptionController.to.pharmacyList) {
      if (element.id == PrescriptionController.to.confirmationPharmacyData['pharmacy_id']) {
        final markerData = Marker(
          // given marker id
          markerId: const MarkerId('pharmacy-marker'),
          // given marker icon
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
          // given position
          position: LatLng(double.parse(element.latitude!), double.parse(element.longitude!)),
          infoWindow: InfoWindow(
            // given title for marker
            title: 'Location: ${element.pharmacyName}',
          ),
        );
        _markers.add(markerData);
        setState(() {});
        PrescriptionController.to.setPharmacyMarkerLocalStorage(
            pharmacyLat: double.parse(element.latitude!),
            pharmacyLon: double.parse(element.longitude!),
            pharmacyName: element.pharmacyName!);
        // PrescriptionController.to.pharmacyMarker(markerData);
      }
    }
  }

  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    globalLogger.d(AuthController.to.deliverymanId.value, "Auth Delivery");
    final info = PrescriptionController.to.getMarkerData();
    PolylinePoints polylinePoints = PolylinePoints();
    if (HomeController.to.deliveryStatus.value == DeliveryStatus.none ||
        HomeController.to.deliveryStatus.value == DeliveryStatus.accepted) {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        mapApiKey, // Your Google Map Key
        PointLatLng(info['user-marker']['lat'], info['user-marker']['lon']),
        PointLatLng(info['pharmacy-marker']['lat'], info['pharmacy-marker']['lon']),
      );

      polylineCoordinates.clear();
      if (result.points.isNotEmpty) {
        for (var point in result.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        setState(() {});
      }
    }
    if (AuthController.to.deliverymanId.value.isNotEmpty) {
      if (HomeController.to.deliveryStatus.value == DeliveryStatus.pickedUp) {
        polylineCoordinates.clear();
      }
      PolylineResult result2 = await polylinePoints.getRouteBetweenCoordinates(
        mapApiKey, // Your Google Map Key
        HomeController.to.deliveryStatus.value == DeliveryStatus.pickedUp
            ? PointLatLng(info['user-marker']['lat'], info['user-marker']['lon'])
            : PointLatLng(info['pharmacy-marker']['lat'], info['pharmacy-marker']['lon']),
        PointLatLng(AuthController.to.getDeliveryManPosition['lat'], AuthController.to.getDeliveryManPosition['lon']),
      );
      if (result2.points.isNotEmpty) {
        for (var point in result2.points) {
          polylineCoordinates.add(
            LatLng(point.latitude, point.longitude),
          );
        }
        setState(() {});
      }
    }
  }

  Set<Circle>? circles;
  LatLng? _position;
  StreamSubscription<LocationData>? locationSubscription;
  void _onMapCreated(GoogleMapController cntlr, LatLng position) {
    _controller = cntlr;
    _controller!.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: position, zoom: 14)));
    setState(() {});
  }

  final LatLng _initialCameraPosition = LatLng(
    HomeController.to.userPosition['lat'] ?? 23.721194,
    HomeController.to.userPosition['lon'] ?? 90.234722,
  );
  bool isFirstTime = true;
  bool isFirstPolyCall = true;
  bool isEmitFirstTime = true;
  Map<String, dynamic>? pharmacyConfirmationData;

  int _start = LIVE_SEARCH_TIME;

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  @override
  void initState() {
    globalLogger.d('Called');
    if (PrescriptionController.to.confirmOrderStatus.value) {
      _location = Location();
      final info = PrescriptionController.to.getMarkerData();
      locationSubscription = _location?.onLocationChanged.listen((loc) {
        if (HomeController.to.deliveryStatus.value == DeliveryStatus.delivered) {
          PrescriptionController.to.removeLiveSearchInfo();
          HomeController.to.deliveryStatus(DeliveryStatus.none);
          Get.back();
        } else if (HomeController.to.deliveryStatus.value == DeliveryStatus.cancelled) {
          bool isExist = false;
          dynamic markerData;
          for (var data in _markers) {
            if (data.markerId.value == AuthController.to.deliverymanId.value) {
              isExist = true;
              markerData = data;
            }
          }
          if (isExist) {
            _markers.remove(markerData);
          }
          HomeController.to.deliveryStatus(DeliveryStatus.none);
          Get.back();
        }
        _position = LatLng(info['user-marker']['lat'], info['user-marker']['lon']);

        if (HomeController.to.deliveryStatus.value == DeliveryStatus.none ||
            HomeController.to.deliveryStatus.value == DeliveryStatus.accepted) {
          final pharmacyMarkerData = Marker(
            // given marker id
            markerId: MarkerId(info['pharmacy-marker']['id']),
            // given marker icon
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
            // given position
            position: LatLng(info['pharmacy-marker']['lat'], info['pharmacy-marker']['lon']),
            infoWindow: InfoWindow(
              // given title for marker
              title: info['pharmacy-marker']['title'],
            ),
          );
          _markers.add(pharmacyMarkerData);
        } else {
          bool isExist = false;
          dynamic markerData;
          for (var data in _markers) {
            if (data.markerId.value == info['pharmacy-marker']['id']) {
              isExist = true;
              markerData = data;
            }
          }
          if (isExist) {
            _markers.remove(markerData);
          }
        }
        if (HomeController.to.deliveryStatus.value != DeliveryStatus.cancelled &&
            AuthController.to.deliverymanId.value.isNotEmpty) {
          PrescriptionController.to.getTime();

          final deliverymanMarkerData = Marker(
            // given marker id
            markerId: MarkerId(AuthController.to.deliverymanId.value),
            // given marker icon
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            // given position
            position: LatLng(
                AuthController.to.getDeliveryManPosition['lat'], AuthController.to.getDeliveryManPosition['lon']),
            infoWindow: const InfoWindow(
              // given title for marker
              title: 'Location: Deliveryman',
            ),
          );
          _markers.add(deliverymanMarkerData);
        }
        globalLogger.d(_markers.map((e) => e.toJson()), 'Marker Data Delivery');
        setState(() {});
        getPolyPoints();
      });
    } else {
      startTimer();
      initSocket();
      circles = {
        Circle(
          circleId: const CircleId('id'),
          center: const LatLng(20.42796133580664, 80.885749655962),
          radius: 1000,
          strokeWidth: 1,
          strokeColor: kPrimaryColor.withOpacity(.5),
          fillColor: kPrimaryColor.withOpacity(.2),
        )
      };

      locationSubscription = _location?.onLocationChanged.listen((loc) async {
        setState(() {
          _position = LatLng(loc.latitude!, loc.longitude!);
        });

        // globalLogger.d(_position);
        if (PrescriptionController.to.confirmOrderStatus.value && isFirstPolyCall) {
          globalLogger.d('ASCE');
          globalLogger.d(PrescriptionController.to.prescriptionLiveSearchLoading.value &&
              !PrescriptionController.to.confirmOrderStatus.value);
          getPolyPoints();
          isFirstPolyCall = false;
          circles = {};
          setState(() {});
          PrescriptionController.to.getTime();
        }

        if (PrescriptionController.to.timerStatus.value) {
          if (timer != null && timer!.isActive) {
            timer!.cancel();
          }
          _start = PrescriptionController.to.time.value;
          setState(() {});
        }

        if (isFirstTime) {
          circles = {
            Circle(
                circleId: const CircleId('id'),
                center: _position!,
                radius: 1000,
                strokeWidth: 1,
                strokeColor: kPrimaryColor.withOpacity(.5),
                fillColor: kPrimaryColor.withOpacity(.2))
          };
          PrescriptionController.to
              .setUserMarkerLocalStorage(userLat: _position!.latitude, userLon: _position!.longitude);
          userMarker = Marker(
            // given marker id
            markerId: const MarkerId('user-marker'),
            // given marker icon
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
            // given position
            position: _position!,
            infoWindow: const InfoWindow(
              // given title for marker
              title: 'Location: My Location',
            ),
          );
          // PrescriptionController.to.userMarker(userMarker);
          await PrescriptionController.to.getPharmacyListForLiveSearch(
              {'latitude': loc.latitude!.toString(), 'longitude': loc.longitude!.toString(), 'distance': '1'});
          isFirstTime = false;
          _searchCount++;
          setState(() {});
        }
        if (socket.connected && PrescriptionController.to.processPharmacyDataList.isNotEmpty && isEmitFirstTime) {
          // globalLogger.d(PrescriptionController.to.processPharmacyDataList);
          socket.emit('sendChatToServer', [PrescriptionController.to.processPharmacyDataList]);
          isEmitFirstTime = false;
          setState(() {});
        }
        if ((_listenFromMedicine > 0 || _searchCount == 2) && _start == 0) {
          Get.back();
        }
        if (_listenFromMedicine == 0 && _start == 0 && _searchCount == 1) {
          if (timer != null && timer!.isActive) {
            timer!.cancel();
          }
          _start = 30;
          isFirstLoadingDone = true;
          setState(() {});
          PrescriptionController.to.prescriptionLiveSearchLoading(false);
          startTimer();
          Future.delayed(const Duration(seconds: 30), () {
            if (!_isRepeatSearchDone) {
              Get.back();
            }
          });
        }
        // if (_listenFromMedicine == 0 && _start == 0 && _searchCount == 1) {
        //   _searchCount++;
        //   _start = LIVE_SEARCH_TIME;
        //   setState(() {});
        //   PrescriptionController.to.getPharmacyListForLiveSearch({
        //     'latitude': loc.latitude!.toString(),
        //     'longitude': loc.longitude!.toString(),
        //     'distance': '2'
        //   }).then((_) {
        //     if (socket.connected &&
        //         PrescriptionController.to.processPharmacyDataList.isNotEmpty) {
        //       // globalLogger.d(PrescriptionController.to.processPharmacyDataList);
        //       socket.emit('sendChatToServerMedicine',
        //           [PrescriptionController.to.processPharmacyDataList]);
        //       circles = {
        //         Circle(
        //             circleId: const CircleId('id'),
        //             center: _position!,
        //             radius: 2000,
        //             strokeWidth: 1,
        //             strokeColor: kPrimaryColor.withOpacity(.5),
        //             fillColor: kPrimaryColor.withOpacity(.2))
        //       };
        //
        //       setState(() {});
        //     }
        //   });
        //   startTimer();
        // }
      });
    }
    super.initState();
  }

  ///Initialization Socket
  initSocket() {
    globalLogger.d('Init Socket Enter');
    // globalLogger.d(socket!.id, 'Socket Var');
    socket.onConnect((_) {
      globalLogger.d('Connection Socket');

      socket.on('sendChatToPharmacy', (newMessage) {
        globalLogger.d('medicine data', 'Send To Pharmacy');
      });
      socket.on('sendChatToClient', (newMessage) {
        globalLogger.d(newMessage, 'Raw');
        globalLogger.d(
            UserController.to.getUserInfo.id, newMessage['first_msg']['user_id'] == UserController.to.getUserInfo.id);
        if (newMessage['first_msg']['user_id'] == UserController.to.getUserInfo.id) {
          PrescriptionController.to.setConfirmPharmacyData(newMessage);
          PrescriptionController.to.prescriptionLiveSearchLoading(false);
          // pharmacyConfirmationData = newMessage;
          // setState(() {});
          globalLogger.d('Confirmation From Pharmacy', 'Processing');
          _start = AFTER_PHARMACY_CONFIRMATION_LIVE_SEARCH_TIME;
          _listenFromMedicine++;
          setState(() {});
          globalLogger.d(_start);

          loadData();
        } else {
          globalLogger.d('This user is not authenticate for this data listen!', 'Authenticate Message');
        }
      });
      socket.on('sendConfirmationToPharmacy', (newMessage) {
        globalLogger.d('Confirmation From User', 'Send for Pharmacy');
      });
    });
    socket.connect();
    socket.onDisconnect((_) => globalLogger.d('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  @override
  void dispose() {
    if (locationSubscription != null) {
      locationSubscription!.cancel();
    }
    PrescriptionController.to.prescriptionLiveSearchLoading(true);
    // PrescriptionController.to.confirmationPharmacyData({});
    if (timer != null && timer!.isActive) {
      timer!.cancel();
    }
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  sendMessage() {
    // globalLogger.d(PrescriptionController.to.processPharmacyDataList[0]);
    // Map<String, dynamic> messageMap =
    //     PrescriptionController.to.processPharmacyDataList[0];
    if (socket.connected) {
      globalLogger.d(PrescriptionController.to.processPharmacyDataList);
      socket.emit('sendChatToServerMedicine', [PrescriptionController.to.processPharmacyDataList]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Container(
          height: Get.height,
          width: Get.width,
          color: PrescriptionController.to.prescriptionLiveSearchLoading.value &&
                  !PrescriptionController.to.confirmOrderStatus.value
              ? const Color(0xff005C1A)
              : Colors.white,
          child: Column(
            children: [
              PrescriptionController.to.prescriptionLiveSearchLoading.value &&
                      !PrescriptionController.to.confirmOrderStatus.value
                  ? SizedBox(
                      height: MediaQuery.of(context).padding.top + kToolbarHeight,
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                getSimpleDialog(
                                  'Alert Message!',
                                  'For another live search order request , you will have to wait for at least 02 Minutes',
                                  contentColor: Colors.red,
                                  contentFontWeight: FontWeight.bold,
                                );
                              },
                              child: const SizedBox(
                                width: 60,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const Text(
                              'Live Search Products',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(
                              width: 60,
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: MediaQuery.of(context).padding.top,
                      width: Get.width,
                      color: Colors.white,
                    ),
              Stack(
                children: [
                  SizedBox(
                    height: PrescriptionController.to.prescriptionLiveSearchLoading.value &&
                            !PrescriptionController.to.confirmOrderStatus.value
                        ? Get.height - (MediaQuery.of(context).padding.top + kToolbarHeight + Get.height * .4)
                        : PrescriptionController.to.confirmOrderStatus.value
                            ? Get.height - (MediaQuery.of(context).padding.top + kToolbarHeight + Get.height * .2)
                            : Get.height - (MediaQuery.of(context).padding.top + kToolbarHeight + Get.height * .4),
                    width: Get.width,
                    child: ClipRRect(
                      borderRadius: PrescriptionController.to.prescriptionLiveSearchLoading.value &&
                              !PrescriptionController.to.confirmOrderStatus.value
                          ? const BorderRadius.vertical(
                              top: Radius.circular(25),
                            )
                          : BorderRadius.circular(0),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        markers: Set<Marker>.of(_markers),
                        initialCameraPosition: CameraPosition(target: _initialCameraPosition),
                        onMapCreated: (GoogleMapController controller) {
                          _onMapCreated(
                              controller,
                              (_position != null
                                  ? _position!
                                  : LatLng(
                                      HomeController.to.userPosition['lat'], HomeController.to.userPosition['lon'])));
                        },
                        polylines: {
                          Polyline(
                            polylineId: const PolylineId("route-pharmacy"),
                            points: polylineCoordinates,
                            color: kPrimaryColor,
                            width: 2,
                          ),
                        },
                        onCameraMove: (pos) {},
                        // onCameraIdle: () {
                        //   globalLogger.d("Worked Idel");
                        //   _controller!.animateCamera(
                        //       CameraUpdate.newLatLngZoom(_position!, 14));
                        // },
                        circles: circles == null ? {} : circles!,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      height: 10,
                      width: Get.width,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (!PrescriptionController.to.prescriptionLiveSearchLoading.value)
                    Positioned(
                      top: 0,
                      left: 0,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const SizedBox(
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    height: PrescriptionController.to.prescriptionLiveSearchLoading.value &&
                            !PrescriptionController.to.confirmOrderStatus.value
                        ? Get.height * .4
                        : PrescriptionController.to.confirmOrderStatus.value
                            ? (Get.height * .2) + kToolbarHeight
                            : (Get.height * .4) + kToolbarHeight,
                    width: Get.width,
                    color: Colors.white,
                    child: PrescriptionController.to.prescriptionLiveSearchLoading.value &&
                            !PrescriptionController.to.confirmOrderStatus.value
                        ? Column(
                            children: [
                              space5C,
                              Image.asset(
                                'assets/icons/loading.gif',
                                height: Get.height * .15,
                                width: Get.height * .15,
                              ),
                              space2C,
                              const TitleText(
                                title: 'Please wait...',
                                fontSize: 16,
                              ),
                              space2C,
                              const TitleText(
                                title: 'We will notify you once product is found',
                                fontSize: 12,
                              ),
                            ],
                          )
                        : _listenFromMedicine == 0 && _searchCount == 1
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          TitleText(
                                            title: 'Search Result',
                                            fontSize: 16,
                                            color: kTextColor,
                                          ),
                                          const HorizontalDivider(
                                            color: Color(0xff4A8B5C),
                                            thickness: .5,
                                          ),
                                          space1C,
                                          TitleText(
                                            title: 'Not Available Medicines (0)',
                                            fontSize: 12,
                                            color: kTextColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          space1C,
                                          SizedBox(
                                            height: (Get.height * .2) - 6,
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              itemCount: 0,
                                              itemBuilder: (_, index) {
                                                return Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    TitleText(
                                                      title: ' PrescriptionController.to.medicineCartList[index].name!',
                                                      fontSize: 14,
                                                      color: kTextColor,
                                                    ),
                                                    TitleText(
                                                      title:
                                                          'PrescriptionController.to.medicineCartList[index].offerPrice!',

                                                      // double.parse(PrescriptionController
                                                      //     .to
                                                      //     .confirmationPharmacyData[
                                                      // 'unavailable'][index]
                                                      // [
                                                      // 'sell_price'])
                                                      //     .toStringAsFixed(
                                                      //     2),
                                                      fontSize: 14,
                                                      color: kTextColor,
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                          // Row(
                                          // mainAxisAlignment:
                                          // MainAxisAlignment.spaceBetween,
                                          // children: [
                                          // Expanded(
                                          // child: TitleText(
                                          // title: HealthCareController
                                          //     .to
                                          //     .getSingleProductInfo
                                          //     .name!,
                                          // fontSize: 14,
                                          // color: kTextColor,
                                          // maxLines: 2,
                                          // ),
                                          // ),
                                          // space4R,
                                          // TitleText(
                                          // title: double.parse(
                                          // HealthCareController
                                          //     .to
                                          //     .getSingleProductInfo
                                          //     .offerPrice!)
                                          //     .toStringAsFixed(2),
                                          // fontSize: 14,
                                          // color: kTextColor,
                                          // ),
                                          // ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(
                                          flex: 1,
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: PrimaryButton(
                                            height: 36,
                                            marginVertical: 8,
                                            marginHorizontal: 0,
                                            label: 'Repeat Search',
                                            contentPadding: 0,
                                            fontSize: 12,
                                            onPressed: () async {
                                              _searchCount++;
                                              _start = LIVE_SEARCH_TIME;

                                              PrescriptionController.to.prescriptionLiveSearchLoading(true);
                                              await PrescriptionController.to.getPharmacyListForLiveSearch({
                                                'latitude': _position!.latitude.toString(),
                                                'longitude': _position!.longitude.toString(),
                                                'distance': '2'
                                              });
                                              if (socket.connected &&
                                                  PrescriptionController.to.processPharmacyDataList.isNotEmpty) {
                                                // globalLogger.d(HealthCareController.to.processPharmacyDataList);
                                                socket.emit('sendChatToServerHealthcare',
                                                    [PrescriptionController.to.processPharmacyDataList]);
                                                circles = {
                                                  Circle(
                                                      circleId: const CircleId('id'),
                                                      center: _position!,
                                                      radius: 2000,
                                                      strokeWidth: 1,
                                                      strokeColor: kPrimaryColor.withOpacity(.5),
                                                      fillColor: kPrimaryColor.withOpacity(.2))
                                                };
                                              }
                                              _isRepeatSearchDone = true;
                                              isFirstLoadingDone = false;
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                        const Spacer(
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : PrescriptionController.to.confirmOrderStatus.value
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(top: 8),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Status: ',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: HomeController.to.deliveryStatus.value == DeliveryStatus.none
                                                    ? "Order is Waiting For Rider"
                                                    : HomeController.to.deliveryStatus.value == DeliveryStatus.accepted
                                                        ? "Order is Waiting For Picked Up"
                                                        : HomeController.to.deliveryStatus.value ==
                                                                DeliveryStatus.pickedUp
                                                            ? "Order is Picked Up by Rider"
                                                            : HomeController.to.deliveryStatus.value ==
                                                                    DeliveryStatus.cancelled
                                                                ? "Order is Cancelled by Rider"
                                                                : HomeController.to.deliveryStatus.value ==
                                                                        DeliveryStatus.delivered
                                                                    ? "Order is Delivered by Rider"
                                                                    : "",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'Order ID: ',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: PrescriptionController.to.orderSuccessData['order_id'] ?? '-',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 24.0).copyWith(bottom: 16.0),
                                        child: RichText(
                                          text: TextSpan(
                                            text:
                                                '${PrescriptionController.to.confirmationPharmacyData['available'] == null ? 0 : PrescriptionController.to.confirmationPharmacyData['available'].length} products from: ',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: PrescriptionController
                                                        .to.confirmationPharmacyData['pharmacy_name'] ??
                                                    '-',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const HorizontalDivider(
                                        color: Color(0xff4A8B5C),
                                        thickness: .5,
                                        horizontalMargin: 16,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                TitleText(
                                                  title: 'Distance',
                                                  fontSize: 16,
                                                  color: kTextColor,
                                                ),
                                                Obx(
                                                  () => TitleText(
                                                    title:
                                                        '${PrescriptionController.to.calculateDistance().toStringAsFixed(2)} Km',
                                                    fontSize: 20,
                                                    color: kTextColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            height: 40,
                                            width: 1,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xff4A8B5C),
                                                width: .25,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                TitleText(
                                                  title: 'Estimate Time',
                                                  fontSize: 16,
                                                  color: kTextColor,
                                                ),
                                                Obx(
                                                  () => TitleText(
                                                    title: AuthController.to.deliverymanId.value.isNotEmpty
                                                        ? PrescriptionController.to.distanceTime.value.toString()
                                                        : '30 mins',
                                                    fontSize: 20,
                                                    color: kTextColor,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              TitleText(
                                                title: 'Search Result',
                                                fontSize: 16,
                                                color: kTextColor,
                                              ),
                                              const HorizontalDivider(
                                                color: Color(0xff4A8B5C),
                                                thickness: .5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  TitleText(
                                                    title: PrescriptionController
                                                        .to.confirmationPharmacyData['pharmacy_name'],
                                                    fontSize: 16,
                                                    color: kTextColor,
                                                  ),
                                                  Row(
                                                    children: [
                                                      TitleText(
                                                        title: 'Review',
                                                        fontSize: 12,
                                                        color: kTextColor,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: Color(0xffFFA873),
                                                            size: 14,
                                                          ),
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: Color(0xffFFA873),
                                                            size: 14,
                                                          ),
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: Color(0xffFFA873),
                                                            size: 14,
                                                          ),
                                                          const Icon(
                                                            Icons.star_rounded,
                                                            color: Color(0xffFFA873),
                                                            size: 14,
                                                          ),
                                                          Icon(
                                                            Icons.star_rounded,
                                                            color: kTextColorLite,
                                                            size: 14,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  TitleText(
                                                    title: 'License No: ',
                                                    fontSize: 12,
                                                    color: kTextColor,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  Obx(() {
                                                    String data = '';
                                                    for (var element in PrescriptionController.to.pharmacyList) {
                                                      if (element.id ==
                                                          PrescriptionController
                                                              .to.confirmationPharmacyData['pharmacy_id']) {
                                                        data = element.drugLicenseNo!;
                                                      }
                                                    }
                                                    return TitleText(
                                                      title: data,
                                                      fontSize: 12,
                                                      color: kTextColor,
                                                    );
                                                  }),
                                                ],
                                              ),
                                              space1C,
                                              TitleText(
                                                title:
                                                    'Available Medicines (${PrescriptionController.to.confirmationPharmacyData['available'].length})',
                                                fontSize: 12,
                                                color: kTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              space1C,
                                              SizedBox(
                                                height: (Get.height * .1) - 3,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: PrescriptionController
                                                      .to.confirmationPharmacyData['available'].length,
                                                  itemBuilder: (_, index) {
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        TitleText(
                                                          title: PrescriptionController
                                                              .to.confirmationPharmacyData['available'][index]['name'],
                                                          fontSize: 14,
                                                          color: kTextColor,
                                                        ),
                                                        TitleText(
                                                          title: double.parse(PrescriptionController
                                                                  .to
                                                                  .confirmationPharmacyData['available'][index]
                                                                      ['sell_price']
                                                                  .toString())
                                                              .toStringAsFixed(2),
                                                          fontSize: 14,
                                                          color: kTextColor,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                              const HorizontalDivider(
                                                color: Color(0xff4A8B5C),
                                                thickness: .5,
                                              ),
                                              TitleText(
                                                title:
                                                    'Not Available Medicines (${PrescriptionController.to.confirmationPharmacyData['unavailable'].length})',
                                                fontSize: 12,
                                                color: kTextColor,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              space1C,
                                              SizedBox(
                                                height: (Get.height * .1) - 3,
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  itemCount: PrescriptionController
                                                      .to.confirmationPharmacyData['unavailable'].length,
                                                  itemBuilder: (_, index) {
                                                    return Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        TitleText(
                                                          title: PrescriptionController.to
                                                              .confirmationPharmacyData['unavailable'][index]['name'],
                                                          fontSize: 14,
                                                          color: kTextColor,
                                                        ),
                                                        TitleText(
                                                          title: double.parse(PrescriptionController
                                                                      .to.confirmationPharmacyData['unavailable'][index]
                                                                  ['sell_price'])
                                                              .toStringAsFixed(2),
                                                          fontSize: 14,
                                                          color: kTextColor,
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (!_isRepeatSearchDone)
                                              Expanded(
                                                flex: 1,
                                                child: PrimaryButton(
                                                  height: 36,
                                                  marginVertical: 8,
                                                  marginHorizontal: 0,
                                                  label: 'Repeat Search',
                                                  contentPadding: 0,
                                                  fontSize: 12,
                                                  onPressed: () async {
                                                    PrescriptionController.to.prescriptionLiveSearchLoading(true);
                                                    await PrescriptionController.to.getPharmacyListForLiveSearch({
                                                      'latitude': _position!.latitude.toString(),
                                                      'longitude': _position!.longitude.toString(),
                                                      'distance': '2'
                                                    });

                                                    socket.emit('sendChatToServerMedicine',
                                                        [PrescriptionController.to.processPharmacyDataList]);
                                                    _isRepeatSearchDone = true;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                            if (!_isRepeatSearchDone) space5R,
                                            if (_isRepeatSearchDone)
                                              const Spacer(
                                                flex: 1,
                                              ),
                                            Expanded(
                                              flex: _isRepeatSearchDone ? 2 : 1,
                                              child: PrimaryButton(
                                                height: 36,
                                                marginVertical: 8,
                                                marginHorizontal: 0,
                                                label: 'Confirm & Checkout',
                                                contentPadding: 0,
                                                fontSize: 12,
                                                onPressed: () async {
                                                  PrescriptionController.to.timerStatus(true);
                                                  PrescriptionController.to.time(_start);
                                                  PrescriptionController.to.prescriptionLiveSearchLoading(false);
                                                  final data = await Get.toNamed(BillingScreen.routeName,
                                                      arguments: {'from': 'Medicine'});

                                                  if (data == null) {
                                                    PrescriptionController.to.timerStatus(false);

                                                    startTimer();
                                                  }
                                                },
                                              ),
                                            ),
                                            if (_isRepeatSearchDone)
                                              const Spacer(
                                                flex: 1,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                  ),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: !PrescriptionController.to.confirmOrderStatus.value ? Text("$_start (s)") : const SizedBox(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
