import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsers extends StatefulWidget {
  const AdminUsers({super.key});

  @override
  State<AdminUsers> createState() => _AdminUsersState();
}

class _AdminUsersState extends State<AdminUsers> {
  var phonecollection = FirebaseFirestore.instance.collection('profile');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'Users Detail',
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
      body: SingleChildScrollView(
        child: SizedBox(
          //height: deviceSize.height,
          //width: deviceSize.width,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20,),
              StreamBuilder
              //<QuerySnapshot>
              (
            stream:
                phonecollection.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                var doc = snapshot.data!.docs;
                return ListView.builder(
                    scrollDirection: Axis
                        .vertical, //Vertical viewport was given unbounded height resolve
                    shrinkWrap:
                        true, //Vertical viewport was given unbounded height resolve
                        physics: const NeverScrollableScrollPhysics(),//Singlechildscrollview Doesn'T Scroll Screen With Listview.Builder
                    itemCount: doc.length,
                    itemBuilder: (context, index) {
                      return 
                      Padding(
                        padding: const EdgeInsets.only(right: 15,left: 15,top: 4,bottom: 4,),
                        child: 
                        // GestureDetector(
                        //   onTap: () {
                        //     deleteAddr(snapshot.data!.docs[index].reference.id
                        //         .toString());
                        //   },
                        //   child: 
                          Card(
                            //color: Colors.grey.shade100,
                            child: Row(
                              children: [
                                //const Icon(Icons.home),
                                Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          const Text('Name : '),
                                          Text(
                                            doc[index].get('name'),style: TextStyle(
                                              color: Colors.blue.shade900,
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
                                          const Text('Phone no : '),
                                          Text(
                                            doc[index].get('phone no'),
                                            style:  TextStyle(
                                              color: Colors.blue.shade900,
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
      ),
    );
  }
}