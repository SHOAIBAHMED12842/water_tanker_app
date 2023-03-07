// import 'dart:async';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class CheckConnection extends StatefulWidget{
//   @override
//   State createState() {
//     return _CheckConnection();
//   }
// }

// class _CheckConnection extends State{
//   StreamSubscription? internetconnection;
//   bool isoffline = false;
//   //set variable for Connectivity subscription listiner
  
//   @override
//   void initState() {
//     internetconnection = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//         // whenevery connection status is changed.
//         if(result == ConnectivityResult.none){
//              //there is no any connection
//              setState(() {
//                  isoffline = true;
//              }); 
//         }else if(result == ConnectivityResult.mobile){
//              //connection is mobile data network
//              setState(() {
//                 isoffline = false;
//              });
//         }else if(result == ConnectivityResult.wifi){
//             //connection is from wifi
//             setState(() {
//                isoffline = false;
//             });
//         }
//     }); // using this listiner, you can get the medium of connection as well.

//     super.initState();
//   }

//   @override
//   dispose() {
//     super.dispose();
//     internetconnection!.cancel();
//     //cancel internent connection subscription after you are done
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(title:Text("Check Connection")),
//         body:SingleChildScrollView( 
//              child: Column(children: [
                  
//                   Container( 
//                      child: errmsg("No Internet Connection Available", isoffline),
//                      //to show internet connection message on isoffline = true.
//                   ),

//                   Container( 
//                      //this is your content
//                       margin: EdgeInsets.all(30),
//                       width:double.infinity,
//                       child: Center( 
//                          child:Text("Check Connections",
//                             style:TextStyle(fontSize:20)
//                          )
//                       )
//                   )

//              ],)
//         )
//     );
//   }

//   Widget errmsg(String text,bool show){
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
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class SubCategoery extends StatefulWidget {
//   final doc;
//   SubCategoery(this.doc); 

//   @override
//   _SubCategoryClassState createState() => _SubCategoryClassState();
// }

// class _SubCategoryClassState extends State<SubCategoery> {
//   final db = Firestore.instance;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("SubCategories"),
//         centerTitle: true,
//       ),
//       body: new StreamBuilder<QuerySnapshot>(
//         stream: db
//             .collection('Users')
//             .document(widget.doc)
//             .collection('TestSubCollection')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             var doc = snapshot.data.documents;
//             return new ListView.builder(
//                 itemCount: doc.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Card(
//                       child: Column(
//                         children: <Widget>[
//                           Text(doc[index].data['Course']),
//                           SizedBox(
//                             height: 10.0,
//                           ),
//                           Text(doc[index].data['other']),
//                         ],
//                       ),
//                     ),
//                   );
//                 });
//           } else {
//             return LinearProgressIndicator();
//           }
//         },
//       ),
//     );
//   }
// }