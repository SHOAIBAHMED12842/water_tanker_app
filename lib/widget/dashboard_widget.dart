import 'package:flutter/material.dart';

class DashboardWidget extends StatelessWidget {
  DashboardWidget(this.name, this.image);
  final String name;
  final String image;
  

  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return SizedBox(
      //height: deviceSize.height,
      //width: deviceSize.width,
      child: Card(
        elevation: 8,
                  shadowColor: Colors.grey,
                  margin: const EdgeInsets.only(left: 20,right: 20,bottom: 15,top: 15,),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
        child: Container(
                      height: 110,
                      margin: const EdgeInsets.only(top: 20,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ),
                              ),
                              Container(
                                child: Image.asset(
                                    image,
                                    height: 50,
                                    width: 100,
                                  ),
                              ),
                            ],
                          ),
                          Container(
                            height: 50,
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 10,),
                            child: const Icon(
                              Icons.arrow_right_alt_sharp,
                              color: Colors.blue,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
      ),
    );
  }
}