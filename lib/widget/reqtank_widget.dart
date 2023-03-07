//import 'dart:math';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_number_otp/widget/booking_request.dart';
import 'package:intl/intl.dart';

import '../screens/dashboard.dart';

//import  'package:intl/intl.dart';

class ReqTankWidget extends StatefulWidget {
  const ReqTankWidget({super.key});

  @override
  State<ReqTankWidget> createState() => _ReqTankWidgetState();
}

class _ReqTankWidgetState extends State<ReqTankWidget> {
  var tankservice = 'GPS';
  var isgps = false;
  var isaddr = false;
  var isgallon = false;
  var address = '';
  var quantity = '';
  var mobileno = '';
  var location = '';
  late bool isEmpty = false;
   //late final List<String> addresssplit;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid = '';
  Future<void> _getuid() async {
    final user = auth.currentUser!;
    //var uid = user.uid;
    setState(() {
      uid = user.uid;
      mobileno = '0${user.phoneNumber.toString().substring(3)}';
    });
  }

  var requestcollection =
      FirebaseFirestore.instance.collection('request_booking');
  Future<void> checkIfCollectionExist(String uid) async {
    try {
      var value = await requestcollection
          .doc(uid)
          .get(); //.collection(collectionName).get();
      setState(() {
        isEmpty = value.exists;
        //isEmpty = value.docs.isEmpty;
      });
    } catch (e) {
      rethrow;
    }

    //print(collectionName);
    //print(isEmpty);
  }

