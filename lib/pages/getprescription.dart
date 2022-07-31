import 'package:flutter/material.dart';

class GetPrescriptionPage extends StatefulWidget {
  const GetPrescriptionPage({Key? key}) : super(key: key);

  @override
  State<GetPrescriptionPage> createState() => _GetPrescriptionPageState();
}

class _GetPrescriptionPageState extends State<GetPrescriptionPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SynapseRx'),
      ),
      body: Container(
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
              Image.asset(
                'assets/images/scan_qrcode.png',
                fit: BoxFit.fill,
              ),
              const Text(
                "Tap to Scan Prescription QR Code",
                style: TextStyle(
                  fontSize: 12.0,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w200,
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
                  fontWeight: FontWeight.w200,
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
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'A Patient ID is required';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Patient ID',
                            hintText: 'Enter Patient ID'),
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'A prescription code is required';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Presciption Code',
                              hintText: 'Enter Prescription Code'),
                          style: const TextStyle(
                            color: Color(0xFF000000),
                            fontWeight: FontWeight.w200,
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
                                getPrescription();
                              }
                            },
                            icon: const Icon(Icons.search),
                            label: const Text(
                              "Search for Prescription",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
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
                              primary: Colors.red,
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
                                fontWeight: FontWeight.w200,
                              ),
                            )),
                      ),
                    ]),
                  ))
            ]),
      ),
    );
  }

  void getPrescription() {}
}
