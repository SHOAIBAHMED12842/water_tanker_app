import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:phone_number_otp/screens/profile_address.dart';
import 'package:phone_number_otp/widget/my_address.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  String location = '24.9180,67.0971';
  final FirebaseAuth auth = FirebaseAuth.instance;
  late bool isEmpty = false;
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
    checkIfCollectionExist('address_info', uid);
  }

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

  var phonecollection = FirebaseFirestore.instance.collection('profile');
  Future deleteAddr(String id) async {
    try {
      await phonecollection
          .doc(uid)
          .collection('address_info')
          .doc(id)
          .delete();
          Fluttertoast.showToast(
          msg: "Address Delete Successfully",
          //toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 25,
        );
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
          //   Container(
          // margin: const EdgeInsets.all(3),
          //child:
          Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                //width: MediaQuery.of(context).size.width,
                //height: MediaQuery.of(context).size.height,
                margin: const EdgeInsets.only(
                  right: 30,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyAddress(location),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: Colors.blue.shade900,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Add New',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          isEmpty
              ? Center(
                child: Text(
                    'DOUBLE TAP ADDRESS TO DELETE',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontSize: 20,
                    ),
                  ),
              )
              : Container(),
          StreamBuilder
              //<QuerySnapshot>
              (
            stream:
                phonecollection.doc(uid).collection('address_info').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          onDoubleTap: () {
                            deleteAddr(snapshot.data!.docs[index].reference.id
                                .toString());
                          },
                          child: Card(
                            color: Colors.grey.shade100,
                            child: Row(
                              children: [
                                //const Icon(Icons.home),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text('Place : '),
                                          Text(
                                            doc[index].get('place'),
                                          ),
                                          //ElevatedButton(onPressed: (){}, child: Icon(Icons.delete),),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      Row(
                                        children: [
                                          const Text('Address : '),
                                          Text(
                                            doc[index].get('address'),
                                            style: TextStyle(
                                              color: Colors.grey.shade600,
                                              fontSize: 11,
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
                      );
                    });
              } else {
                return const LinearProgressIndicator();
              }
            },
          ),
          const SizedBox(
            height: 175,
          ),
          !isEmpty
              ? const Center(
                  child: Text(
                    'No address found',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
      //);
    );
  }
}
