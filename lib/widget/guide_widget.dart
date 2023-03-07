import 'package:flutter/material.dart';

class GuideWidget extends StatelessWidget {
  GuideWidget(this.question,);
  final String question;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade700,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 160,
                child: Card(
                  color: Colors.grey.shade200,
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
                    top: 10,
                  ),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  child: Image.asset(
                    'assets/images/tanker.png',
                    width: 120,
                  ),
                ),
              ),
              Container(
                color: Colors.grey.shade200,
                padding: const EdgeInsets.only(
                  left: 5,
                  right: 5,
                  bottom: 15,
                  top: 3,
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/youtube.png',
                          width: 45,
                        ),
                        const Text('Watch Video'),
                      ],
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/images/docs.png',
                          width: 45,
                        ),
                        const Text('Read Text'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
