import 'dart:async';
import 'dart:ui';
//import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_number_otp/widget/dashboard_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:toast/toast.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  //  var subscriptions;
  // var connectionStatus;
  // checkInternetConnectivity() {
  //   if (connectionStatus == ConnectivityResult.none) {
  //     print(connectionStatus);
  //     return Fluttertoast.showToast(
  //         msg: "Check your internet connection",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.red,
  //         textColor: Colors.white,
  //         fontSize: 16.0
  //     );
  //   }
  // }
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
                Navigator.pop(context);
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
  late bool isEmpty1 = false;
  //bool isValid = true;
  final FirebaseAuth auth = FirebaseAuth.instance;
  var uid = '';

// void internet_connection()async{
//   try {
//   final result = await InternetAddress.lookup('example.com');
//   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//     print('connected');
//   }
// } on SocketException catch (_) {
//   print('not connected');
//   AlertDialog(
//         title: const Text('Alert'),
//         content: const Text('Internet not connected'),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Ok'),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Dashboard(),
//                 ),
//               );
//             },
//           ),
//         ],
//       );

// }
// }
  Future<void> _getphoneno() async {
    final user = auth.currentUser!;
    //var uid = user.uid;
    setState(() {
      uid = user.uid;
      mobileno = '0${user.phoneNumber.toString().substring(3)}';
    });

    if (mobileno == '03322045416' ||
        mobileno == '03338286467' ||
        mobileno == '03312571764' ||
        mobileno == '03242661295') {
      //.uid=='IWrG5UPgBqaNVbDt5g2dnhSFU572'
      Future.delayed(Duration.zero, () {
        Navigator.pushNamedAndRemoveUntil(context, 'admdash', (route) => false);
      });
    }
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
      //return value.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkIfCollectionExist1(String uid) async {
    try {
      var value = await phonecollection.doc(uid).get();
      setState(() {
        isEmpty1 = value.exists;
      });
      //isEmpty = value.docs.isNotEmpty;
      //print(isEmpty);
      //return value.docs.isNotEmpty;
    } catch (e) {
      rethrow;
    }
  }

