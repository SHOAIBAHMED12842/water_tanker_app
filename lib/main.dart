import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_number_otp/screens/admin_Reqhist.dart';
import 'package:phone_number_otp/screens/admin_dashboard.dart';
import 'package:phone_number_otp/screens/admin_request.dart';
import 'package:phone_number_otp/screens/admin_users.dart';
//import 'package:phone_number_otp/screens/booking_request.dart';
import 'package:phone_number_otp/screens/dashboard.dart';
import 'package:phone_number_otp/screens/dashboardOTS.dart';
import 'package:phone_number_otp/screens/otp.dart';
import 'package:phone_number_otp/screens/phone.dart';
import 'package:phone_number_otp/screens/profile_address.dart';
import 'package:phone_number_otp/screens/resquest_Tanker.dart';
import 'package:phone_number_otp/screens/splash_screen.dart';
import 'package:phone_number_otp/screens/tanker_History.dart';
import 'package:phone_number_otp/screens/terms_conditio.dart';
import 'package:phone_number_otp/screens/track_Tanker.dart';
import 'package:phone_number_otp/screens/userGuide.dart';
//import 'package:toast/toast.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //ToastContext.init(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KWSB OTS',
      //initialRoute: 'home',
      //initialRoute: 'phone',
      //initialRoute: 'admdash',
      routes: {
      'phone':(context) => const MyPhone(),
      'otp':(context) => MyOtp(),
      'home':(context) => const Dashboard(),
      'addr':(context) => ProfileAddress(),
      'terms':(context) => const TermCondition(),
      'ots':(context) => const DashboardOTS(),
      'retank':(context) => const RequestTanker(),
      'trtank':(context) => const TrackTanker(),
      'tahist':(context) => const TankerHistory(),
      'userguide':(context) => const UserGuide(),
      'admdash':(context) => const AdminDashboard(),
      'admuser':(context) => const AdminUsers(),
      'admreq':(context) => const AdminRequest(),
      'admreqhist':(context) => const AdminReqhist(),
      //'bookdash':(context) => const BookingRequest(),
    },
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (ctx, userSnapshot){   //all things will be notified such as token sigin signup etc
        if(userSnapshot.connectionState==ConnectionState.waiting){
          return const SplashScreen();
        }
        if(userSnapshot.hasData){
          return const Dashboard();
        }
        return const MyPhone();
      },
      
      ), 
    );
  }
}

// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     initialRoute: 'phone',
//     routes: {
//       'phone':(context) => MyPhone(),
//       'otp':(context) => MyOtp(),
//       'home':(context) => MyHome(),
//     },
//   ),
//   home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),builder: (ctx, userSnapshot){   //all things will be notified such as token sigin signup etc
//         if(userSnapshot.connectionState==ConnectionState.waiting){
//           return SplashScreen();
//         }
//         if(userSnapshot.hasData){
//           return MyHome();
//         }
//         return MyPhone();
//       }
//       ), 
//   );
// }



