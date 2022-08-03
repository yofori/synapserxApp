import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
            child: (FutureBuilder<Prescription?>(
                future: _dioClient.getPrescription(widget.prescriptionid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(15),
                                padding: const EdgeInsets.all(10.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 7,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                        Border.all(color: Colors.blueAccent)),
                                child: Column(children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child: Text(
                                          textAlign: TextAlign.left,
                                          'Name: ${prescriptionInfo.pxFirstname} ${prescriptionInfo.pxSurname}')),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                        textAlign: TextAlign.left,
                                        'Age: ${prescriptionInfo.pxAge}yrs  Gender: ${toBeginningOfSentenceCase(prescriptionInfo.pxgender)} '),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                        textAlign: TextAlign.left,
                                        'Prescription Date: ${DateFormat('dd-MM-yyyy @ hh:mm').format(DateTime.parse(prescriptionInfo.createdAt.toString()))}'),
                                  ),
                                  // ignore: prefer_const_constructors
                                ]),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                  padding: const EdgeInsets.all(10.0),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 7,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  child: ListView?.separated(
                                    shrinkWrap: true,
                                    itemCount:
                                        prescriptionInfo.medications!.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Text(
                                          '${index + 1}. ${prescriptionInfo.medications![index].routeOfAdministration.toString()} '
                                          '${prescriptionInfo.medications![index].drugName.toString()} '
                                          '${prescriptionInfo.medications![index].dose.toString()} '
                                          '${prescriptionInfo.medications![index].dosageRegimen.toString()} x '
                                          '${prescriptionInfo.medications![index].noOfDays.toString()} days');
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return const SizedBox(height: 4);
                                    },
                                  ))
                            ],
                          ),
                        );
                      }
                    }
                    // ignore: avoid_unnecessary_containers
                    return Container(
                        child: const Text(
                            'No Prescription Found')); //const CircularProgressIndicator();
                  }
                }))));
  }
}
