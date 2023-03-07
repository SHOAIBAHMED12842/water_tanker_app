import 'package:flutter/material.dart';
import 'package:phone_number_otp/widget/profile_widget.dart';

class ProfileAddress extends StatefulWidget {
  @override
  State<ProfileAddress> createState() => _ProfileAddressState();
}

class _ProfileAddressState extends State<ProfileAddress> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'Profile/Addresses',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, 'home');
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: SizedBox(
        //height: deviceSize.height,
        //width: deviceSize.width,
        width: MediaQuery.of(context).size.width,
        //scrollDirection: Axis.vertical,
          child: ProfileWidget(),
        ),
      ),
    );
  }
}
