//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
//import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:phone_number_otp/screens/dashboard.dart';
//import 'package:phone_number_otp/screens/profile_address.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _formKey2 = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  String? name, email, mobileno;
  bool isValid = false;
  final FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _nameController.addListener(
      () {
        if (_nameController.text.isEmpty) {
          setState(() {
            isValid = false;
          });
        } else {
          setState(() {
            isValid = true;
          });
        }
      },
    );
    _emailController.addListener(
      () {
        if (_emailController.text.isEmpty) {
          setState(() {
            isValid = false;
          });
        } else {
          setState(() {
            isValid = true;
          });
        }
      },
    );
    _getphoneno();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    //_mobileFocusNode.dispose();
    //_dateFocusNode.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  var uid = '';
  Future<void> _getphoneno() async {
    final user = auth.currentUser!;
    //var uid = user.uid;
    setState(() {
      uid = user.uid;
      mobileno = '0${user.phoneNumber.toString().substring(3)}';
      _mobileController.text = mobileno!;
    });
  }

  var phonecollection = FirebaseFirestore.instance.collection('profile');
  @override
  Widget build(BuildContext context) {
    void update() async {
      final isValid = _formKey2.currentState!.validate();
      //print(uid);
      FocusScope.of(context).unfocus();
      if (isValid) {
        _formKey2.currentState!.save();
        await phonecollection.doc(uid).set({
          'name': name,
          'email': email,
          'phone no': mobileno,
        });
        // _nameController.clear();
        // _emailController.clear();
        Fluttertoast.showToast(
          msg: "Profile Updated Successfully",
          //toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 5,
          backgroundColor: Colors.grey.shade200,
          textColor: Colors.black,
          fontSize: 16,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Dashboard(),
          ),
        );
        
      }
    }
    return Container(
      margin: const EdgeInsets.all(7),
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(
            left: 10,
          ),
          child: Form(
            key: _formKey2,
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              shrinkWrap: true,
              //mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: const ValueKey('name'),
                  controller: _nameController,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.characters,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.next,
                  focusNode: _nameFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_emailFocusNode);
                  },
                  inputFormatters: const [],
                  onSaved: (value) {
                    _nameController.value = TextEditingValue(
                      text: value!.toUpperCase(),
                      selection: _nameController.selection,
                    );
                    name = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Can\'t be empty';
                    }
                    if (value.length < 4) {
                      return 'Too short';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.name,
                  decoration: const InputDecoration(
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Email',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: const ValueKey('email'),
                  autocorrect: false,
                  controller: _emailController,
                  textCapitalization: TextCapitalization.none,
                  textInputAction: TextInputAction.next,
                  enableSuggestions: false,
                  focusNode: _emailFocusNode,
                  // onFieldSubmitted: (_) {
                  //   FocusScope.of(context).requestFocus(_mobileFocusNode);
                  // },
                  onSaved: (value) {
                    email = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty ||
                        !value.contains('@') ||
                        !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Mobile No.',
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  key: const ValueKey('mobileno'),
                  controller: _mobileController,
                  enabled: false,
                  enableSuggestions: false,
                ),
                const SizedBox(
                  height: 30,
                ),
                Container(
                  margin: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      update();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isValid ? Colors.blue.shade900 : Colors.blue.shade200,
                    ),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                        color: isValid ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
