import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TermCondition extends StatefulWidget {
  const TermCondition({super.key});

  @override
  State<TermCondition> createState() => _TermConditionState();
}

class _TermConditionState extends State<TermCondition> {
  // final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        toolbarHeight: 80,
        title: const Center(
          child: Text(
            'User Guide / FAQS / Terms & Conditions',
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
      body: 
          // SfPdfViewer.network(
          //     'https://cdn.syncfusion.com/content/PDFViewer/encrypted.pdf',
          //     password: 'syncfusion'),
      // SfPdfViewer.network(
      //     'https://cdn.websitepolicies.com/wp-content/uploads/2022/04/terms-and-conditions-template.pdf',key: _pdfViewerKey,),
      SfPdfViewer.asset(
              'assets/terms-and-conditions-template.pdf'),
    );
  }
}
