import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import '../common/service.dart';

class AddAssociationsPage extends StatefulWidget {
  const AddAssociationsPage({Key? key}) : super(key: key);

  @override
  State<AddAssociationsPage> createState() => _AddAssociationsPageState();
}

class _AddAssociationsPageState extends State<AddAssociationsPage> {
  TextEditingController patientidController = TextEditingController();
  static String accessToken = GlobalData.accessToken;
  final _formKey = GlobalKey<FormState>();
  final DioClient _dioClient = DioClient();
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
      _scanBarcode = barcodeScanRes;
      addAssociation();
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Add Patient'),
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    GestureDetector(
                        onTap: () => scanQR(),
                        child: Image.asset(
                          'assets/images/scan_qrcode.png',
                          fit: BoxFit.fill,
                        )),
                    const Text(
                      "Tap to Scan Patient QR Code",
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
                    const Text('Enter Patient ID to add'),
                    const SizedBox(height: 20),
                    Form(
                        key: _formKey,
                        child: SizedBox(
                            width: 300,
                            child: Column(children: [
                              TextFormField(
                                controller: patientidController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'A Patient ID is required';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.person),
                                    labelText: 'Patient ID',
                                    hintText: 'Enter Patient ID'),
                                style: const TextStyle(
                                  color: Color(0xFF000000),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                    key: null,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _scanBarcode = patientidController.text;
                                        addAssociation();
                                      }
                                    },
                                    icon: const Icon(Icons.person_add),
                                    label: const Text('Add Patient',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ))),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                    key: null,
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.cancel),
                                    label: const Text('Cancel',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ))),
                              ),
                            ])))
                  ]),
            ),
          )));

  Future<void> addAssociation() async {
    patientidController.text = _scanBarcode;
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Processing Data'),
        backgroundColor: Colors.blue.shade300,
      ));
      dynamic response = await _dioClient.addAssociation(
          token: accessToken, patientid: _scanBarcode);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      if (response['ErrorCode'] == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Patient: ${response['patientFullname']} added'),
          backgroundColor: Colors.green.shade300,
        ));
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Error: Unable to add patient'),
          backgroundColor: Colors.red.shade300,
        ));
      }
    }
    setState(() {});
  }
}
