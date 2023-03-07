import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookingRequest extends StatefulWidget {
  String? TankerID;
  BookingRequest(this.TankerID, {super.key});

  @override
  State<BookingRequest> createState() => _BookingRequestState();
}

class _BookingRequestState extends State<BookingRequest> {
  var tankid;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tankid = widget.TankerID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //width: deviceSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Image.asset(
                  'assets/images/img1.png',
                  width: 200,
                  height: MediaQuery.of(context).size.height - 300,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 70,
                  width: 90,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'Booking Received',
                  style: TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  'REQUEST TANKER NO',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  tankid,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Center(
                child: Container(
                  height: 45,
                  width: double.infinity,
                  margin: const EdgeInsets.all(15),
                  child: ElevatedButton(
                    onPressed: () {
                      Fluttertoast.showToast(
                        msg: "Request($tankid) Booked Successfully",
                        //toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 5,
                        backgroundColor: Colors.grey.shade200,
                        textColor: Colors.black,
                        fontSize: 16,
                      );
                      Navigator.pushNamed(context, 'trtank');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                    ),
                    child: const Text(
                      'DONE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
