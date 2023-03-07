import 'package:flutter/material.dart';
import 'package:phone_number_otp/widget/reqtank_widget.dart';

class RequestTanker extends StatefulWidget {
  const RequestTanker({super.key});

  @override
  State<RequestTanker> createState() => _RequestTankerState();
}

class _RequestTankerState extends State<RequestTanker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'OTS-Request Tanker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: const ReqTankWidget(),
        ),
      ),
    );
  }
}
