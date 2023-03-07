import 'package:flutter/material.dart';

class AddressCard extends StatelessWidget {
  //const AddressCard({super.key});
  String cardmember;
  AddressCard(this.cardmember);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 30,
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
