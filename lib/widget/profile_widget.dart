import 'package:flutter/material.dart';
import 'package:phone_number_otp/widget/address_widget.dart';
import 'package:phone_number_otp/widget/profile_form.dart';

class ProfileWidget extends StatefulWidget {

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool presssedButton = false;
  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
        //child: SizedBox(
          //height: deviceSize.height,
          //width: deviceSize.width,
          //width: MediaQuery.of(context).size.width,
          //height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              SizedBox(
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                         setState(
                          () => presssedButton = !presssedButton,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20), 
                        backgroundColor: presssedButton ? Colors.white : Colors.blue.shade900,
                         side: BorderSide(
                          color:  Colors.blue.shade900,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.zero,
                            bottomRight: Radius.zero,
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                        ),
                      ),
                      child: Text('PROFILE',style: TextStyle(
                          color: presssedButton ? Colors.blue.shade900 : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(
                          () => presssedButton = !presssedButton,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(20), 
                        backgroundColor: presssedButton ? Colors.blue.shade900 : Colors.white,
                        side: BorderSide(
                          color: Colors.blue.shade900,
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.zero,
                            bottomLeft: Radius.zero,
                            topRight: Radius.circular(5),
                            bottomRight: Radius.circular(5),
                          ),
                        ),
                      ),
                      child: Text(
                        'ADDRESSES',
                        style: TextStyle(
                          color: presssedButton ? Colors.white : Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15,),
              !presssedButton ? const ProfileForm() : const AddressWidget(),
            ],
          ),
        //),
      );
  }
}