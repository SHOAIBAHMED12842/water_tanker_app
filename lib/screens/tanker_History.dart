import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TankerHistory extends StatefulWidget {
  const TankerHistory({super.key});

  @override
  State<TankerHistory> createState() => _TankerHistoryState();
}

class _TankerHistoryState extends State<TankerHistory> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late bool isEmpty = false;
  var phonecollection = FirebaseFirestore.instance.collection('profile');
  Future<void> checkIfCollectionExist(String collectionName, String uid) async {
    try {
      var value =
          await phonecollection.doc(uid).collection(collectionName).get();
      setState(() {
        isEmpty = value.docs.isNotEmpty;
      });
      //isEmpty = value.docs.isNotEmpty;
      //print(isEmpty);
    } catch (e) {
      rethrow;
    }
  }
  var uid = '';
  Future<void> _getuid() async {
    final user = auth.currentUser!;
    //var uid = user.uid;
    setState(() {
      uid = user.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getuid();
    checkIfCollectionExist('request_booking', uid);
  }
  Future deleteReqhist(String id) async {
  try {
      await phonecollection
          .doc(uid)
          .collection('request_booking')
          .doc(id)
          .delete();
          Fluttertoast.showToast(
          msg: "History Deleted Successfully",
          //toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 16,
        );
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
            'OTS-Tanker History',
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
      body:isEmpty
          ? SingleChildScrollView(
              child: SizedBox(
                //height: deviceSize.height,
                //width: deviceSize.width,
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
                                'DOUBLE TAP DETAIL TO REMOVE',
                                style: TextStyle(
                                  color: Colors.blue.shade900,
                                  fontSize: 15,
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
                      stream: phonecollection.doc(uid).collection('request_booking').snapshots(),
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
                                      deleteReqhist(snapshot
                                          .data!.docs[index].reference.id
                                          .toString());
                                    },
                                    child: Row(
                                      children: [
                                        // SizedBox(
                                        //   height:68,
                                        //   width: 80,
                                        //   child:
                                        Card(
                                          color: Colors.blue,
                                          child: Container(
                                            margin: const EdgeInsets.all(8),
                                            child: Column(
                                              children: [
                                                Text(
                                                  doc[index].get('Date'),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                Text(
                                                  doc[index].get('Day'),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //),
                                        //Card(
                                        //margin: const EdgeInsets.only(left: 70,right: 70),
                                        //color: Colors.grey.shade100,
                                        //child:
                                        Row(
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
                                                      const Text(
                                                          'Tanker ID : '),
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
                                                      const Text('Status : '),
                                                      Text(
                                                        doc[index]
                                                            .get('Status'),
                                                        style: const TextStyle(
                                                          color: Colors.green,
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
                                                        doc[index]
                                                            .get('Gallons'),
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
                                                      const Text('Amount: '),
                                                      Text(
                                                        doc[index]
                                                            .get('Amount'),
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
                                                      const Text('Delivery Charges : '),
                                                      Text(
                                                        doc[index]
                                                            .get('Delivery Charges'),
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
                                                      const Text('Water Charges : '),
                                                      Text(
                                                        doc[index]
                                                            .get('Water Charges'),
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
                                        //),
                                      ],
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
                'No history found',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
      );
  }
}