//  bool ActiveConnection = false;
//   String T = "";
//   Future CheckUserConnection() async {
//     try {
//       final result = await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         setState(() {
//           ActiveConnection = true;
//           Fluttertoast.showToast(
//           msg: "Turn off the data and repress again",
//           //toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 5,
//           backgroundColor: Colors.grey.shade200,
//           textColor: Colors.black,
//           fontSize: 16,
//         );
//           //T = "Turn off the data and repress again";
//         });
//       }
//     } on SocketException catch (_) {
//       setState(() {
//         ActiveConnection = false;
//          Fluttertoast.showToast(
//           msg: "Turn On the data and repress again",
//           //toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 5,
//           backgroundColor: Colors.grey.shade200,
//           textColor: Colors.black,
//           fontSize: 16,
//         );
//         //T = "Turn On the data and repress again";
//       });
//     }
//   }
//late FToast fToast;
// StreamSubscription? internetconnection;
//   bool isoffline = false;
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
    // internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //     // whenevery connection status is changed.
    //     if(result == ConnectivityResult.none){
    //          //there is no any connection
    //          setState(() {
    //              isoffline = true;
    //          });
    //     }else if(result == ConnectivityResult.mobile){
    //          //connection is mobile data network
    //          setState(() {
    //             isoffline = false;
    //          });
    //     }else if(result == ConnectivityResult.wifi){
    //         //connection is from wifi
    //         setState(() {
    //            isoffline = false;
    //         });
    //     }
    // });

    getConnectivity();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    //CheckUserConnection();

    // checkInternetConnectivity();

    //   subscriptions = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   setState(() {
    //     connectionStatus = result;
    //   });
    //   checkInternetConnectivity();
    // });
    // TODO: implement initState
    super.initState();

    _getphoneno();

    checkIfCollectionExist1(uid);
    checkIfCollectionExist('address_info', uid);
    // fToast = FToast();
    // fToast.init(context);
    //internet_connection();
    //_addrDataExist();
  }

  @override
  void dispose() {
    //internetconnection!.cancel();
    // TODO: implement dispose
    //subscriptions.cancel();
    _connectivitySubscription.cancel();
    subscription.cancel();
    super.dispose();
  }

  var phonecollection = FirebaseFirestore.instance.collection('profile');
  @override
  Widget build(BuildContext context) {
    //ToastContext.init(context);
    //isEmpty=checkIfCollectionExist('address_info',uid) as bool;
    //final deviceSize = MediaQuery.of(context).size;
    void _signout() {
      FirebaseAuth.instance.signOut();
      Fluttertoast.showToast(
        msg: "$mobileno Logout Successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: Colors.grey.shade200,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      Navigator.pushNamed(context, 'phone');
    }

    //final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
              // Container(
              //        child: errmsg("No Internet Connection Available", isoffline),
              //        //to show internet connection message on isoffline = true.
              //     ),
              !isEmpty1
                  ? Text(
                      '    Kindly fill profile info detail to appear info here',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  : FutureBuilder<DocumentSnapshot>(
                      //Fetching data from the uid specified of the profile
                      future: phonecollection.doc(uid).get(),
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
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                "    ${data['name']}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              isEmpty
                                  ? Text(
                                      "      $mobileno",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : Container(),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          );
                        }
                        return const Center(child: LinearProgressIndicator());
                      },
                    ),
              SizedBox(
                height: 10,
              ),
              isEmpty
                  ? Container()
                  : Container(
                      width: double.infinity,
                      color: Colors.red,
                      padding: const EdgeInsets.all(5),
                      child: const Text(
                        //'Please register & add address to use tanker online service.',
                        'Please add address in profile info to use tanker service',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
              const SizedBox(
                height: 10,
              ),
              isEmpty
                  ? GestureDetector(
                      onTap: () => Navigator.pushNamed(context, 'ots'),
                      child: DashboardWidget(
                        'Online Tanker Service',
                        'assets/images/tanker.png',
                      ),
                    )
                  : GestureDetector(
                      onTap: () {},
                      child: DashboardWidget(
                        'Online Tanker Service',
                        'assets/images/tanker.png',
                      ),
                    ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'addr'),
                child: DashboardWidget(
                  'Profile Information',
                  'assets/images/profile.png',
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'terms'),
                child: DashboardWidget(
                  'User Guide / FAQS / Terms & Conditions',
                  'assets/images/book.png',
                ),
              ),
              InkWell(
                //onTap: _showsnakebar,
                onTap: () async {
                  Uri phoneno =
                      Uri.parse('tel:+923322045416'); //'tel:+923041112482'
                  if (await launchUrl(phoneno)) {
                    //dialer opened
                  } else {
                    //dailer is not opened
                  }
                },
                child: DashboardWidget(
                  'Contact Us',
                  'assets/images/contact.png',
                ),
              ),
              InkWell(
                //onTap:  _showsnakebar,
                onTap: () {
                  //Toast.show("COMMING SOON", duration: 3, gravity:  Toast.bottom);//Toast.lengthShort
                  Fluttertoast.showToast(
                      msg: "Coming Soon",
                      //toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: DashboardWidget(
                  'Complaint Management System',
                  'assets/images/bad-review.png',
                ),
              ),
              InkWell(
                //onTap: _showsnakebar,
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Coming Soon",
                      //toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
                child: DashboardWidget(
                  'Water Connection Request',
                  'assets/images/water.png',
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
// Widget errmsg(String text,bool show){
//   //error message widget.
//       if(show == true){
//         //if error is true then show error message box
//         return Container(
//             padding: EdgeInsets.all(10.00),
//             margin: EdgeInsets.only(bottom: 10.00),
//             color: Colors.red,
//             child: Row(children: [

//                 Container(
//                     margin: EdgeInsets.only(right:6.00),
//                     child: Icon(Icons.info, color: Colors.white),
//                 ), // icon for error message

//                 Text(text, style: TextStyle(color: Colors.white)),
//                 //show error message text
//             ]),
//         );
//       }else{
//          return Container();
//          //if error is false, return empty container.
//       }
//   }
