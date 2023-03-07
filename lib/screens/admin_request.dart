import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminRequest extends StatefulWidget {
  const AdminRequest({super.key});

  @override
  State<AdminRequest> createState() => _AdminRequestState();
}

class _AdminRequestState extends State<AdminRequest> {
  var date = '';
  var day = '';
  var time = '';
  var tankerid = '';
  var gallons = '';
  var amount = '';
  var distance = '';
  var deliverycharges = '';
  var watercharges = '';
  var uid = '';
  var phoneno = '';
  late bool isEmpty = false;
  var requestcollection =
      FirebaseFirestore.instance.collection('request_booking');
  var phonecollections = FirebaseFirestore.instance.collection('profile');
  var historycollection =
      FirebaseFirestore.instance.collection('booking_history');
  Future<void> checkIfCollectionExist() async {
    try {
      var value = await requestcollection.get();
      setState(() {
        isEmpty = value.docs.isNotEmpty;
      });
      //isEmpty = value.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfCollectionExist();
  }

  Future deleteReq(String id) async {
    try {
      await phonecollections.doc(uid).collection("request_booking").add({
        'Date': date,
        'Day': day,
        'Time': time,
        'Tanker ID': tankerid,
        'Status': 'Closed',
        'Gallons': gallons,
        'Amount': amount,
        'Distance': distance,
        'Delivery Charges': deliverycharges,
        'Water Charges': watercharges,
      });
      await historycollection.add({
        'Date': date,
        'Day': day,
        'Time': time,
        'Tanker ID': tankerid,
        'Status': 'Closed',
        'Gallons': gallons,
        'Amount': amount,
        'Distance': distance,
        'Delivery Charges': deliverycharges,
        'Water Charges': watercharges,
        'Phone no': phoneno,
      });
      Fluttertoast.showToast(
        msg: "Request($tankerid) Approved Successfully",
        //toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.black,
        fontSize: 16,
      );
      await requestcollection.doc(id).delete();
    } catch (e) {
      return false;
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
            'Requests Details',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'admdash');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: isEmpty
          ? SingleChildScrollView(
              child: SizedBox(
                //height: deviceSize.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    isEmpty
                        ? Center(
                            child: Text(
                              'DOUBLE TAP DETAIL TO APPROVE',
                              style: TextStyle(
                                color: Colors.blue.shade900,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder
                        //<QuerySnapshot>
                        (
                      stream: requestcollection.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                  child:
                                      // GestureDetector(
                                      //   onTap: () {
                                      //     deleteAddr(snapshot.data!.docs[index].reference.id
                                      //         .toString());
                                      //   },
                                      //   child:
                                      GestureDetector(
                                    onDoubleTap: () {
                                      setState(() {
                                        day = doc[index].get('Day').toString();
                                        date =
                                            doc[index].get('Date').toString();
                                        time =
                                            doc[index].get('Time').toString();
                                        tankerid = doc[index]
                                            .get('Tanker ID')
                                            .toString();
                                        gallons = doc[index]
                                            .get('Gallons')
                                            .toString();
                                        amount =
                                            doc[index].get('Amount').toString();
                                        distance = doc[index]
                                            .get('Distance')
                                            .toString();
                                        deliverycharges = doc[index]
                                            .get('Delivery Charges')
                                            .toString();
                                        watercharges = doc[index]
                                            .get('Water Charges')
                                            .toString();
                                        uid = doc[index].get('UID').toString();
                                        phoneno = doc[index]
                                            .get('Phone no')
                                            .toString();
                                      });
                                      deleteReq(snapshot
                                          .data!.docs[index].reference.id
                                          .toString());
                                    },
                                    child: Card(
                                      //margin: const EdgeInsets.only(left: 70,right: 70),
                                      //color: Colors.grey.shade100,
                                      child: Row(
                                        //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          //const Icon(Icons.home),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              left: 10,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Tanker ID : '),
                                                    Text(
                                                      doc[index]
                                                          .get('Tanker ID'),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    //ElevatedButton(onPressed: (){}, child: Icon(Icons.delete),),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Date : '),
                                                    Text(
                                                      doc[index].get('Date'),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Day : '),
                                                    Text(
                                                      doc[index].get('Day'),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Time : '),
                                                    Text(
                                                      doc[index].get('Time'),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Status : '),
                                                    Text(
                                                      doc[index].get('Status'),
                                                      style: const TextStyle(
                                                        color: Colors.red,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Phone No : '),
                                                    Text(
                                                      doc[index]
                                                          .get('Phone no'),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Gallons : '),
                                                    Text(
                                                      doc[index].get('Gallons'),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Distance : '),
                                                    Text(
                                                      doc[index]
                                                          .get('Distance'),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Amount : '),
                                                    Text(
                                                      doc[index].get('Amount'),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 10.0,
                                                ),
                                                Row(
                                                  children: [
                                                    const Text('Address : '),
                                                    Text(
                                                      doc[index].get('Address'),
                                                      style: TextStyle(
                                                        color: Colors
                                                            .blue.shade900,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //),
                                );
                              });
                        } else {
                          return const LinearProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          : const Center(
              child: Text(
                'No request found',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
    );
  }
}
