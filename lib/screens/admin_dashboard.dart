import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widget/dashboard_widget.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;

  showDialogBox() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(
                  context,
                );
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          }
        },
      );
  bool isAlertSet = false;
  String mobileno = '';
  late bool isEmpty = false;
  //bool isValid = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid = '';
  var phonecollection = FirebaseFirestore.instance.collection('profile');
  Future<void> _getphoneno() async {
    final user = auth.currentUser!;
    //var uid = user.uid;
    setState(() {
      uid = user.uid;
      mobileno = '0${user.phoneNumber.toString().substring(3)}';
    });
  }

  Future<void> checkIfCollectionExist(String uid) async {
    try {
      var value = await phonecollection.doc(uid).get();
      setState(() {
        isEmpty = value.exists;
      });
      //isEmpty = value.docs.isNotEmpty;
      //print(isEmpty);
      //return value.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }
  Future< void > initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print("Error Occurred: ${e.toString()} ");
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _UpdateConnectionState(result);
  }
  Future<void> _UpdateConnectionState(ConnectivityResult result) async {
    if (result == ConnectivityResult.mobile ||
        result == ConnectivityResult.wifi) {
      showStatus(result, true);
    } else {
      showStatus(result, false);
    }
  }
  void showStatus(ConnectivityResult result, bool status) {
    final snackBar = SnackBar(
        content:
            Row(
              children: [
                Icon(Icons.wifi,color: Colors.white,),
                SizedBox(width: 5,),
                Text("${status ? 'Internet is Connected' : 'Internet is not Connected kindly connect it'} "),
              ],
            ),//${result.toString()
        backgroundColor: status ? Colors.green : Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    getConnectivity();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    // TODO: implement initState
    super.initState();
    _getphoneno();
    checkIfCollectionExist(uid);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectivitySubscription.cancel();
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    void _signout() {
      FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
        msg: "Admin Logout Successfully",
        //toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      Navigator.pushNamed(context, 'phone');
    }

    return Scaffold(
      //key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          //height: deviceSize.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/img1.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                  child: Text(
                'ADMIN PANEL',
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.blue.shade900,
                ),
              )),
              // !isEmpty
              //     ? Container(
              //         width: double.infinity,
              //         color: Colors.red,
              //         padding: const EdgeInsets.all(5),
              //         child: const Text(
              //           //'Please register & add address to use tanker online service.',
              //           'Admin Profile Not Found Kindly Insert Details Maunnaly in Database',
              //           style: TextStyle(
              //             fontSize: 15,
              //             color: Colors.white,
              //           ),
              //           textAlign: TextAlign.start,
              //         ),
              //       )
              //     : FutureBuilder<DocumentSnapshot>(
              //         //Fetching data from the uid specified of the profile
              //         future: phonecollection.doc(uid).get(),
              //         builder: (BuildContext context,
              //             AsyncSnapshot<DocumentSnapshot> snapshot) {
              //           //Error Handling conditions
              //           if (snapshot.hasError) {
              //             return Container();
              //           }
              //           if (snapshot.hasData && !snapshot.data!.exists) {
              //             return Container();
              //           }

              //           //Data is output to the user
              //           if (snapshot.connectionState == ConnectionState.done) {
              //             Map<String, dynamic> data =
              //                 snapshot.data!.data() as Map<String, dynamic>;
              //             return Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 const SizedBox(
              //                   height: 10,
              //                 ),
              //                 Text(
              //                   "    ${data['name']}",
              //                   style: const TextStyle(
              //                     fontSize: 18,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 Text(
              //                   "      $mobileno",
              //                   style: const TextStyle(
              //                     fontSize: 12,
              //                     color: Colors.black,
              //                     fontWeight: FontWeight.bold,
              //                   ),
              //                 ),
              //                 const SizedBox(
              //                   height: 8,
              //                 ),
              //               ],
              //             );
              //           }
              //           return const LinearProgressIndicator();
              //         },
              //       ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'admreq'),
                child: DashboardWidget(
                  'Users Request',
                  'assets/images/personal.png',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'admreqhist'),
                child: DashboardWidget(
                  'Tanker Request History',
                  'assets/images/history.png',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'admuser'),
                child: DashboardWidget(
                  'All Users',
                  'assets/images/team.png',
                ),
              ),
              InkWell(
                onTap: _signout,
                //(){_signout;},
                //_signout,
                child: DashboardWidget(
                  'Logout',
                  'assets/images/logout.png',
                ),
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
