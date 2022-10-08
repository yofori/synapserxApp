import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:synapserx_prescriber/common/dio_client.dart';
import 'package:synapserx_prescriber/common/pdf_api.dart';
import 'package:synapserx_prescriber/models/prescription.dart';
import 'package:synapserx_prescriber/pages/prescriptions/editprescriptions.dart';

import '../../common/pdf_prescription_api.dart';

class PatientPrescriptionsPage extends StatefulWidget {
  const PatientPrescriptionsPage({
    Key? key,
    required this.patientuid,
    required this.patientName,
  }) : super(key: key);
  final String patientuid;
  final String patientName;

  @override
  // ignore: library_private_types_in_public_api
  _PatientPrescriptionsPageState createState() =>
      _PatientPrescriptionsPageState();
}

class _PatientPrescriptionsPageState extends State<PatientPrescriptionsPage> {
  final DioClient _dioClient = DioClient();
  GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          tooltip: 'Add New Medication',
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditPrescriptionPage(
                          title: 'Create Prescription',
                          prescriptionID: '',
                          isEditting: false,
                          patientID: widget.patientuid,
                        )));
            setState(() {});
          },
          child: const Icon(
            Icons.post_add,
            size: 30,
          )),
      appBar: AppBar(title: const Text('Prescriptions')),
      body: Column(children: <Widget>[
        const SizedBox(height: 10),
        Text('Patient: ${widget.patientName}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Expanded(
            child: FutureBuilder<List<Prescription>>(
          future: _dioClient.getPxRx(widget.patientuid),
          builder: (BuildContext context,
              AsyncSnapshot<List<Prescription>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              final error = snapshot.error;
              return Center(
                child: Text(
                  "Error: $error",
                ),
              );
            } else if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Patient has no prescriptions'),
                );
              }
              return RefreshIndicator(
                onRefresh: () async {
                  _refresh();
                },
                child: ListView.separated(
                  key: _key,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      childrenPadding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 5),
                      expandedCrossAxisAlignment: CrossAxisAlignment.end,
                      maintainState: true,
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.blue, width: 2),
                        ),
                        child: Center(
                            child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(fontSize: 16),
                        )),
                      ),
                      title: Text(
                          'Date: ${DateFormat('dd-MM-yyyy @ hh:mm a').format(DateTime.parse(snapshot.data![index].createdAt.toString()))}'),
                      subtitle: Text(
                          'Prescriber: ${snapshot.data![index].prescriberName.toString()}'),
                      children: [
                        ListView.builder(
                            itemCount:
                                snapshot.data![index].medications!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, i) => ListTile(
                                leading: CircleAvatar(
                                  child: Text((i + 1).toString()),
                                ),
                                title: Text(snapshot
                                    .data![index].medications![i].drugName!
                                    .toUpperCase()),
                                subtitle: Text(
                                    '${snapshot.data![index].medications![i].dose} '
                                    '${snapshot.data![index].medications![i].dosageUnits} '
                                    '${snapshot.data![index].medications![i].dosageRegimen} x '
                                    '${snapshot.data![index].medications![i].duration} ${snapshot.data![index].medications![i].durationUnits}'))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(children: [
                              IconButton(
                                  icon: const Icon(Icons.share),
                                  tooltip: 'Share Prescription',
                                  onPressed: () {
                                    generatePresciptionPdf(
                                        snapshot.data![index].sId.toString());
                                    // _onShare(
                                    //     navigatorKey.currentContext!,
                                    //     snapshot.data![index].prescriberMDCRegNo
                                    //         .toString());
                                  }),
                              const Text(
                                'Share ',
                                textAlign: TextAlign.center,
                              ),
                            ]),
                            Column(children: [
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  tooltip: 'Edit Prescription',
                                  onPressed: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditPrescriptionPage(
                                                  title: 'Edit Prescription',
                                                  prescriptionID: snapshot
                                                      .data![index].sId
                                                      .toString(),
                                                  isEditting: true,
                                                  patientID: snapshot
                                                      .data![index].pxId
                                                      .toString(),
                                                )));
                                    setState(() {});
                                  }),
                              const Text(
                                'Edit ',
                                textAlign: TextAlign.center,
                              ),
                            ]),
                            Column(children: [
                              IconButton(
                                  icon: const Icon(Icons.delete),
                                  tooltip: 'Delete Prescription',
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text(
                                          'Confirm Action',
                                          textAlign: TextAlign.center,
                                        ),
                                        content: const Text(
                                          'Are you sure you want to delete this prescription? This cannot be undone',
                                          textAlign: TextAlign.center,
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel')),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary: Colors.green,
                                              ),
                                              onPressed: () async {
                                                String prescriptionID = snapshot
                                                    .data![index].sId
                                                    .toString();
                                                log('Selected Prescription $prescriptionID');
                                                await _dioClient
                                                    .deletePrescription(
                                                        prescriptionID:
                                                            prescriptionID)
                                                    .whenComplete(() => {
                                                          Navigator.pop(
                                                              context),
                                                          setState(() {
                                                            if (!mounted)
                                                              return;
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: const Text(
                                                                  'Prescription deleted'),
                                                              backgroundColor:
                                                                  Colors.green
                                                                      .shade300,
                                                            ));
                                                          })
                                                        });
                                              },
                                              child: const Text(
                                                'Delete',
                                              ))
                                        ],
                                      ),
                                    );
                                  }),
                              const Text(
                                'Delete ',
                                textAlign: TextAlign.center,
                              ),
                            ]),
                            Column(
                              children: [
                                IconButton(
                                    icon: const Icon(Icons.copy),
                                    tooltip: 'Refill Prescription',
                                    onPressed: () {}),
                                const Text(
                                  'Refill',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      height: 2,
                      color: Colors.grey,
                    );
                  },
                ),
              );
            }
            return Container();
          },
        )),
      ]),
    );
  }

  void generatePresciptionPdf(String prescriptionID) async {
    Prescription? prescription =
        await _dioClient.getPrescription(prescriptionID);
    log(prescription!.pxFirstname.toString());
    final pdfFile = await PdfPrescriptionApi.generate(prescription);
    // ignore: use_build_context_synchronously
    //PdfApi.sharePDF(context, pdfFile);
    PdfApi.openFile(pdfFile);
  }

  Future<void> _refresh() async {
    if (mounted) {
      _key = GlobalKey();
      setState(() {});
    }
    Future.value(null);
  }
}
