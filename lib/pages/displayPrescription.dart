import 'package:flutter/material.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/models/prescription.dart';

class DisplayPrescriptionPage extends StatefulWidget {
  const DisplayPrescriptionPage({Key? key, required this.prescriptionid})
      : super(key: key);
  final String prescriptionid;

  @override
  State<DisplayPrescriptionPage> createState() =>
      _DisplayPrescriptionPageState();
}

class _DisplayPrescriptionPageState extends State<DisplayPrescriptionPage> {
  final DioClient _dioClient = DioClient();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SynapseRx - Retrieved Prescription'),
        ),
        body: SingleChildScrollView(
            child: FutureBuilder<Prescription?>(
                future: _dioClient.getPrescription(widget.prescriptionid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    if (snapshot.hasData) {
                      Prescription? prescriptionInfo = snapshot.data;
                      if (prescriptionInfo != null) {
                        return Container(
                            margin: const EdgeInsets.all(20),
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.zero,
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                        textAlign: TextAlign.left,
                                        'Name: ${prescriptionInfo.pxFirstname} ${prescriptionInfo.pxSurname}')),
                                SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                      textAlign: TextAlign.left,
                                      'Age: ${prescriptionInfo.pxAge}yrs  Gender: ${prescriptionInfo.pxgender} '),
                                )
                              ],
                            ));
                      }
                    }
                    // ignore: avoid_unnecessary_containers
                    return Container(
                        child: const Text(
                            'No Prescription Found')); //const CircularProgressIndicator();
                  }
                })));
  }
}
