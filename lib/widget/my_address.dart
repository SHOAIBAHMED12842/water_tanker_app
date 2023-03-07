import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_number_otp/screens/dashboard.dart';
//import 'package:phone_number_otp/screens/profile_address.dart';
import 'package:phone_number_otp/widget/address_card.dart';
import 'package:phone_number_otp/widget/address_card1.dart';
//import 'package:phone_number_otp/widget/address_widget.dart';
import 'package:phone_number_otp/widget/pick_location.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:url_launcher/url_launcher.dart';
//import 'package:intl/intl.dart';

class MyAddress extends StatefulWidget {
  //const MyAddress({super.key});
  String? location;
  MyAddress(this.location, {super.key});

  @override
  State<MyAddress> createState() => _MyAddressState();
}

class _MyAddressState extends State<MyAddress> {
  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();
  final _formKey4 = GlobalKey<FormState>();
  final _formKey5 = GlobalKey<FormState>();
  late final TextEditingController _mapLocation;
  final _consumerController = TextEditingController();
  final _addrController = TextEditingController();
  //bool isValid = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _consumerController.addListener(
      () {
        if (_consumerController.text.isEmpty) {
          setState(() {
            isValid = false;
          });
        } else {
          setState(() {
            isValid = true;
          });
        }
      },
    );
    _addrController.addListener(
      () {
        if (_addrController.text.isEmpty) {
          setState(() {
            isValid = false;
          });
        } else {
          setState(() {
            isValid = true;
          });
        }
      },
    );
    _mapLocation = TextEditingController(text: widget.location);
    _getuid();
  }
  //String? location;
  //bool _autovalidate = false;

  bool _validated = false;
  bool _validatedarea = false;
  bool _validatedblock = false;
  bool _validatedsector = false;
  String _enteredAddr = '';
  String _enteredconsumer = '';
  String placeValue = '';
  String? selectedArea;
  String? selectedblock;
  String? selectedsector;
  String? selectedhydrant;
  bool isValid = false;
  var areas;

  //List<Map<int,String>> listA = {};

  // static Future<void> openMap(String latlang) async {
  //   String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latlang';
  //   if (await canLaunch(googleUrl)) {
  //     await launch(googleUrl);
  //   } else {
  //     throw 'Could not open the map.';
  //   }
  // }
// static Future<void> openMap(double latitude, double longitude) async {
//     String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//     if (await canLaunch(googleUrl)) {
//       await launch(googleUrl);
//     } else {
//       throw 'Could not open the map.';
//     }
//   }
  var listAreas = [
    {"id": 1, "name": "DHA"},
    {"id": 2, "name": "Gulshan"},
    {"id": 3, "name": "Johar"}
  ];

  var listBlocks = [
    {"id": 1, "areaId": 1, "name": "Block-1"},
    {"id": 2, "areaId": 1, "name": "Block-2"},
    {"id": 3, "areaId": 2, "name": "Block-3"},
    {"id": 4, "areaId": 2, "name": "Block-4"},
    {"id": 5, "areaId": 3, "name": "Block-5"},
    {"id": 6, "areaId": 3, "name": "Block-6"}
  ];

  var listBlockSec = [
    {"id": 1, "areaId": 1, "blockId": 1, "name": "Sector-1"},
    {"id": 2, "areaId": 1, "blockId": 1, "name": "Sector-2"},
    {"id": 3, "areaId": 1, "blockId": 2, "name": "Sector-3"},
    {"id": 4, "areaId": 1, "blockId": 2, "name": "Sector-4"},
    {"id": 5, "areaId": 2, "blockId": 3, "name": "Sector-5"},
    {"id": 6, "areaId": 2, "blockId": 3, "name": "Sector-6"},
    {"id": 7, "areaId": 2, "blockId": 4, "name": "Sector-7"},
    {"id": 8, "areaId": 2, "blockId": 4, "name": "Sector-8"},
    {"id": 9, "areaId": 3, "blockId": 5, "name": "Sector-9"},
    {"id": 10, "areaId": 3, "blockId": 5, "name": "Sector-10"},
    {"id": 11, "areaId": 3, "blockId": 6, "name": "Sector-11"},
    {"id": 12, "areaId": 3, "blockId": 6, "name": "Sector-12"},
  ];
  var listSelectedBlock = <Map<String, Object>>[];
  var filterBlocks = <Map<String, Object>>[];
