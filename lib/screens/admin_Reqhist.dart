import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminReqhist extends StatefulWidget {
  const AdminReqhist({super.key});

  @override
  State<AdminReqhist> createState() => _AdminReqhistState();
}

class _AdminReqhistState extends State<AdminReqhist> {
  late bool isEmpty = false;
  var historycollection =
      FirebaseFirestore.instance.collection('booking_history');
  Future<void> checkIfCollectionExist() async {
    try {
      var value = await historycollection.get();
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

  Future deleteReqhist(String id) async {
    await historycollection.doc(id).delete();
     Fluttertoast.showToast(
          msg: "Delete Approved Request Successfully",
          //toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 16,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'Approved History',
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
                      stream: historycollection.snapshots(),
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
