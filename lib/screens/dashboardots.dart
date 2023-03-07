import 'package:flutter/material.dart';
import 'package:phone_number_otp/widget/dashboard_widget.dart';

class DashboardOTS extends StatefulWidget {
  const DashboardOTS({super.key});

  @override
  State<DashboardOTS> createState() => _DashboardOTSState();
}

class _DashboardOTSState extends State<DashboardOTS> {
  @override
  Widget build(BuildContext context) {
    //final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'Online Tanker Service',
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
      body: SingleChildScrollView(
        child: SizedBox(
          //height: deviceSize.height,
          //width: deviceSize.width,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'retank'),
                child: DashboardWidget(
                    'Request Tanker',
                    'assets/images/tanker.png',
                  ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'trtank'),
                child: DashboardWidget(
                    'Track Tanker',
                    'assets/images/tanker.png',
                  ),
              ),
             GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'tahist'),
                child:DashboardWidget(
                    'Tanker History',
                    'assets/images/tanker.png',
                  ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, 'userguide'),
                child: DashboardWidget(
                    'User Guide',
                    'assets/images/tanker.png',
                  ),
              ),
              const SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}