//var filterBlocks = <Map>[];
  List<Map<String, Object>> filtersblock(Object? areaID) {
    for (Map<String, Object> map in listBlocks) {
      if (map["areaId"] == areaID) {
        listSelectedBlock.add(map);
      }
    }
    return listSelectedBlock;
  }

  var listSelectedBlockSec = <Map<String, Object>>[];
  var filterBlockSec = <Map<String, Object>>[];
  List<Map<String, Object>> filtersblocksec(String? blockID) {
    var blocksID = int.parse(blockID!);
    for (Map<String, Object> map in listBlockSec) {
      if (map["blockId"] == blocksID) {
        listSelectedBlockSec.add(map);
      }
    }
    return listSelectedBlockSec;
  }

  List<String> hydrants = [];

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var uid = '';
  //String mobileno = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> _getuid() async {
    final user = auth.currentUser!;
    setState(() {
      uid = user.uid;
      //mobileno = '0${user.phoneNumber.toString().substring(3)}';
    });
  }

  var phonecollections = FirebaseFirestore.instance.collection('profile');
  //final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    void addrsubmit() async {
      final isValid1 = _formKey.currentState!.validate();
      final isValid2 = _formKey1.currentState!.validate();
      final isValid3 = _formKey2.currentState!.validate();
      final isValid4 = _formKey3.currentState!.validate();
      final isValid5 = _formKey4.currentState!.validate();
      final isValid6 = _formKey5.currentState!.validate();
      if (isValid1 &&
          isValid2 &&
          isValid3 &&
          isValid4 &&
          isValid5 &&
          isValid6) {
        _formKey.currentState!.save();
        _formKey1.currentState!.save();
        _formKey2.currentState!.save();
        _formKey3.currentState!.save();
        _formKey4.currentState!.save();
        _formKey5.currentState!.save();
        await phonecollections.doc(uid).collection("address_info").add({
          //await phonecollections.add({
          'place': placeValue,
          'location latlng': widget.location,
          'consumer no': _enteredconsumer,
          'address': _enteredAddr,
          // 'uid': uid,
          // 'phone no':mobileno,
        });

        Fluttertoast.showToast(
          msg: "Address Add Successfully",
          //toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
            //ProfileAddress(),
            //MyAddress(widget.location),
          ),
        );
        // showDialog(
        //   context: context,
        //   builder: (context) {
        //     return AlertDialog(
        //       title: const Text('Confirmation Message'),
        //       content: const Text('Address add successfully'),
        //       //Text('Did\'nt verify press ok to try again!'),
        //       actions: [
        //         ElevatedButton(
        //           onPressed: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => const Dashboard(),
        //                 //ProfileAddress(),
        //                 //MyAddress(widget.location),
        //               ),
        //             );
        //             //Navigator.pop(context);
        //           },
        //           child: const Text("OK"),
        //         ),
        //       ],
        //     );
        //   },
        // );
      }
    }

    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      //key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'Address',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            //const AddressWidget();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          //height: deviceSize.height,
          //width: deviceSize.width,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 15, left: 15, right: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Add Address',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '(Map Location must be selected first otherwise default will submit)',
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Colors.grey.shade200,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              AddressCard('Place :'),
                              const SizedBox(
                                width: 25, //75
                              ),
                              SizedBox(
                                height: 70,
                                width: 210,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    top: 20,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.only(
                                        right: 27, //55
                                        left: 40,
                                        bottom: 5,
                                        top: 5,
                                      ),
                                      backgroundColor: Colors.grey.shade200,
                                      side: const BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: Form(
                                      key: _formKey,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      child: DropdownSearch<String>(
                                        popupProps:
                                            const PopupProps.modalBottomSheet(
                                          showSelectedItems: true,
                                          modalBottomSheetProps:
                                              ModalBottomSheetProps(
                                            isScrollControlled: true,
                                            constraints:
                                                BoxConstraints(maxHeight: 175),
                                            enableDrag: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        items: const [
                                          "Home",
                                          "Work",
                                          "Other",
                                        ],
                                        dropdownDecoratorProps:
                                            const DropDownDecoratorProps(
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "",
                                            hintStyle: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value.toString() == 'SELECT') {
                                            return 'Please select place';
                                          }
                                          return null;
                                        },
                                        // => value == 'SELECT'
                                        //           ? 'Please select place'
                                        //           : 'SELECT',
                                        onChanged: (newValue) {
                                          setState(() {
                                            placeValue = newValue!;
                                          });
                                        },
                                        selectedItem: "SELECT",
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              AddressCard('Area :'),
                              const SizedBox(
                                width: 28, //75
                              ),
                              Container(
                                height: 50,
                                width: 210,
                                margin: const EdgeInsets.only(
                                  top: 20,
                                  left: 5,
                                ),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.only(
                                      right: 27, //55
                                      left: 40,
                                      bottom: 5,
                                      top: 5,
                                    ),
                                    backgroundColor: Colors.grey.shade200,
                                    side: const BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: Form(
                                    key: _formKey1,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    child: DropdownButtonFormField(
                                      isExpanded: true,
                                      //underline: const SizedBox(),//for dropdown button
                                      decoration:
                                          const InputDecoration.collapsed(
                                              hintText: ''),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                      alignment: AlignmentDirectional.center,
                                      dropdownColor: Colors.white,
                                      value: null,
                                      validator: (value) => value == null
                                          ? 'Please select area'
                                          : null,
                                      icon: Icon(
                                        Icons.arrow_drop_down_outlined,
                                        //Icons.keyboard_arrow_down_sharp,
                                        color: Colors.grey.shade600,
                                      ),
                                      hint: const Text(
                                        'SELECT AREA   ',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      items: listAreas.map((item) {
                                        return DropdownMenuItem(
                                          value: item['id'],
                                          child: Text(item['name'].toString()),
                                        );
                                      }).toList(),

                                      onChanged: (area) {
                                        filterBlocks.clear();
                                        filterBlocks = filtersblock(area);
                                        setState(() {
                                          selectedblock = null;
                                          //selectedArea = area.toString();
                                          _validatedarea = true;
                                          _validatedblock = false;
                                          _validatedsector = false;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          _validatedarea
                              ? Row(
                                  children: [
                                    AddressCard('Block :'),
                                    const SizedBox(
                                      width: 25,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 210,
                                      margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 5,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                            right: 27, //55
                                            left: 40,
                                            bottom: 5,
                                            top: 5,
                                          ),
                                          backgroundColor: Colors.grey.shade200,
                                          side: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Form(
                                          key: _formKey2,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          child: DropdownButtonFormField(
                                            isExpanded: true,
                                            //underline: const SizedBox(),//for dropdown button
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: ''),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            alignment:
                                                AlignmentDirectional.center,
                                            dropdownColor: Colors.white,
                                            value: selectedblock,
                                            //value: null,
                                            validator: (value) => value == null
                                                ? 'Please select block'
                                                : null,
                                            icon: Icon(
                                              Icons.arrow_drop_down_outlined,
                                              //Icons.keyboard_arrow_down_sharp,
                                              color: Colors.grey.shade600,
                                            ),
                                            hint: const Text(
                                              'SELECT BLOCK   ',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),

                                            items: filterBlocks.map((items) {
                                              return DropdownMenuItem(
                                                value: items['id'].toString(),
                                                child: Text(
                                                    items['name'].toString()),
                                              );
                                            }).toList(),
                                            onChanged: (block) {
                                              filterBlockSec.clear();
                                              //print(block);
                                              filterBlockSec =
                                                  filtersblocksec(block);
                                              //print(filterBlockSec);
                                              setState(() {
                                                selectedsector = null;
                                                selectedblock = block;
                                                _validatedblock = true;
                                                _validatedsector = false;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          _validatedblock
                              ? Row(
                                  children: [
                                    AddressCard('Sector :'),
                                    const SizedBox(
                                      width: 22,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 210,
                                      margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 5,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                            right: 27, //55
                                            left: 40,
                                            bottom: 5,
                                            top: 5,
                                          ),
                                          backgroundColor: Colors.grey.shade200,
                                          side: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: Form(
                                          key: _formKey3,
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          child: DropdownButtonFormField(
                                            isExpanded: true,
                                            // underline:
                                            //     const SizedBox(), //for dropdown button
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: ''),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            alignment:
                                                AlignmentDirectional.center,
                                            dropdownColor: Colors.white,
                                            value: selectedsector,
                                            validator: (value) => value == null
                                                ? 'Please select sector'
                                                : null,
                                            //selectedsector,
                                            icon: Icon(
                                              Icons.arrow_drop_down_outlined,
                                              //Icons.keyboard_arrow_down_sharp,
                                              color: Colors.grey.shade600,
                                            ),
                                            hint: const Text(
                                              'SELECT',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            items: filterBlockSec.map((items) {
                                              return DropdownMenuItem(
                                                value: items['id'].toString(),
                                                child: Text(
                                                    items['name'].toString()),
                                              );
                                            }).toList(),

                                            onChanged: (sector) {
                                              setState(() {
                                                selectedhydrant = null;
                                                selectedsector = sector;
                                                _validatedsector = true;
                                                //_validatedblock = false;
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          _validatedsector
                              ? Row(
                                  children: [
                                    AddressCard('Hydrant :'),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      height: 50,
                                      width: 210,
                                      margin: const EdgeInsets.only(
                                        top: 20,
                                        left: 5,
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.only(
                                            right: 27, //55
                                            left: 40,
                                            bottom: 5,
                                            top: 5,
                                          ),
                                          backgroundColor: Colors.grey.shade200,
                                          side: const BorderSide(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onPressed: () {},
                                        child: DropdownButton<String>(
                                          isExpanded: true,
                                          iconSize: 0.0,
                                          underline:
                                              const SizedBox(), //for dropdown button
                                          // decoration:
                                          //     const InputDecoration.collapsed(
                                          //         hintText: ''),
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15,
                                          ),
                                          alignment:
                                              AlignmentDirectional.center,
                                          dropdownColor: Colors.white,
                                          value: selectedhydrant,
                                          icon: Icon(
                                            //Icons.arrow_drop_down_outlined,
                                            Icons.keyboard_arrow_down_sharp,
                                            color: Colors.grey.shade600,
                                          ),
                                          hint: const Text(
                                            'NIL       ',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          items: hydrants.map((String hydrant) {
                                            return DropdownMenuItem(
                                              value: hydrant,
                                              child: Text(hydrant),
                                            );
                                          }).toList(),

                                          onChanged: null,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          const SizedBox(
                            height: 20,
                          ),
                          Form(
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 30,
                              ),
                              child: Row(
                                children: [
                                  AddressCard('Map Location :'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: Container(
                                      color: Colors.grey.shade300,
                                      child: TextField(
                                        controller: _mapLocation,
                                        // TextEditingController(
                                        //   text: " 24.9180, 67.0971",
                                        // ),
                                        enableInteractiveSelection: false,
                                        focusNode: FocusNode(),
                                        enabled: false,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: const Border(
                                        bottom: BorderSide(
                                            width: 1.0, color: Colors.black12),
                                      ),
                                      color: Colors.grey.shade300,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.my_location_sharp,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const PickLocation(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: _formKey4,
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 30,
                              ),
                              child: Row(
                                children: [
                                  AddressCard1('Consumer No :'),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      key: const ValueKey('consumer no'),
                                      controller: _consumerController,
                                      maxLength: 12,
                                      onSaved: (value) {
                                        _enteredconsumer = value!;
                                      },
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Consumer no can\'t be empty';
                                        }
                                        if (value.length < 12) {
                                          return 'Must be 12 character long';
                                        }

                                        return null;
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        hintText: 'Enter 12 digit Consumer No',
                                        hintStyle: TextStyle(
                                            color: Colors.black38,
                                            fontSize: 14),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Form(
                            key: _formKey5,
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 30,
                              ),
                              child: Row(
                                children: [
                                  AddressCard1('Address :'),
                                  const SizedBox(
                                    width: 55,
                                  ),
                                  Flexible(
                                    child: TextFormField(
                                      key: const ValueKey('address'),
                                      controller: _addrController,
                                      keyboardType: TextInputType.multiline,
                                      maxLength: 30,
                                      maxLines: 2,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Address can\'t be empty';
                                        }
                                        if (value.length < 21) {
                                          return 'Must be 21 character long';
                                        }
                                        return null;
                                      },
                                      onChanged: (value) {
                                        setState(() {
                                          _enteredAddr = value;
                                        });
                                      },
                                      decoration: const InputDecoration(
                                        //counterText: "",
                                        hintText: 'Enter your address',
                                        hintStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        ),
                                        // errorText: _validated
                                        //     ? 'Please enter address'
                                        //     : null,
                                        // counterText:
                                        //     '${_enteredText.length.toString()} characters remaining/40.',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 45,
                      width: double.infinity,
                      margin: const EdgeInsets.all(15),
                      child: ElevatedButton(
                        onPressed: () {
                          // if (_formKey.currentState!.validate()) {
                          //   _formKey.currentState!.save();
                          // }
                          // //test(1);
                          // if (_formKey1.currentState!.validate()) {
                          //   _formKey1.currentState!.save();
                          // }
                          // if (_formKey2.currentState!.validate()) {
                          //   _formKey2.currentState!.save();
                          // }
                          // if (_formKey3.currentState!.validate()) {
                          //   _formKey3.currentState!.save();
                          // }
                          // if (_formKey4.currentState!.validate()) {
                          //   _formKey4.currentState!.save();
                          // }
                          // CountryDependentDropDown();
                          // _filterlistblock();
                          // setState(() {
                          //   _enteredAddr.isEmpty
                          //       ? _validated = true
                          //       : _validated = false;
                          //   _enteredconsumer.isEmpty
                          //       ? _validated = true
                          //       : _validated = false;
                          // });
                          // String tdata =
                          //     DateFormat("hh:mm a").format(DateTime.now());
                          // print(tdata);
                          // String cdate1 =
                          //     DateFormat("EEEEE").format(DateTime.now());
                          // print(cdate1);
                          // String cdate2 = DateFormat("MMMMdd, yyyy")
                          //     .format(DateTime.now());
                          // print(cdate2);
                          addrsubmit();
                          //openMap("24.9180,67.0971");
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade900,
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