  String time = DateFormat("hh:mm a").format(DateTime.now());
  String day = DateFormat("EEEEE").format(DateTime.now());
  String date = DateFormat("MMMM dd, yyyy").format(DateTime.now());
  String rndnumber = '';
  var rnd = Random();
  var phonecollection = FirebaseFirestore.instance.collection('profile');
  var galloncollection = FirebaseFirestore.instance.collection('gallons');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getuid();
    checkIfCollectionExist(uid);
  }

  @override
  Widget build(BuildContext context) {
    void requesttanker() async {
      for (var i = 0; i < 10; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      setState(() {
        rndnumber;
      });
      //print(rndnumber);
      await requestcollection.doc(uid).set({
        'Tanker ID': rndnumber,
        'Time': time,
        'Status': "Pending",
        'Day': day,
        'Date': date,
        'Service': tankservice,
        'Gallons': quantity,
        'Address': address,
        'Map Location': location,
        'Phone no': mobileno,
        'UID': uid,
        'Amount': '1300.00',
        'Distance': '4.45 KM',
        'Water Charges': '1300.00',
        'Delivery Charges': '0.00',
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookingRequest(rndnumber),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          Text(
            'Tanker Service',
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          // Directionality(
          //   textDirection: TextDirection.ltr,
          //   child:
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                  right: 10,
                  left: 10,
                  bottom: 10,
                  top: 10,
                ),
                backgroundColor: Colors.grey.shade200,
                side: BorderSide(
                  color: Colors.grey.shade500,
                ),
              ),
              label: const Text(
                '',
              ),
              icon: !isgps
                  ? Row(
                      children: const [
                        Text(
                          'Select Tanker Service',
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // SizedBox(
                        //   width: 157,
                        // ),
                        // Icon(
                        //   Icons.keyboard_arrow_down_sharp,
                        //   color: Colors.black,
                        // ),
                      ],
                    )
                  : Row(
                      children: [
                        Text(
                          tankservice,
                          style: const TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        // const SizedBox(
                        //   width: 259,
                        // ),
                        // const Icon(
                        //   Icons.keyboard_arrow_down_sharp,
                        //   color: Colors.black,
                        // ),
                      ],
                    ),
              onPressed: () {
                //showGPS(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.blue,
                      scrollable: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            10.0,
                          ),
                        ),
                      ),
                      // contentPadding: EdgeInsets.only(
                      //   top: 15.0,
                      // ),
                      title: const SizedBox(
                        //color: Colors.blue.shade800,
                        height: 71,
                        child: Center(
                          child: Text(
                            'Tanker Service',
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      content: SizedBox(
                        height: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Select Tanker Service',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  tankservice;
                                  isgps = true;
                                  isaddr = false;
                                  isgallon = false;
                                });
                                Navigator.pop(context);
                              },
                              child: Card(
                                elevation: 0,
                                //color: Colors.red,
                                child: Container(
                                  margin: const EdgeInsets.only(top: 3),
                                  width: 300,
                                  height: 25,
                                  child: Center(
                                    child: Text(
                                      tankservice,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          //),
          isgps
              ? const SizedBox(
                  height: 15,
                )
              : Container(),
          isgps
              ? Text(
                  'Address',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          isgps
              ?
              // Directionality(
              //     textDirection: TextDirection.ltr,
              //     child:
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        // right: 10,
                        left: 10,
                        bottom: 10,
                        top: 10,
                      ),
                      backgroundColor: Colors.grey.shade200,
                      side: BorderSide(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    label: const Text(
                      '',
                    ),
                    icon: !isaddr
                        ? Row(
                            children: const [
                              Text(
                                'Select Address',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // SizedBox(
                              //   width: 200,
                              // ),
                              // Icon(
                              //   Icons.keyboard_arrow_down_sharp,
                              //   color: Colors.black,
                              // ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                address,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              //  SizedBox(
                              //   width: MediaQuery.of(context).size.width,
                              // ),
                              // const Icon(
                              //   Icons.keyboard_arrow_down_sharp,
                              //   color: Colors.black,
                              // ),
                            ],
                          ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            //insetPadding: const EdgeInsets.only(left: 5,right: 5,),
                            //insetPadding: EdgeInsets.zero,
                            //contentPadding: EdgeInsets.zero,
                            titlePadding: const EdgeInsets.only(
                              top: 5,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            backgroundColor: Colors.blue,
                            scrollable: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              top: 15.0,
                            ),
                            title: const SizedBox(
                              //color: Colors.blue.shade800,
                              //height: 71,
                              child: Center(
                                child: Text(
                                  'Address',
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            content:
                                // SizedBox(
                                // //height: 80,
                                // child:
                                Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Address of Delivery Location',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                StreamBuilder
                                    //<QuerySnapshot>
                                    (
                                  stream: phonecollection
                                      .doc(uid)
                                      .collection('address_info')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      var doc = snapshot.data!.docs;
                                      return ListView.builder(
                                          scrollDirection: Axis
                                              .vertical, //Vertical viewport was given unbounded height resolve
                                          shrinkWrap:
                                              true, //Vertical viewport was given unbounded height resolve
                                          physics:
                                              const NeverScrollableScrollPhysics(), //Singlechildscrollview Doesn'T Scroll Screen With Listview.Builder
                                          itemCount: doc.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 15,
                                                left: 15,
                                                top: 4,
                                                bottom: 4,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    address = doc[index]
                                                        .get('address')
                                                        .toString();
                                                    location = doc[index]
                                                        .get('location latlng')
                                                        .toString();
                                                    isaddr = true;
                                                    isgallon = false;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Card(
                                                  color: Colors.grey.shade100,
                                                  child: Row(
                                                    children: [
                                                      //const Icon(Icons.home),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              doc[index]
                                                                  .get('place'),
                                                            ),
                                                            Text(
                                                              doc[index].get(
                                                                  'address'),
                                                              style:
                                                                  const TextStyle(
                                                                // color: Colors.grey
                                                                //     .shade600,
                                                                fontSize: 11,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                            //),
                          );
                        },
                      );
                    },
                  ),
                )
              //)
              : Container(),
          !isaddr
              ? const SizedBox(
                  height: 10,
                )
              : Container(),
          !isaddr
              ? Row(
                  children: const [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 15,
                    ),
                    Text(
                      ' All Prices given are subject to change with distance!',
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 15,
          ),
          isaddr
              ? Text(
                  'Gallons',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          isaddr
              ?
              // Directionality(
              //     textDirection: TextDirection.ltr,
              //     child:
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.only(
                        right: 10,
                        left: 10,
                        bottom: 10,
                        top: 10,
                      ),
                      backgroundColor: Colors.grey.shade200,
                      side: BorderSide(
                        color: Colors.grey.shade500,
                      ),
                    ),
                    label: const Text(
                      '',
                    ),
                    icon: !isgallon
                        ? Row(
                            children: const [
                              Text(
                                'Select No. of Gallons',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // SizedBox(
                              //   width: 160,
                              // ),
                              // Icon(
                              //   Icons.keyboard_arrow_down_sharp,
                              //   color: Colors.black,
                              // ),
                            ],
                          )
                        : Row(
                            children: [
                              Text(
                                quantity,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              // SizedBox(
                              //   width: 160,
                              // ),
                              // Icon(
                              //   Icons.keyboard_arrow_down_sharp,
                              //   color: Colors.black,
                              // ),
                            ],
                          ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            titlePadding: const EdgeInsets.only(
                              top: 5,
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            backgroundColor: Colors.blue,
                            scrollable: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10.0,
                                ),
                              ),
                            ),
                            contentPadding: const EdgeInsets.only(
                              top: 15.0,
                            ),
                            title: const SizedBox(
                              //color: Colors.blue.shade800,
                              //height: 71,
                              child: Center(
                                child: Text(
                                  'Gallons',
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            content:
                                // SizedBox(
                                // //height: 80,
                                // child:
                                Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select no. of gallons',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                StreamBuilder
                                    //<QuerySnapshot>
                                    (
                                  stream: galloncollection.snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      var doc = snapshot.data!.docs;
                                      return ListView.builder(
                                          scrollDirection: Axis
                                              .vertical, //Vertical viewport was given unbounded height resolve
                                          shrinkWrap:
                                              true, //Vertical viewport was given unbounded height resolve
                                          physics:
                                              const NeverScrollableScrollPhysics(), //Singlechildscrollview Doesn'T Scroll Screen With Listview.Builder
                                          itemCount: doc.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                right: 15,
                                                left: 15,
                                                top: 4,
                                                bottom: 4,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    quantity = doc[index]
                                                        .get('quantity')
                                                        .toString();
                                                    isgallon = true;
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Card(
                                                  color: Colors.grey.shade100,
                                                  child: Row(
                                                    children: [
                                                      //const Icon(Icons.home),
                                                      Container(
                                                        margin: const EdgeInsets
                                                            .only(left: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: <Widget>[
                                                            const SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              doc[index].get(
                                                                  'quantity'),
                                                              style:
                                                                  const TextStyle(
                                                                // color: Colors.grey
                                                                //     .shade600,
                                                                fontSize: 15,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 5,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                //),
                                              ),
                                            );
                                          });
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ],
                            ),
                            //),
                          );
                        },
                      );
                    },
                  ),
                )
              //)
              : Container(),
          const SizedBox(
            height: 10,
          ),
          isaddr
              ? Row(
                  children: const [
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 15,
                    ),
                    Text(
                      ' All Prices given are subject to change with distance!',
                      textAlign: TextAlign.justify,
                    ),
                  ],
                )
              : Container(),
          const SizedBox(
            height: 5,
          ),
          isgallon
              ? Container(
                  height: 45,
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () async {
                      !isEmpty
                          ? 
                          requesttanker()
                          : showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Column(
                                    children: [
                                      const Center(
                                        child: Text(
                                          'Sorry, only one order is allowed at a time.Please try again once your previous order is complete.',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      const SizedBox(height: 15,),
                                      Text(
                                        'Return to the main menu',
                                        style: TextStyle(
                                          color: Colors.blue.shade900,
                                          fontSize: 15,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),

                                  //Text('Did\'nt verify press ok to try again!'),
                                  actions: [
                                    Center(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Dashboard(),
                                                //ProfileAddress(),
                                              ),
                                            );
                                          },
                                          child: const Text("OK"),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BookingRequest(rndnumber),
                      //   ),
                      // );
                      // var rndnumber = "";
                      // var rnd = new Random();
                      // for (var i = 0; i < 10; i++) {
                      //   rndnumber = rndnumber + rnd.nextInt(9).toString();
                      // }
                      // print(rndnumber);

                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       title: const Text('Confirmation Message'),
                      //       content: const Text('Tanker booked successfully'),
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: const Text(
                      'Request Tanker',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
