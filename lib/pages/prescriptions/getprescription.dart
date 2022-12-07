import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:synapserx_prescriber/pages/prescriptions/displayprescription.dart';

class GetPrescriptionPage extends StatefulWidget {
  const GetPrescriptionPage({Key? key}) : super(key: key);

  @override
  State<GetPrescriptionPage> createState() => _GetPrescriptionPageState();
}

class _GetPrescriptionPageState extends State<GetPrescriptionPage> {
  TextEditingController presciptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _scanBarcode = 'Unknown';
  @override
  void initState() {
    super.initState();
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      //print(barcodeScanRes);
      if (!mounted) return;
      if (barcodeScanRes != '-1') {
        setState(() {
          _scanBarcode = barcodeScanRes;
          getprescription();
        });
      }
    } on PlatformException {
      log('Platform related issues');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Get Prescription'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.center,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () => scanQR(),
                      child: Image.asset(
                        'assets/images/scan_qrcode.png',
                        fit: BoxFit.fill,
                      )),
                  const Text(
                    "Tap to Scan Prescription QR Code",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Color(0xFF000000),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                      key: _formKey,
                      child: SizedBox(
                        width: 300,
                        child: Column(children: [
                          // TextFormField(
                          //   validator: (value) {
                          //     if (value!.isEmpty) {
                          //       return 'A Patient ID is required';
                          //     }
                          //     return null;
                          //   },
                          //   decoration: const InputDecoration(
                          //       border: OutlineInputBorder(),
                          //       prefixIcon: Icon(Icons.person),
                          //       labelText: 'Patient ID',
                          //       hintText: 'Enter Patient ID'),
                          //   style: const TextStyle(
                          //     color: Color(0xFF000000),
                          //     fontWeight: FontWeight.w300,
                          //   ),
                          // ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                              controller: presciptionController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'A prescription code is required';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.code),
                                  labelText: 'Presciption Code',
                                  hintText: 'Enter Prescription Code'),
                              style: const TextStyle(
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.w300,
                              )),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton.icon(
                                key: null,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _scanBarcode = presciptionController.text;
                                    getprescription();
                                  }
                                },
                                icon: const Icon(Icons.search),
                                label: const Text(
                                  "Find Prescription",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton.icon(
                                key: null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.cancel),
                                label: const Text(
                                  "Cancel",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          ),
                        ]),
                      ))
                ]),
          ),
        ));
  }

  getprescription() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DisplayPrescriptionPage(prescriptionid: _scanBarcode),
      ),
    );
  }
}
