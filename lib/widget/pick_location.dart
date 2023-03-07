import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:geolocator/geolocator.dart';
import 'package:phone_number_otp/widget/my_address.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:geocoding/geocoding.dart';

class PickLocation extends StatefulWidget {
  const PickLocation({super.key});

  @override
  State<PickLocation> createState() => _PickLocationState();
}

class _PickLocationState extends State<PickLocation> {
  //String Address = 'search';
  CameraPosition? cameraPosition;
  //String location = "Location Name:";
  String latlong = '24.9180,67.0971';
  var markericon = BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(), 'assets/images/google-maps.png');
  final Set<Marker> markers = {}; //markers for google map
  Set<Marker> getmarkers() {
    //setState(() {
    markers.add(
      Marker(
        markerId: const MarkerId('1'),
        position: const LatLng(24.9180, 67.0971),
        infoWindow: const InfoWindow(
          title: '',
          snippet: 'Drag the marker to pick the location',
        ),
        draggable: true,
        icon: BitmapDescriptor.defaultMarker,
        onDragEnd: ((newPosition) {
          latlong =
              '${newPosition.latitude.toString().substring(0, 8)},${newPosition.longitude.toString().substring(0, 8)}';
        }),
      ),
    );
    //});
    return markers;
  }

  //Set<Marker> markers = Set();
  late GoogleMapController mapController;
  late BitmapDescriptor pinLocationIcon;
  final LatLng _center = const LatLng(24.9180, 67.0971);
  final Completer<GoogleMapController> _controller = Completer();
  String palcename='';
  MapType _currentMapType = MapType.hybrid;

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  //final List<Marker> _markers = <Marker>[]; //marker implementation
  //final List _markers = [];
  //Map<String, Marker> _markers = {};
  final List<Marker> _list = <Marker>[
    // const Marker(
    //   markerId: MarkerId('1'),
    //   position: LatLng(24.9180, 67.0971),
    //   infoWindow: InfoWindow(title: 'My position'),
    //   draggable: true,
    //   icon: BitmapDescriptor.defaultMarker,
    //   // onDragEnd: ((newPosition) {
    //   //   debugPrint(newPosition.latitude.toString().substring(0, 7));
    //   //   debugPrint(newPosition.longitude.toString().substring(0, 7));
    //   // }),
    // ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //_markers.addAll(_list);
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(), 'assets/images/google-maps.png');
  }

  // method for getting user current location
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      //print("ERROR$error");
    });
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      //forceAndroidLocationManager: true
    );
  }

  void _changeMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  // Future<void> _goToDefaultLocation() async {
  //   CameraPosition cameraPosition = CameraPosition(
  //     target: _center,
  //     zoom: 10,
  //   );
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  //   markers.clear();
  //   setState(() {
  //     //addMarker('2', _center);
  //     markers.add(Marker(
  //       markerId: MarkerId('3'),
  //       position: LatLng(24.9180, 67.0971),
  //       //infoWindow: InfoWindow(title: 'My position'),
  //       draggable: true,
  //       icon: pinLocationIcon,
  //       //BitmapDescriptor.defaultMarker,
  //     ));
  //   });
  // }

  // void _updatePosition(CameraPosition position) {
  //   Position newMarkerPosition = Position(
  //       latitude: position.target.latitude,
  //       longitude: position.target.longitude,
  //       accuracy: 25.0,
  //       altitude: 25.0,
  //       heading: 25.0,
  //       speed: 25.0,
  //       speedAccuracy: 25.0,
  //       timestamp: null);
  //   Marker marker = _list[1];

  //   setState(() {
  //     _list[1] = marker.copyWith(
  //         positionParam:
  //             LatLng(newMarkerPosition.latitude, newMarkerPosition.longitude));
  //   });
  //   print(_list[1]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'Pick Location',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Expanded( //incorrect use of parentwidget
            //   child:
            AbsorbPointer(
              absorbing: false,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 16,
                ),
                mapType: _currentMapType,
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                tiltGesturesEnabled: false,
                zoomGesturesEnabled: false,
                mapToolbarEnabled: true,
                //indoorViewEnabled: true,
                //myLocationButtonEnabled: true,
                compassEnabled: true,
                //markers: _markers.values.toSet(),
                markers: Set<Marker>.of(_list),
                //markers: getmarkers(),
              ),
            ),
            //),
            PointerInterceptor(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(
                  top: 8,
                  right: 8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //const Text('Tap the location on right and pick the location',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16),),
                        GestureDetector(
                          onTap: () {
                            getUserCurrentLocation().then((value) async {
                              // specified current users location
                              CameraPosition cameraPosition = CameraPosition(
                                target: LatLng(value.latitude, value.longitude),
                                zoom: 16,
                              );

                              final GoogleMapController controller =
                                  await _controller.future;
                              controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                      cameraPosition));
                              // Marker marker = markers.firstWhere(
                              //   (marker) => marker.markerId.value == "1",
                              // );
                              latlong =
                                  '${value.latitude.toString().substring(0, 8)},${value.longitude.toString().substring(0, 8)}';
                              // List<Placemark> placemarks =
                              //     await placemarkFromCoordinates(
                              //         value.latitude, value.longitude);
                              //         print(placemarks);
                              // palcename = "${placemarks
                              //         .first.administrativeArea}, ${placemarks.first.street}";
                              setState(() {
                                //_markers.clear();
                                _list.clear();
                                //markers.clear();
                                //markers.remove(marker);
                                // marker added for current users location
                                //addMarker('2',  LatLng(value.latitude, value.longitude));
                                _list.add(Marker(
                                  // onTap: () {
                                  //   debugPrint('Tapped');
                                  // },
                                  markerId: const MarkerId("2"),
                                  position:
                                      LatLng(value.latitude, value.longitude),
                                  infoWindow: const InfoWindow(
                                    title: 'My Current Location',
                                    snippet:
                                        'Drag the marker to pick the location',
                                  ),
                                  draggable: true,
                                  icon: pinLocationIcon,
                                  //BitmapDescriptor.defaultMarker,
                                  onDragEnd: ((newPosition) {
                                    setState(() {
                                      latlong =
                                          '${newPosition.latitude.toString().substring(0, 8)},${newPosition.longitude.toString().substring(0, 8)}';
                                      //debugPrint(latlong);
                                    });
                                  }),
                                ));
                                //_list.remove(marker);
                                //_list.removeWhere((key, marker) => marker.markerId.value == "1");
                              });
                            });
                          },
                          child: Card(
                            color: Colors.grey.shade300,
                            shape: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            child: const SizedBox(
                                // height: 40,
                                // width: 40,
                                height: 50,
                                width: 50,
                                child: Center(
                                    child: Text(
                                  'TAP',
                                  style: TextStyle(fontSize: 22),
                                ))
                                // Icon(
                                //   Icons.my_location_sharp,
                                //   color: Colors.grey.shade600,
                                //   size: 22,
                                // ),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 295, top: 2),
                      height: 50,
                      child: FloatingActionButton(
                        onPressed: _changeMapType,
                        backgroundColor: Colors.blue.shade800,
                        child: const Icon(
                          Icons.map,
                          size: 30.0,
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Container(
                    //   margin: const EdgeInsets.only(left: 295, top: 2),
                    //   height: 50,
                    //   child: FloatingActionButton(
                    //     onPressed: _goToDefaultLocation,
                    //     backgroundColor: Colors.blue.shade800,
                    //     child: const Icon(
                    //       Icons.home_rounded,
                    //       size: 30.0,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(
                      height: 350,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (latlong == '24.9180,67.0971') {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Pick Location Alert!'),
                                content: const Text(
                                    "Kindly tap the location then press the pick button."),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PickLocation(),
                                        ),
                                      );
                                    },
                                    child: const Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MyAddress(latlong),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: const Text(
                        'PICK LOCATION',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
