//import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_number_otp/screens/phone.dart';
//import 'package:flutter/src/widgets/container.dart';
//import 'package:flutter/src/widgets/framework.dart';
import 'package:pinput/pinput.dart';

class MyOtp extends StatefulWidget {
  //const MyWidget({super.key});

  @override
  State<MyOtp> createState() => _MyOtpState();
}

class _MyOtpState extends State<MyOtp> {
  var code = '007';
  var mobileno;

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
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
                  height: 25,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: const Text(
                    'Phone Verification',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: TweenAnimationBuilder(
                    tween: Tween(begin: 60.0, end: 0),
                    duration: Duration(seconds: 60),
                    builder: (context, value, child) {
                      double val = value as double;
                      int time = val.toInt();
                      return Text(
                        "Enter your OTP in $time to continue",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                    onEnd: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPhone(),
                        ),
                      );
                    },
                  ),
                  // const Text(
                  //   'Enter your OTP to continue ',
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  child: Pinput(
                      length: 6,
                      showCursor: true,
                      onCompleted: (value) {
                        code = value;
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          //AuthCredential authCredential = PhoneAuthProvider.credential(smsCode: code, verificationId: MyPhone.verify);
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: MyPhone.verify,
                                  smsCode: code);
                          //print(MyPhone.verify);
                          // Sign the user in (or link) with the credential
                          await FirebaseAuth.instance
                              .signInWithCredential(credential);
                          mobileno = FirebaseAuth
                              .instance.currentUser!.phoneNumber
                              .toString()
                              .substring(3);
                          //await authlogin(credential);
                          //     print("Phone number automatically verified and user signed in: ${FirebaseAuth.instance.currentUser!.uid}");
                          if (mobileno == '3322045416' ||
                              mobileno == '3338286467' ||
                              mobileno == '3312571764' ||
                              mobileno == '3242661295') {
                            //.uid=='IWrG5UPgBqaNVbDt5g2dnhSFU572'
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'admdash', (route) => false);
                            Fluttertoast.showToast(
                              msg: "Admin Login Successfully",
                              //toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.grey.shade200,
                              textColor: Colors.black,
                              fontSize: 16,
                            );
                          } else {
                            Navigator.pushNamedAndRemoveUntil(
                                context, 'home', (route) => false);
                            Fluttertoast.showToast(
                              msg:
                                  "0${FirebaseAuth.instance.currentUser!.phoneNumber.toString().substring(3)} Login Successfully",
                              //toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: Colors.grey.shade200,
                              textColor: Colors.black,
                              fontSize: 16,
                            );
                          }
                        } catch (e) {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('OTP Alert Messege!'),
                                content: Text(
                                    "Kindly entered OTP/You Entered wrong OTP"),
                                //content:  Text(e.toString()),
                                //Text('Did\'nt verify press ok to try again!'),
                                actions: [
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) => MyOtp(),
                                          //   ),
                                          // );
                                        },
                                        child: Container(
                                          width: 100,
                                          child: Text(
                                            "RE-ENTERED OTP",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MyPhone(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 90,
                                          child: Text(
                                            "EDIT PHONE NO",
                                            style: TextStyle(fontSize: 10),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('Verify phone number'),
                    ),
                  ),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, 'phone', (route) => false);
                      },
                      child: const Text(
                        'Edit Phone Number?',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  //  void setError(message) {
  //   showDialog(
  //                         context: context,
  //                         builder: (context) {
  //                           return AlertDialog(
  //                             title: const Text('OTP Alert Messege!'),
  //                             content: Text(message.toString()),
  //                             //Text('Did\'nt verify press ok to try again!'),
  //                             actions: [
  //                               ElevatedButton(
  //                                 onPressed: () {
  //                                   Navigator.push(
  //                                     context,
  //                                     MaterialPageRoute(
  //                                       builder: (context) => MyOtp(),
  //                                     ),
  //                                   );
  //                                 },
  //                                 child: Text("OK"),
  //                               ),
  //                             ],
  //                           );
  //                         },
  //                       );
  //  }

  // void notifyListeners() {}
}
