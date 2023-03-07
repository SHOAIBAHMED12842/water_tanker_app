import 'package:flutter/material.dart';

class AddressCard1 extends StatelessWidget {
  //const AddressCard1({super.key});
  String cardmember;
  AddressCard1(this.cardmember);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
      ),
      child: Row(
        children: [
          Text(
            cardmember,
            style: const TextStyle(
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
