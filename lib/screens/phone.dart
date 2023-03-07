import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
//import 'package:pinput/pinput.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
//import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';

String? globalsverify;

class MyPhone extends StatefulWidget {
  const MyPhone({super.key});
  static String verify = '';

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
   final Connectivity _connectivity = Connectivity();
  late StreamSubscription< ConnectivityResult > _connectivitySubscription;
  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  void dismissKeyboard() {
    focusNode.unfocus();
  }
showDialogBox() => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity',),
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
  //TextEditingController phonecontroller = TextEditingController();
  late FocusNode focusNode;
  bool _validate = false;
  var phone = '';
  final _auth = FirebaseAuth.instance;
  //static String verify = '';
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   countrycode.text = '+92';
  //   //image=Image.asset('assets/images/pakistan.png') as String ;
  //   super.initState();
  // }
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
    // TODO: implement initState
    getConnectivity();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_UpdateConnectionState);
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    subscription.cancel();
    focusNode.dispose();

    super.dispose();
  }
  // @override
  // void dispose() {
  //   phonecontroller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: deviceSize.height,
        width: deviceSize.width,
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/img1.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: const Text(
                    'Please enter your mobile number to continue.',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    //textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 60,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 75,
                        child: TextField(
                          //controller: countrycode,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    height: 40,
                                    child: Image.asset(
                                      'assets/images/pakistan.png',
                                      //height: 1,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(child: const Text('+92')),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '|',
                        style: TextStyle(fontSize: 50, color: Colors.grey),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          focusNode: focusNode,
                          keyboardType: TextInputType.phone,
                          maxLength: 11,
                          onChanged: (value) {
                            phone = value;
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: '0300 123 4567',
                            errorText: _validate
                                ? 'Phone number Can\'t Be Empty'
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        dismissKeyboard();
                        setState(() {
                          phone.isEmpty ? _validate = true : _validate = false;
                        });

                        await _auth.verifyPhoneNumber(
                          phoneNumber: '+92${phone.toString().substring(1)}',
                          timeout: Duration(seconds: 60),
                          codeAutoRetrievalTimeout: (String verificationId) {
                            verificationId = verificationId;
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  //title: const Text('OTP is Expired!'),
                                  content:
                                      Text("     OTP is Expired!"),
                                  //content:  Text(e.toString()),
                                  //Text('Did\'nt verify press ok to try again!'),
                                  // actions: [
                                  //   Row(
                                  //     children: [
                                  //       SizedBox(
                                  //         width: 65,
                                  //       ),
                                  //       Center(
                                  //         child: ElevatedButton(
                                  //           onPressed: () {
                                  //             Navigator.push(
                                  //               context,
                                  //               MaterialPageRoute(
                                  //                 builder: (context) =>
                                  //                     MyPhone(),
                                  //               ),
                                  //             );
                                  //           },
                                  //           child: Container(
                                  //             width: 90,
                                  //             child: Text(
                                  //               "EDIT PHONE NO",
                                  //               style: TextStyle(fontSize: 10),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ],
                                );
                              },
                            );
                          },
                          codeSent: (String verificationId,
                              int? forceResendingToken) {
                            MyPhone.verify = verificationId;
                            Navigator.pushNamed(context, 'otp');
                            Fluttertoast.showToast(
                              msg: "OTP Send Successfully",
                              //toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey.shade200,
                              textColor: Colors.black,
                              fontSize: 16,
                            );
                          },
                          verificationCompleted:
                              (PhoneAuthCredential authCredential) {},
                          verificationFailed:
                              (FirebaseAuthException authException) {
                            Fluttertoast.showToast(
                              msg: "${authException.toString().substring(34,72)} mobile no${authException.toString().substring(79)} ",
                              //toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.grey.shade200,
                              textColor: Colors.black,
                              fontSize: 16,
                            );
                            //print(authException.message);
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Get OTP for Verification'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
