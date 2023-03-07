import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackTanker extends StatefulWidget {
  const TrackTanker({super.key});

  @override
  State<TrackTanker> createState() => _TrackTankerState();
}

class _TrackTankerState extends State<TrackTanker> {
  //var mobileno = '';
  late bool isEmpty = false;
  late bool isPending = false;
  var order = 'Order At';
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid = '';
  Future<void> _getuid() async {
    final user = auth.currentUser!;
    //var uid = user.uid;
    setState(() {
      uid = user.uid;
      //mobileno = '0${user.phoneNumber.toString().substring(3)}';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getuid();
    checkIfCollectionExist(uid);
  }

  static Future<void> openMap(String latlang) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latlang';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'OTS-Track Tanker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'ots');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: !isEmpty
          ? const Center(
              child: Text(
                'No request apply',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )
          : SingleChildScrollView(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15,),
                    Center(child: Text('Tap Below to see Order Details',style: TextStyle(fontSize: 16,),),),
                    //SizedBox(height: 5,),
                    FutureBuilder<DocumentSnapshot>(
                      //Fetching data from the uid specified of the profile
                      future: requestcollection.doc(uid).get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        //Error Handling conditions
                        if (snapshot.hasError) {
                          return Container();
                        }
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return Container();
                        }
          
                        //Data is output to the user
                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return
                              // Column(
                              //   //crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     const SizedBox(
                              //       height: 10,
                              //     ),
                              GestureDetector(
                            onTap: () {
                              setState(() {
                                isPending = !isPending;
                              });
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: 150,
                                  child: Card(
                                    margin: const EdgeInsets.only(
                                      left: 15,
                                      top: 11,
                                    ),
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Tanker ID",
                                          style: TextStyle(
                                            fontSize: 15,
                                            //fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "${data['Tanker ID']}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 35,
                                ),
                                Text(
                                  "${data['Status']}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                const SizedBox(
                                  width: 50,
                                ),
                                !isPending
                                    ? Icon(Icons.keyboard_arrow_down,
                                        color: Colors.blue.shade900)
                                    : Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.blue.shade900,
                                      ),
                              ],
                            ),
                          );
                          //   ],
                          // );
                        }
                        return Container();
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    isPending
                        ? Container(
                            margin: const EdgeInsets.only(
                              left: 15,
                              top: 11,
                              right: 15,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  order,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.blue.shade900,
                                  ),
                                ),
                                Card(
                                  margin: const EdgeInsets.only(
                                    top: 11,
                                  ),
                                  child: FutureBuilder<DocumentSnapshot>(
                                    //Fetching data from the uid specified of the profile
                                    future: requestcollection.doc(uid).get(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                                      //Error Handling conditions
                                      if (snapshot.hasError) {
                                        return Container();
                                      }
                                      if (snapshot.hasData &&
                                          !snapshot.data!.exists) {
                                        return Container();
                                      }
          
                                      //Data is output to the user
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Map<String, dynamic> data = snapshot.data!
                                            .data() as Map<String, dynamic>;
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Time",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 132,
                                                ),
                                                Text(
                                                  "${data['Time']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Day",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 140,
                                                ),
                                                Text(
                                                  "${data['Day']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Date",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 135,
                                                ),
                                                Text(
                                                  "${data['Date']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Service",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 115,
                                                ),
                                                Text(
                                                  "${data['Service']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Gallons",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 112,
                                                ),
                                                Text(
                                                  "${data['Gallons']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children:  [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Amount",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 112,
                                                ),
                                                Text(
                                                  "${data['Amount']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                             const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children:  [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Distance",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 108,
                                                ),
                                                Text(
                                                  "${data['Distance']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                             const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Address",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 105,
                                                ),
                                                //addresssplit=data['Address'].toString().split(' '),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "${data['Address'].toString().substring(0, 5)}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey.shade800,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${data['Address'].toString().substring(5, 21)}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey.shade800,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${data['Address'].toString().substring(21)}",
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.grey.shade800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                             const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children:  [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Column(
                                                  children: const [
                                                    Text(
                                                      "Delivery",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Charges",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                 const SizedBox(
                                                  width: 108,
                                                ),
                                                Text(
                                                  "${data['Delivery Charges']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children:  [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                Column(
                                                  children: const [
                                                    Text(
                                                      "Water",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Charges",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                 const SizedBox(
                                                  width: 108,
                                                ),
                                                Text(
                                                  "${data['Water Charges']}",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                const SizedBox(
                                                  width: 25,
                                                ),
                                                const Text(
                                                  "Map Location",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                //const SizedBox(width: 70,),
                                                // const Text(':', style: TextStyle(
                                                //     fontSize: 18,
                                                //   ),),
                                                const SizedBox(
                                                  width: 50,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: "View on map",
                                                    style: const TextStyle(color: Colors.blue,),
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            openMap(
                                                                data['Map Location']);
                                                          },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        );
                                      }
                                      return const Center(child: LinearProgressIndicator());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
            ),
          ),
    );
  }
}
